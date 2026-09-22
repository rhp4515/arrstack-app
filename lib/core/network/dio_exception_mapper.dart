/// Maps `dio`'s [DioException] onto the app's closed [AppError] set
/// (spec §5, §11). This is the single source of truth for status-code →
/// error-variant mapping; both [ErrorMappingInterceptor] and
/// `guardDioCall` use it.
library;

import 'dart:io';

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/tailnet.dart';
import 'package:dio/dio.dart';

/// Converts a [DioException] into the matching [AppError] variant.
AppError mapDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => _mapTimeout(exception),
    DioExceptionType.connectionError => _mapConnectionFailure(exception),
    DioExceptionType.badCertificate => NetworkError(
      cause: exception,
      userMessage: 'The server certificate could not be verified.',
    ),
    DioExceptionType.cancel => UnknownError(
      cause: exception,
      userMessage: 'The request was cancelled.',
    ),
    DioExceptionType.badResponse => _mapStatusCode(exception),
    DioExceptionType.unknown => _mapUnknown(exception),
  };
}

AppError _mapStatusCode(DioException exception) {
  final statusCode = exception.response?.statusCode;
  return switch (statusCode) {
    401 || 403 => AuthError(statusCode: statusCode, cause: exception),
    404 => NotFoundError(cause: exception),
    429 => RateLimitedError(
      retryAfter: _parseRetryAfter(exception),
      cause: exception,
    ),
    final code? when code >= 500 && code < 600 => ServerError(
      statusCode: code,
      cause: exception,
    ),
    _ => UnknownError(statusCode: statusCode, cause: exception),
  };
}

AppError _mapUnknown(DioException exception) {
  if (exception.error is SocketException) {
    return _mapConnectionFailure(exception);
  }
  return UnknownError(cause: exception);
}

/// Splits "couldn't connect" into the two cases that need different advice
/// from the user: the host name never resolved (DNS), or it resolved and
/// the connection itself failed.
NetworkError _mapConnectionFailure(DioException exception) {
  final host = _hostLabel(exception);
  final isTailnet = host != null && isTailnetHost(host);
  if (_isHostLookupFailure(exception.error)) {
    return NetworkError(
      isDnsFailure: true,
      isTailnetTarget: isTailnet,
      cause: exception,
      // Says what to do next in the case that actually happens. "Connect
      // Tailscale" is useless advice to someone whose Tailscale is already
      // connected and whose browser resolves the same name — a MagicDNS
      // name can fail here while working elsewhere on the device, and the
      // 100.x address needs no DNS at all.
      userMessage: host == null
          ? "Couldn't look up that server's address. If Tailscale is "
                'already connected, use its 100.x address instead of the '
                'name.'
          : "Couldn't look up $host. If Tailscale is already connected, "
                'use its 100.x address instead of the name.',
    );
  }
  return NetworkError(
    isTailnetTarget: isTailnet,
    cause: exception,
    userMessage: host == null
        ? 'Could not reach the server. Check the URL and your connection.'
        : 'Could not reach $host. Check the URL and your connection.',
  );
}

/// Dart reports an unresolvable host as a [SocketException] with no
/// [SocketException.address] and a `Failed host lookup: '<host>'` message;
/// the OS error code underneath varies by platform, so the message is the
/// portable signal.
bool _isHostLookupFailure(Object? error) {
  if (error is! SocketException) return false;
  return error.address == null &&
      error.message.toLowerCase().contains('failed host lookup');
}

NetworkError _mapTimeout(DioException exception) {
  final host = _hostLabel(exception);
  final target = host ?? 'The server';

  // A tailnet address that times out has already told us the tunnel is
  // not carrying this app's traffic: the name or address is only routable
  // inside the tailnet, so nothing else could have swallowed the packets.
  // On a carrier network 100.64.0.0/10 usually has a route, so bypassed
  // traffic times out instead of failing fast — which is why this reads
  // like a dead service. Android excludes apps from a VPN individually,
  // so "connect Tailscale" is the wrong advice when every other app on
  // the device is fine.
  if (host != null && isTailnetHost(host)) {
    return NetworkError(
      isTimeout: true,
      isTailnetTarget: true,
      cause: exception,
      userMessage:
          '$target did not respond. If Tailscale is connected and other '
          "apps can reach it, check this app isn't excluded in "
          "Tailscale's App-based split tunneling.",
    );
  }

  return NetworkError(
    isTimeout: true,
    cause: exception,
    userMessage:
        '$target did not respond in time. Off your home network this '
        'needs Tailscale connected.',
  );
}

/// `host:port` for the request that failed, for use in a user-facing
/// message. Never the full URL: the path and query can carry an API key on
/// services that accept one as a parameter, and [AppError.userMessage] is
/// rendered verbatim in the UI.
String? _hostLabel(DioException exception) {
  final uri = exception.requestOptions.uri;
  if (uri.host.isEmpty) return null;
  return uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
}

Duration? _parseRetryAfter(DioException exception) {
  final header = exception.response?.headers.value('retry-after');
  final seconds = header == null ? null : int.tryParse(header);
  return seconds == null ? null : Duration(seconds: seconds);
}

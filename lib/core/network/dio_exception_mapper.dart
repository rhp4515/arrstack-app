/// Maps `dio`'s [DioException] onto the app's closed [AppError] set
/// (spec §5, §11). This is the single source of truth for status-code →
/// error-variant mapping; both [ErrorMappingInterceptor] and
/// `guardDioCall` use it.
library;

import 'dart:io';

import 'package:arrstack/core/network/app_error.dart';
import 'package:dio/dio.dart';

/// Converts a [DioException] into the matching [AppError] variant.
AppError mapDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => NetworkError(
      isTimeout: true,
      cause: exception,
      userMessage: _timeoutMessage(_hostLabel(exception)),
    ),
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
  if (_isHostLookupFailure(exception.error)) {
    return NetworkError(
      isDnsFailure: true,
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

String _timeoutMessage(String? host) {
  final target = host ?? 'The server';
  return '$target did not respond in time. Off your home network this '
      'needs Tailscale connected.';
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

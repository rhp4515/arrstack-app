/// Follows 307/308 redirects for requests that carry a body.
///
/// `dart:io` only follows redirects for GET and HEAD, so a reverse proxy
/// answering `POST /api/v3/series` with `307` (typically http → https, or a
/// path normalisation) surfaced as an error even though every read — which
/// does follow the same redirect — worked. 307/308 mean "repeat the same
/// request, same method and body, at the new address", which is safe to do
/// here.
///
/// The request carries an API key or session cookie, so where it may be
/// resent is limited to the same host or another address on the user's own
/// network (private ranges, local names, the tailnet) — a proxy on the LAN
/// routinely redirects to a sibling address or another port, and the user
/// may have no https there. A redirect to a *public* host is never
/// followed, nor is one that downgrades https to http on a public host,
/// because a response must not be able to send the credentials out of the
/// network.
library;

import 'package:arrstack/core/network/private_host.dart';
import 'package:dio/dio.dart';

class RedirectFollowingInterceptor extends Interceptor {
  RedirectFollowingInterceptor(this._dio, {this.maxRedirects = 3});

  /// The client to re-send through, so the redirected request passes the
  /// same interceptors (API key, cookie, logging) as the original.
  final Dio _dio;
  final int maxRedirects;

  static const _hopsKey = 'redirectHops';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final target = _redirectTarget(err);
    if (target == null) return handler.next(err);

    final request = err.requestOptions;
    final hops = (request.extra[_hopsKey] as int? ?? 0) + 1;
    if (hops > maxRedirects) return handler.next(err);

    try {
      final response = await _dio.fetch<dynamic>(
        request.copyWith(
          path: target.toString(),
          extra: {...request.extra, _hopsKey: hops},
        ),
      );
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  /// Where [err] says to resend to, or null when it isn't a redirect this
  /// interceptor should follow.
  Uri? _redirectTarget(DioException err) {
    final response = err.response;
    final status = response?.statusCode;
    if (response == null || (status != 307 && status != 308)) return null;

    final method = err.requestOptions.method.toUpperCase();
    if (method == 'GET' || method == 'HEAD') return null; // already followed

    final location = response.headers.value('location');
    if (location == null || location.isEmpty) return null;

    final from = err.requestOptions.uri;
    final Uri to;
    try {
      to = from.resolve(location);
    } on FormatException {
      return null;
    }
    if (!to.hasAuthority || (to.scheme != 'http' && to.scheme != 'https')) {
      return null;
    }
    if (isPrivateNetworkHost(to.host)) return to;
    if (to.host.toLowerCase() != from.host.toLowerCase()) return null;
    if (from.scheme == 'https' && to.scheme != 'https') return null;
    return to;
  }
}

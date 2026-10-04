/// Follows 307/308 redirects for requests that carry a body.
///
/// `dart:io` only follows redirects for GET and HEAD, so a reverse proxy
/// answering `POST /api/v3/series` with `307` (typically http → https, or a
/// path normalisation) surfaced as an error even though every read — which
/// does follow the same redirect — worked. 307/308 mean "repeat the same
/// request, same method and body, at the new address", which is safe to do
/// here.
///
/// Only a redirect to the *same host* is followed. The request carries an
/// API key or session cookie, and handing that to a different host because
/// a response said so would leak it. A redirect that downgrades https to
/// http is refused for the same reason.
library;

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
    if (!to.hasAuthority || to.host.toLowerCase() != from.host.toLowerCase()) {
      return null;
    }
    if (from.scheme == 'https' && to.scheme != 'https') return null;
    return to;
  }
}

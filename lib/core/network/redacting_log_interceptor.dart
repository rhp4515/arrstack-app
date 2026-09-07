/// Logs method/path/status for every request while redacting secrets
/// (spec §11: "Redact keys/URLs in any logging interceptor" — the raw
/// `X-Api-Key` value, or any credential-looking header/query value, must
/// never appear in logged output).
library;

import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// A message sink, defaulting to `dart:developer`'s `log`. Tests inject a
/// capturing sink to assert redaction without touching a real logger.
typedef LogSink = void Function(String message);

const String redactedPlaceholder = '<redacted>';

const Set<String> _sensitiveHeaderNames = {
  'x-api-key',
  'authorization',
  'cookie',
  'set-cookie',
};

/// Logs `--> METHOD path`, `<-- status path`, and `<-- ERROR status path`
/// lines, with sensitive headers and query parameters masked.
class RedactingLogInterceptor extends Interceptor {
  RedactingLogInterceptor({LogSink? logger}) : _log = logger ?? _defaultLog;

  final LogSink _log;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['requestStart'] = DateTime.now().millisecondsSinceEpoch;
    _log(
      '--> ${options.method} ${_redactUri(options.uri)} '
      'headers=${_redactHeaders(options.headers)}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final start = response.requestOptions.extra['requestStart'] as int?;
    final duration = start != null
        ? ' (${DateTime.now().millisecondsSinceEpoch - start}ms)'
        : '';
    _log(
      '<-- ${response.statusCode} '
      '${_redactUri(response.requestOptions.uri)}$duration',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final start = err.requestOptions.extra['requestStart'] as int?;
    final duration = start != null
        ? ' (${DateTime.now().millisecondsSinceEpoch - start}ms)'
        : '';
    final responseData = err.response?.data != null
        ? ' body=${err.response?.data}'
        : '';
    final message = err.message != null ? ': ${err.message}' : '';
    _log(
      '<-- ERROR ${err.response?.statusCode ?? '-'} '
      '${_redactUri(err.requestOptions.uri)}$duration$message$responseData',
    );
    handler.next(err);
  }

  static Map<String, String> _redactHeaders(Map<String, dynamic> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: _sensitiveHeaderNames.contains(entry.key.toLowerCase())
            ? redactedPlaceholder
            : entry.value.toString(),
    };
  }

  static String _redactUri(Uri uri) {
    if (uri.queryParameters.isEmpty) return uri.toString();
    final redacted = <String, String>{
      for (final entry in uri.queryParameters.entries)
        entry.key: _isSensitiveQueryKey(entry.key)
            ? redactedPlaceholder
            : entry.value,
    };
    return uri.replace(queryParameters: redacted).toString();
  }

  static bool _isSensitiveQueryKey(String key) {
    final lower = key.toLowerCase();
    return lower.contains('key') ||
        lower.contains('token') ||
        lower.contains('pass') ||
        lower.contains('secret');
  }

  static void _defaultLog(String message) =>
      developer.log(message, name: 'arrstack.network');
}

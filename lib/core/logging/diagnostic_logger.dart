/// The write side of the diagnostic log: a fire-and-forget facade that
/// timestamps entries and never lets a logging failure reach the caller,
/// plus a Dio interceptor that records failed service requests.
library;

import 'dart:developer' as developer;

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:dio/dio.dart';

class DiagnosticLogger {
  DiagnosticLogger(this._store, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DiagnosticLogStore _store;
  final DateTime Function() _clock;

  void info(String tag, String message) => _log(LogLevel.info, tag, message);

  void warn(String tag, String message) => _log(LogLevel.warn, tag, message);

  void error(String tag, String message) => _log(LogLevel.error, tag, message);

  void _log(LogLevel level, String tag, String message) {
    _store
        .append(
          LogEntry(time: _clock(), level: level, tag: tag, message: message),
        )
        .catchError((Object error) {
          developer.log(
            'Failed to write diagnostic log entry: $error',
            name: 'arrstack.diagnostics',
          );
        });
  }
}

/// "Radarr · GET api/v3/queue failed | NetworkError: Connection timed out"
/// — the request that failed and why, in the same shape the log page shows
/// for every service. The store redacts hosts and keys on the way in.
class DiagnosticLogInterceptor extends Interceptor {
  DiagnosticLogInterceptor({required this.tag, required this.logger});

  final String tag;
  final DiagnosticLogger logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // A cancelled request is the app changing its mind, not a failure.
    if (err.type != DioExceptionType.cancel) {
      final options = err.requestOptions;
      logger.warn(
        tag,
        '${options.method} ${options.path} failed | ${describeDioFailure(err)}',
      );
    }
    handler.next(err);
  }
}

/// A one-line reason for a failed request: the mapped [AppError] type and
/// its message, the status code, and the transport's own wording (the
/// difference between "timed out" and "connection refused" is what a
/// support reader needs).
String describeDioFailure(DioException err) {
  final mapped = err.error;
  if (mapped is AppError) return describeError(mapped);
  final status = err.response?.statusCode;
  return [
    err.type.name,
    if (status != null) '(HTTP $status)',
    if (err.message case final message?) '· $message',
  ].join(' ');
}

/// Describes any thrown object or [AppError] for the log, without a stack
/// trace.
String describeError(Object error) {
  if (error is DioException) return describeDioFailure(error);
  if (error is! AppError) return '${error.runtimeType}: $error';
  final status = error.statusCode;
  final cause = error.cause;
  // For a socket failure the mapper wraps the DioException whose own
  // `error` is e.g. "SocketException: Connection refused"; for a timeout
  // Dio's message carries the description.
  final transport = cause is DioException
      ? (cause.error ?? cause.message)
      : cause;
  return [
    '${error.runtimeType}: ${error.userMessage}',
    if (status != null) '(HTTP $status)',
    if (transport != null) '· $transport',
  ].join(' ');
}

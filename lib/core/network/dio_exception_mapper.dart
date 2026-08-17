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
    ),
    DioExceptionType.connectionError => NetworkError(
      isTimeout: false,
      cause: exception,
    ),
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
    return NetworkError(cause: exception);
  }
  return UnknownError(cause: exception);
}

Duration? _parseRetryAfter(DioException exception) {
  final header = exception.response?.headers.value('retry-after');
  final seconds = header == null ? null : int.tryParse(header);
  return seconds == null ? null : Duration(seconds: seconds);
}

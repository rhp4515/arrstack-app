// AppError mapping from representative DioExceptions: timeout, 401, 404,
// 429, 500, and a raw socket/connection error.

import 'dart:io';

import 'package:arrstack/core/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

RequestOptions _options() => RequestOptions(path: '/system/status');

Response<dynamic> _response(
  int statusCode, {
  Map<String, List<String>>? headers,
}) {
  return Response<dynamic>(
    requestOptions: _options(),
    statusCode: statusCode,
    headers: Headers.fromMap(headers ?? const {}),
  );
}

void main() {
  test('connectionTimeout maps to a timeout NetworkError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.connectionTimeout,
    );

    final error = mapDioException(exception);

    expect(error, isA<NetworkError>());
    expect((error as NetworkError).isTimeout, isTrue);
  });

  test('receiveTimeout maps to a timeout NetworkError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.receiveTimeout,
    );

    final error = mapDioException(exception);

    expect(error, isA<NetworkError>());
    expect((error as NetworkError).isTimeout, isTrue);
  });

  test('401 response maps to AuthError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.badResponse,
      response: _response(401),
    );

    final error = mapDioException(exception);

    expect(error, isA<AuthError>());
    expect(error.statusCode, 401);
  });

  test('403 response maps to AuthError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.badResponse,
      response: _response(403),
    );

    expect(mapDioException(exception), isA<AuthError>());
  });

  test('404 response maps to NotFoundError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.badResponse,
      response: _response(404),
    );

    expect(mapDioException(exception), isA<NotFoundError>());
  });

  test('429 response maps to RateLimitedError and parses Retry-After', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.badResponse,
      response: _response(
        429,
        headers: {
          'retry-after': ['30'],
        },
      ),
    );

    final error = mapDioException(exception);

    expect(error, isA<RateLimitedError>());
    expect((error as RateLimitedError).retryAfter, const Duration(seconds: 30));
  });

  test('500 response maps to ServerError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.badResponse,
      response: _response(500),
    );

    final error = mapDioException(exception);

    expect(error, isA<ServerError>());
    expect(error.statusCode, 500);
  });

  test('a raw SocketException (connectionError) maps to NetworkError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.connectionError,
      error: const SocketException('Failed host lookup'),
    );

    final error = mapDioException(exception);

    expect(error, isA<NetworkError>());
    expect((error as NetworkError).isTimeout, isFalse);
  });

  test('unknown type wrapping a SocketException maps to NetworkError', () {
    final exception = DioException(
      requestOptions: _options(),
      type: DioExceptionType.unknown,
      error: const SocketException('Network is unreachable'),
    );

    expect(mapDioException(exception), isA<NetworkError>());
  });

  test('every mapped error carries a non-empty userMessage', () {
    final exceptions = [
      DioException(
        requestOptions: _options(),
        type: DioExceptionType.connectionTimeout,
      ),
      DioException(
        requestOptions: _options(),
        type: DioExceptionType.badResponse,
        response: _response(500),
      ),
    ];

    for (final exception in exceptions) {
      expect(mapDioException(exception).userMessage, isNotEmpty);
    }
  });
}

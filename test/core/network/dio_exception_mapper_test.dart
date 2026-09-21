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

  group('reaching the host', () {
    // A base URL is required for the mapper to name the host it failed to
    // reach; RequestOptions(path:) alone has no host to report.
    RequestOptions remoteOptions() => RequestOptions(
      path: 'api/v3/system/status',
      baseUrl: 'http://nas.tailnet-xxxx.ts.net:7878/',
    );

    test('an unresolvable host is flagged as a DNS failure and named', () {
      final exception = DioException(
        requestOptions: remoteOptions(),
        type: DioExceptionType.connectionError,
        error: const SocketException(
          "Failed host lookup: 'nas.tailnet-xxxx.ts.net'",
        ),
      );

      final error = mapDioException(exception);

      expect(error, isA<NetworkError>());
      expect((error as NetworkError).isDnsFailure, isTrue);
      expect(error.isTimeout, isFalse);
      expect(error.userMessage, contains('nas.tailnet-xxxx.ts.net:7878'));
      expect(error.userMessage, contains('Tailscale'));
    });

    test('a refused connection is a network error but not a DNS one', () {
      final exception = DioException(
        requestOptions: remoteOptions(),
        type: DioExceptionType.connectionError,
        error: const SocketException(
          'Connection refused',
          address: null,
          osError: OSError('Connection refused', 111),
        ),
      );

      final error = mapDioException(exception);

      expect((error as NetworkError).isDnsFailure, isFalse);
      expect(error.userMessage, contains('nas.tailnet-xxxx.ts.net:7878'));
    });

    test('a timeout names the host that did not answer', () {
      final exception = DioException(
        requestOptions: remoteOptions(),
        type: DioExceptionType.connectionTimeout,
      );

      final error = mapDioException(exception);

      expect((error as NetworkError).isTimeout, isTrue);
      expect(error.isDnsFailure, isFalse);
      expect(error.userMessage, contains('nas.tailnet-xxxx.ts.net:7878'));
    });

    test('never puts the request path or query in the user message: an API '
        'key passed as a query parameter would leak into the UI', () {
      final exception = DioException(
        requestOptions: RequestOptions(
          path: 'api/v1/health',
          baseUrl: 'http://nas.tailnet-xxxx.ts.net:8503/',
          queryParameters: const {'apikey': 'super-secret'},
        ),
        type: DioExceptionType.connectionTimeout,
      );

      final error = mapDioException(exception);

      expect(error.userMessage, isNot(contains('super-secret')));
      expect(error.userMessage, isNot(contains('api/v1/health')));
    });

    test('falls back to generic copy when there is no host to name', () {
      final exception = DioException(
        requestOptions: _options(),
        type: DioExceptionType.connectionTimeout,
      );

      expect(mapDioException(exception).userMessage, isNotEmpty);
    });
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

// guardDioCall: bridges dio's exception-based API to Result<T>.

import 'package:arrstack/core/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns Ok with the call result on success', () async {
    final result = await guardDioCall(() async => 42);

    expect(result.valueOrNull, 42);
  });

  test('maps a DioException with a pre-computed AppError (from the '
      'interceptor) straight through', () async {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/x'),
      error: const NotFoundError(),
    );

    final result = await guardDioCall<int>(() => throw exception);

    expect(result.errorOrNull, isA<NotFoundError>());
  });

  test(
    'maps a DioException with no pre-computed error by deriving one',
    () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await guardDioCall<int>(() => throw exception);

      expect(result.errorOrNull, isA<NetworkError>());
    },
  );

  test('maps a FormatException to a ValidationError', () async {
    final result = await guardDioCall<int>(
      () => throw const FormatException('bad json'),
    );

    expect(result.errorOrNull, isA<ValidationError>());
  });
}

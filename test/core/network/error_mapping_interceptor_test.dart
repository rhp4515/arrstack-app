// ErrorMappingInterceptor: attaches a mapped AppError to DioException.error
// so callers get a consistent Result via guardDioCall.

import 'package:arrstack/core/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test(
    'attaches an AppError to the DioException for a failed request',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
      final adapter = DioAdapter(dio: dio);
      dio.interceptors.add(const ErrorMappingInterceptor());

      adapter.onGet(
        '/system/status',
        (server) => server.reply(404, {'error': 'not found'}),
      );

      try {
        await dio.get<dynamic>('/system/status');
        fail('expected a DioException');
      } on DioException catch (exception) {
        expect(exception.error, isA<NotFoundError>());
      }
    },
  );
}

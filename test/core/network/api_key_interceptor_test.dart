// ApiKeyInterceptor: adds X-Api-Key for apiKey-auth services, sourcing the
// key from an injected lookup rather than a hardcoded value.

import 'package:arrstack/core/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('adds the X-Api-Key header when the lookup returns a key', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    dio.interceptors.add(
      ApiKeyInterceptor(lookupApiKey: () async => 'super-secret-key'),
    );

    RequestOptions? captured;
    adapter.onGet(
      '/system/status',
      (server) => server.reply(200, {'status': 'ok'}),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    await dio.get<dynamic>('/system/status');

    expect(captured, isNotNull);
    expect(captured!.headers[ApiKeyInterceptor.headerName], 'super-secret-key');
  });

  test('adds no header when the lookup returns null', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    dio.interceptors.add(ApiKeyInterceptor(lookupApiKey: () async => null));

    RequestOptions? captured;
    adapter.onGet(
      '/system/status',
      (server) => server.reply(200, {'status': 'ok'}),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    await dio.get<dynamic>('/system/status');

    expect(
      captured!.headers.containsKey(ApiKeyInterceptor.headerName),
      isFalse,
    );
  });
}

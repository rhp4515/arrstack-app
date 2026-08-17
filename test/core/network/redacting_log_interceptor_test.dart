// RedactingLogInterceptor: logs method/path/status but must never leak the
// X-Api-Key header value (or other credential-looking header/query values).

import 'package:arrstack/core/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  const secretKey = 'super-secret-api-key-value';

  test('redacts the X-Api-Key header in logged output', () async {
    final messages = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    dio.options.headers[ApiKeyInterceptor.headerName] = secretKey;
    dio.interceptors.add(RedactingLogInterceptor(logger: messages.add));

    adapter.onGet(
      '/system/status',
      (server) => server.reply(200, {'status': 'ok'}),
    );

    await dio.get<dynamic>('/system/status');

    expect(messages, isNotEmpty);
    final joined = messages.join('\n');
    expect(joined, isNot(contains(secretKey)));
    expect(joined, contains(redactedPlaceholder));
    expect(joined, contains('GET'));
    expect(joined, contains('200'));
  });

  test('redacts a sensitive query parameter (e.g. apikey=)', () async {
    final messages = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    dio.interceptors.add(RedactingLogInterceptor(logger: messages.add));

    adapter.onGet(
      '/status',
      (server) => server.reply(200, {'status': 'ok'}),
      queryParameters: {'apikey': secretKey},
    );

    await dio.get<dynamic>('/status', queryParameters: {'apikey': secretKey});

    final joined = messages.join('\n');
    expect(joined, isNot(contains(secretKey)));
  });

  test('never leaks the key even when the request errors', () async {
    final messages = <String>[];
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    dio.options.headers[ApiKeyInterceptor.headerName] = secretKey;
    dio.interceptors.add(RedactingLogInterceptor(logger: messages.add));

    adapter.onGet(
      '/system/status',
      (server) => server.reply(401, {'error': 'unauthorized'}),
    );

    await expectLater(
      dio.get<dynamic>('/system/status'),
      throwsA(isA<DioException>()),
    );

    final joined = messages.join('\n');
    expect(joined, isNot(contains(secretKey)));
  });
}

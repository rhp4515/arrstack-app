import 'dart:io';

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/diagnostic_logger.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late InMemoryDiagnosticLogStore store;
  late DiagnosticLogger logger;

  setUp(() {
    store = InMemoryDiagnosticLogStore();
    logger = DiagnosticLogger(store, clock: () => DateTime.utc(2026, 9, 30));
  });

  Future<List<LogEntry>> entries() async {
    await Future<void>.delayed(Duration.zero);
    return store.readAll();
  }

  test('writes timestamped entries at each level', () async {
    logger
      ..info('Backup', 'saved')
      ..warn('Radarr', 'slow')
      ..error('App', 'boom');
    final all = await entries();
    expect(all.map((e) => e.level), [
      LogLevel.error,
      LogLevel.warn,
      LogLevel.info,
    ]);
    expect(all.first.time, DateTime.utc(2026, 9, 30));
  });

  test('interceptor records a failed request with its mapped reason', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.10:7878/'));
    final adapter = DioAdapter(dio: dio);
    dio.interceptors.addAll([
      const ErrorMappingInterceptor(),
      DiagnosticLogInterceptor(tag: 'Radarr', logger: logger),
    ]);
    adapter.onGet('api/v3/queue', (server) => server.reply(401, {}));

    await expectLater(
      dio.get<dynamic>('api/v3/queue'),
      throwsA(isA<DioException>()),
    );

    final entry = (await entries()).single;
    expect(entry.tag, 'Radarr');
    expect(entry.level, LogLevel.warn);
    expect(entry.message, startsWith('GET api/v3/queue failed | AuthError'));
    expect(entry.message, contains('HTTP 401'));
    expect(entry.message, isNot(contains('192.168.1.10')));
  });

  test('interceptor ignores cancelled requests', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test/'));
    final adapter = DioAdapter(dio: dio);
    dio.interceptors.add(
      DiagnosticLogInterceptor(tag: 'Sonarr', logger: logger),
    );
    adapter.onGet(
      'api/v3/series',
      (server) => server.reply(200, [], delay: const Duration(seconds: 1)),
    );
    final token = CancelToken();
    final request = dio.get<dynamic>('api/v3/series', cancelToken: token);
    token.cancel();
    await expectLater(request, throwsA(isA<DioException>()));
    expect(await entries(), isEmpty);
  });

  test('describeError surfaces the socket failure behind a NetworkError', () {
    final socketFailure = DioException(
      requestOptions: RequestOptions(path: 'x'),
      type: DioExceptionType.connectionError,
      error: const SocketException('Connection refused'),
    );
    final mapped = mapDioException(socketFailure);
    final text = describeError(mapped);
    expect(text, startsWith('NetworkError: '));
    expect(text, contains('Connection refused'));
  });
}

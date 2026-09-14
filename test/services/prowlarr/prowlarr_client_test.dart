// ProwlarrClient.getIndexerStats accepts optional startDate/endDate and
// sends them as ISO yyyy-MM-dd query params when given, omitting them
// entirely when neither date is supplied.

import 'package:arrstack/services/prowlarr/client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late ProwlarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = ProwlarrClient(dio);
  });

  test(
    'getIndexerStats sends startDate and endDate as query params when given',
    () async {
      RequestOptions? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );
      adapter.onGet(
        'api/v1/indexerstats',
        (server) => server.reply(200, {'indexers': <Map<String, dynamic>>[]}),
        queryParameters: {'startDate': '2026-08-14', 'endDate': '2026-09-13'},
      );

      final result = await client.getIndexerStats(
        startDate: DateTime(2026, 8, 14),
        endDate: DateTime(2026, 9, 13),
      );

      expect(result.isOk, isTrue);
      expect(captured!.queryParameters, {
        'startDate': '2026-08-14',
        'endDate': '2026-09-13',
      });
    },
  );

  test(
    'getIndexerStats omits query params when neither date is given',
    () async {
      RequestOptions? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );
      adapter.onGet(
        'api/v1/indexerstats',
        (server) => server.reply(200, {'indexers': <Map<String, dynamic>>[]}),
        queryParameters: <String, dynamic>{},
      );

      final result = await client.getIndexerStats();

      expect(result.isOk, isTrue);
      expect(captured!.queryParameters, <String, dynamic>{});
    },
  );
}

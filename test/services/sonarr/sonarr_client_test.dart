// SonarrClient.getWantedMissing must page through api/v3/wanted/missing,
// parse each record as SonarrCalendarEpisode (same shape includeSeries=true
// gives the calendar endpoint), skip a malformed record, and map a 5xx to Err.

import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = SonarrClient(dio);
  });

  test('getWantedMissing parses records and requests includeSeries', () async {
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
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 1,
        'pageSize': 50,
        'totalRecords': 1,
        'records': [
          {
            'id': 501,
            'seriesId': 9,
            'seasonNumber': 2,
            'episodeNumber': 5,
            'title': 'The You You Are',
            'airDateUtc': '2022-03-25T00:00:00Z',
            'hasFile': false,
            'monitored': true,
            'series': {'id': 9, 'title': 'Severance'},
          },
        ],
      }),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing();

    expect(result.isOk, isTrue);
    final list = result.valueOrNull!;
    expect(list, hasLength(1));
    expect(list.single.id, 501);
    expect(list.single.series?.title, 'Severance');
    expect(captured!.queryParameters['includeSeries'], true);
  });

  test(
    'getWantedMissing skips a malformed record and keeps the rest',
    () async {
      adapter.onGet(
        'api/v3/wanted/missing',
        (server) => server.reply(200, {
          'page': 1,
          'pageSize': 50,
          'totalRecords': 2,
          'records': [
            'not a map',
            {
              'id': 502,
              'seriesId': 9,
              'seasonNumber': 2,
              'episodeNumber': 6,
              'title': 'Chikhai Bardo',
              'hasFile': false,
              'monitored': true,
            },
          ],
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'airDateUtc',
          'sortDirection': 'descending',
          'includeSeries': true,
        },
      );

      final result = await client.getWantedMissing();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.map((e) => e.id), [502]);
    },
  );

  test('getWantedMissing respects a custom page and pageSize', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 2,
        'pageSize': 10,
        'totalRecords': 12,
        'records': <Map<String, dynamic>>[],
      }),
      queryParameters: {
        'page': 2,
        'pageSize': 10,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing(page: 2, pageSize: 10);

    expect(result.isOk, isTrue);
    expect(result.valueOrNull, isEmpty);
  });

  test('getWantedMissing maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(503, {'message': 'unavailable'}),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing();

    expect(result.isErr, isTrue);
  });
}

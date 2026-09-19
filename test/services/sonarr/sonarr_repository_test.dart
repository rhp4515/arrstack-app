// SonarrRepository.listMissingEpisodes pages through wanted/missing until a
// page returns fewer than pageSize records, concatenating every page.

import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, dynamic> _episode(int id) => {
  'id': id,
  'seriesId': 9,
  'seasonNumber': 1,
  'episodeNumber': id,
  'title': 'Episode $id',
  'hasFile': false,
  'monitored': true,
};

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repository = SonarrRepository(SonarrClient(dio));
  });

  test(
    'stops after the first page when it has fewer than 50 records',
    () async {
      adapter.onGet(
        'api/v3/wanted/missing',
        (server) => server.reply(200, {
          'page': 1,
          'pageSize': 50,
          'totalRecords': 2,
          'records': [_episode(1), _episode(2)],
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'airDateUtc',
          'sortDirection': 'descending',
          'includeSeries': true,
        },
      );

      final result = await repository.listMissingEpisodes();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.map((e) => e.id), [1, 2]);
    },
  );

  test('fetches a second page when the first is exactly full', () async {
    final firstPage = List.generate(50, (i) => _episode(i + 1));
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 1,
        'pageSize': 50,
        'totalRecords': 51,
        'records': firstPage,
      }),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 2,
        'pageSize': 50,
        'totalRecords': 51,
        'records': [_episode(51)],
      }),
      queryParameters: {
        'page': 2,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await repository.listMissingEpisodes();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull, hasLength(51));
    expect(result.valueOrNull!.last.id, 51);
  });

  test(
    'continues to the next page when one record on a full page is malformed',
    () async {
      // 50 raw records, but one is malformed, so it parses to 49 —
      // pagination must still continue because the RAW count (50) equals
      // pageSize, not the parsed count.
      final firstPageRaw = <Object?>[
        'not a map',
        ...List.generate(49, (i) => _episode(i + 1)),
      ];
      adapter.onGet(
        'api/v3/wanted/missing',
        (server) => server.reply(200, {
          'page': 1,
          'pageSize': 50,
          'totalRecords': 50,
          'records': firstPageRaw,
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'airDateUtc',
          'sortDirection': 'descending',
          'includeSeries': true,
        },
      );
      adapter.onGet(
        'api/v3/wanted/missing',
        (server) => server.reply(200, {
          'page': 2,
          'pageSize': 50,
          'totalRecords': 50,
          'records': [_episode(50)],
        }),
        queryParameters: {
          'page': 2,
          'pageSize': 50,
          'sortKey': 'airDateUtc',
          'sortDirection': 'descending',
          'includeSeries': true,
        },
      );

      final result = await repository.listMissingEpisodes();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, hasLength(50));
      expect(result.valueOrNull!.last.id, 50);
    },
  );

  test('returns Err immediately when the first page fails', () async {
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

    final result = await repository.listMissingEpisodes();

    expect(result.isErr, isTrue);
  });
}

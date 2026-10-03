// SonarrClient/SonarrRepository history: GET api/v3/history (paged envelope)
// and GET api/v3/history/since (plain list) must send the right query
// (series + episode embedded), parse records defensively, and map HTTP
// failures to Err.

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/sonarr/models/sonarr_history.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _pageQuery = {
  'page': 1,
  'pageSize': 50,
  'sortKey': 'date',
  'sortDirection': 'descending',
  'includeSeries': true,
  'includeEpisode': true,
};

Map<String, dynamic> _record({
  int id = 1,
  String eventType = 'downloadFolderImported',
  Object? series = const {'id': 9, 'title': 'Severance', 'year': 2022},
  Object? episode = const {
    'id': 501,
    'seasonNumber': 2,
    'episodeNumber': 5,
    'title': 'Trojan\'s Horse',
  },
}) => {
  'id': id,
  'seriesId': 9,
  'episodeId': 501,
  'sourceTitle': 'Severance.S02E05.1080p.WEB-GRP',
  'eventType': eventType,
  'date': '2026-09-20T08:45:00Z',
  'quality': {
    'quality': {'id': 3, 'name': 'WEBDL-1080p'},
  },
  'series': series,
  'episode': episode,
};

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrRepository repo;
  RequestOptions? captured;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = SonarrRepository(SonarrClient(dio));
    captured = null;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );
  });

  group('getHistory', () {
    test('requests a date-sorted page with series and episode', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'page': 3,
          'pageSize': 10,
          'records': [_record()],
        }),
        queryParameters: {..._pageQuery, 'page': 3, 'pageSize': 10},
      );

      final result = await repo.getHistory(page: 3, pageSize: 10);

      expect(result.isOk, isTrue);
      final record = result.valueOrNull!.single;
      expect(record.id, 1);
      expect(record.eventType, 'downloadFolderImported');
      expect(record.date, DateTime.utc(2026, 9, 20, 8, 45));
      expect(record.sourceTitle, 'Severance.S02E05.1080p.WEB-GRP');
      expect(record.qualityName, 'WEBDL-1080p');
      expect(record.seriesTitle, 'Severance');
      expect(record.seasonNumber, 2);
      expect(record.episodeNumber, 5);
      expect(record.episodeTitle, "Trojan's Horse");
      expect(record.episodeCode, 'S02E05');
      expect(record.displayTitle, 'Severance S02E05');
      expect(captured!.queryParameters['includeEpisode'], true);
    });

    test('skips a malformed record and keeps the rest', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'records': [
            _record(id: 1),
            {'id': 'not-an-int', 'date': '2026-09-20T08:45:00Z'},
            _record(id: 3),
          ],
        }),
        queryParameters: _pageQuery,
      );

      final result = await repo.getHistory();

      expect(result.valueOrNull!.map((r) => r.id), [1, 3]);
    });

    test('tolerates missing or malformed embedded series/episode', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'records': [
            _record(id: 1, series: null, episode: null),
            _record(id: 2, episode: {'seasonNumber': 'two'}),
            {'date': '2026-09-20T08:45:00Z'},
          ],
        }),
        queryParameters: _pageQuery,
      );

      final records = (await repo.getHistory()).valueOrNull!;

      expect(records, hasLength(3));
      expect(records[0].displayTitle, 'Severance.S02E05.1080p.WEB-GRP');
      expect(records[0].episodeCode, isNull);
      expect(records[1].episode, isNull);
      expect(records[1].displayTitle, 'Severance');
      expect(records[2].eventType, 'unknown');
      expect(records[2].displayTitle, 'Unknown episode');
    });

    test('maps a 500 to Err', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(500, {'message': 'boom'}),
        queryParameters: _pageQuery,
      );

      final result = await repo.getHistory();

      expect(result.errorOrNull, isA<ServerError>());
    });
  });

  group('getHistoryPage', () {
    test('counts a record that failed to parse as received, so a full '
        'page still reads as full', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'totalRecords': 140,
          'records': [
            _record(id: 1),
            {'id': 'not-an-int', 'date': '2026-09-20T08:45:00Z'},
            _record(id: 3),
          ],
        }),
        queryParameters: _pageQuery,
      );

      final page = (await repo.getHistoryPage()).valueOrNull!;

      expect(page.records.map((r) => r.id), [1, 3]);
      expect(page.received, 3);
      expect(page.totalRecords, 140);
    });

    test('leaves the total unknown when the server omits it', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'records': [_record()],
        }),
        queryParameters: _pageQuery,
      );

      final page = (await repo.getHistoryPage()).valueOrNull!;

      expect(page.totalRecords, isNull);
      expect(page.received, 1);
    });
  });

  group('getHistorySince', () {
    test('sends the date as ISO-8601 UTC and parses a plain list', () async {
      adapter.onGet(
        'api/v3/history/since',
        (server) => server.reply(200, [_record(id: 4, eventType: 'grabbed')]),
        queryParameters: {
          'date': '2026-09-19T12:00:00.000Z',
          'includeSeries': true,
          'includeEpisode': true,
        },
      );

      final result = await repo.getHistorySince(DateTime.utc(2026, 9, 19, 12));

      final record = result.valueOrNull!.single;
      expect(record, isA<SonarrHistoryRecord>());
      expect(record.id, 4);
      expect(record.eventType, 'grabbed');
      expect(captured!.path, 'api/v3/history/since');
    });

    test('maps a network failure to Err', () async {
      adapter.onGet(
        'api/v3/history/since',
        (server) => server.throws(
          0,
          DioException.connectionError(
            requestOptions: RequestOptions(path: 'api/v3/history/since'),
            reason: 'offline',
          ),
        ),
        queryParameters: {
          'date': '2026-09-19T12:00:00.000Z',
          'includeSeries': true,
          'includeEpisode': true,
        },
      );

      final result = await repo.getHistorySince(DateTime.utc(2026, 9, 19, 12));

      expect(result.isErr, isTrue);
    });
  });
}

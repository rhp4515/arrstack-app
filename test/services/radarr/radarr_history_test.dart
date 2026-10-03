// RadarrClient/RadarrRepository history: GET api/v3/history (paged envelope)
// and GET api/v3/history/since (plain list) must send the right query,
// parse records defensively (a malformed record is skipped, a malformed
// embedded movie is dropped), and map HTTP failures to Err.

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, dynamic> _record({
  int id = 1,
  String eventType = 'grabbed',
  Object? movie = const {'id': 7, 'title': 'Dune', 'year': 2021},
}) => {
  'id': id,
  'movieId': 7,
  'sourceTitle': 'Dune.2021.1080p.BluRay-GRP',
  'eventType': eventType,
  'date': '2026-09-20T08:45:00Z',
  'downloadId': 'abc',
  'quality': {
    'quality': {'id': 7, 'name': 'Bluray-1080p'},
    'revision': {'version': 1},
  },
  'movie': movie,
};

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late RadarrRepository repo;
  RequestOptions? captured;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = RadarrRepository(RadarrClient(dio));
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
    test('requests a date-sorted page with the movie embedded', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'page': 2,
          'pageSize': 20,
          'totalRecords': 1,
          'records': [_record()],
        }),
        queryParameters: {
          'page': 2,
          'pageSize': 20,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistory(page: 2, pageSize: 20);

      expect(result.isOk, isTrue);
      final record = result.valueOrNull!.single;
      expect(record.id, 1);
      expect(record.eventType, 'grabbed');
      expect(record.date, DateTime.utc(2026, 9, 20, 8, 45));
      expect(record.sourceTitle, 'Dune.2021.1080p.BluRay-GRP');
      expect(record.qualityName, 'Bluray-1080p');
      expect(record.movieTitle, 'Dune');
      expect(record.movieYear, 2021);
      expect(record.displayTitle, 'Dune (2021)');
      expect(captured!.path, 'api/v3/history');
    });

    test('defaults to page 1 of 50', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {'records': <Object>[]}),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistory();

      expect(result.valueOrNull, isEmpty);
    });

    test('skips a malformed record and keeps the rest', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'records': [
            _record(id: 1),
            {'id': 2, 'eventType': 'grabbed'}, // no date
            _record(id: 3, eventType: 'downloadFolderImported'),
          ],
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistory();

      expect(result.valueOrNull!.map((r) => r.id), [1, 3]);
    });

    test('tolerates a missing or malformed embedded movie', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'records': [
            _record(id: 1, movie: null),
            _record(id: 2, movie: {'title': 42}),
            {'date': '2026-09-20T08:45:00Z'},
          ],
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final records = (await repo.getHistory()).valueOrNull!;

      expect(records, hasLength(3));
      expect(records[0].movie, isNull);
      expect(records[0].displayTitle, 'Dune.2021.1080p.BluRay-GRP');
      expect(records[1].movie, isNull);
      expect(records[2].id, 0);
      expect(records[2].eventType, 'unknown');
      expect(records[2].qualityName, isNull);
      expect(records[2].displayTitle, 'Unknown movie');
    });

    test('maps a 500 to Err', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(500, {'message': 'boom'}),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistory();

      expect(result.isErr, isTrue);
      expect(result.errorOrNull, isA<ServerError>());
    });

    test('an HTML body is an Err, not an empty success', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, '<html>login</html>'),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistory();

      expect(result.isErr, isTrue);
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
            {'id': 2, 'eventType': 'grabbed'},
            _record(id: 3),
          ],
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
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
        queryParameters: {
          'page': 1,
          'pageSize': 50,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );

      final page = (await repo.getHistoryPage()).valueOrNull!;

      expect(page.totalRecords, isNull);
      expect(page.received, 1);
    });
  });

  group('getHistorySince', () {
    test('sends the date as ISO-8601 UTC and parses a plain list', () async {
      final since = DateTime.utc(2026, 9, 19, 12);
      adapter.onGet(
        'api/v3/history/since',
        (server) =>
            server.reply(200, [_record(id: 9, eventType: 'downloadFailed')]),
        queryParameters: {
          'date': '2026-09-19T12:00:00.000Z',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistorySince(since);

      expect(result.isOk, isTrue);
      final record = result.valueOrNull!.single;
      expect(record, isA<RadarrHistoryRecord>());
      expect(record.id, 9);
      expect(record.eventType, 'downloadFailed');
      expect(captured!.queryParameters['date'], '2026-09-19T12:00:00.000Z');
    });

    test('converts a local since to UTC', () async {
      final since = DateTime(2026, 9, 19, 12);
      final expected = since.toUtc().toIso8601String();
      adapter.onGet(
        'api/v3/history/since',
        (server) => server.reply(200, <Object>[]),
        queryParameters: {'date': expected, 'includeMovie': true},
      );

      final result = await repo.getHistorySince(since);

      expect(result.valueOrNull, isEmpty);
      expect(expected, endsWith('Z'));
    });

    test('maps a 401 to Err', () async {
      adapter.onGet(
        'api/v3/history/since',
        (server) => server.reply(401, {'message': 'nope'}),
        queryParameters: {
          'date': '2026-09-19T12:00:00.000Z',
          'includeMovie': true,
        },
      );

      final result = await repo.getHistorySince(DateTime.utc(2026, 9, 19, 12));

      expect(result.isErr, isTrue);
    });
  });
}

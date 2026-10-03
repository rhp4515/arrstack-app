import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/features/notifications/sources/import_history_sources.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, Object?> _movie(int id, String event, String date, String title) =>
    {
      'id': id,
      'movieId': id,
      'eventType': event,
      'date': date,
      'sourceTitle': '$title.2024.1080p',
      'quality': {
        'quality': {'id': 7, 'name': 'Bluray-1080p'},
      },
      'movie': {'id': id, 'title': title, 'year': 2024},
    };

void main() {
  group('RadarrImportSource', () {
    late DioAdapter adapter;
    late RadarrImportSource source;

    setUp(() {
      final dio = Dio(BaseOptions(baseUrl: 'http://example.test/'));
      adapter = DioAdapter(dio: dio);
      source = RadarrImportSource(
        instanceId: 'r1',
        instanceName: 'Harivin Radarr',
        repository: RadarrRepository(RadarrClient(dio)),
      )..clock = () => DateTime.utc(2026, 9, 30, 12);
    });

    test('first check starts at the newest record on the server', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {
          'records': [
            _movie(9, 'grabbed', '2026-09-30T10:00:00Z', 'Dune'),
            _movie(8, 'downloadFolderImported', '2026-09-29T10:00:00Z', 'Up'),
          ],
        }),
        queryParameters: {
          'page': 1,
          'pageSize': 10,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );
      final check = (await source.check(null) as Ok<SourceCheck>).value;
      expect(check.items, isEmpty);
      expect(check.checkpoint, '2026-09-30T10:00:00.000Z');
    });

    test('an empty history starts at now', () async {
      adapter.onGet(
        'api/v3/history',
        (server) => server.reply(200, {'records': <Object>[]}),
        queryParameters: {
          'page': 1,
          'pageSize': 10,
          'sortKey': 'date',
          'sortDirection': 'descending',
          'includeMovie': true,
        },
      );
      final check = (await source.check(null) as Ok<SourceCheck>).value;
      expect(check.checkpoint, '2026-09-30T12:00:00.000Z');
    });

    test('reports only imports newer than the checkpoint', () async {
      const since = '2026-09-30T10:00:00.000Z';
      adapter.onGet(
        'api/v3/history/since',
        (server) => server.reply(200, [
          // The record the checkpoint came from: inclusive on the server.
          _movie(9, 'downloadFolderImported', '2026-09-30T10:00:00Z', 'Old'),
          _movie(10, 'grabbed', '2026-09-30T10:05:00Z', 'Rage Of Stars'),
          _movie(
            11,
            'downloadFolderImported',
            '2026-09-30T10:15:00Z',
            'Rage Of Stars',
          ),
          _movie(12, 'downloadFolderImported', '2026-09-30T10:20:00Z', 'Uyir'),
        ]),
        queryParameters: {'date': since, 'includeMovie': true},
      );
      final check = (await source.check(since) as Ok<SourceCheck>).value;
      expect(check.items.map((i) => i.title), [
        'Uyir (2024)',
        'Rage Of Stars (2024)',
      ]);
      expect(check.items.first.detail, 'Bluray-1080p');
      expect(check.checkpoint, '2026-09-30T10:20:00.000Z');
      expect(source.singleTitle(check.items.first), 'Movie ready');
    });

    test('passes a server error through', () async {
      const since = '2026-09-30T10:00:00.000Z';
      adapter.onGet(
        'api/v3/history/since',
        (server) => server.reply(500, {}),
        queryParameters: {'date': since, 'includeMovie': true},
      );
      expect(await source.check(since), isA<Err<SourceCheck>>());
    });
  });

  test('SonarrImportSource titles episodes with their code and name', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test/'));
    final adapter = DioAdapter(dio: dio);
    final source = SonarrImportSource(
      instanceId: 's1',
      instanceName: 'Sonarr',
      repository: SonarrRepository(SonarrClient(dio)),
    );
    const since = '2026-09-30T10:00:00.000Z';
    adapter.onGet(
      'api/v3/history/since',
      (server) => server.reply(200, [
        {
          'id': 3,
          'eventType': 'downloadFolderImported',
          'date': '2026-09-30T11:00:00Z',
          'quality': {
            'quality': {'id': 3, 'name': 'WEBDL-1080p'},
          },
          'series': {'id': 1, 'title': 'Severance'},
          'episode': {
            'id': 5,
            'seasonNumber': 2,
            'episodeNumber': 5,
            'title': 'Trojan Horse',
          },
        },
      ]),
      queryParameters: {
        'date': since,
        'includeSeries': true,
        'includeEpisode': true,
      },
    );
    final check = (await source.check(since) as Ok<SourceCheck>).value;
    expect(check.items.single.title, 'Severance S02E05');
    expect(check.items.single.detail, 'Trojan Horse · WEBDL-1080p');
    expect(source.groupTitle(4), '4 episodes ready');
  });
}

// SonarrRepository release methods are thin passthroughs over SonarrClient:
// searchEpisodeReleases hands back the raw SonarrRelease list (mapping to the
// shared ReleaseCandidate view-model happens in the feature layer), and
// grabRelease forwards {guid, indexerId} to the client. Exercised end-to-end
// through the real SonarrClient against a mocked Dio.

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrRepository repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = SonarrRepository(SonarrClient(dio));
  });

  test('searchEpisodeReleases returns the raw SonarrRelease list', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(200, [
        {
          'guid': 'ix-1',
          'title': 'Show.S01E01-GRP',
          'size': 1234,
          'indexerId': 3,
          'indexer': 'ix',
          'seeders': 12,
          'leechers': 1,
          'protocol': 'torrent',
          'qualityWeight': 6,
          'quality': {
            'quality': {'name': 'WEBDL-1080p'},
          },
          'rejected': true,
          'rejections': [
            {'reason': 'Wrong quality', 'type': 'permanent'},
          ],
        },
      ]),
      queryParameters: {'episodeId': 9},
    );

    final result = await repo.searchEpisodeReleases(9);

    expect(result.isOk, isTrue);
    final release = result.valueOrNull!.single;
    expect(release, isA<SonarrRelease>());
    expect(release.guid, 'ix-1');
    expect(release.indexer, 'ix');
    expect(release.protocol, 'torrent');
    expect(release.quality?.quality?.name, 'WEBDL-1080p');
    expect(release.rejected, isTrue);
    expect(release.rejections, ['Wrong quality']);
  });

  test('searchEpisodeReleases propagates an Err from the client', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(500, {'message': 'boom'}),
      queryParameters: {'episodeId': 9},
    );

    final result = await repo.searchEpisodeReleases(9);

    expect(result.isErr, isTrue);
  });

  test('grabRelease delegates to the client', () async {
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(201, <String, dynamic>{}),
      data: {'guid': 'ix-1', 'indexerId': 3},
    );

    final result = await repo.grabRelease(guid: 'ix-1', indexerId: 3);

    expect(result.isOk, isTrue);
  });
}

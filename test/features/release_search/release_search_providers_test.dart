// releaseSearchResults dispatches to the Sonarr or Radarr repository based on
// ServiceType; releaseSortController defaults to Peers and updates on select.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

ProviderContainer _container(List<Override> overrides) {
  final c = ProviderContainer(overrides: overrides);
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('releaseSearchResults routes sonarr → SonarrRepository', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(dio: dio).onGet(
      'api/v3/release',
      (s) => s.reply(200, [
        {
          'guid': 'a',
          'title': 'A',
          'size': 1,
          'indexerId': 1,
          'protocol': 'torrent',
          'rejections': [],
        },
      ]),
      queryParameters: {'episodeId': 5},
    );

    final container = _container([
      sonarrRepositoryProvider('i1')
          .overrideWith((ref) async => SonarrRepository(SonarrClient(dio))),
    ]);

    final result = await container.read(
      releaseSearchResultsProvider(
        service: ServiceType.sonarr,
        instanceId: 'i1',
        targetId: 5,
      ).future,
    );

    expect(result, isA<Ok<List<ReleaseCandidate>>>());
    expect(result.valueOrNull!.single.guid, 'a');
  });

  test('releaseSearchResults routes radarr → RadarrRepository', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://r.test'));
    DioAdapter(dio: dio).onGet(
      'api/v3/release',
      (s) => s.reply(200, [
        {
          'guid': 'm',
          'title': 'M',
          'size': 1,
          'indexerId': 1,
          'protocol': 'torrent',
          'rejections': [],
        },
      ]),
      queryParameters: {'movieId': 9},
    );

    final container = _container([
      radarrRepositoryProvider('i2')
          .overrideWith((ref) async => RadarrRepository(RadarrClient(dio))),
    ]);

    final result = await container.read(
      releaseSearchResultsProvider(
        service: ServiceType.radarr,
        instanceId: 'i2',
        targetId: 9,
      ).future,
    );

    expect(result.valueOrNull!.single.guid, 'm');
  });

  test('releaseSearchResults returns Err for an unsupported service', () async {
    final container = _container(const []);

    final result = await container.read(
      releaseSearchResultsProvider(
        service: ServiceType.bazarr,
        instanceId: 'x',
        targetId: 1,
      ).future,
    );

    expect(result.isErr, isTrue);
  });

  test('releaseSortController defaults to peers and updates', () {
    final container = _container(const []);

    expect(container.read(releaseSortControllerProvider), ReleaseSort.peers);
    container
        .read(releaseSortControllerProvider.notifier)
        .select(ReleaseSort.size);
    expect(container.read(releaseSortControllerProvider), ReleaseSort.size);
  });
}

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('continueWatching caps at 3, ordered soonest-airing first', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    final repo = SonarrRepository(SonarrClient(dio));

    adapter.onGet(
      RegExp('api/v3/calendar.*'),
      (server) => server.reply(200, [
        {
          'id': 1,
          'seriesId': 10,
          'seasonNumber': 2,
          'episodeNumber': 5,
          'airDateUtc': DateTime.now()
              .add(const Duration(days: 2))
              .toUtc()
              .toIso8601String(),
          'hasFile': false,
          'monitored': true,
        },
      ]),
    );

    final container = ProviderContainer(
      overrides: [
        sonarrRepositoryProvider('inst-1').overrideWith((ref) async => repo),
        sonarrSeriesProvider('inst-1').overrideWith(
          (ref) async => Ok([
            SonarrSeries(
              id: 10,
              title: 'Severance',
              statistics: const SonarrStatistics(
                episodeFileCount: 10,
                totalEpisodeCount: 19,
              ),
            ),
            SonarrSeries(
              id: 11,
              title: 'Fully Downloaded Show',
              statistics: const SonarrStatistics(
                episodeFileCount: 5,
                totalEpisodeCount: 5,
              ),
            ),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final entries = await container.read(
      continueWatchingProvider('inst-1').future,
    );

    expect(entries, hasLength(1));
    expect(entries.single.series.title, 'Severance');
  });
}

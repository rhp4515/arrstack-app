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

/// Builds a [SonarrSeries] with the given partial-progress stats.
SonarrSeries _partialSeries(int id, String title) => SonarrSeries(
  id: id,
  title: title,
  statistics: const SonarrStatistics(
    episodeFileCount: 10,
    totalEpisodeCount: 19,
  ),
);

/// Builds a raw calendar-entry JSON map for [seriesId] airing at [airDate].
Map<String, dynamic> _calendarJson(int seriesId, DateTime airDate) => {
  'id': seriesId,
  'seriesId': seriesId,
  'seasonNumber': 2,
  'episodeNumber': 5,
  'airDateUtc': airDate.toUtc().toIso8601String(),
  'hasFile': false,
  'monitored': true,
};

void main() {
  test('continueWatching includes a single qualifying series', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    final repo = SonarrRepository(SonarrClient(dio));

    adapter.onGet(
      RegExp('api/v3/calendar.*'),
      (server) => server.reply(200, [
        _calendarJson(10, DateTime.now().add(const Duration(days: 2))),
      ]),
    );

    final container = ProviderContainer(
      overrides: [
        sonarrRepositoryProvider('inst-1').overrideWith((ref) async => repo),
        sonarrSeriesProvider('inst-1').overrideWith(
          (ref) async => Ok([
            _partialSeries(10, 'Severance'),
            const SonarrSeries(
              id: 11,
              title: 'Fully Downloaded Show',
              statistics: SonarrStatistics(
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

  test('continueWatching caps at 3, ordered soonest-airing first', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    final repo = SonarrRepository(SonarrClient(dio));
    final now = DateTime.now();

    // Four partial-progress series, each with a distinct future airing.
    // Intentionally out of order so a correct sort is actually exercised.
    adapter.onGet(
      RegExp('api/v3/calendar.*'),
      (server) => server.reply(200, [
        _calendarJson(20, now.add(const Duration(days: 8))), // 4th soonest
        _calendarJson(21, now.add(const Duration(days: 1))), // soonest
        _calendarJson(22, now.add(const Duration(days: 5))), // 3rd soonest
        _calendarJson(23, now.add(const Duration(days: 3))), // 2nd soonest
      ]),
    );

    final container = ProviderContainer(
      overrides: [
        sonarrRepositoryProvider('inst-1').overrideWith((ref) async => repo),
        sonarrSeriesProvider('inst-1').overrideWith(
          (ref) async => Ok([
            _partialSeries(20, 'Show D'),
            _partialSeries(21, 'Show A'),
            _partialSeries(22, 'Show C'),
            _partialSeries(23, 'Show B'),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final entries = await container.read(
      continueWatchingProvider('inst-1').future,
    );

    expect(entries, hasLength(3));
    expect(entries.map((e) => e.series.title).toList(), [
      'Show A',
      'Show B',
      'Show C',
    ]);
  });

  test('continueWatching omits a partial-progress series with no calendar '
      'entry rather than erroring', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    final repo = SonarrRepository(SonarrClient(dio));

    // Only series 30 has a calendar entry; series 31 has none.
    adapter.onGet(
      RegExp('api/v3/calendar.*'),
      (server) => server.reply(200, [
        _calendarJson(30, DateTime.now().add(const Duration(days: 2))),
      ]),
    );

    final container = ProviderContainer(
      overrides: [
        sonarrRepositoryProvider('inst-1').overrideWith((ref) async => repo),
        sonarrSeriesProvider('inst-1').overrideWith(
          (ref) async => Ok([
            _partialSeries(30, 'Has Calendar Entry'),
            _partialSeries(31, 'No Calendar Entry'),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final entries = await container.read(
      continueWatchingProvider('inst-1').future,
    );

    expect(entries, hasLength(1));
    expect(entries.single.series.title, 'Has Calendar Entry');
  });

  test(
    'ActiveLibrarySort defaults to recentlyAdded and updates on select',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(activeLibrarySortProvider),
        LibrarySort.recentlyAdded,
      );

      container
          .read(activeLibrarySortProvider.notifier)
          .select(LibrarySort.title);

      expect(container.read(activeLibrarySortProvider), LibrarySort.title);
    },
  );
}

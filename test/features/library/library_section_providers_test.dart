// Library sub-tab providers: Upcoming/Missing narrow the shared
// aggregations to one instance, Queue fills titles from the library list,
// and History pages through the repository.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/library/library_section_providers.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/sonarr/models/sonarr_history.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRadarrRepository extends Mock implements RadarrRepository {}

class _MockSonarrRepository extends Mock implements SonarrRepository {}

CalendarEntry _entry(
  String title, {
  String instanceId = 'r1',
  ServiceType service = ServiceType.radarr,
  bool monitored = true,
  int day = 1,
}) => CalendarEntry(
  kind: service == ServiceType.radarr
      ? CalendarEntryKind.movie
      : CalendarEntryKind.episode,
  service: service,
  instanceId: instanceId,
  date: DateTime(2026, 10, day),
  title: title,
  monitored: monitored,
);

RadarrHistoryRecord _radarrRecord(int id) => RadarrHistoryRecord(
  id: id,
  eventType: 'grabbed',
  date: DateTime.utc(2026, 9, 20),
  movie: RadarrHistoryMovie(title: 'Movie $id', year: 2020),
  quality: const RadarrQualityInfo(
    quality: RadarrQuality(name: 'Bluray-1080p'),
  ),
);

HistoryPage<T> _page<T>(List<T> records, {int? received, int? total}) =>
    HistoryPage(
      records: records,
      received: received ?? records.length,
      totalRecords: total,
    );

void main() {
  test('libraryUpcoming keeps monitored entries of one instance', () async {
    final container = ProviderContainer(
      overrides: [
        calendarScheduleProvider.overrideWith(
          (ref) async => Ok(
            groupEntriesByDay([
              _entry('Keep A', day: 2),
              _entry('Keep B', day: 1),
              _entry('Other instance', instanceId: 'r2'),
              _entry('Unmonitored', monitored: false),
              _entry(
                'A show on the same id',
                service: ServiceType.sonarr,
                instanceId: 'r1',
              ),
            ]),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      libraryUpcomingProvider(ServiceType.radarr, 'r1').future,
    );

    final days = result.valueOrNull!;
    expect(days, hasLength(2));
    expect(days.expand((d) => d.entries).map((e) => e.title), [
      'Keep B',
      'Keep A',
    ]);
  });

  test('libraryUpcoming passes a schedule error through', () async {
    final container = ProviderContainer(
      overrides: [
        calendarScheduleProvider.overrideWith(
          (ref) async => const Err(StorageError(userMessage: 'nope')),
        ),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(
      libraryUpcomingProvider(ServiceType.radarr, 'r1').future,
    );

    expect(result.errorOrNull?.userMessage, 'nope');
  });

  group('libraryMissingEpisodes', () {
    SonarrCalendarEpisode aired(int day) =>
        SonarrCalendarEpisode(id: day, airDateUtc: DateTime.utc(2026, 1, day));

    ProviderContainer over(Result<List<SonarrCalendarEpisode>> missing) {
      final repo = _MockSonarrRepository();
      when(repo.listMissingEpisodes).thenAnswer((_) async => missing);
      final container = ProviderContainer(
        overrides: [
          sonarrRepositoryProvider('s1').overrideWith((ref) async => repo),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('lists the instance\'s episodes newest first', () async {
      final container = over(Ok([aired(1), aired(3), aired(2)]));

      final result = (await container.read(
        libraryMissingEpisodesProvider('s1').future,
      )).valueOrNull!;

      expect(result.map((m) => m.episode.id), [3, 2, 1]);
      expect(result.map((m) => m.instanceId).toSet(), {'s1'});
    });

    test('reports an unreachable instance as an error, rather than as '
        'nothing missing', () async {
      final container = over(const Err(NetworkError()));

      final result = await container.read(
        libraryMissingEpisodesProvider('s1').future,
      );

      expect(result.errorOrNull, isA<NetworkError>());
    });
  });

  test('libraryQueue uses the movie title and computes progress', () async {
    final container = ProviderContainer(
      overrides: [
        radarrMoviesProvider('r1').overrideWith(
          (ref) async => const Ok([RadarrMovie(id: 7, title: 'Dune')]),
        ),
        radarrQueueProvider('r1').overrideWith(
          (ref) async => const Ok([
            RadarrQueueItem(
              id: 1,
              movieId: 7,
              title: 'Dune.2021.1080p-GRP',
              status: 'downloading',
              size: 100,
              sizeleft: 40,
              timeleft: '00:12:00',
            ),
            RadarrQueueItem(id: 2, title: 'Orphan.Release'),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(radarrMoviesProvider('r1').future);

    final result = await container.read(
      libraryQueueProvider(ServiceType.radarr, 'r1').future,
    );

    final entries = result.valueOrNull!;
    expect(entries.first.title, 'Dune');
    expect(entries.first.releaseTitle, 'Dune.2021.1080p-GRP');
    expect(entries.first.status, 'Downloading');
    expect(entries.first.progress, closeTo(0.6, 0.001));
    expect(entries.first.timeLeft, '12m left');
    expect(entries.last.title, 'Orphan.Release');
    expect(entries.last.releaseTitle, isNull);
    expect(entries.last.status, 'Queued');
  });

  test('libraryQueue works for Sonarr', () async {
    final container = ProviderContainer(
      overrides: [
        sonarrSeriesProvider('s1').overrideWith(
          (ref) async => const Ok([SonarrSeries(id: 9, title: 'Severance')]),
        ),
        sonarrQueueProvider('s1').overrideWith(
          (ref) async => const Ok([
            SonarrQueueItem(id: 1, seriesId: 9, title: 'Sev.S02E05'),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(sonarrSeriesProvider('s1').future);

    final result = await container.read(
      libraryQueueProvider(ServiceType.sonarr, 's1').future,
    );

    expect(result.valueOrNull!.single.title, 'Severance');
  });

  group('libraryHistory', () {
    test('loads page 1 and appends page 2 on loadMore', () async {
      final repo = _MockRadarrRepository();
      when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
        (_) async =>
            Ok(_page([for (var i = 1; i <= 50; i++) _radarrRecord(i)])),
      );
      when(() => repo.getHistoryPage(page: 2, pageSize: 50))
          .thenAnswer((_) async => Ok(_page([_radarrRecord(51)])));
      final container = ProviderContainer(
        overrides: [
          radarrRepositoryProvider('r1').overrideWith((ref) async => repo),
        ],
      );
      addTearDown(container.dispose);
      final provider = libraryHistoryProvider(ServiceType.radarr, 'r1');
      final sub = container.listen(provider, (_, _) {});
      addTearDown(sub.close);

      final first = (await container.read(provider.future)).valueOrNull!;
      expect(first.entries, hasLength(50));
      expect(first.hasMore, isTrue);
      expect(first.entries.first.title, 'Movie 1 (2020)');
      expect(first.entries.first.quality, 'Bluray-1080p');

      final error = await container.read(provider.notifier).loadMore();

      expect(error, isNull);
      final second = container.read(provider).value!.valueOrNull!;
      expect(second.entries, hasLength(51));
      expect(second.page, 2);
      expect(second.hasMore, isFalse);
    });

    test('loadMore returns the error and keeps loaded entries', () async {
      final repo = _MockRadarrRepository();
      when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
        (_) async =>
            Ok(_page([for (var i = 1; i <= 50; i++) _radarrRecord(i)])),
      );
      when(() => repo.getHistoryPage(page: 2, pageSize: 50))
          .thenAnswer((_) async => const Err(ServerError(userMessage: 'down')));
      final container = ProviderContainer(
        overrides: [
          radarrRepositoryProvider('r1').overrideWith((ref) async => repo),
        ],
      );
      addTearDown(container.dispose);
      final provider = libraryHistoryProvider(ServiceType.radarr, 'r1');
      final sub = container.listen(provider, (_, _) {});
      addTearDown(sub.close);
      await container.read(provider.future);

      final error = await container.read(provider.notifier).loadMore();

      expect(error?.userMessage, 'down');
      expect(
        container.read(provider).value!.valueOrNull!.entries,
        hasLength(50),
      );
    });

    test('maps Sonarr records with the episode code', () async {
      final repo = _MockSonarrRepository();
      when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
        (_) async => Ok(
          _page([
            SonarrHistoryRecord(
              id: 1,
              eventType: 'downloadFolderImported',
              date: DateTime.utc(2026, 9, 20),
              series: const SonarrHistorySeries(title: 'Severance'),
              episode: const SonarrHistoryEpisode(
                seasonNumber: 2,
                episodeNumber: 5,
              ),
            ),
          ]),
        ),
      );
      final container = ProviderContainer(
        overrides: [
          sonarrRepositoryProvider('s1').overrideWith((ref) async => repo),
        ],
      );
      addTearDown(container.dispose);
      final provider = libraryHistoryProvider(ServiceType.sonarr, 's1');
      final sub = container.listen(provider, (_, _) {});
      addTearDown(sub.close);

      final feed = (await container.read(provider.future)).valueOrNull!;

      expect(feed.entries.single.title, 'Severance S02E05');
      expect(feed.hasMore, isFalse);
    });

    Future<LibraryHistory> historyOver(_MockRadarrRepository repo) async {
      final container = ProviderContainer(
        overrides: [
          radarrRepositoryProvider('r1').overrideWith((ref) async => repo),
        ],
      );
      addTearDown(container.dispose);
      final provider = libraryHistoryProvider(ServiceType.radarr, 'r1');
      final sub = container.listen(provider, (_, _) {});
      addTearDown(sub.close);
      await container.read(provider.future);
      return container.read(provider.notifier);
    }

    LibraryHistoryFeed feedOf(LibraryHistory history) =>
        history.state.value!.valueOrNull!;

    test('loadMore drops rows already listed when new history shifted '
        'the pages', () async {
      final repo = _MockRadarrRepository();
      // Page 1 held 100..51; two new events then pushed 52 and 51 onto
      // page 2, which now starts with rows already shown.
      when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
        (_) async =>
            Ok(_page([for (var i = 100; i > 50; i--) _radarrRecord(i)])),
      );
      when(() => repo.getHistoryPage(page: 2, pageSize: 50)).thenAnswer(
        (_) async => Ok(_page([for (var i = 52; i > 2; i--) _radarrRecord(i)])),
      );
      final history = await historyOver(repo);

      await history.loadMore();

      final ids = feedOf(history).entries.map((e) => e.id).toList();
      expect(ids, [for (var i = 100; i > 2; i--) i]);
      expect(ids.toSet(), hasLength(ids.length), reason: 'no row twice');
    });

    test('a full page with a record that failed to parse still offers '
        'Load more', () async {
      final repo = _MockRadarrRepository();
      when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
        (_) async => Ok(
          _page([for (var i = 1; i <= 49; i++) _radarrRecord(i)], received: 50),
        ),
      );
      final history = await historyOver(repo);

      expect(feedOf(history).entries, hasLength(49));
      expect(feedOf(history).hasMore, isTrue);
    });

    test("goes by the server's total when it reports one", () async {
      final repo = _MockRadarrRepository();
      when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
        (_) async => Ok(
          _page([for (var i = 1; i <= 50; i++) _radarrRecord(i)], total: 50),
        ),
      );
      final history = await historyOver(repo);

      expect(
        feedOf(history).hasMore,
        isFalse,
        reason: 'a full page, but the last one — no empty page 2 to load',
      );
    });
  });
}

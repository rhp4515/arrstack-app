import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Stands in for a real `SonarrRepository` so tests control
/// `listMissingEpisodes()` without a live Dio/HTTP layer. `SonarrRepository`
/// is a plain (non-`final`) class, so overriding one method here is safe —
/// nothing else on it is called by `sonarrMissingEpisodesProvider`.
class _FakeSonarrRepository extends SonarrRepository {
  _FakeSonarrRepository(this._result) : super(SonarrClient(Dio()));
  final Result<List<SonarrCalendarEpisode>> _result;

  @override
  Future<Result<List<SonarrCalendarEpisode>>> listMissingEpisodes() async =>
      _result;
}

void main() {
  group('ActiveActivityLens', () {
    test('defaults to transfers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(activeActivityLensProvider),
        ActivityLens.transfers,
      );
    });

    test('select updates the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(activeActivityLensProvider.notifier)
          .select(ActivityLens.wanted);

      expect(container.read(activeActivityLensProvider), ActivityLens.wanted);
    });
  });

  group('sonarrMissingEpisodesProvider', () {
    SonarrCalendarEpisode episode(int id, {DateTime? airDateUtc}) =>
        SonarrCalendarEpisode(id: id, airDateUtc: airDateUtc);

    test('aggregates missing episodes across every reachable Sonarr instance, keeping instanceId', () async {
      final a = buildInstance(id: 'sonarr-a', serviceType: ServiceType.sonarr);
      final b = buildInstance(id: 'sonarr-b', serviceType: ServiceType.sonarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          sonarrRepositoryProvider(a.id).overrideWith(
            (ref) async => _FakeSonarrRepository(Ok([episode(1)])),
          ),
          sonarrRepositoryProvider(b.id).overrideWith(
            (ref) async => _FakeSonarrRepository(Ok([episode(2)])),
          ),
        ],
      );
      addTearDown(container.dispose);

      final episodes = await container.read(
        sonarrMissingEpisodesProvider.future,
      );
      expect(episodes.map((e) => e.episode.id), containsAll([1, 2]));
      expect(
        episodes.firstWhere((e) => e.episode.id == 1).instanceId,
        'sonarr-a',
      );
      expect(
        episodes.firstWhere((e) => e.episode.id == 2).instanceId,
        'sonarr-b',
      );
    });

    test('drops a failing instance silently and keeps the rest', () async {
      final a = buildInstance(id: 'sonarr-a', serviceType: ServiceType.sonarr);
      final b = buildInstance(id: 'sonarr-b', serviceType: ServiceType.sonarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          sonarrRepositoryProvider(a.id).overrideWith(
            (ref) async => _FakeSonarrRepository(const Err(NetworkError())),
          ),
          sonarrRepositoryProvider(b.id).overrideWith(
            (ref) async => _FakeSonarrRepository(Ok([episode(2)])),
          ),
        ],
      );
      addTearDown(container.dispose);

      final episodes = await container.read(
        sonarrMissingEpisodesProvider.future,
      );
      expect(episodes.map((e) => e.episode.id), [2]);
    });

    test('sorts by airDateUtc ascending, nulls last', () {
      final unsorted = [
        SonarrMissingEpisode(
          instanceId: 'i',
          episode: episode(1, airDateUtc: DateTime.utc(2026, 3, 1)),
        ),
        SonarrMissingEpisode(instanceId: 'i', episode: episode(2)),
        SonarrMissingEpisode(
          instanceId: 'i',
          episode: episode(3, airDateUtc: DateTime.utc(2026, 1, 1)),
        ),
      ];

      final sorted = sortMissingEpisodesByAirDate(unsorted);

      expect(sorted.map((e) => e.episode.id), [3, 1, 2]);
    });

    test('returns empty when there are no Sonarr instances', () async {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => const Ok([])),
        ],
      );
      addTearDown(container.dispose);

      final episodes = await container.read(
        sonarrMissingEpisodesProvider.future,
      );
      expect(episodes, isEmpty);
    });
  });

  group('bazarrWantedAggregateProvider', () {
    test('concatenates subtitles from every reachable instance', () async {
      final a = buildInstance(id: 'bazarr-a', serviceType: ServiceType.bazarr);
      final b = buildInstance(id: 'bazarr-b', serviceType: ServiceType.bazarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          bazarrWantedProvider(a.id).overrideWith(
            (ref) async => const Ok([BazarrWantedSubtitle(title: 'x')]),
          ),
          bazarrWantedProvider(b.id).overrideWith(
            (ref) async => const Ok([BazarrWantedSubtitle(title: 'y')]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final aggregate = await container.read(
        bazarrWantedAggregateProvider.future,
      );
      expect(aggregate.subtitles.map((s) => s.title), ['x', 'y']);
      expect(aggregate.hasUnreachableInstance, isFalse);
    });

    test(
      'sets hasUnreachableInstance and keeps the other instance\'s subtitles',
      () async {
        final a = buildInstance(
          id: 'bazarr-a',
          serviceType: ServiceType.bazarr,
        );
        final b = buildInstance(
          id: 'bazarr-b',
          serviceType: ServiceType.bazarr,
        );

        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([a, b])),
            bazarrWantedProvider(a.id)
                .overrideWith((ref) async => const Err(NetworkError())),
            bazarrWantedProvider(b.id).overrideWith(
              (ref) async => const Ok([BazarrWantedSubtitle(title: 'y')]),
            ),
          ],
        );
        addTearDown(container.dispose);

        final aggregate = await container.read(
          bazarrWantedAggregateProvider.future,
        );
        expect(aggregate.hasUnreachableInstance, isTrue);
        expect(aggregate.subtitles.map((s) => s.title), ['y']);
      },
    );

    test('sets hasUnreachableInstance when an instance throws (not just Err) '
        'and keeps the other instance\'s subtitles', () async {
      final a = buildInstance(id: 'bazarr-a', serviceType: ServiceType.bazarr);
      final b = buildInstance(id: 'bazarr-b', serviceType: ServiceType.bazarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          bazarrWantedProvider(a.id).overrideWith(
            (ref) async => throw Exception('endpoint resolution failed'),
          ),
          bazarrWantedProvider(b.id).overrideWith(
            (ref) async => const Ok([BazarrWantedSubtitle(title: 'y')]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final aggregate = await container.read(
        bazarrWantedAggregateProvider.future,
      );
      expect(aggregate.hasUnreachableInstance, isTrue);
      expect(aggregate.subtitles.map((s) => s.title), ['y']);
    });

    test(
      'is not unreachable and has no subtitles with zero Bazarr instances',
      () async {
        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => const Ok([])),
          ],
        );
        addTearDown(container.dispose);

        final aggregate = await container.read(
          bazarrWantedAggregateProvider.future,
        );
        expect(aggregate.subtitles, isEmpty);
        expect(aggregate.hasUnreachableInstance, isFalse);
      },
    );
  });

  group('TransfersThroughputHistory', () {
    Result<QbitMainData> mainData(int dlSpeed) => Ok(
      QbitMainData(
        serverState: QbitServerState(
          dlInfoSpeed: dlSpeed,
          dlInfoData: 0,
          upInfoSpeed: 0,
          upInfoData: 0,
          dlRateLimit: 0,
          upRateLimit: 0,
          dhtNodes: 0,
          connectionStatus: 'connected',
        ),
      ),
    );

    test('samples every 5 seconds while a listener is active', () {
      fakeAsync((async) {
        final container = ProviderContainer(
          overrides: [
            qbitMainDataProvider('qbit-1')
                .overrideWith((ref) async => mainData(1024)),
          ],
        );
        addTearDown(container.dispose);

        container.listen(
          transfersThroughputHistoryProvider('qbit-1'),
          (_, _) {},
          fireImmediately: true,
        );
        async.flushMicrotasks();

        async.elapse(const Duration(seconds: 15));
        async.flushMicrotasks();

        final samples = container.read(
          transfersThroughputHistoryProvider('qbit-1'),
        );
        expect(samples.length, greaterThanOrEqualTo(3));
        expect(samples.every((s) => s.dlSpeedBytesPerSecond == 1024), isTrue);
      });
    });

    test(
      'pruneAndAppendThroughputSample drops samples older than 60 minutes',
      () {
        final now = DateTime.utc(2026, 1, 15, 12, 0, 0);
        // Old: 2 hours before now (outside 60-minute window)
        final old = DateTime.utc(2026, 1, 15, 10, 0, 0);
        // Recent: 30 minutes before now (within 60-minute window)
        final recent = DateTime.utc(2026, 1, 15, 11, 30, 0);

        final current = [
          ThroughputSample(timestamp: old, dlSpeedBytesPerSecond: 100),
          ThroughputSample(timestamp: recent, dlSpeedBytesPerSecond: 200),
        ];

        final result = pruneAndAppendThroughputSample(current, 512, now);

        // Old sample should be dropped, recent and new should remain
        expect(result.length, 2);
        expect(result[0].dlSpeedBytesPerSecond, 200);
        expect(result[1].dlSpeedBytesPerSecond, 512);
        expect(
          result.every(
            (s) =>
                s.timestamp.isAfter(now.subtract(const Duration(minutes: 60))),
          ),
          isTrue,
        );
      },
    );

    test('stops sampling after disposal', () {
      fakeAsync((async) {
        var pollCount = 0;
        final container = ProviderContainer(
          overrides: [
            qbitMainDataProvider('qbit-1').overrideWith((ref) async {
              pollCount++;
              return mainData(1024);
            }),
          ],
        );

        container.listen(
          transfersThroughputHistoryProvider('qbit-1'),
          (_, _) {},
          fireImmediately: true,
        );
        async.flushMicrotasks();

        // Let some samples collect
        async.elapse(const Duration(seconds: 10));
        async.flushMicrotasks();
        final countBefore = pollCount;
        expect(countBefore, greaterThan(0));

        // Dispose the provider
        container.dispose();

        // Elapse more time and verify no additional polls occurred
        async.elapse(const Duration(seconds: 10));
        async.flushMicrotasks();
        expect(pollCount, countBefore);
      });
    });

    test('keeps sampling on later ticks after a tick throws (e.g. missing '
        'credentials or an unresolvable endpoint)', () {
      fakeAsync((async) {
        var callCount = 0;
        final container = ProviderContainer(
          overrides: [
            qbitMainDataProvider('qbit-1').overrideWith((ref) async {
              callCount++;
              if (callCount == 1) {
                throw Exception('No credentials found for instance qbit-1');
              }
              return mainData(1024);
            }),
          ],
        );
        addTearDown(container.dispose);

        container.listen(
          transfersThroughputHistoryProvider('qbit-1'),
          (_, _) {},
          fireImmediately: true,
        );
        async.flushMicrotasks();

        // First tick throws inside `_sample`; it must be swallowed rather
        // than propagate as an unhandled async error, and this tick's
        // sample is skipped.
        async.elapse(const Duration(seconds: 5));
        async.flushMicrotasks();
        expect(
          container.read(transfersThroughputHistoryProvider('qbit-1')),
          isEmpty,
        );

        // The timer must still be running for the next tick.
        async.elapse(const Duration(seconds: 5));
        async.flushMicrotasks();
        final samples = container.read(
          transfersThroughputHistoryProvider('qbit-1'),
        );
        expect(samples, isNotEmpty);
        expect(samples.every((s) => s.dlSpeedBytesPerSecond == 1024), isTrue);
      });
    });

    test('starts empty before the first sample tick', () {
      final container = ProviderContainer(
        overrides: [
          qbitMainDataProvider('qbit-1')
              .overrideWith((ref) async => mainData(0)),
        ],
      );
      addTearDown(container.dispose);

      final samples = container.read(
        transfersThroughputHistoryProvider('qbit-1'),
      );
      expect(samples, isEmpty);
    });
  });
}

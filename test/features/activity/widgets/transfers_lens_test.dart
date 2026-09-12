import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/transfers_lens.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stands in for the real [SelectedDownloadInstanceId] so tests can supply
/// a fixed instance id (or null) without going through the real
/// instance-loading logic.
class _FakeSelectedDownloadInstanceId extends SelectedDownloadInstanceId {
  _FakeSelectedDownloadInstanceId(this.value);

  final String? value;

  @override
  Future<String?> build() async => value;
}

QbitTorrent _torrent(String hash, String state) => QbitTorrent(
  hash: hash,
  name: hash,
  size: 1000,
  progress: 0.5,
  dlspeed: 100,
  upspeed: 0,
  priority: 1,
  numSeeds: 1,
  numLeechs: 1,
  numIncomplete: 0,
  ratio: 0,
  eta: 60,
  state: state,
  addedOn: 0,
  completionOn: 0,
  category: '',
  tags: '',
  savePath: '',
  timeActive: 0,
  lastActivity: 0,
);

void main() {
  group('filterTorrents', () {
    final torrents = [
      _torrent('a', 'downloading'),
      _torrent('b', 'uploading'),
      _torrent('c', 'pausedDL'),
    ];

    test('all returns every torrent', () {
      expect(filterTorrents(torrents, TorrentFilter.all), hasLength(3));
    });

    test('active returns only actively downloading torrents', () {
      final result = filterTorrents(torrents, TorrentFilter.active);
      expect(result.map((t) => t.hash), ['a']);
    });

    test('seeding returns completed/uploading torrents', () {
      final result = filterTorrents(torrents, TorrentFilter.seeding);
      expect(result.map((t) => t.hash), ['b']);
    });

    test('active excludes a stalled torrent', () {
      final withStalled = [...torrents, _torrent('d', 'stalledDL')];
      final result = filterTorrents(withStalled, TorrentFilter.active);
      expect(result.map((t) => t.hash), ['a']);
    });

    test('seeding treats progress >= 1.0 as complete regardless of state', () {
      const complete = QbitTorrent(
        hash: 'e',
        name: 'e',
        size: 1000,
        progress: 1.0,
        dlspeed: 0,
        upspeed: 0,
        priority: 1,
        numSeeds: 1,
        numLeechs: 0,
        numIncomplete: 0,
        ratio: 1,
        eta: 0,
        state: 'downloading',
        addedOn: 0,
        completionOn: 0,
        category: '',
        tags: '',
        savePath: '',
        timeActive: 0,
        lastActivity: 0,
      );
      final result = filterTorrents([complete], TorrentFilter.seeding);
      expect(result.map((t) => t.hash), ['e']);
    });

    // The lens only surfaces All/Downloading/Seeding as chips, but
    // `filterTorrents` switches on all 7 `TorrentFilter` values — the
    // remaining four fall back to returning the unfiltered list.
    for (final filter in [
      TorrentFilter.completed,
      TorrentFilter.stalled,
      TorrentFilter.paused,
      TorrentFilter.errored,
    ]) {
      test('$filter falls back to returning every torrent unfiltered', () {
        expect(filterTorrents(torrents, filter), hasLength(3));
      });
    }
  });

  group('TransfersLens widget', () {
    testWidgets('shows an empty state when there is no qBittorrent instance', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedDownloadInstanceIdProvider.overrideWith(
              () => _FakeSelectedDownloadInstanceId(null),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: TransfersLens())),
        ),
      );
      await tester.pump();

      expect(find.text('No qBittorrent instance'), findsOneWidget);
    });

    testWidgets('shows the sparkline, secondary chips, and torrent list', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedDownloadInstanceIdProvider.overrideWith(
              () => _FakeSelectedDownloadInstanceId('qbit-1'),
            ),
            qbitTorrentsProvider(
              'qbit-1',
            ).overrideWith((ref) async => Ok([_torrent('a', 'downloading')])),
            transfersThroughputHistoryProvider('qbit-1')
                .overrideWith(_FakeHistory.new),
          ],
          child: const MaterialApp(home: Scaffold(body: TransfersLens())),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('All'), findsOneWidget);
      expect(find.textContaining('Downloading'), findsWidgets);
      expect(find.textContaining('Seeding'), findsWidgets);
      expect(find.text('a'), findsOneWidget); // torrent name
    });

    testWidgets(
      'shows an empty state message when the filter matches nothing',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectedDownloadInstanceIdProvider.overrideWith(
                () => _FakeSelectedDownloadInstanceId('qbit-1'),
              ),
              qbitTorrentsProvider('qbit-1')
                  .overrideWith((ref) async => const Ok([])),
              transfersThroughputHistoryProvider('qbit-1')
                  .overrideWith(_FakeHistory.new),
            ],
            child: const MaterialApp(home: Scaffold(body: TransfersLens())),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.text('Nothing here'), findsOneWidget);
      },
    );

    testWidgets(
      'shows an error state with a retry action when torrents fail to load',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectedDownloadInstanceIdProvider.overrideWith(
                () => _FakeSelectedDownloadInstanceId('qbit-1'),
              ),
              qbitTorrentsProvider('qbit-1').overrideWith(
                (ref) async => const Err(
                  UnknownError(userMessage: 'Could not reach qBittorrent'),
                ),
              ),
              transfersThroughputHistoryProvider('qbit-1')
                  .overrideWith(_FakeHistory.new),
            ],
            child: const MaterialApp(home: Scaffold(body: TransfersLens())),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.text('Failed to load torrents'), findsOneWidget);
        expect(find.text('Could not reach qBittorrent'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets('tapping a secondary chip changes the active filter', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedDownloadInstanceIdProvider.overrideWith(
              () => _FakeSelectedDownloadInstanceId('qbit-1'),
            ),
            qbitTorrentsProvider('qbit-1').overrideWith(
              (ref) async => Ok([
                _torrent('a', 'downloading'),
                _torrent('b', 'uploading'),
              ]),
            ),
            transfersThroughputHistoryProvider('qbit-1')
                .overrideWith(_FakeHistory.new),
          ],
          child: const MaterialApp(home: Scaffold(body: TransfersLens())),
        ),
      );
      await tester.pump();
      await tester.pump();

      // Default filter is `active`, so only the downloading torrent shows.
      // ('a' renders via `Text(torrent.name)` in the downloading block;
      // 'b' would render as a seeding row, which embeds the name inside a
      // combined "name size · speed" string rather than a bare Text('b').)
      expect(find.text('a'), findsOneWidget);
      expect(find.textContaining('b'), findsNothing);

      await tester.tap(find.textContaining('Seeding'));
      await tester.pump();
      await tester.pump();

      expect(find.text('a'), findsNothing);
      expect(find.textContaining('b'), findsOneWidget);
    });
  });
}

/// Stands in for the real [TransfersThroughputHistory] so the widget test
/// doesn't start a live `Timer.periodic` — the sampling behavior itself is
/// covered by Task 6's provider tests.
class _FakeHistory extends TransfersThroughputHistory {
  @override
  List<ThroughputSample> build(String instanceId) => const [];
}

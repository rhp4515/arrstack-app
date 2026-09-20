import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/qbittorrent/qbit_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

QbitTorrent _torrent({
  required String state,
  double progress = 0.5,
  double ratio = 0.0,
}) => QbitTorrent(
  hash: 'h1',
  name: 'Some.Release-GRP',
  size: 1000000000,
  progress: progress,
  dlspeed: 1000,
  upspeed: 500,
  priority: 1,
  numSeeds: 10,
  numLeechs: 5,
  numIncomplete: 0,
  ratio: ratio,
  eta: 300,
  state: state,
  tracker: 'https://torrentleech.org/announce',
  addedOn: 0,
  completionOn: 0,
  category: '',
  tags: '',
  savePath: '',
  timeActive: 0,
  lastActivity: 0,
);

class FakeQbitRepository implements QbitRepository {
  final List<String> stoppedHashes = [];
  final List<String> deletedHashes = [];
  final Map<String, bool> deleteFilesMap = {};

  @override
  Future<Result<void>> stopTorrents(List<String> hashes) async {
    stoppedHashes.addAll(hashes);
    return const Ok(null);
  }

  @override
  Future<Result<void>> deleteTorrents(
    List<String> hashes, {
    bool deleteFiles = false,
  }) async {
    deletedHashes.addAll(hashes);
    for (final hash in hashes) {
      deleteFilesMap[hash] = deleteFiles;
    }
    return const Ok(null);
  }

  @override
  Future<Result<List<QbitTorrent>>> listTorrents() async =>
      const Ok(<QbitTorrent>[]);

  @override
  Future<Result<QbitMainData>> getMainData() async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> startTorrents(List<String> hashes) async =>
      const Ok(null);

  @override
  Future<Result<void>> addTorrent(String url) async => const Ok(null);

  @override
  Future<Result<ServiceIdentity>> testConnection() async =>
      throw UnimplementedError();
}

Future<void> _pump(
  WidgetTester tester,
  QbitTorrent torrent, {
  FakeQbitRepository? fakeRepository,
}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: fakeRepository != null
          ? [
              qbitRepositoryProvider('qbit-1')
                  .overrideWithValue(AsyncValue.data(fakeRepository)),
            ]
          : [],
      child: MaterialApp(
        home: Scaffold(
          body: TorrentBlock(instanceId: 'qbit-1', torrent: torrent),
        ),
      ),
    ),
  );
}

void main() {
  test('torrentIsComplete is true for finished/seeding states', () {
    expect(
      torrentIsComplete(_torrent(state: 'uploading', progress: 1)),
      isTrue,
    );
    expect(torrentIsComplete(_torrent(state: 'stalledUP')), isTrue);
    expect(
      torrentIsComplete(_torrent(state: 'downloading', progress: 0.5)),
      isFalse,
    );
  });

  test('torrentIsStalled is true only for stalledDL', () {
    expect(torrentIsStalled(_torrent(state: 'stalledDL')), isTrue);
    expect(torrentIsStalled(_torrent(state: 'downloading')), isFalse);
  });

  testWidgets('downloading state shows the Downloading tag and progress', (
    tester,
  ) async {
    await _pump(tester, _torrent(state: 'downloading', progress: 0.68));

    expect(find.text('Downloading'), findsOneWidget);
    expect(find.text('68%'), findsOneWidget);
    expect(find.text('Some.Release-GRP'), findsOneWidget);
  });

  testWidgets(
    'stalled state shows the Stalled tag and a Find another release button',
    (tester) async {
      await _pump(tester, _torrent(state: 'stalledDL', progress: 0.23));

      expect(find.text('Stalled'), findsOneWidget);
      expect(find.text('Find another release'), findsOneWidget);
    },
  );

  testWidgets('seeding state shows a compact row with the ratio', (
    tester,
  ) async {
    await _pump(tester, _torrent(state: 'uploading', progress: 1, ratio: 1.42));

    expect(find.text('1.42'), findsOneWidget);
    expect(find.text('Downloading'), findsNothing);
    expect(find.text('Find another release'), findsNothing);
  });

  testWidgets('stalled Find another release button shows SnackBar', (
    tester,
  ) async {
    await _pump(tester, _torrent(state: 'stalledDL'));

    await tester.tap(find.text('Find another release'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(
        'Search for a replacement release from the Library or Wanted tab.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('downloading pause button calls stopTorrents with hash', (
    tester,
  ) async {
    final fakeRepo = FakeQbitRepository();
    await _pump(
      tester,
      _torrent(state: 'downloading'),
      fakeRepository: fakeRepo,
    );

    final pauseButton = find.byTooltip('Pause');
    expect(pauseButton, findsOneWidget);

    await tester.tap(pauseButton);
    await tester.pumpAndSettle();

    expect(fakeRepo.stoppedHashes, contains('h1'));
  });

  testWidgets('downloading delete button opens the shared confirm dialog', (
    tester,
  ) async {
    final fakeRepo = FakeQbitRepository();
    await _pump(
      tester,
      _torrent(state: 'downloading'),
      fakeRepository: fakeRepo,
    );

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Remove this torrent?'), findsOneWidget);
    expect(find.text('Also delete files on disk'), findsOneWidget);

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(fakeRepo.deletedHashes, contains('h1'));
    expect(fakeRepo.deleteFilesMap['h1'], isFalse);
  });

  testWidgets('downloading delete cancel does not delete anything', (
    tester,
  ) async {
    final fakeRepo = FakeQbitRepository();
    await _pump(
      tester,
      _torrent(state: 'downloading'),
      fakeRepository: fakeRepo,
    );

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(fakeRepo.deletedHashes, isEmpty);
  });

  testWidgets('stalled delete button now opens the shared confirm dialog '
      '(previously deleted with no confirmation at all)', (tester) async {
    final fakeRepo = FakeQbitRepository();
    await _pump(tester, _torrent(state: 'stalledDL'), fakeRepository: fakeRepo);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Remove this torrent?'), findsOneWidget);
    expect(fakeRepo.deletedHashes, isEmpty);

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(fakeRepo.deletedHashes, contains('h1'));
    expect(fakeRepo.deleteFilesMap['h1'], isFalse);
  });
}

import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
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

Future<void> _pump(WidgetTester tester, QbitTorrent torrent) {
  return tester.pumpWidget(
    ProviderScope(
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
}

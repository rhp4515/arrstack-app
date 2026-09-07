// The tile is the scannable row: title + a facts line (quality, size, peers,
// indexer, age). Rejected releases are dimmed and surface their first reason.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate release({
  bool rejected = false,
  List<String> rejections = const [],
  int? seeders = 25,
  ReleaseProtocol protocol = ReleaseProtocol.torrent,
}) => ReleaseCandidate(
  guid: 'g',
  indexerId: 1,
  indexerName: 'MyIndexer',
  title: 'Show.S01E01.1080p.WEB-DL-GRP',
  sizeBytes: 2000000000,
  protocol: protocol,
  qualityLabel: 'WEBDL-1080p',
  qualityWeight: 6,
  ageMinutes: 200,
  isRejected: rejected,
  rejections: rejections,
  downloadAllowed: true,
  seeders: seeders,
  leechers: 2,
);

Future<void> _pump(
  WidgetTester tester,
  ReleaseCandidate r, {
  VoidCallback? onTap,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ReleaseTile(release: r, onTap: onTap ?? () {}),
      ),
    ),
  );
}

void main() {
  testWidgets('shows title, quality, indexer and a formatted size', (
    tester,
  ) async {
    await _pump(tester, release());
    expect(find.textContaining('Show.S01E01'), findsOneWidget);
    expect(find.textContaining('WEBDL-1080p'), findsOneWidget);
    expect(find.textContaining('MyIndexer'), findsOneWidget);
    expect(find.textContaining('GB'), findsOneWidget);
  });

  testWidgets('usenet release shows "usenet" instead of a peer count', (
    tester,
  ) async {
    await _pump(
      tester,
      release(protocol: ReleaseProtocol.usenet, seeders: null),
    );
    expect(find.textContaining('usenet'), findsOneWidget);
  });

  testWidgets('rejected release is dimmed and shows its first reason', (
    tester,
  ) async {
    await _pump(
      tester,
      release(rejected: true, rejections: const ['Wrong quality', 'Too big']),
    );
    expect(find.textContaining('Wrong quality'), findsOneWidget);
    expect(find.textContaining('+1 more'), findsOneWidget);
    expect(find.byType(Opacity), findsWidgets);
  });

  testWidgets('tapping the tile invokes onTap', (tester) async {
    var tapped = false;
    await _pump(tester, release(), onTap: () => tapped = true);
    await tester.tap(find.byType(ReleaseTile));
    expect(tapped, isTrue);
  });
}

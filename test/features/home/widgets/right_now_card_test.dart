import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/home/widgets/right_now_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows throughput and torrent counts', (tester) async {
    const summary = RightNowSummary(
      downloadSpeed: 1024 * 1024,
      uploadSpeed: 512 * 1024,
      downloadingCount: 2,
      seedingCount: 3,
      etaToNextFinishSeconds: 300,
      downloadingFraction: 0.5,
      pausedOrStalledFraction: 0.25,
      queuedFraction: 0.25,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: RightNowCard(summary: summary)),
      ),
    );

    expect(find.textContaining('2 downloading'), findsOneWidget);
    expect(find.textContaining('3 seeding'), findsOneWidget);
  });

  testWidgets(
    'renders a single neutral segment when there are no active torrents',
    (tester) async {
      const summary = RightNowSummary(
        downloadSpeed: 0,
        uploadSpeed: 0,
        downloadingCount: 0,
        seedingCount: 0,
        downloadingFraction: 0,
        pausedOrStalledFraction: 0,
        queuedFraction: 0,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RightNowCard(summary: summary)),
        ),
      );

      expect(find.byType(RightNowCard), findsOneWidget);
    },
  );
}

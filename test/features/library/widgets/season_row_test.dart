import 'package:arrstack/features/library/widgets/season_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeasonRow', () {
    testWidgets('shows label and have/total, collapsed by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeasonRow(
              label: 'Season 2',
              have: 10,
              total: 10,
              episodes: (_) => const Text('episode list'),
            ),
          ),
        ),
      );

      expect(find.text('Season 2'), findsOneWidget);
      expect(find.text('10/10'), findsOneWidget);
      expect(find.text('episode list'), findsNothing);
    });

    testWidgets('expands to show episodes on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeasonRow(
              label: 'Season 2',
              have: 10,
              total: 10,
              episodes: (_) => const Text('episode list'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Season 2'));
      await tester.pumpAndSettle();

      expect(find.text('episode list'), findsOneWidget);
    });
  });

  group('EpisodeRow', () {
    testWidgets('shows code, title, and quality when downloaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EpisodeRow(
              code: 'S02E05',
              title: 'The You You Are',
              hasFile: true,
              qualityLabel: 'WEBDL-1080p',
            ),
          ),
        ),
      );

      expect(find.text('S02E05'), findsOneWidget);
      expect(find.text('The You You Are'), findsOneWidget);
      expect(find.text('WEBDL-1080p'), findsOneWidget);
      expect(find.text('Missing'), findsNothing);
    });

    testWidgets('shows "Missing" when not downloaded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EpisodeRow(
              code: 'S01E08',
              title: 'Unknown Episode',
              hasFile: false,
              qualityLabel: null,
            ),
          ),
        ),
      );

      expect(find.text('Missing'), findsOneWidget);
    });
  });
}

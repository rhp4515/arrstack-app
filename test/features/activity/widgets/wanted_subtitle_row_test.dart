/// Tests for [WantedSubtitleRow] widget.
library;

import 'package:arrstack/features/activity/widgets/wanted_subtitle_row.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WantedSubtitleRow', () {
    testWidgets('displays title for movie', (WidgetTester tester) async {
      const subtitle = BazarrWantedSubtitle(
        title: 'Inception',
        type: 'movie',
        languages: ['en', 'fr'],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
        ),
      );

      expect(find.text('Inception'), findsOneWidget);
    });

    testWidgets('displays title and meta line for episode', (
      WidgetTester tester,
    ) async {
      const subtitle = BazarrWantedSubtitle(
        title: 'Pilot',
        type: 'episode',
        seriesTitle: 'Breaking Bad',
        seasonNumber: 1,
        episodeNumber: 1,
        languages: ['en'],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
        ),
      );

      expect(find.text('Pilot'), findsOneWidget);
      expect(find.text('Breaking Bad - S01E01'), findsOneWidget);
    });

    testWidgets('displays language chips', (WidgetTester tester) async {
      const subtitle = BazarrWantedSubtitle(
        title: 'Test Movie',
        type: 'movie',
        languages: ['en', 'fr', 'es'],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
        ),
      );

      expect(find.text('EN'), findsOneWidget);
      expect(find.text('FR'), findsOneWidget);
      expect(find.text('ES'), findsOneWidget);
    });

    testWidgets('displays no meta line when languages list is empty', (
      WidgetTester tester,
    ) async {
      const subtitle = BazarrWantedSubtitle(
        title: 'Test Movie',
        type: 'movie',
        languages: [],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
        ),
      );

      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets(
      'formats episode meta line correctly with two-digit season and episode',
      (WidgetTester tester) async {
        const subtitle = BazarrWantedSubtitle(
          title: 'Ozymandias',
          type: 'episode',
          seriesTitle: 'Breaking Bad',
          seasonNumber: 5,
          episodeNumber: 14,
          languages: ['en'],
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
          ),
        );

        expect(find.text('Breaking Bad - S05E14'), findsOneWidget);
      },
    );
  });
}

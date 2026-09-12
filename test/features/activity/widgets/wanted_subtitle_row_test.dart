import 'package:arrstack/features/activity/widgets/wanted_subtitle_row.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the title, series/episode meta line, and language tags', (
    tester,
  ) async {
    const subtitle = BazarrWantedSubtitle(
      title: 'The You You Are',
      type: 'episode',
      seriesTitle: 'Severance',
      seasonNumber: 2,
      episodeNumber: 5,
      languages: ['en', 'fr'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
      ),
    );

    expect(find.text('The You You Are'), findsOneWidget);
    expect(find.textContaining('Severance'), findsOneWidget);
    expect(find.textContaining('S02E05'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('FR'), findsOneWidget);
  });

  testWidgets('omits the meta line for a movie (no series title)', (
    tester,
  ) async {
    const subtitle = BazarrWantedSubtitle(
      title: 'Some Movie',
      type: 'movie',
      languages: ['en'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
      ),
    );

    expect(find.text('Some Movie'), findsOneWidget);
    expect(find.textContaining('S0'), findsNothing);
  });
}

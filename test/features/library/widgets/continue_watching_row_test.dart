import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/features/library/widgets/continue_watching_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a kicker and one card per entry', (tester) async {
    final entries = [
      ContinueWatchingEntry(
        series: const SonarrSeries(id: 1, title: 'Severance'),
        caption: 'S02E05 · next Fri',
        referenceDate: DateTime(2026, 9, 18),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContinueWatchingRow(instanceId: 'inst-1', entries: entries),
        ),
      ),
    );

    expect(find.text('CONTINUE WATCHING'), findsOneWidget);
    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('S02E05 · next Fri'), findsOneWidget);
  });

  testWidgets('renders nothing when entries is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ContinueWatchingRow(instanceId: 'inst-1', entries: []),
        ),
      ),
    );

    expect(find.text('CONTINUE WATCHING'), findsNothing);
  });
}

import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/features/library/widgets/continue_watching_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

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

  Future<String?> tapCard(WidgetTester tester, ContinueWatchingEntry e) async {
    String? location;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            body: ContinueWatchingRow(instanceId: 'inst-1', entries: [e]),
          ),
        ),
        GoRoute(
          path: '/library/sonarr/:i/series/:s',
          builder: (_, state) {
            location = state.uri.toString();
            return const SizedBox();
          },
          routes: [
            GoRoute(
              path: 'episode/:e',
              builder: (_, state) {
                location = state.uri.toString();
                return const SizedBox();
              },
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text(e.series.title));
    await tester.pumpAndSettle();
    return location;
  }

  testWidgets('tapping a card opens its episode', (tester) async {
    final location = await tapCard(
      tester,
      ContinueWatchingEntry(
        series: const SonarrSeries(id: 7, title: 'Severance'),
        caption: 'S02E05 · next Fri',
        referenceDate: DateTime(2026, 9, 18),
        episodeId: 42,
      ),
    );
    expect(location, '/library/sonarr/inst-1/series/7/episode/42');
  });

  testWidgets('tapping a card without an episode opens the series', (
    tester,
  ) async {
    final location = await tapCard(
      tester,
      ContinueWatchingEntry(
        series: const SonarrSeries(id: 7, title: 'Severance'),
        caption: 'next Fri',
        referenceDate: DateTime(2026, 9, 18),
      ),
    );
    expect(location, '/library/sonarr/inst-1/series/7');
  });
}

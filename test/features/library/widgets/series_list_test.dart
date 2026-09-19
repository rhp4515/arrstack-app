import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/series_list.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a LibraryRow per series with the right trailing state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrSeriesProvider('inst-1').overrideWith(
            (ref) async => const Ok([
              SonarrSeries(
                id: 1,
                title: 'Severance',
                monitored: true,
                statistics: SonarrStatistics(
                  episodeFileCount: 19,
                  totalEpisodeCount: 19,
                ),
              ),
              SonarrSeries(
                id: 2,
                title: 'The Simpsons',
                monitored: true,
                statistics: SonarrStatistics(
                  episodeFileCount: 30,
                  totalEpisodeCount: 296,
                ),
              ),
              SonarrSeries(id: 3, title: 'Andor', monitored: false),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SeriesList(instanceId: 'inst-1')),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Unmonitored'), findsOneWidget);
  });

  testWidgets('sort: title orders rows alphabetically', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrSeriesProvider('inst-1').overrideWith(
            (ref) async => const Ok([
              SonarrSeries(id: 1, title: 'Zeta'),
              SonarrSeries(id: 2, title: 'Alpha'),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SeriesList(instanceId: 'inst-1', sort: LibrarySort.title),
          ),
        ),
      ),
    );
    await tester.pump();

    final titles = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data)
        .whereType<String>()
        .where((t) => t == 'Zeta' || t == 'Alpha')
        .toList();
    expect(titles, ['Alpha', 'Zeta']);
  });
}

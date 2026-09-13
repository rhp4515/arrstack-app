import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/series_detail_page.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title, stats, and a season row per season', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrSingleSeriesProvider(
            instanceId: 'inst-1',
            seriesId: 1,
          ).overrideWith(
            (ref) async => const Ok(
              SonarrSeries(
                id: 1,
                title: 'Severance',
                year: 2022,
                network: 'Apple TV+',
                monitored: true,
                statistics: SonarrStatistics(
                  episodeFileCount: 19,
                  totalEpisodeCount: 19,
                  sizeOnDisk: 65498251264,
                ),
                seasons: [
                  SonarrSeason(
                    seasonNumber: 1,
                    statistics: SonarrStatistics(
                      episodeFileCount: 9,
                      totalEpisodeCount: 9,
                    ),
                  ),
                  SonarrSeason(
                    seasonNumber: 2,
                    statistics: SonarrStatistics(
                      episodeFileCount: 10,
                      totalEpisodeCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          sonarrEpisodesProvider(
            instanceId: 'inst-1',
            seriesId: 1,
          ).overrideWith((ref) async => const Ok([])),
        ],
        child: const MaterialApp(
          home: SeriesDetailPage(instanceId: 'inst-1', seriesId: 1),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('19/19'), findsOneWidget);
    expect(find.text('EPISODES'), findsOneWidget);
    expect(find.text('ON DISK'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
    expect(find.text('Season 2'), findsOneWidget);
  });
}

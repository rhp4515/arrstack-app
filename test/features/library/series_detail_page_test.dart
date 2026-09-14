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

  testWidgets('tapping the season-order toggle reverses season order', (
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

    final seasonOneRect = tester.getTopLeft(find.text('Season 1'));
    final seasonTwoRect = tester.getTopLeft(find.text('Season 2'));
    expect(seasonOneRect.dy, greaterThan(seasonTwoRect.dy));
    // newest first: 2 before 1

    await tester.tap(find.text('Newest first ⌄'));
    await tester.pump();

    final afterOne = tester.getTopLeft(find.text('Season 1'));
    final afterTwo = tester.getTopLeft(find.text('Season 2'));
    expect(afterOne.dy, lessThan(afterTwo.dy)); // oldest first: 1 before 2
  });
}

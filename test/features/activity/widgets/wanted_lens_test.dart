import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/wanted_lens.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the offline error card when Bazarr is unreachable', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith((ref) async => []),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async => const BazarrWantedAggregate(
              subtitles: [BazarrWantedSubtitle(title: 'still works')],
              hasUnreachableInstance: true,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Bazarr is unreachable'), findsOneWidget);
    expect(
      find.text('still works'),
      findsOneWidget,
    ); // partial data still lists
  });

  testWidgets('shows both sections with their kicker counts when data exists', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith(
            (ref) async => [
              const SonarrMissingEpisode(
                instanceId: 'sonarr-1',
                episode: SonarrCalendarEpisode(id: 1, seriesId: 9, title: 'x'),
              ),
            ],
          ),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async => const BazarrWantedAggregate(
              subtitles: [BazarrWantedSubtitle(title: 'y')],
              hasUnreachableInstance: false,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    expect(find.textContaining('MISSING EPISODES'), findsOneWidget);
    expect(find.textContaining('WANTED SUBTITLES'), findsOneWidget);
    expect(find.text('Bazarr is unreachable'), findsNothing);
  });

  testWidgets('tapping the Episodes chip hides the subtitles section', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith(
            (ref) async => [
              const SonarrMissingEpisode(
                instanceId: 'sonarr-1',
                episode: SonarrCalendarEpisode(id: 1, seriesId: 9, title: 'x'),
              ),
            ],
          ),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async => const BazarrWantedAggregate(
              subtitles: [BazarrWantedSubtitle(title: 'y')],
              hasUnreachableInstance: false,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Episodes'));
    await tester.pump();

    expect(find.textContaining('MISSING EPISODES'), findsOneWidget);
    expect(find.textContaining('WANTED SUBTITLES'), findsNothing);
  });

  testWidgets(
    'shows an empty state when there is nothing wanted and no error',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sonarrMissingEpisodesProvider.overrideWith((ref) async => []),
            bazarrWantedAggregateProvider.overrideWith(
              (ref) async => const BazarrWantedAggregate(
                subtitles: [],
                hasUnreachableInstance: false,
              ),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: WantedLens())),
        ),
      );
      await tester.pump();

      expect(find.text('Nothing wanted'), findsOneWidget);
    },
  );
}

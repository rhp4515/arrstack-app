// test/features/activity/widgets/missing_episode_row_test.dart
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/missing_episode_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('episodeCode', () {
    test('zero-pads season and episode', () {
      expect(episodeCode(4, 3), 'S04E03');
      expect(episodeCode(1, 12), 'S01E12');
    });

    test('falls back to 00 for a missing season or episode', () {
      expect(episodeCode(null, 3), 'S00E03');
      expect(episodeCode(4, null), 'S04E00');
    });
  });

  group('formatAiredDate', () {
    test('formats as YYYY-MM-DD', () {
      expect(formatAiredDate(DateTime.utc(2022, 3, 25)), '2022-03-25');
    });

    test('returns an em dash for a null date', () {
      expect(formatAiredDate(null), '—');
    });
  });

  group('MissingEpisodeRow widget', () {
    Widget wrap(Widget child) => MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(body: child),
          ),
          GoRoute(
            path: '/library/sonarr/:instanceId/series/:seriesId/episode/:episodeId/search',
            builder: (context, state) {
              final instanceId = state.pathParameters['instanceId'] ?? '?';
              final seriesId = state.pathParameters['seriesId'] ?? '?';
              final episodeId = state.pathParameters['episodeId'] ?? '?';
              final title = state.uri.queryParameters['title'] ?? '?';
              return Scaffold(
                body: Text(
                  'search page: $instanceId/$seriesId/$episodeId/$title',
                ),
              );
            },
          ),
        ],
      ),
    );

    testWidgets(
      'shows the episode code, series/episode title, and aired date',
      (tester) async {
        final missing = SonarrMissingEpisode(
          instanceId: 'sonarr-1',
          episode: SonarrCalendarEpisode(
            id: 501,
            seriesId: 9,
            seasonNumber: 2,
            episodeNumber: 5,
            title: 'The You You Are',
            airDateUtc: DateTime.utc(2022, 3, 25),
            series: const SonarrSeries(title: 'Severance'),
          ),
        );

        await tester.pumpWidget(
          wrap(MissingEpisodeRow(missingEpisode: missing)),
        );

        expect(find.text('S02E05'), findsOneWidget);
        expect(find.textContaining('Severance'), findsOneWidget);
        expect(find.textContaining('2022-03-25'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping Search releases navigates to the release search route with correct parameters',
      (tester) async {
        const missing = SonarrMissingEpisode(
          instanceId: 'sonarr-1',
          episode: SonarrCalendarEpisode(
            id: 501,
            seriesId: 9,
            title: 'Test Episode',
          ),
        );

        await tester.pumpWidget(
          wrap(const MissingEpisodeRow(missingEpisode: missing)),
        );
        await tester.tap(find.text('Search releases'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('search page: sonarr-1/9/501/Test Episode'),
          findsOneWidget,
        );
      },
    );

    testWidgets('disables Search releases button when seriesId is null', (
      tester,
    ) async {
      const missing = SonarrMissingEpisode(
        instanceId: 'sonarr-1',
        episode: SonarrCalendarEpisode(id: 501, seriesId: null, title: 'x'),
      );

      await tester.pumpWidget(
        wrap(const MissingEpisodeRow(missingEpisode: missing)),
      );

      final button = find.byType(OutlinedButton);
      expect(button, findsOneWidget);

      final buttonWidget = tester.widget<OutlinedButton>(button);
      expect(buttonWidget.onPressed, isNull);
    });
  });
}

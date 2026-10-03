import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/missing_view.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

Widget _radarr(Future<Result<List<RadarrMovie>>> Function() movies) =>
    ProviderScope(
      overrides: [radarrMoviesProvider('r1').overrideWith((ref) => movies())],
      child: const MaterialApp(
        home: Scaffold(
          body: LibraryMissingView(type: ServiceType.radarr, instanceId: 'r1'),
        ),
      ),
    );

class _MockSonarrRepository extends Mock implements SonarrRepository {}

/// The real Missing provider and view, over instance `s1`'s repository.
Widget _sonarr(Result<List<SonarrCalendarEpisode>> missing) {
  final repo = _MockSonarrRepository();
  when(repo.listMissingEpisodes).thenAnswer((_) async => missing);
  return ProviderScope(
    overrides: [
      sonarrRepositoryProvider('s1').overrideWith((ref) async => repo),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: LibraryMissingView(type: ServiceType.sonarr, instanceId: 's1'),
      ),
    ),
  );
}

void main() {
  group('Radarr', () {
    testWidgets('shows a spinner while loading', (tester) async {
      final pending = Completer<Result<List<RadarrMovie>>>();
      await tester.pumpWidget(_radarr(() => pending.future));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows an empty state when nothing is missing', (tester) async {
      await tester.pumpWidget(
        _radarr(
          () async => const Ok([
            RadarrMovie(id: 1, title: 'On Disk', hasFile: true),
            RadarrMovie(id: 2, title: 'Unmonitored', monitored: false),
          ]),
        ),
      );
      await tester.pump();

      expect(find.text('Nothing missing'), findsOneWidget);
    });

    testWidgets('shows the error with Retry', (tester) async {
      await tester.pumpWidget(
        _radarr(() async => const Err(ServerError(userMessage: 'Radarr 500'))),
      );
      await tester.pump();

      expect(find.text('Failed to load movies'), findsOneWidget);
      expect(find.text('Radarr 500'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('lists monitored movies without a file, with Search all', (
      tester,
    ) async {
      await tester.pumpWidget(
        _radarr(
          () async => const Ok([
            RadarrMovie(
              id: 1,
              title: 'Mickey 17',
              year: 2025,
              studio: 'Warner Bros.',
              status: 'inCinemas',
            ),
            RadarrMovie(id: 2, title: 'Dune', hasFile: true),
          ]),
        ),
      );
      await tester.pump();

      expect(find.text('MISSING MOVIES · 1'), findsOneWidget);
      expect(find.text('Search all'), findsOneWidget);
      expect(find.text('Mickey 17'), findsOneWidget);
      expect(find.text('2025 · Warner Bros. · In cinemas'), findsOneWidget);
      expect(find.text('Dune'), findsNothing);
    });
  });

  group('Sonarr', () {
    testWidgets('shows an empty state when nothing is missing', (tester) async {
      await tester.pumpWidget(_sonarr(const Ok([])));
      await tester.pump();
      await tester.pump();

      expect(find.text('Nothing missing'), findsOneWidget);
    });

    testWidgets('lists this instance\'s missing episodes', (tester) async {
      await tester.pumpWidget(
        _sonarr(
          Ok([
            SonarrCalendarEpisode(
              id: 501,
              seriesId: 9,
              seasonNumber: 2,
              episodeNumber: 5,
              title: 'Trojan Horse',
              airDateUtc: DateTime.utc(2025, 2, 14),
              series: const SonarrSeries(id: 9, title: 'Severance'),
            ),
          ]),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('MISSING EPISODES · 1'), findsOneWidget);
      expect(find.text('S02E05'), findsOneWidget);
      expect(find.text('Severance · Trojan Horse'), findsOneWidget);
    });

    testWidgets('an unreachable instance shows the error with Retry, not a '
        'false "Nothing missing"', (tester) async {
      await tester.pumpWidget(
        _sonarr(
          const Err(NetworkError(userMessage: 'Could not reach nas:8989.')),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Nothing missing'), findsNothing);
      expect(find.textContaining('Could not reach'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

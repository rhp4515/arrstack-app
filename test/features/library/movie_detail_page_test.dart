import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/movie_detail_page.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(RadarrMovie movie) {
  return ProviderScope(
    overrides: [
      radarrMovieProvider(
        instanceId: 'inst-1',
        movieId: 1,
      ).overrideWith((ref) async => Ok(movie)),
    ],
    child: const MaterialApp(
      home: MovieDetailPage(instanceId: 'inst-1', movieId: 1),
    ),
  );
}

void main() {
  testWidgets(
    'renders QUALITY/ON DISK stats, genre line, and three secondary buttons',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const RadarrMovie(
            id: 1,
            title: 'Dune: Part Two',
            year: 2024,
            monitored: true,
            hasFile: true,
            sizeOnDisk: 54200000000,
            genres: ['Science Fiction', 'Adventure'],
            imdbId: 'tt15239678',
            tmdbId: 693134,
            movieFile: RadarrMovieFile(
              id: 1,
              size: 54200000000,
              quality: RadarrQualityInfo(
                quality: RadarrQuality(name: 'Bluray-2160p'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dune: Part Two'), findsOneWidget);
      expect(find.text('ON DISK'), findsOneWidget);
      expect(find.text('QUALITY'), findsOneWidget);
      expect(find.text('Science Fiction · Adventure'), findsOneWidget);
      expect(find.text('IMDb'), findsOneWidget);
      expect(find.text('TMDB'), findsOneWidget);
      expect(find.text('Subtitles'), findsOneWidget);
    },
  );

  testWidgets('omits the FILE block entirely when movieFile is null', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const RadarrMovie(
          id: 1,
          title: 'Dune: Part Two',
          year: 2024,
          monitored: true,
          hasFile: false,
          imdbId: 'tt15239678',
          tmdbId: 693134,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('FILE'), findsNothing);
  });

  testWidgets(
    'renders FILE block without Video/Audio rows when mediaInfo is null',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          RadarrMovie(
            id: 1,
            title: 'Dune: Part Two',
            year: 2024,
            monitored: true,
            hasFile: true,
            sizeOnDisk: 54200000000,
            imdbId: 'tt15239678',
            tmdbId: 693134,
            added: DateTime(2026, 8, 28),
            path: '/movies/Dune Part Two (2024)',
            movieFile: const RadarrMovieFile(
              id: 1,
              size: 54200000000,
              releaseGroup: 'FraMeSToR',
              quality: RadarrQualityInfo(
                quality: RadarrQuality(name: 'Bluray-2160p'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('FILE'), findsOneWidget);
      expect(find.text('Release'), findsOneWidget);
      expect(find.text('FraMeSToR'), findsOneWidget);
      expect(find.text('Added'), findsOneWidget);
      expect(find.text('2026-08-28'), findsOneWidget);
      expect(find.text('Path'), findsOneWidget);
      expect(find.text('Video'), findsNothing);
      expect(find.text('Audio'), findsNothing);
    },
  );

  testWidgets('omits the IMDb button when imdbId is absent', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const RadarrMovie(
          id: 1,
          title: 'Dune: Part Two',
          year: 2024,
          monitored: true,
          hasFile: false,
          tmdbId: 693134,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('IMDb'), findsNothing);
    expect(find.text('TMDB'), findsOneWidget);
    expect(find.text('Subtitles'), findsOneWidget);
  });
}

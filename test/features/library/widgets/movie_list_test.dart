import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

Widget _host(
  Future<Result<List<RadarrMovie>>> Function() movies, {
  String query = '',
}) => ProviderScope(
  overrides: [radarrMoviesProvider('inst-1').overrideWith((ref) => movies())],
  child: MaterialApp(
    home: Scaffold(
      body: MovieList(instanceId: 'inst-1', query: query),
    ),
  ),
);

const _file = RadarrMovieFile(
  id: 1,
  quality: RadarrQualityInfo(quality: RadarrQuality(name: 'Bluray-1080p')),
);

void main() {
  testWidgets('shows a spinner while loading', (tester) async {
    final pending = Completer<Result<List<RadarrMovie>>>();
    await tester.pumpWidget(_host(() => pending.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('lists every movie with year · studio and a quality chip', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        () async => const Ok([
          RadarrMovie(
            id: 1,
            title: 'Mickey 17',
            year: 2025,
            studio: 'Warner Bros.',
          ),
          RadarrMovie(
            id: 2,
            title: 'Dune: Part Two',
            year: 2024,
            studio: 'Legendary Pictures',
            hasFile: true,
            movieFile: _file,
          ),
        ]),
      ),
    );
    await tester.pump();

    expect(find.text('ALL MOVIES · 2'), findsOneWidget);
    expect(find.text('Mickey 17'), findsOneWidget);
    expect(find.text('2025 · Warner Bros.'), findsOneWidget);
    expect(find.text('2024 · Legendary Pictures'), findsOneWidget);
    expect(find.text('Bluray-1080p'), findsOneWidget);
    expect(find.byIcon(PhosphorIconsRegular.caretRight), findsNWidgets(2));
    // Missing movies live in their own sub-tab now.
    expect(find.textContaining('MISSING'), findsNothing);
  });

  testWidgets('filters by the search query', (tester) async {
    await tester.pumpWidget(
      _host(
        () async => const Ok([
          RadarrMovie(id: 1, title: 'Mickey 17'),
          RadarrMovie(id: 2, title: 'Dune'),
        ]),
        query: 'dun',
      ),
    );
    await tester.pump();

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Mickey 17'), findsNothing);
  });

  testWidgets('follows the shared sort toggle', (tester) async {
    await tester.pumpWidget(
      _host(
        () async => const Ok([
          RadarrMovie(id: 1, title: 'Zodiac', year: 2007),
          RadarrMovie(id: 2, title: 'Arrival', year: 2016),
        ]),
      ),
    );
    await tester.pump();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MovieList)),
    );
    container
        .read(activeLibrarySortProvider.notifier)
        .select(LibrarySort.title);
    await tester.pump();

    expect(
      tester.getTopLeft(find.text('Arrival')).dy,
      lessThan(tester.getTopLeft(find.text('Zodiac')).dy),
    );
    expect(find.text('Title ⌄'), findsOneWidget);
  });

  testWidgets('shows an empty state', (tester) async {
    await tester.pumpWidget(_host(() async => const Ok([])));
    await tester.pump();

    expect(find.text('No movies found'), findsOneWidget);
  });

  testWidgets('shows the error with Retry', (tester) async {
    await tester.pumpWidget(
      _host(() async => const Err(ServerError(userMessage: 'Radarr down'))),
    );
    await tester.pump();

    expect(find.text('Failed to load movies'), findsOneWidget);
    expect(find.text('Radarr down'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

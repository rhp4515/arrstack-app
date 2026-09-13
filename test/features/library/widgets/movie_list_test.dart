import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a Missing section before Recently added, with a count', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          radarrMoviesProvider('inst-1').overrideWith(
            (ref) async => Ok([
              const RadarrMovie(
                id: 1,
                title: 'Mickey 17',
                monitored: true,
                hasFile: false,
              ),
              const RadarrMovie(
                id: 2,
                title: 'Dune: Part Two',
                monitored: true,
                hasFile: true,
                sizeOnDisk: 54200000000,
              ),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: MovieList(instanceId: 'inst-1')),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('MISSING'), findsOneWidget);
    expect(find.text('Mickey 17'), findsOneWidget);
    expect(find.text('Search all'), findsOneWidget);
    expect(find.text('Dune: Part Two'), findsOneWidget);

    final missingPos = tester.getTopLeft(find.textContaining('MISSING')).dy;
    final recentPos = tester
        .getTopLeft(find.textContaining('RECENTLY ADDED'))
        .dy;
    expect(missingPos, lessThan(recentPos));
  });

  testWidgets('omits the Missing section when nothing is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          radarrMoviesProvider('inst-1').overrideWith(
            (ref) async => Ok([
              const RadarrMovie(id: 1, title: 'Dune: Part Two', hasFile: true),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: MovieList(instanceId: 'inst-1')),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('MISSING'), findsNothing);
  });
}

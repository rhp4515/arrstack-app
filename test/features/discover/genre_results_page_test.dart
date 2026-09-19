import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/discover/genre_results_page.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

void main() {
  testWidgets('shows a Nocturne header and a badge on an in-library result', (
    tester,
  ) async {
    final results = [
      const SeerrResult(
        id: 1,
        title: 'Sinners',
        mediaInfo: SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          seerrMoviesByGenreProvider(
            instanceId: instanceId,
            genreId: 5,
          ).overrideWith((ref) async => Ok(results)),
        ],
        child: const MaterialApp(
          home: GenreResultsPage(
            instanceId: instanceId,
            genreId: 5,
            genreName: 'Action',
            mediaType: 'movie',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Action'), findsOneWidget);
    expect(find.text('In library'), findsOneWidget);
  });
}

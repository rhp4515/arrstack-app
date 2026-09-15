import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/add_movie_page.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'radarr-1';

void main() {
  testWidgets(
    'shows a result-count caption and dims an already-added result with a check',
    (tester) async {
      final movies = [
        const RadarrMovie(title: 'Nosferatu', year: 2024, tmdbId: 1),
        const RadarrMovie(
          id: 9,
          title: 'Nosferatu the Vampyre',
          year: 1979,
          tmdbId: 2,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            radarrLookupProvider(
              instanceId: instanceId,
              term: 'nosferatu',
            ).overrideWith((ref) async => Ok(movies)),
          ],
          child: const MaterialApp(home: AddMoviePage(instanceId: instanceId)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'nosferatu');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      // Bounded pumps rather than pumpAndSettle: the poster's
      // CachedNetworkImage never resolves in the test environment (no real
      // network), so its placeholder's indeterminate CircularProgressIndicator
      // keeps scheduling frames forever and pumpAndSettle would spin until
      // its timeout (see discover_page_test.dart for the same pattern).
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('results from TMDB'), findsOneWidget);
      expect(find.textContaining('already in library'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      final dimmedRow = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.text('Nosferatu the Vampyre'),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(dimmedRow.opacity, 0.6);
    },
  );
}

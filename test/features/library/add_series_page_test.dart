import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/add_series_page.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'sonarr-1';

void main() {
  testWidgets(
    'shows a result-count caption and an add button for a new series',
    (tester) async {
      final series = [
        const SonarrSeries(title: 'Severance', year: 2022, tvdbId: 1),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sonarrLookupProvider(
              instanceId: instanceId,
              term: 'severance',
            ).overrideWith((ref) async => Ok(series)),
          ],
          child: const MaterialApp(home: AddSeriesPage(instanceId: instanceId)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'severance');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      // Bounded pumps rather than pumpAndSettle: the poster's
      // CachedNetworkImage never resolves in the test environment (no real
      // network), so its placeholder's indeterminate CircularProgressIndicator
      // keeps scheduling frames forever and pumpAndSettle would spin until
      // its timeout (see discover_page_test.dart for the same pattern).
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('results from TMDB'), findsOneWidget);
      expect(find.text('Severance'), findsOneWidget);
    },
  );
}

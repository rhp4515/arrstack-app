import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/add_series_page.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

const instanceId = 'sonarr-1';

void main() {
  testWidgets(
    'shows a result-count caption and an add button for a new series',
    (tester) async {
      final series = [
        const SonarrSeries(title: 'Severance', year: 2022, tvdbId: 1),
        const SonarrSeries(
          title: 'Severance: Behind the Scenes',
          year: 2022,
          tvdbId: 2,
        ),
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

      // Primary/secondary add-button hierarchy (README §3d): an accent
      // outline for the top result, a divider outline for every other
      // result, and never a filled background for either — per the design
      // tokens' "primary is an accent outline on transparent, never a fill"
      // rule. Locate the two "+" add buttons (the search field's own "x"
      // clear button is also an IconButton, so filter on the plus icon).
      final addButtons = tester
          .widgetList<IconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is IconButton &&
                  widget.icon is Icon &&
                  (widget.icon as Icon).icon == PhosphorIconsRegular.plus,
            ),
          )
          .toList();
      expect(addButtons, hasLength(2));

      final primaryButton = addButtons[0];
      final secondaryButton = addButtons[1];

      expect(primaryButton.style?.backgroundColor, isNull);
      expect(secondaryButton.style?.backgroundColor, isNull);
      expect(
        primaryButton.style?.side?.resolve(<WidgetState>{})?.color,
        AppColors.accent,
      );
      expect(
        secondaryButton.style?.side?.resolve(<WidgetState>{})?.color,
        AppColors.divider,
      );
    },
  );
}

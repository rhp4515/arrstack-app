import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/add_series_options.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'sonarr-1';

Widget host(SonarrSeries series) {
  return ProviderScope(
    overrides: [
      sonarrQualityProfilesProvider(instanceId)
          .overrideWith((ref) async => const Ok(<SonarrQualityProfile>[])),
      sonarrRootFoldersProvider(instanceId)
          .overrideWith((ref) async => const Ok(<SonarrRootFolder>[])),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: AddSeriesOptionsSheet(instanceId: instanceId, series: series),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'renders a grab handle, the "{year} · adding to Sonarr" subtitle, and an '
    'accent-outlined, non-filled "Add series to library" button',
    (tester) async {
      await tester.pumpWidget(
        host(const SonarrSeries(title: 'Andor', year: 2022, tvdbId: 1)),
      );
      await tester.pump();

      expect(find.text('Add "Andor"'), findsOneWidget);
      expect(find.text('2022 · adding to Sonarr'), findsOneWidget);

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Add series to library'),
      );
      expect(button.style?.backgroundColor, isNull);
      expect(
        button.style?.side?.resolve(<WidgetState>{})?.color,
        AppColors.accent,
      );
      expect(
        button.style?.foregroundColor?.resolve(<WidgetState>{}),
        AppColors.accent,
      );
    },
  );

  testWidgets('falls back to "—" for a year-less lookup result', (
    tester,
  ) async {
    await tester.pumpWidget(host(const SonarrSeries(title: 'Unreleased')));
    await tester.pump();

    expect(find.text('— · adding to Sonarr'), findsOneWidget);
  });
}

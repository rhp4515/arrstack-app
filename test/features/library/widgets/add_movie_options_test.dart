import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/add_movie_options.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'radarr-1';

Widget host(RadarrMovie movie) {
  return ProviderScope(
    overrides: [
      radarrQualityProfilesProvider(instanceId)
          .overrideWith((ref) async => const Ok(<RadarrQualityProfile>[])),
      radarrRootFoldersProvider(instanceId)
          .overrideWith((ref) async => const Ok(<RadarrRootFolder>[])),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: AddMovieOptionsSheet(instanceId: instanceId, movie: movie),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'renders a grab handle, the "{year} · adding to Radarr" subtitle, and an '
    'accent-outlined, non-filled "Add to library" button',
    (tester) async {
      await tester.pumpWidget(
        host(const RadarrMovie(title: 'Nosferatu', year: 2024, tmdbId: 1)),
      );
      await tester.pump();

      expect(find.text('Add "Nosferatu"'), findsOneWidget);
      expect(find.text('2024 · adding to Radarr'), findsOneWidget);

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Add to library'),
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
    await tester.pumpWidget(host(const RadarrMovie(title: 'Unreleased')));
    await tester.pump();

    expect(find.text('— · adding to Radarr'), findsOneWidget);
  });
}

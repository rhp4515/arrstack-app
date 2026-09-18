import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../support/fixtures.dart';

void main() {
  testWidgets(
    'hides the endpoint chip when there is no representative instance',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instancesProvider.overrideWith((ref) async => const Ok([])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(path: '/', builder: (_, _) => const HomeBand()),
                GoRoute(
                  path: '/home/settings',
                  builder: (_, _) => const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeBand), findsOneWidget);
    },
  );

  testWidgets('shows the hero healthy/total count', (tester) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeSummaryProvider.overrideWith(
            (ref) async =>
                const HomeSummary(healthy: 1, total: 1, statusLines: []),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const HomeBand()),
              GoRoute(
                path: '/home/settings',
                builder: (_, _) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('/ 1 healthy'), findsOneWidget);
  });

  testWidgets(
    'adds the device top inset to its internal padding, on top of the '
    'fixed design spacing, so the gear button clears a status bar/notch',
    (tester) async {
      const topInset = 40.0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instancesProvider.overrideWith((ref) async => const Ok([])),
          ],
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: topInset)),
            child: MaterialApp.router(
              routerConfig: GoRouter(
                routes: [
                  GoRoute(path: '/', builder: (_, _) => const HomeBand()),
                  GoRoute(
                    path: '/home/settings',
                    builder: (_, _) => const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(HomeBand),
              matching: find.byType(Container),
            )
            .first,
      );
      final padding = container.padding! as EdgeInsets;
      expect(padding.top, AppSpacing.space6 + topInset);
    },
  );
}

import 'dart:async';

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/home_band_skeleton.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/right_now_card_skeleton.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../support/fixtures.dart';

void main() {
  testWidgets('renders all three skeletons plus the caption with an SSID', (
    tester,
  ) async {
    final radarr = buildInstance(serviceType: ServiceType.radarr);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          currentSsidProvider.overrideWith((ref) => Stream.value('Harivin-5G')),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const HomeLoadingState()),
              GoRoute(
                path: '/home/settings',
                builder: (_, _) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(HomeBandSkeleton), findsOneWidget);
    expect(find.byType(RightNowCardSkeleton), findsOneWidget);
    expect(find.byType(ServiceTileGridSkeleton), findsOneWidget);
    expect(find.text('Contacting 1 services on Harivin-5G…'), findsOneWidget);
  });

  testWidgets('omits "on <ssid>" from the caption when the SSID is null', (
    tester,
  ) async {
    final radarr = buildInstance(serviceType: ServiceType.radarr);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          currentSsidProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const HomeLoadingState()),
              GoRoute(
                path: '/home/settings',
                builder: (_, _) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Contacting 1 services…'), findsOneWidget);
  });

  testWidgets(
    'omits the count entirely while instancesProvider is still resolving',
    (tester) async {
      final instancesCompleter = Completer<Result<List<ServiceInstance>>>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instancesProvider.overrideWith((ref) => instancesCompleter.future),
            currentSsidProvider.overrideWith(
              (ref) => Stream.value('Harivin-5G'),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(path: '/', builder: (_, _) => const HomeLoadingState()),
                GoRoute(
                  path: '/home/settings',
                  builder: (_, _) => const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Contacting your services…'), findsOneWidget);
      expect(find.textContaining('0 services'), findsNothing);

      instancesCompleter.complete(Ok([buildInstance()]));
      await tester.pump();
    },
  );

  testWidgets(
    'HomeBandSkeleton adds the device top inset to its internal padding, '
    'so the gear button clears a status bar/notch',
    (tester) async {
      const topInset = 40.0;
      final radarr = buildInstance(serviceType: ServiceType.radarr);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([radarr])),
            currentSsidProvider.overrideWith((ref) => Stream.value(null)),
          ],
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: topInset)),
            child: MaterialApp.router(
              routerConfig: GoRouter(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (_, _) => const HomeLoadingState(),
                  ),
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
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(HomeBandSkeleton),
              matching: find.byType(Container),
            )
            .first,
      );
      final padding = container.padding! as EdgeInsets;
      expect(padding.top, AppSpacing.space6 + topInset);
    },
  );
}

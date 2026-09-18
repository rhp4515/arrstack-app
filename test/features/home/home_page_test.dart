import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_page.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fixtures.dart';

void main() {
  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => const HomePage())],
        ),
      ),
    );
  }

  testWidgets('shows the empty state when there are no instances', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => const Ok([])),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(HomeBand), findsNothing);
    expect(find.byType(ConnectionStateDevChipRow), findsNothing);
    expect(find.text('No services yet'), findsOneWidget);
    expect(find.text('Add a service'), findsOneWidget);
    expect(find.text("What's supported?"), findsOneWidget);
  });

  testWidgets('"What\'s supported?" opens the supported-services sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => const Ok([])),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text("What's supported?"));
    await tester.pumpAndSettle();

    expect(find.text('Supported today'), findsOneWidget);
    expect(find.text('Radarr'), findsOneWidget);
  });

  testWidgets('shows the band and service grid when a service is reachable', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );

    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        homeServiceSummariesProvider.overrideWith(
          (ref) async => [
            const HomeServiceSummary(
              instanceId: 'radarr-1',
              instanceName: 'Home Radarr',
              serviceType: ServiceType.radarr,
              isReachable: true,
              summaryLine: '412 movies',
            ),
          ],
        ),
        rightNowProvider.overrideWith((ref) async => null),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeBand), findsOneWidget);
    expect(find.byType(ServiceTileGrid), findsOneWidget);
  });

  testWidgets('shows the loading skeleton on the initial fetch', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );
    final summariesCompleter = Completer<List<HomeServiceSummary>>();

    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        homeServiceSummariesProvider.overrideWith(
          (ref) => summariesCompleter.future,
        ),
        rightNowProvider.overrideWith((ref) async => null),
      ]),
    );
    await tester.pump();

    expect(find.byType(HomeLoadingState), findsOneWidget);

    summariesCompleter.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('shows the offline layout when nothing is reachable', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );

    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        homeServiceSummariesProvider.overrideWith(
          (ref) async => [
            const HomeServiceSummary(
              instanceId: 'radarr-1',
              instanceName: 'Home Radarr',
              serviceType: ServiceType.radarr,
              isReachable: false,
              summaryLine: 'Unreachable',
              statusLabel: 'Unreachable',
            ),
          ],
        ),
        rightNowProvider.overrideWith((ref) async => null),
        cachedServiceSummariesProvider.overrideWith((ref) async => const []),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeOfflineState), findsOneWidget);
    expect(find.byType(HomeBand), findsNothing);
  });

  testWidgets('shows the dev chip row only when the flag is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(true),
        instancesProvider.overrideWith((ref) async => const Ok([])),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ConnectionStateDevChipRow), findsOneWidget);
  });

  testWidgets('selecting a dev override chip switches the rendered layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(true),
        instancesProvider.overrideWith((ref) async => const Ok([])),
        cachedServiceSummariesProvider.overrideWith((ref) async => const []),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);

    await tester.tap(find.text('offline'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeOfflineState), findsOneWidget);
  });
}

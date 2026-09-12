import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/home/home_page.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fixtures.dart';

void main() {
  Widget wrap(overrides) {
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
      wrap([instancesProvider.overrideWith((ref) async => const Ok([]))]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(HomeBand), findsNothing);
  });

  testWidgets('shows the band and service grid when instances exist', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );

    await tester.pumpWidget(
      wrap([
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        rightNowProvider.overrideWith((ref) async => null),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeBand), findsOneWidget);
    expect(find.byType(ServiceTileGrid), findsOneWidget);
  });
}

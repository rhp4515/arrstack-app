import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/storage/fakes.dart';

void main() {
  testWidgets(
    'shows a live status dot and Reachable text for a matched instance',
    (tester) async {
      const instance = ServiceInstance(
        id: 'radarr-1',
        name: 'Radarr 4K',
        serviceType: ServiceType.radarr,
        authType: AuthType.apiKey,
        localBaseUrl: 'http://10.0.0.1:7878',
        isDefault: true,
        endpointMode: EndpointMode.auto,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            configStoreProvider.overrideWithValue(FakeConfigStore()),
            instancesProvider.overrideWith((ref) async => const Ok([instance])),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => [
                const HomeServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: 'Radarr 4K',
                  serviceType: ServiceType.radarr,
                  isReachable: true,
                  summaryLine: '412 movies',
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Radarr 4K'), findsOneWidget);
      expect(find.text('Reachable'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
    },
  );

  testWidgets('shows the summary line for an unreachable instance', (
    tester,
  ) async {
    const instance = ServiceInstance(
      id: 'bazarr-1',
      name: 'Bazarr',
      serviceType: ServiceType.bazarr,
      authType: AuthType.apiKey,
      localBaseUrl: 'http://10.0.0.1:6767',
      endpointMode: EndpointMode.auto,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configStoreProvider.overrideWithValue(FakeConfigStore()),
          instancesProvider.overrideWith((ref) async => const Ok([instance])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              const HomeServiceSummary(
                instanceId: 'bazarr-1',
                instanceName: 'Bazarr',
                serviceType: ServiceType.bazarr,
                isReachable: false,
                summaryLine: 'Unreachable',
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: SettingsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unreachable'), findsOneWidget);
  });
}

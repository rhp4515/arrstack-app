import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

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

  testWidgets(
    'shows "Status unavailable" rather than a silent no-summary fallback '
    'when the summaries fetch itself fails',
    (tester) async {
      const instance = ServiceInstance(
        id: 'sonarr-1',
        name: 'Sonarr',
        serviceType: ServiceType.sonarr,
        authType: AuthType.apiKey,
        localBaseUrl: 'http://10.0.0.1:8989',
        endpointMode: EndpointMode.auto,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            configStoreProvider.overrideWithValue(FakeConfigStore()),
            instancesProvider.overrideWith((ref) async => const Ok([instance])),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => throw Exception('summaries fetch failed'),
            ),
          ],
          child: const MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sonarr'), findsOneWidget);
      expect(find.text('Status unavailable'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping delete on an instance row opens the shared confirm dialog, '
    'and confirming deletes it',
    (tester) async {
      const instance = ServiceInstance(
        id: 'radarr-1',
        name: 'Radarr 4K',
        serviceType: ServiceType.radarr,
        authType: AuthType.apiKey,
        localBaseUrl: 'http://10.0.0.1:7878',
        endpointMode: EndpointMode.auto,
      );
      final fakeRepository = FakeInstanceRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            configStoreProvider.overrideWithValue(FakeConfigStore()),
            instanceRepositoryProvider.overrideWithValue(fakeRepository),
            instancesProvider.overrideWith((ref) async => const Ok([instance])),
            homeServiceSummariesProvider.overrideWith((ref) async => const []),
          ],
          child: const MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(PhosphorIconsRegular.trash));
      await tester.pumpAndSettle();

      expect(find.text('Remove Radarr 4K?'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(fakeRepository.deletedIds, ['radarr-1']);
    },
  );
}

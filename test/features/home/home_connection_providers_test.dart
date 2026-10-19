import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  group('homeConnectionStateProvider', () {
    test('is loading before instances resolve', () {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith(
            (ref) => Completer<Result<List<ServiceInstance>>>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.loading,
      );
    });

    test('is unconfigured when there are no instances', () async {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => const Ok([])),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.unconfigured,
      );
    });

    test('is loading on the initial fetch, before summaries resolve', () async {
      final radarr = buildInstance(
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeServiceSummariesProvider.overrideWith(
            (ref) => Completer<List<HomeServiceSummary>>().future,
          ),
          rightNowProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.loading,
      );
    });

    test('is offline when instances exist but nothing is reachable', () async {
      final radarr = buildInstance(
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              HomeServiceSummary(
                instanceId: radarr.id,
                instanceName: radarr.name,
                serviceType: ServiceType.radarr,
                isReachable: false,
                summaryLine: 'Unreachable',
                statusLabel: 'Unreachable',
              ),
            ],
          ),
          rightNowProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);
      await container.read(homeServiceSummariesProvider.future);
      await container.read(rightNowProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.offline,
      );
    });

    test('is ready when at least one service is reachable', () async {
      final radarr = buildInstance(
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              HomeServiceSummary(
                instanceId: radarr.id,
                instanceName: radarr.name,
                serviceType: ServiceType.radarr,
                isReachable: true,
                summaryLine: '412 movies',
              ),
            ],
          ),
          rightNowProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);
      await container.read(homeServiceSummariesProvider.future);
      await container.read(rightNowProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.ready,
      );
    });

    test(
      'is ready when only qBittorrent is configured and it is reachable',
      () async {
        final qbit = buildInstance(
          id: 'qbit-1',
          serviceType: ServiceType.qbittorrent,
          isDefault: true,
        );
        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([qbit])),
            homeServiceSummariesProvider.overrideWith((ref) async => const []),
            rightNowProvider.overrideWith(
              (ref) async => const RightNowSummary(
                downloadSpeed: 100,
                uploadSpeed: 0,
                downloadingCount: 1,
                seedingCount: 0,
                downloadingFraction: 1,
                pausedOrStalledFraction: 0,
                queuedFraction: 0,
              ),
            ),
          ],
        );
        addTearDown(container.dispose);
        await container.read(instancesProvider.future);
        await container.read(homeServiceSummariesProvider.future);
        await container.read(rightNowProvider.future);

        expect(
          container.read(homeConnectionStateProvider),
          HomeConnectionState.ready,
        );
      },
    );
  });

  group('effectiveHomeConnectionStateProvider', () {
    test('uses the real computed state when no override is set', () async {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => const Ok([])),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);

      expect(
        container.read(effectiveHomeConnectionStateProvider),
        HomeConnectionState.unconfigured,
      );
    });

    test(
      'uses the dev override when set, ignoring the real computed state',
      () async {
        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => const Ok([])),
          ],
        );
        addTearDown(container.dispose);
        await container.read(instancesProvider.future);

        container
            .read(homeConnectionStateDevOverrideProvider.notifier)
            .set(HomeConnectionState.offline);

        expect(
          container.read(effectiveHomeConnectionStateProvider),
          HomeConnectionState.offline,
        );
      },
    );
  });

  group('showDevConnectionSwitcherProvider', () {
    test('defaults to kDebugMode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(showDevConnectionSwitcherProvider), kDebugMode);
    });
  });
}

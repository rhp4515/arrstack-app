// test/features/home/home_providers_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

class _FakeKumaMonitors extends KumaMonitors {
  _FakeKumaMonitors(this._monitors);
  final List<KumaMonitor> _monitors;

  @override
  Stream<Result<List<KumaMonitor>>> build(String instanceId) async* {
    yield Ok(_monitors);
  }
}

void main() {
  group('primaryDashboardInstanceProvider', () {
    test('prefers the default Radarr instance', () async {
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final sonarr = buildInstance(
        id: 'sonarr-1',
        serviceType: ServiceType.sonarr,
        isDefault: true,
      );

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([sonarr, radarr])),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        primaryDashboardInstanceProvider.future,
      );
      expect(result?.id, 'radarr-1');
    });

    test('returns null when there are no instances', () async {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => const Ok([])),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        primaryDashboardInstanceProvider.future,
      );
      expect(result, isNull);
    });
  });

  group('homeServiceSummariesProvider', () {
    test(
      'excludes qBittorrent and includes one tile per configured type',
      () async {
        final radarr = buildInstance(
          id: 'radarr-1',
          serviceType: ServiceType.radarr,
          isDefault: true,
        );
        final qbit = buildInstance(
          id: 'qbit-1',
          serviceType: ServiceType.qbittorrent,
          isDefault: true,
        );

        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([radarr, qbit])),
            radarrMoviesProvider(radarr.id).overrideWith(
              (ref) async => const Ok([
                RadarrMovie(hasFile: false, monitored: true),
                RadarrMovie(hasFile: true, monitored: true),
              ]),
            ),
          ],
        );
        addTearDown(container.dispose);

        final summaries = await container.read(
          homeServiceSummariesProvider.future,
        );
        expect(summaries, hasLength(1));
        expect(summaries.single.serviceType, ServiceType.radarr);
        expect(summaries.single.summaryLine, '2 movies · 1 missing');
        expect(summaries.single.isReachable, isTrue);
      },
    );

    test('marks a service unreachable when its provider returns Err', () async {
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
        isDefault: true,
      );

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          radarrMoviesProvider(radarr.id)
              .overrideWith((ref) async => const Err(NetworkError())),
        ],
      );
      addTearDown(container.dispose);

      final summaries = await container.read(
        homeServiceSummariesProvider.future,
      );
      expect(summaries.single.isReachable, isFalse);
      expect(summaries.single.statusLabel, 'Unreachable');
    });

    test(
      'uses the default instance when a type has multiple instances',
      () async {
        final nonDefault = buildInstance(
          id: 'sonarr-1',
          serviceType: ServiceType.sonarr,
        );
        final theDefault = buildInstance(
          id: 'sonarr-2',
          serviceType: ServiceType.sonarr,
          isDefault: true,
        );

        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith(
              (ref) async => Ok([nonDefault, theDefault]),
            ),
            sonarrSeriesProvider(theDefault.id)
                .overrideWith((ref) async => const Ok([])),
          ],
        );
        addTearDown(container.dispose);

        final summaries = await container.read(
          homeServiceSummariesProvider.future,
        );
        expect(summaries.single.instanceId, 'sonarr-2');
      },
    );

    test('computes a Bazarr summary from the wanted-subtitle count', () async {
      final bazarr = buildInstance(
        id: 'bazarr-1',
        serviceType: ServiceType.bazarr,
        isDefault: true,
      );

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([bazarr])),
          bazarrWantedProvider(bazarr.id).overrideWith(
            (ref) async => const Ok([
              BazarrWantedSubtitle(title: 'x'),
              BazarrWantedSubtitle(title: 'y'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summaries = await container.read(
        homeServiceSummariesProvider.future,
      );
      expect(summaries.single.summaryLine, '2 wanted subtitles');
    });

    test(
      'computes an Uptime Kuma summary from the down-monitor count',
      () async {
        final kuma = buildInstance(
          id: 'kuma-1',
          serviceType: ServiceType.uptimeKuma,
          isDefault: true,
        );

        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([kuma])),
            kumaMonitorsProvider(kuma.id).overrideWith(
              () => _FakeKumaMonitors([
                const KumaMonitor(
                  id: 1,
                  name: 'a',
                  type: 'http',
                  active: true,
                  interval: 60,
                  status: 0,
                ),
                const KumaMonitor(
                  id: 2,
                  name: 'b',
                  type: 'http',
                  active: true,
                  interval: 60,
                  status: 1,
                ),
              ]),
            ),
          ],
        );
        addTearDown(container.dispose);

        final summaries = await container.read(
          homeServiceSummariesProvider.future,
        );
        expect(summaries.single.summaryLine, '2 monitors · 1 down');
      },
    );
  });
}

/// Providers for global app settings: Home SSIDs and default endpoint mode
/// (spec §6a, §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network_providers.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

/// Live version string for a Settings instance row (README §2m: the
/// `192.168.1.10:7878 · v5.14.0` subtitle). Only fetched for service types
/// whose client implements [ConnectionTestClient] over a plain,
/// already-authenticated request — Uptime Kuma's socket-session client and
/// Prowlarr/Einthusan (no version-bearing status endpoint wired up) are
/// deliberately excluded rather than faked. Best-effort: any failure
/// (unreachable instance, missing credential, parse error) resolves to
/// null so a version-fetch hiccup never turns into a page-level error —
/// the endpoint string alone is still a useful subtitle.
@riverpod
Future<String?> instanceVersion(
  Ref ref,
  String instanceId,
  ServiceType serviceType,
) async {
  try {
    switch (serviceType) {
      case ServiceType.radarr:
        final repo = await ref.watch(
          radarrRepositoryProvider(instanceId).future,
        );
        return switch (await repo.testConnection()) {
          Ok(:final value) => value.version,
          Err() => null,
        };
      case ServiceType.sonarr:
        final repo = await ref.watch(
          sonarrRepositoryProvider(instanceId).future,
        );
        return switch (await repo.testConnection()) {
          Ok(:final value) => value.version,
          Err() => null,
        };
      case ServiceType.bazarr:
        // Bazarr's ConnectionTestClient implementation hits a health-check
        // endpoint with no version field (see BazarrClient.testConnection
        // doc comment) — getStatus()'s api/system/status carries the real
        // version instead.
        final repo = await ref.watch(
          bazarrRepositoryProvider(instanceId).future,
        );
        return switch (await repo.getStatus()) {
          Ok(:final value) => value.version.isEmpty ? null : value.version,
          Err() => null,
        };
      case ServiceType.seerr:
        final repo = await ref.watch(
          seerrRepositoryProvider(instanceId).future,
        );
        return switch (await repo.testConnection()) {
          Ok(:final value) => value.version,
          Err() => null,
        };
      case ServiceType.qbittorrent:
        return switch (await ref.watch(
          qbitConnectionStatusProvider(instanceId).future,
        )) {
          Ok(:final value) => value.version,
          Err() => null,
        };
      case ServiceType.uptimeKuma:
      case ServiceType.prowlarr:
      case ServiceType.einthusan:
        return null;
    }
  } on Object {
    return null;
  }
}

/// qBittorrent-specific reachability + identity check for a Settings
/// instance row. qBittorrent is deliberately excluded from
/// `homeServiceSummariesProvider` (it's summarized by the Home hub's
/// `rightNowProvider` instead), so a qBittorrent `ServiceInstance` never
/// has a matching `HomeServiceSummary` — the Settings row needs its own
/// direct reachability signal rather than borrowing Home's, or its dot
/// stays permanently neutral and its version never renders regardless of
/// the instance's real state.
@riverpod
Future<Result<ServiceIdentity>> qbitConnectionStatus(
  Ref ref,
  String instanceId,
) async {
  final repo = await ref.watch(qbitRepositoryProvider(instanceId).future);
  return repo.testConnection();
}

@Riverpod(keepAlive: true)
class HomeSsidsSettings extends _$HomeSsidsSettings {
  @override
  Future<List<String>> build() async {
    final result = await ref.watch(homeSsidsProvider.future);
    if (result case Ok<List<String>>(:final value)) return value;
    return const [];
  }

  Future<void> addHomeSsid(String ssid) async {
    final current = await future;
    if (ssid.isNotEmpty && !current.contains(ssid)) {
      final next = [...current, ssid];
      await ref.read(configStoreProvider).writeHomeSsids(next);
      ref.invalidate(homeSsidsProvider);
    }
  }

  Future<void> removeHomeSsid(String ssid) async {
    final current = await future;
    final next = current.where((s) => s != ssid).toList();
    await ref.read(configStoreProvider).writeHomeSsids(next);
    ref.invalidate(homeSsidsProvider);
  }

  Future<String?> detectCurrentSsid() async {
    final ssidSource = ref.read(ssidSourceProvider);
    final status = await ssidSource.permissionStatus();
    if (!status.isGranted) {
      final granted = await ssidSource.requestPermission();
      if (!granted) return null;
    }
    return ssidSource.currentSsid();
  }
}

@Riverpod(keepAlive: true)
class DefaultEndpointModeSettings extends _$DefaultEndpointModeSettings {
  @override
  Future<EndpointMode> build() async {
    final result = await ref.watch(defaultEndpointModeProvider.future);
    if (result case Ok<EndpointMode>(:final value)) return value;
    return EndpointMode.auto;
  }

  Future<void> updateMode(EndpointMode mode) async {
    await ref.read(configStoreProvider).writeDefaultEndpointMode(mode);
    ref.invalidate(defaultEndpointModeProvider);
  }
}

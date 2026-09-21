// lib/features/home/home_providers.dart
/// Providers backing the Home hub: the representative instance for the
/// endpoint chip, and per-service tile summaries (Phase 3 design §Provider
/// plan).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/seerr/seerr.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

/// Finds a "primary" instance to show the endpoint chip for on Home.
/// Moved verbatim from the deleted `endpoint_indicator.dart`.
@riverpod
Future<ServiceInstance?> primaryDashboardInstance(Ref ref) async {
  final result = await ref.watch(instancesProvider.future);
  if (result case Ok(:final value)) {
    if (value.isEmpty) return null;
    return value.firstWhere(
      (i) => i.isDefault && i.serviceType == ServiceType.radarr,
      orElse: () => value.firstWhere(
        (i) => i.isDefault && i.serviceType == ServiceType.sonarr,
        orElse: () =>
            value.firstWhere((i) => i.isDefault, orElse: () => value.first),
      ),
    );
  }
  return null;
}

@riverpod
Future<List<HomeServiceSummary>> homeServiceSummaries(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return [];
  final instances = instancesResult.value;

  final types = instances
      .map((i) => i.serviceType)
      .where((t) => t != ServiceType.qbittorrent)
      .toSet();

  final selectedInstances = [
    for (final type in types) _defaultInstanceOfType(instances, type),
  ].whereType<ServiceInstance>().toList();

  final summaries = await Future.wait([
    for (final instance in selectedInstances) _summaryFor(ref, instance),
  ]);

  try {
    await _cacheReachableSummaries(ref, summaries);
    // Persisting the cache is best-effort: a preference read/write failure
    // must never hide already-fetched, valid summaries behind a provider
    // error — that would turn a harmless storage hiccup into a false
    // "everything is unreachable" signal.
  } on Object {
    // Swallow deliberately, per the comment above.
  }
  return summaries;
}

/// Write-through cache (README §3f `lastKnown`): upserts every reachable
/// summary by instanceId, leaving cached entries for currently-unreachable
/// or since-removed services untouched, so a partial outage doesn't wipe
/// out other services' last-known-good data.
Future<void> _cacheReachableSummaries(
  Ref ref,
  List<HomeServiceSummary> summaries,
) async {
  final reachable = summaries.where((s) => s.isReachable);
  if (reachable.isEmpty) return;

  final configStore = ref.read(configStoreProvider);
  final existingRaw = await configStore.readCachedSummaries();
  final existing = <String, Map<String, dynamic>>{
    for (final json in existingRaw)
      if (json['instanceId'] is String) json['instanceId'] as String: json,
  };

  final now = DateTime.now();
  for (final summary in reachable) {
    existing[summary.instanceId] = CachedServiceSummary(
      instanceId: summary.instanceId,
      instanceName: summary.instanceName,
      serviceType: summary.serviceType,
      summaryLine: summary.summaryLine,
      lastFetchedAt: now,
    ).toJson();
  }

  await configStore.writeCachedSummaries(existing.values.toList());
  ref.invalidate(cachedServiceSummariesProvider);
}

ServiceInstance? _defaultInstanceOfType(
  List<ServiceInstance> instances,
  ServiceType type,
) {
  final ofType = instances.where((i) => i.serviceType == type).toList();
  if (ofType.isEmpty) return null;
  return ofType.firstWhere((i) => i.isDefault, orElse: () => ofType.first);
}

Future<HomeServiceSummary> _summaryFor(Ref ref, ServiceInstance instance) {
  return switch (instance.serviceType) {
    ServiceType.radarr => _radarrSummary(ref, instance),
    ServiceType.sonarr => _sonarrSummary(ref, instance),
    ServiceType.bazarr => _bazarrSummary(ref, instance),
    ServiceType.uptimeKuma => _kumaSummary(ref, instance),
    ServiceType.prowlarr => _prowlarrSummary(ref, instance),
    ServiceType.seerr => _seerrSummary(ref, instance),
    ServiceType.einthusan => _einthusanSummary(ref, instance),
    ServiceType.qbittorrent => throw UnsupportedError(
      'qBittorrent is summarized by rightNowProvider, not homeServiceSummariesProvider',
    ),
  };
}

Future<HomeServiceSummary> _radarrSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final result = await ref.watch(radarrMoviesProvider(instance.id).future);
    return switch (result) {
      Ok(:final value) => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine:
            '${value.length} movies · '
            '${value.where((m) => !m.hasFile && m.monitored).length} missing',
      ),
      Err(:final error) => _unreachableSummary(instance, error: error),
    };
    // Catches unexpected failures (e.g. repository construction) so one
    // service's outage doesn't fail the whole tile list.
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

Future<HomeServiceSummary> _sonarrSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final result = await ref.watch(sonarrSeriesProvider(instance.id).future);
    return switch (result) {
      Ok(:final value) => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine:
            '${value.length} series · '
            '${value.where((s) => s.statistics?.percentOfEpisodes != 100).length} incomplete',
      ),
      Err(:final error) => _unreachableSummary(instance, error: error),
    };
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

Future<HomeServiceSummary> _bazarrSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final result = await ref.watch(bazarrWantedProvider(instance.id).future);
    return switch (result) {
      Ok(:final value) => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine: '${value.length} wanted subtitles',
      ),
      Err(:final error) => _unreachableSummary(instance, error: error),
    };
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

Future<HomeServiceSummary> _kumaSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final result = await ref.watch(kumaMonitorsProvider(instance.id).future);
    return switch (result) {
      Ok(:final value) => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine:
            '${value.length} monitors · '
            '${value.where(isMonitorDown).length} down',
      ),
      Err(:final error) => _unreachableSummary(instance, error: error),
    };
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

Future<HomeServiceSummary> _prowlarrSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final indexersResult = await ref.watch(
      prowlarrIndexersProvider(instance.id).future,
    );
    final statsResult = await ref.watch(
      prowlarrIndexerStatsProvider(instance.id).future,
    );
    return switch ((indexersResult, statsResult)) {
      (Ok(:final value), Ok(value: final stats)) => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine:
            '${value.length} indexers · '
            '${_averageResponseMs(stats.indexers)}ms',
      ),
      (Err(:final error), _) => _unreachableSummary(instance, error: error),
      (_, Err(:final error)) => _unreachableSummary(instance, error: error),
    };
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

int _averageResponseMs(List<IndexerStat> stats) {
  if (stats.isEmpty) return 0;
  final total = stats.fold<int>(0, (sum, s) => sum + s.averageResponseTime);
  return total ~/ stats.length;
}

Future<HomeServiceSummary> _seerrSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final result = await ref.watch(
      seerrRequestsProvider(
        instanceId: instance.id,
        filter: 'pending',
        sort: 'added',
      ).future,
    );
    return switch (result) {
      Ok(:final value) => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine: '${value.pageInfo.results} requests pending',
      ),
      Err(:final error) => _unreachableSummary(instance, error: error),
    };
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

/// Einthusan used to report a hardcoded "Connected" because the repository
/// exposed no health check. That made its tile and Settings dot green
/// whatever the network was doing — and, worse, wrote a bogus "reachable"
/// row into the last-known cache and told Home's offline card that at least
/// one service was fine while every other request was timing out. It now
/// probes the same `api/v1/health` endpoint the Add/Edit connection test
/// already used.
Future<HomeServiceSummary> _einthusanSummary(
  Ref ref,
  ServiceInstance instance,
) async {
  try {
    final repo = await ref.watch(
      einthusanRepositoryProvider(instance.id).future,
    );
    return switch (await repo.testConnection()) {
      Ok() => HomeServiceSummary(
        instanceId: instance.id,
        instanceName: instance.name,
        serviceType: instance.serviceType,
        isReachable: true,
        summaryLine: 'Connected',
      ),
      Err(:final error) => _unreachableSummary(instance, error: error),
    };
  } on Object catch (error) {
    return _unreachableSummary(instance, error: _asAppError(error));
  }
}

/// The repository providers rethrow their [AppError] when the instance
/// can't even be composed (no credential, unresolvable endpoint). Keeping
/// it means the row can say *why* instead of a bare "Unreachable", and
/// Home's offline card can tell a credential problem from an outage.
AppError? _asAppError(Object error) => error is AppError ? error : null;

HomeServiceSummary _unreachableSummary(
  ServiceInstance instance, {
  AppError? error,
}) => HomeServiceSummary(
  instanceId: instance.id,
  instanceName: instance.name,
  serviceType: instance.serviceType,
  isReachable: false,
  // Stays the bare word: this is the Home tile's one-line, ellipsized slot,
  // where a sentence-long diagnosis truncates to noise. The detail travels
  // in [lastError] for the surfaces with room for it (Settings rows, the
  // offline card).
  summaryLine: 'Unreachable',
  statusLabel: 'Unreachable',
  lastError: error,
);

@riverpod
Future<HomeSummary> homeSummary(Ref ref) async {
  final summaries = await ref.watch(homeServiceSummariesProvider.future);
  final healthy = summaries.where((s) => s.isReachable).length;

  final statusLines = summaries
      .where((s) => !s.isReachable)
      .take(2)
      .map(
        (s) => HomeStatusLine(
          label: '${s.serviceType.displayName} unreachable',
          isWarning: true,
        ),
      )
      .toList();

  return HomeSummary(
    healthy: healthy,
    total: summaries.length,
    statusLines: statusLines,
  );
}

@riverpod
Future<RightNowSummary?> rightNow(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return null;

  final instance = _defaultInstanceOfType(
    instancesResult.value,
    ServiceType.qbittorrent,
  );
  if (instance == null) return null;

  final mainDataResult = await ref.watch(
    qbitMainDataProvider(instance.id).future,
  );
  if (mainDataResult is! Ok<QbitMainData>) return null;

  final torrents = mainDataResult.value.torrents.values.toList();
  final serverState = mainDataResult.value.serverState;

  final downloading = torrents.where(_isActivelyDownloading).toList();
  final pausedOrStalled = torrents
      .where((t) => _isPausedOrStalled(t.state))
      .toList();
  final queued = torrents.where((t) => _isQueued(t.state)).toList();
  final seeding = torrents.where(torrentIsComplete).toList();

  final activeTotal =
      downloading.length + pausedOrStalled.length + queued.length;

  final etaCandidates = downloading
      .map((t) => t.eta)
      .where((eta) => eta > 0 && eta < 8640000)
      .toList();

  return RightNowSummary(
    downloadSpeed: serverState.dlInfoSpeed,
    uploadSpeed: serverState.upInfoSpeed,
    downloadingCount: downloading.length,
    seedingCount: seeding.length,
    etaToNextFinishSeconds: etaCandidates.isEmpty
        ? null
        : etaCandidates.reduce((a, b) => a < b ? a : b),
    downloadingFraction: activeTotal == 0
        ? 0
        : downloading.length / activeTotal,
    pausedOrStalledFraction: activeTotal == 0
        ? 0
        : pausedOrStalled.length / activeTotal,
    queuedFraction: activeTotal == 0 ? 0 : queued.length / activeTotal,
  );
}

bool _isPausedOrStalled(String state) =>
    const {'pausedDL', 'pausedUP', 'stalledDL', 'stalledUP'}.contains(state);

bool _isQueued(String state) =>
    const {'queuedDL', 'queuedUP', 'allocating'}.contains(state);

bool _isActivelyDownloading(QbitTorrent t) =>
    !torrentIsComplete(t) &&
    !_isPausedOrStalled(t.state) &&
    !_isQueued(t.state);

/// Invalidates the leaf network providers backing Home, then the derived
/// aggregation providers, so pull-to-refresh actually re-fetches (Phase 3
/// final-review fix — the derived providers alone just recompute from
/// cached leaf data).
Future<void> refreshHome(WidgetRef ref) async {
  final instancesResult = await ref.read(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return;
  final instances = instancesResult.value;

  final types = instances.map((i) => i.serviceType).toSet();
  for (final type in types) {
    final instance = _defaultInstanceOfType(instances, type);
    if (instance == null) continue;
    switch (type) {
      case ServiceType.radarr:
        ref.invalidate(radarrMoviesProvider(instance.id));
      case ServiceType.sonarr:
        ref.invalidate(sonarrSeriesProvider(instance.id));
      case ServiceType.bazarr:
        ref.invalidate(bazarrWantedProvider(instance.id));
      case ServiceType.uptimeKuma:
        ref.invalidate(kumaMonitorsProvider(instance.id));
      case ServiceType.prowlarr:
        ref.invalidate(prowlarrIndexersProvider(instance.id));
        ref.invalidate(prowlarrIndexerStatsProvider(instance.id));
      case ServiceType.seerr:
        ref.invalidate(
          seerrRequestsProvider(
            instanceId: instance.id,
            filter: 'pending',
            sort: 'added',
          ),
        );
      case ServiceType.einthusan:
        break;
      case ServiceType.qbittorrent:
        ref.invalidate(qbitMainDataProvider(instance.id));
    }
  }

  ref.invalidate(homeServiceSummariesProvider);
  ref.invalidate(homeSummaryProvider);
  ref.invalidate(rightNowProvider);

  await Future.wait([
    ref.read(homeServiceSummariesProvider.future),
    ref.read(rightNowProvider.future),
  ]);
}

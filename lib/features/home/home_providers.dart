// lib/features/home/home_providers.dart
/// Providers backing the Home hub: the representative instance for the
/// endpoint chip, and per-service tile summaries (Phase 3 design §Provider
/// plan).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/downloads/widgets/torrent_tile.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
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

  final summaries = <HomeServiceSummary>[];
  for (final type in types) {
    final instance = _defaultInstanceOfType(instances, type);
    if (instance == null) continue;
    summaries.add(await _summaryFor(ref, instance));
  }
  return summaries;
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
    ServiceType.einthusan => Future.value(_einthusanSummary(instance)),
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
      Err() => _unreachableSummary(instance),
    };
    // Catches unexpected failures (e.g. repository construction) so one
    // service's outage doesn't fail the whole tile list.
  } on Object {
    return _unreachableSummary(instance);
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
      Err() => _unreachableSummary(instance),
    };
  } on Object {
    return _unreachableSummary(instance);
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
      Err() => _unreachableSummary(instance),
    };
  } on Object {
    return _unreachableSummary(instance);
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
            '${value.where((m) => m.status == 0).length} down',
      ),
      Err() => _unreachableSummary(instance),
    };
  } on Object {
    return _unreachableSummary(instance);
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
      _ => _unreachableSummary(instance),
    };
  } on Object {
    return _unreachableSummary(instance);
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
      Err() => _unreachableSummary(instance),
    };
  } on Object {
    return _unreachableSummary(instance);
  }
}

/// Einthusan has no reachability-check plumbing in the repository layer
/// today (only job CRUD endpoints exist) — mirrors the old dashboard's
/// catch-all "Connected" behavior rather than inventing a new health check.
HomeServiceSummary _einthusanSummary(ServiceInstance instance) =>
    HomeServiceSummary(
      instanceId: instance.id,
      instanceName: instance.name,
      serviceType: instance.serviceType,
      isReachable: true,
      summaryLine: 'Connected',
    );

HomeServiceSummary _unreachableSummary(ServiceInstance instance) =>
    HomeServiceSummary(
      instanceId: instance.id,
      instanceName: instance.name,
      serviceType: instance.serviceType,
      isReachable: false,
      summaryLine: 'Unreachable',
      statusLabel: 'Unreachable',
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

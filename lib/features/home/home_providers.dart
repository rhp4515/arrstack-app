// lib/features/home/home_providers.dart
/// Providers backing the Home hub: the representative instance for the
/// endpoint chip, and per-service tile summaries (Phase 3 design §Provider
/// plan).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/seerr/seerr.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
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

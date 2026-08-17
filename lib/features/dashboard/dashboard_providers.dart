/// Providers for aggregating health and activity across all services.
library;

import 'package:arrstack/app/theme/service_accents.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<List<ServiceHealth>> stackHealth(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return [];
  final instances = instancesResult.value;

  final healths = <ServiceHealth>[];

  for (final instance in instances) {
    final health = await _getHealthForInstance(ref, instance);
    healths.add(health);
  }

  return healths;
}

Future<ServiceHealth> _getHealthForInstance(Ref ref, ServiceInstance instance) async {
  final id = instance.id;
  final type = instance.serviceType;

  return switch (type) {
    ServiceType.radarr => _getRadarrHealth(ref, instance),
    ServiceType.sonarr => _getSonarrHealth(ref, instance),
    ServiceType.qbittorrent => _getQbitHealth(ref, instance),
    ServiceType.bazarr => _getBazarrHealth(ref, instance),
    ServiceType.uptimeKuma => _getKumaHealth(ref, instance),
    _ => ServiceHealth(
        instanceId: id,
        instanceName: instance.name,
        serviceType: type,
        isReachable: true,
        headlineStat: 'Connected',
        statusColor: Colors.grey,
      ),
  };
}

Future<ServiceHealth> _getRadarrHealth(Ref ref, ServiceInstance instance) async {
  final moviesAsync = ref.watch(radarrMoviesProvider(instance.id));
  
  return moviesAsync.when(
    data: (result) => switch (result) {
      Ok(:final value) => ServiceHealth(
          instanceId: instance.id,
          instanceName: instance.name,
          serviceType: instance.serviceType,
          isReachable: true,
          headlineStat: '${value.where((m) => !m.hasFile && m.monitored).length} Missing',
          statusColor: ServiceAccents.radarr,
        ),
      Err() => _offlineHealth(instance),
    },
    loading: () => _loadingHealth(instance),
    error: (_, __) => _offlineHealth(instance),
  );
}

Future<ServiceHealth> _getSonarrHealth(Ref ref, ServiceInstance instance) async {
  final seriesAsync = ref.watch(sonarrSeriesProvider(instance.id));

  return seriesAsync.when(
    data: (result) => switch (result) {
      Ok(:final value) => ServiceHealth(
          instanceId: instance.id,
          instanceName: instance.name,
          serviceType: instance.serviceType,
          isReachable: true,
          headlineStat: '${value.where((s) => s.statistics?.percentOfEpisodes != 100).length} Incomplete',
          statusColor: ServiceAccents.sonarr,
        ),
      Err() => _offlineHealth(instance),
    },
    loading: () => _loadingHealth(instance),
    error: (_, __) => _offlineHealth(instance),
  );
}

Future<ServiceHealth> _getBazarrHealth(Ref ref, ServiceInstance instance) async {
  final wantedAsync = ref.watch(bazarrWantedProvider(instance.id));

  return wantedAsync.when(
    data: (result) => switch (result) {
      Ok(:final value) => ServiceHealth(
          instanceId: instance.id,
          instanceName: instance.name,
          serviceType: instance.serviceType,
          isReachable: true,
          headlineStat: '${value.length} Wanted',
          statusColor: ServiceAccents.bazarr,
        ),
      Err() => _offlineHealth(instance),
    },
    loading: () => _loadingHealth(instance),
    error: (_, __) => _offlineHealth(instance),
  );
}

Future<ServiceHealth> _getQbitHealth(Ref ref, ServiceInstance instance) async {
  final mainDataAsync = ref.watch(qbitMainDataProvider(instance.id));

  return mainDataAsync.when(
    data: (result) => switch (result) {
      Ok(:final value) => ServiceHealth(
          instanceId: instance.id,
          instanceName: instance.name,
          serviceType: instance.serviceType,
          isReachable: true,
          headlineStat: '${value.torrents.length} Torrents',
          statusColor: ServiceAccents.qbittorrent,
        ),
      Err() => _offlineHealth(instance),
    },
    loading: () => _loadingHealth(instance),
    error: (_, __) => _offlineHealth(instance),
  );
}

Future<ServiceHealth> _getKumaHealth(Ref ref, ServiceInstance instance) async {
  final monitorsAsync = ref.watch(kumaMonitorsProvider(instance.id));

  return monitorsAsync.when(
    data: (result) => switch (result) {
      Ok(:final value) => ServiceHealth(
          instanceId: instance.id,
          instanceName: instance.name,
          serviceType: instance.serviceType,
          isReachable: true,
          headlineStat: '${value.where((m) => m.status == 0).length} Down',
          statusColor: ServiceAccents.uptimeKuma,
        ),
      Err() => _offlineHealth(instance),
    },
    loading: () => _loadingHealth(instance),
    error: (_, __) => _offlineHealth(instance),
  );
}

ServiceHealth _offlineHealth(ServiceInstance instance) => ServiceHealth(
      instanceId: instance.id,
      instanceName: instance.name,
      serviceType: instance.serviceType,
      isReachable: false,
      headlineStat: 'Offline',
      statusColor: Colors.red,
    );

ServiceHealth _loadingHealth(ServiceInstance instance) => ServiceHealth(
      instanceId: instance.id,
      instanceName: instance.name,
      serviceType: instance.serviceType,
      isReachable: true,
      headlineStat: 'Loading...',
      statusColor: Colors.grey,
    );

@riverpod
Future<List<ActivityItem>> stackActivity(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return [];
  final instances = instancesResult.value;

  final allActivity = <ActivityItem>[];

  for (final instance in instances) {
    if (instance.serviceType == ServiceType.qbittorrent) {
      final torrentsResult = await ref.watch(qbitTorrentsProvider(instance.id).future);
      if (torrentsResult case Ok(:final value)) {
        allActivity.addAll(value.map((t) => ActivityItem(
              id: t.hash,
              title: t.name,
              serviceType: ServiceType.qbittorrent,
              instanceId: instance.id,
              progress: t.progress,
              speed: t.dlspeed,
              status: t.state,
            )));
      }
    } else if (instance.serviceType == ServiceType.radarr) {
      final queueResult = await ref.watch(radarrQueueProvider(instance.id).future);
      if (queueResult case Ok(:final value)) {
        allActivity.addAll(value.map((q) => ActivityItem(
              id: q.id.toString(),
              title: q.title,
              serviceType: ServiceType.radarr,
              instanceId: instance.id,
              progress: q.size > 0 ? (q.size - q.sizeleft) / q.size : 0,
              speed: 0, // Radarr/Sonarr don't always expose real-time speed in queue
              status: q.status,
            )));
      }
    } else if (instance.serviceType == ServiceType.sonarr) {
      final queueResult = await ref.watch(sonarrQueueProvider(instance.id).future);
      if (queueResult case Ok(:final value)) {
        allActivity.addAll(value.map((q) => ActivityItem(
              id: q.id.toString(),
              title: q.title,
              serviceType: ServiceType.sonarr,
              instanceId: instance.id,
              progress: q.size > 0 ? (q.size - q.sizeleft) / q.size : 0,
              speed: 0,
              status: q.status,
            )));
      }
    }
  }

  // Sort by progress descending (active ones first)
  return allActivity..sort((a, b) => b.progress.compareTo(a.progress));
}

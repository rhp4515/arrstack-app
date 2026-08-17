/// Riverpod providers for the Uptime Kuma service module.
library;

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/uptimekuma/kuma_client.dart';
import 'package:arrstack/services/uptimekuma/kuma_repository.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'kuma_providers.g.dart';

@Riverpod(keepAlive: true)
Future<KumaClient> kumaClient(Ref ref, String instanceId) async {
  final resolutionResult = await ref.watch(
    resolvedEndpointProvider(instanceId).future,
  );
  if (resolutionResult is! Ok<EndpointResolution>) {
    throw Exception('Failed to resolve endpoint');
  }
  final resolution = resolutionResult.value;

  // Socket.io baseUrl should NOT have the /socket.io suffix as the client adds it.
  final baseUrl = resolution.baseUrl.replaceAll(RegExp(r'/socket\.io/?$'), '');

  final client = KumaClient(baseUrl: baseUrl);
  ref.onDispose(client.dispose);
  return client;
}

@Riverpod(keepAlive: true)
Future<KumaRepository> kumaRepository(Ref ref, String instanceId) async {
  final client = await ref.watch(kumaClientProvider(instanceId).future);
  final credential = await ref.watch(
    serviceCredentialProvider(instanceId).future,
  );

  if (credential == null) {
    throw Exception('No credentials found for instance $instanceId');
  }

  return KumaRepository(client, credential);
}

/// The live state of all monitors for a Kuma instance.
@riverpod
class KumaMonitors extends _$KumaMonitors {
  @override
  Stream<Result<List<KumaMonitor>>> build(String instanceId) async* {
    final repository = await ref.watch(
      kumaRepositoryProvider(instanceId).future,
    );

    final monitorsMap = <int, KumaMonitor>{};
    final updates = StreamController<void>();

    // Subscribe BEFORE connecting: Kuma pushes the full monitorList exactly
    // once, right after login, and these are broadcast streams with no buffer.
    // Subscribing after ensureConnected() would drop that initial list and
    // leave the UI stuck on "No monitors found" despite a live connection.
    final monitorsSub = repository.monitorsStream.listen((event) {
      monitorsMap.addAll(event);
      if (!updates.isClosed) updates.add(null);
    });
    final heartbeatsSub = repository.heartbeatStream.listen((event) {
      final monitor = monitorsMap[event.monitorId];
      if (monitor != null) {
        monitorsMap[event.monitorId] = monitor.copyWith(
          status: event.status,
          heartbeats: [event, ...monitor.heartbeats].take(50).toList(),
        );
        if (!updates.isClosed) updates.add(null);
      }
    });
    ref.onDispose(() {
      monitorsSub.cancel();
      heartbeatsSub.cancel();
      updates.close();
    });

    final connectResult = await repository.ensureConnected();
    if (connectResult is Err<void>) {
      yield Err(connectResult.error);
      return;
    }

    List<KumaMonitor> sorted() =>
        monitorsMap.values.toList()..sort((a, b) => a.name.compareTo(b.name));

    // The initial list may already have arrived during the login round-trip;
    // emit it, then re-emit on every subsequent monitor/heartbeat update.
    yield Ok(sorted());
    await for (final _ in updates.stream) {
      yield Ok(sorted());
    }
  }
}

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
  final resolutionResult = await ref.watch(resolvedEndpointProvider(instanceId).future);
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
  final credential = await ref.watch(serviceCredentialProvider(instanceId).future);

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
    final repository = await ref.watch(kumaRepositoryProvider(instanceId).future);
    
    // Attempt connection and login
    final connectResult = await repository.ensureConnected();
    if (connectResult is Err<void>) {
      yield Err(connectResult.error);
      return;
    }

    final Map<int, KumaMonitor> monitorsMap = {};

    // Merge monitor list and heartbeats into a single stream of results
    await for (final event in _mergeStreams(repository)) {
      if (event is Map<int, KumaMonitor>) {
        monitorsMap.addAll(event);
      } else if (event is KumaHeartbeat) {
        final monitor = monitorsMap[event.monitorId];
        if (monitor != null) {
          final updatedHeartbeats = [event, ...monitor.heartbeats].take(50).toList();
          monitorsMap[event.monitorId] = monitor.copyWith(
            status: event.status,
            heartbeats: updatedHeartbeats,
          );
        }
      }
      
      final sortedList = monitorsMap.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      
      yield Ok(sortedList);
    }
  }

  Stream<dynamic> _mergeStreams(KumaRepository repository) async* {
    final controller = StreamController<dynamic>();
    
    final s1 = repository.monitorsStream.listen(controller.add);
    final s2 = repository.heartbeatStream.listen(controller.add);
    
    ref.onDispose(() {
      s1.cancel();
      s2.cancel();
      controller.close();
    });

    yield* controller.stream;
  }
}

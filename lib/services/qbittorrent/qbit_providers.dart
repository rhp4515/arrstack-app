/// Riverpod providers for the qBittorrent service module.
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_client.dart';
import 'package:arrstack/services/qbittorrent/qbit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qbit_providers.g.dart';

@Riverpod(keepAlive: true)
Future<QbitClient> qbitClient(Ref ref, String instanceId) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);
  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };

  final client = QbitClient(dio);
  dio.interceptors.add(client.cookieInterceptor);
  return client;
}

@Riverpod(keepAlive: true)
Future<QbitRepository> qbitRepository(Ref ref, String instanceId) async {
  final client = await ref.watch(qbitClientProvider(instanceId).future);
  final credential = await ref.watch(serviceCredentialProvider(instanceId).future);

  if (credential == null) {
    throw Exception('No credentials found for instance $instanceId');
  }

  return QbitRepository(client, credential);
}

@riverpod
Future<Result<List<QbitTorrent>>> qbitTorrents(Ref ref, String instanceId) async {
  final repository = await ref.watch(qbitRepositoryProvider(instanceId).future);
  return repository.listTorrents();
}

@riverpod
Future<Result<QbitMainData>> qbitMainData(Ref ref, String instanceId) async {
  final repository = await ref.watch(qbitRepositoryProvider(instanceId).future);
  return repository.getMainData();
}

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/prowlarr/client.dart';
import 'package:arrstack/services/prowlarr/models/indexer.dart';
import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';
import 'package:arrstack/services/prowlarr/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Future<ProwlarrClient> prowlarrClient(Ref ref, String instanceId) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);
  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };
  return ProwlarrClient(dio);
}

@riverpod
Future<ProwlarrRepository> prowlarrRepository(
  Ref ref,
  String instanceId,
) async {
  final client = await ref.watch(prowlarrClientProvider(instanceId).future);
  return ProwlarrRepository(client);
}

@riverpod
Future<Result<List<Indexer>>> prowlarrIndexers(
  Ref ref,
  String instanceId,
) async {
  final repo = await ref.watch(prowlarrRepositoryProvider(instanceId).future);
  return await repo.getIndexers();
}

@riverpod
Future<Result<IndexerStatsResponse>> prowlarrIndexerStats(
  Ref ref,
  String instanceId,
) async {
  final repo = await ref.watch(prowlarrRepositoryProvider(instanceId).future);
  return await repo.getIndexerStats();
}

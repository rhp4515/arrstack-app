/// Riverpod providers for the Bazarr service module.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/bazarr/bazarr_client.dart';
import 'package:arrstack/services/bazarr/bazarr_repository.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bazarr_providers.g.dart';

@riverpod
Future<BazarrRepository> bazarrRepository(Ref ref, String instanceId) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);

  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };

  return BazarrRepository(BazarrClient(dio));
}

@riverpod
Future<Result<List<BazarrWantedSubtitle>>> bazarrWanted(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    bazarrRepositoryProvider(instanceId).future,
  );

  final episodesResult = await repository.listWantedEpisodes();
  final moviesResult = await repository.listWantedMovies();

  final List<BazarrWantedSubtitle> allWanted = [];

  if (episodesResult is Ok<List<BazarrWantedSubtitle>>) {
    allWanted.addAll(episodesResult.value);
  }
  if (moviesResult is Ok<List<BazarrWantedSubtitle>>) {
    allWanted.addAll(moviesResult.value);
  }

  if (episodesResult is Err && moviesResult is Err) {
    return episodesResult;
  }

  return Ok(allWanted);
}

@riverpod
Future<Result<BazarrSystemStatus>> bazarrStatus(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    bazarrRepositoryProvider(instanceId).future,
  );
  return repository.getStatus();
}

@riverpod
Future<ServiceInstance?> primaryBazarrInstance(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return null;
  final instances = instancesResult.value;
  return instances
      .where((i) => i.serviceType == ServiceType.bazarr)
      .firstOrNull;
}

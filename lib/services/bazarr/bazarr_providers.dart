/// Riverpod providers for the Bazarr service module.
library;

import 'package:arrstack/core/network/network.dart';
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
Future<Result<List<BazarrWantedSubtitle>>> bazarrWanted(Ref ref, String instanceId) async {
  final repository = await ref.watch(bazarrRepositoryProvider(instanceId).future);
  
  final episodesResult = await repository.listWantedEpisodes();
  final moviesResult = await repository.listWantedMovies();

  if (episodesResult is Err<List<BazarrWantedSubtitle>>) return episodesResult;
  if (moviesResult is Err<List<BazarrWantedSubtitle>>) return moviesResult;

  final allWanted = [
    ...(episodesResult as Ok<List<BazarrWantedSubtitle>>).value,
    ...(moviesResult as Ok<List<BazarrWantedSubtitle>>).value,
  ];

  return Ok(allWanted);
}

@riverpod
Future<Result<BazarrSystemStatus>> bazarrStatus(Ref ref, String instanceId) async {
  final repository = await ref.watch(bazarrRepositoryProvider(instanceId).future);
  return repository.getStatus();
}

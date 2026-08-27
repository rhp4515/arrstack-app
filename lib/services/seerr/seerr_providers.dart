import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seerr_providers.g.dart';

@riverpod
Future<SeerrRepository> seerrRepository(Ref ref, String instanceId) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);
  
  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };

  return SeerrRepository(SeerrClient(dio));
}

@riverpod
Future<Result<List<SeerrResult>>> seerrDiscoverMovies(Ref ref, String instanceId) async {
  final repository = await ref.watch(seerrRepositoryProvider(instanceId).future);
  return repository.discoverMovies();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrDiscoverTv(Ref ref, String instanceId) async {
  final repository = await ref.watch(seerrRepositoryProvider(instanceId).future);
  return repository.discoverTv();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrSearch(
  Ref ref, {
  required String instanceId,
  required String query,
}) async {
  if (query.isEmpty) return const Ok([]);
  final repository = await ref.watch(seerrRepositoryProvider(instanceId).future);
  return repository.search(query);
}

@riverpod
Future<Result<SeerrResult>> seerrDetail(
  Ref ref, {
  required String instanceId,
  required int id,
  required String mediaType,
}) async {
  final repository = await ref.watch(seerrRepositoryProvider(instanceId).future);
  if (mediaType == 'movie') {
    return repository.getMovieDetail(id);
  } else {
    return repository.getTvDetail(id);
  }
}

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
Future<Result<List<SeerrResult>>> seerrDiscoverMovies(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.discoverMovies();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrDiscoverTv(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.discoverTv();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrTrending(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.trending();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrUpcomingMovies(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.upcomingMovies();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrUpcomingTv(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.upcomingTv();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrMoviesByGenre(
  Ref ref, {
  required String instanceId,
  required int genreId,
}) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.moviesByGenre(genreId);
}

@riverpod
Future<Result<List<SeerrResult>>> seerrTvByGenre(
  Ref ref, {
  required String instanceId,
  required int genreId,
}) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.tvByGenre(genreId);
}

@riverpod
Future<Result<List<SeerrGenre>>> seerrMovieGenres(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.movieGenres();
}

@riverpod
Future<Result<List<SeerrGenre>>> seerrTvGenres(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.tvGenres();
}

@riverpod
Future<Result<List<SeerrResult>>> seerrSearch(
  Ref ref, {
  required String instanceId,
  required String query,
}) async {
  if (query.isEmpty) return const Ok([]);
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.search(query);
}

@riverpod
Future<Result<SeerrResult>> seerrDetail(
  Ref ref, {
  required String instanceId,
  required int id,
  required String mediaType,
}) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  if (mediaType == 'movie') {
    return repository.getMovieDetail(id);
  } else {
    return repository.getTvDetail(id);
  }
}

/// `filter`: pending | approved | declined | all. `sort`: added | modified.
@riverpod
Future<Result<SeerrRequestsResponse>> seerrRequests(
  Ref ref, {
  required String instanceId,
  required String filter,
  required String sort,
}) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.getRequests(filter: filter, sort: sort);
}

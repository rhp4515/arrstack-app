/// Riverpod providers for the Radarr service module (spec §4).
///
/// Wires up [RadarrRepository] with the per-instance [Dio] composition
/// (see [dioForInstanceProvider]).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'radarr_providers.g.dart';

@riverpod
Future<RadarrRepository> radarrRepository(Ref ref, String instanceId) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);
  
  // Unwrap the Result<Dio> from Phase 3 fixes
  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };

  return RadarrRepository(RadarrClient(dio));
}

@riverpod
Future<Result<List<RadarrMovie>>> radarrMovies(Ref ref, String instanceId) async {
  final repository = await ref.watch(radarrRepositoryProvider(instanceId).future);
  return repository.listMovies();
}

@riverpod
Future<Result<RadarrMovie>> radarrMovie(
  Ref ref, {
  required String instanceId,
  required int movieId,
}) async {
  // Check if we already have it in the movies list to avoid a fetch.
  final moviesResult = ref.read(radarrMoviesProvider(instanceId)).value;
  if (moviesResult is Ok<List<RadarrMovie>>) {
    try {
      final cached = moviesResult.value.firstWhere((m) => m.id == movieId);
      return Ok(cached);
    } catch (_) {
      // Not in cache, fall through to fetch
    }
  }

  final repository = await ref.watch(radarrRepositoryProvider(instanceId).future);
  return repository.getMovie(movieId);
}

/// Resolves a relative Radarr image URL to a full URL using the instance's
/// current base URL and API key (via query param, as Radarr's image proxy
/// requires it).
@riverpod
Future<String?> radarrFullImageUrl(
  Ref ref, {
  required String instanceId,
  required String relativeUrl,
}) async {
  // If it's already a full URL (like a TMDB link in search results), return as is
  if (relativeUrl.startsWith('http')) return relativeUrl;

  final resolutionResult = await ref.watch(resolvedEndpointProvider(instanceId).future);
  if (resolutionResult is! Ok<EndpointResolution>) return null;
  final resolution = resolutionResult.value;

  final credential = await ref.watch(serviceCredentialProvider(instanceId).future);
  if (credential is! ApiKeyCredential) return null;

  // Use Uri class for robust path manipulation.
  final baseUri = Uri.parse(resolution.baseUrl);
  // Strip the API portion to get the web root
  final cleanPath = baseUri.path.replaceAll(RegExp(r'/api(/v3)?/?$'), '').replaceAll(RegExp(r'/$'), '');
  
  // Ensure relativeUrl doesn't already start with the cleanPath to avoid duplication
  var path = relativeUrl.startsWith('/') ? relativeUrl : '/$relativeUrl';
  if (cleanPath.isNotEmpty && path.startsWith(cleanPath)) {
    path = path.substring(cleanPath.length);
  }

  return baseUri.replace(
    path: '$cleanPath$path',
    queryParameters: {
      ...baseUri.queryParameters,
      'apikey': credential.apiKey,
    },
  ).toString();
}

@riverpod
Future<Result<List<RadarrQualityProfile>>> radarrQualityProfiles(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(radarrRepositoryProvider(instanceId).future);
  return repository.listQualityProfiles();
}

@riverpod
Future<Result<List<RadarrRootFolder>>> radarrRootFolders(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(radarrRepositoryProvider(instanceId).future);
  return repository.listRootFolders();
}

/// Search results for a lookup term.
@riverpod
Future<Result<List<RadarrMovie>>> radarrLookup(
  Ref ref, {
  required String instanceId,
  required String term,
}) async {
  if (term.isEmpty) return const Ok([]);
  final repository = await ref.watch(radarrRepositoryProvider(instanceId).future);
  return repository.searchLookup(term);
}

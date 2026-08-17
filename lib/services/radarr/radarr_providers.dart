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

/// Resolves a relative Radarr image URL to a full URL using the instance's
/// current base URL and API key (via query param, as Radarr's image proxy
/// requires it).
@riverpod
Future<String?> radarrFullImageUrl(
  Ref ref, {
  required String instanceId,
  required String relativeUrl,
}) async {
  final resolutionResult = await ref.watch(resolvedEndpointProvider(instanceId).future);
  if (resolutionResult is! Ok<EndpointResolution>) return null;
  final resolution = resolutionResult.value;

  final credential = await ref.watch(serviceCredentialProvider(instanceId).future);
  if (credential is! ApiKeyCredential) return null;

  final baseUrl = resolution.baseUrl.replaceAll(RegExp(r'/api/v3/?$'), '');
  return '$baseUrl$relativeUrl?apikey=${credential.apiKey}';
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

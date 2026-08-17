/// Riverpod providers for the Sonarr service module (spec §4).
///
/// Wires up [SonarrRepository] with the per-instance [Dio] composition.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sonarr_providers.g.dart';

@riverpod
Future<SonarrRepository> sonarrRepository(Ref ref, String instanceId) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);
  
  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };

  return SonarrRepository(SonarrClient(dio));
}

@riverpod
Future<Result<List<SonarrSeries>>> sonarrSeries(Ref ref, String instanceId) async {
  final repository = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return repository.listSeries();
}

@riverpod
Future<Result<SonarrSeries>> sonarrSingleSeries(
  Ref ref, {
  required String instanceId,
  required int seriesId,
}) async {
  // Check cache first
  final seriesListResult = ref.read(sonarrSeriesProvider(instanceId)).value;
  if (seriesListResult is Ok<List<SonarrSeries>>) {
    try {
      final cached = seriesListResult.value.firstWhere((s) => s.id == seriesId);
      return Ok(cached);
    } catch (_) {}
  }

  final repository = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return repository.getSeries(seriesId);
}

@riverpod
Future<Result<List<SonarrEpisode>>> sonarrEpisodes(
  Ref ref, {
  required String instanceId,
  required int seriesId,
}) async {
  final repository = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return repository.listEpisodes(seriesId);
}

@riverpod
Future<Result<List<SonarrQualityProfile>>> sonarrQualityProfiles(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return repository.listQualityProfiles();
}

@riverpod
Future<Result<List<SonarrRootFolder>>> sonarrRootFolders(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return repository.listRootFolders();
}

/// Search results for a lookup term.
@riverpod
Future<Result<List<SonarrSeries>>> sonarrLookup(
  Ref ref, {
  required String instanceId,
  required String term,
}) async {
  if (term.isEmpty) return const Ok([]);
  final repository = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return repository.searchLookup(term);
}

/// Resolves a relative Sonarr image URL to a full URL.
@riverpod
Future<String?> sonarrFullImageUrl(
  Ref ref, {
  required String instanceId,
  required String relativeUrl,
}) async {
  if (relativeUrl.startsWith('http')) return relativeUrl;

  final resolutionResult = await ref.watch(resolvedEndpointProvider(instanceId).future);
  if (resolutionResult is! Ok<EndpointResolution>) return null;
  final resolution = resolutionResult.value;

  final credential = await ref.watch(serviceCredentialProvider(instanceId).future);
  if (credential is! ApiKeyCredential) return null;

  final baseUri = Uri.parse(resolution.baseUrl);
  final cleanPath = baseUri.path.replaceAll(RegExp(r'/api(/v3)?/?$'), '').replaceAll(RegExp(r'/$'), '');
  
  var path = relativeUrl.startsWith('/') ? relativeUrl : '/$relativeUrl';
  if (cleanPath.isNotEmpty && path.startsWith(cleanPath)) {
    path = path.substring(cleanPath.length);
  }

  final result = baseUri.replace(
    path: '$cleanPath$path',
    queryParameters: {
      ...baseUri.queryParameters,
      'apikey': credential.apiKey,
    },
  ).toString();

  // ignore: avoid_print
  print('Sonarr Resolved Image URL: $result');
  return result;
}

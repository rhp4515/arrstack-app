/// Riverpod wiring for interactive release search: the results future
/// (dispatched to the Sonarr or Radarr repository) and the active sort.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_search_providers.g.dart';

/// Runs an interactive search for [targetId] (an episode id for Sonarr, a
/// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
/// is an explicit, expensive action; refetch with `ref.invalidate`.
@riverpod
Future<Result<List<ReleaseCandidate>>> releaseSearchResults(
  Ref ref, {
  required ServiceType service,
  required String instanceId,
  required int targetId,
}) async {
  if (service == ServiceType.sonarr) {
    final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
    final raw = await repo.searchEpisodeReleases(targetId);
    return raw.map((list) => list.map(ReleaseCandidate.fromSonarr).toList());
  }
  if (service == ServiceType.radarr) {
    final repo = await ref.watch(radarrRepositoryProvider(instanceId).future);
    final raw = await repo.searchMovieReleases(targetId);
    return raw.map((list) => list.map(ReleaseCandidate.fromRadarr).toList());
  }
  return const Err(
    UnknownError(
      userMessage:
          'Interactive search is only available for Sonarr and Radarr.',
    ),
  );
}

/// The active sort for the results list. Defaults to [ReleaseSort.peers].
@riverpod
class ReleaseSortController extends _$ReleaseSortController {
  @override
  ReleaseSort build() => ReleaseSort.peers;

  void select(ReleaseSort value) => state = value;
}

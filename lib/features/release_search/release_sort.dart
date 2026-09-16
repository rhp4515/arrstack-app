/// Sort options for the interactive-search results list (README §3e: Best
/// match / Size / Seeders) and the pure function that applies them.
library;

import 'package:arrstack/features/release_search/models/release_candidate.dart';

/// Active sort for the release list. `best` is the default.
///
/// `best` preserves the service's own original ordering — the order
/// Radarr/Sonarr's repository returned the candidates in, which already
/// reflects their own ranking (custom format score, quality, etc.).
/// `seeders` explicitly re-sorts by seeder count (`peersKey`), descending,
/// unknown last. They are deliberately distinct: `best` is "trust the
/// backend's own ordering," `seeders` is "re-rank by peers regardless of
/// what the backend preferred."
enum ReleaseSort { best, size, seeders }

/// Returns a new list of [items] ordered by [sort]. [items] is not mutated.
List<ReleaseCandidate> applySort(
  List<ReleaseCandidate> items,
  ReleaseSort sort,
) {
  final sorted = [...items];
  switch (sort) {
    case ReleaseSort.best:
      break;
    case ReleaseSort.seeders:
      sorted.sort((a, b) => b.peersKey.compareTo(a.peersKey));
    case ReleaseSort.size:
      sorted.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
  }
  return sorted;
}

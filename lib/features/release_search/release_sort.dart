/// Sort options for the interactive-search results list (README §3e: Best
/// match / Size / Seeders) and the pure function that applies them.
library;

import 'package:arrstack/features/release_search/models/release_candidate.dart';

/// Active sort for the release list. `best` is the default.
///
/// `best` and `seeders` currently produce identical orderings — both rank
/// by `peersKey` (seeders high→low, unknown last), the only ranking signal
/// `ReleaseCandidate` exposes today. There's no separate match-quality
/// score to make "Best match" mean something distinct from "Seeders" yet;
/// this is an honest limitation, not an oversight.
enum ReleaseSort { best, size, seeders }

/// Returns a new list of [items] ordered by [sort]. [items] is not mutated.
List<ReleaseCandidate> applySort(
  List<ReleaseCandidate> items,
  ReleaseSort sort,
) {
  final sorted = [...items];
  switch (sort) {
    case ReleaseSort.best:
    case ReleaseSort.seeders:
      sorted.sort((a, b) => b.peersKey.compareTo(a.peersKey));
    case ReleaseSort.size:
      sorted.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
  }
  return sorted;
}

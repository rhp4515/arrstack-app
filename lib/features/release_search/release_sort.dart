/// Sort options for the interactive-search results list and the pure
/// function that applies them.
library;

import 'package:arrstack/features/release_search/models/release_candidate.dart';

/// Active sort for the release list. `peers` is the default.
enum ReleaseSort { peers, size, age, quality }

/// Returns a new list of [items] ordered by [sort]. [items] is not mutated.
///
/// - [ReleaseSort.peers]: seeders high→low; seeder-less releases (`peersKey`
///   `-1`) sink to the bottom.
/// - [ReleaseSort.size]: bytes small→large.
/// - [ReleaseSort.age]: age in minutes small→large (newest first).
/// - [ReleaseSort.quality]: `qualityWeight` high→low.
List<ReleaseCandidate> applySort(
  List<ReleaseCandidate> items,
  ReleaseSort sort,
) {
  final sorted = [...items];
  switch (sort) {
    case ReleaseSort.peers:
      sorted.sort((a, b) => b.peersKey.compareTo(a.peersKey));
    case ReleaseSort.size:
      sorted.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
    case ReleaseSort.age:
      sorted.sort((a, b) => a.ageMinutes.compareTo(b.ageMinutes));
    case ReleaseSort.quality:
      sorted.sort((a, b) => b.qualityWeight.compareTo(a.qualityWeight));
  }
  return sorted;
}

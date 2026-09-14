/// Pure helpers for Indexers page metrics (README §2l): the slow-response
/// threshold, and aggregation across all indexer stats for the header row
/// and the "LAST 24H" block. Kept free of Flutter imports so they're
/// unit-testable without pumping widgets.
library;

import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';

/// An indexer's average response time above this is flagged "slow". Not a
/// value the README specifies numerically (only the 1284ms example) — a
/// documented judgment call, easy to retune.
const int slowResponseThresholdMs = 1000;

bool isSlowResponse(int averageResponseTimeMs) =>
    averageResponseTimeMs > slowResponseThresholdMs;

class IndexerTotals {
  const IndexerTotals({
    required this.totalGrabs,
    required this.slowestResponseMs,
    required this.queries,
    required this.grabs,
    required this.failures,
  });

  final int totalGrabs;
  final int slowestResponseMs;
  final int queries;
  final int grabs;
  final int failures;
}

IndexerTotals aggregateIndexerStats(List<IndexerStat> stats) {
  if (stats.isEmpty) {
    return const IndexerTotals(
      totalGrabs: 0,
      slowestResponseMs: 0,
      queries: 0,
      grabs: 0,
      failures: 0,
    );
  }
  return IndexerTotals(
    totalGrabs: stats.fold(0, (sum, s) => sum + s.numberOfGrabs),
    slowestResponseMs: stats
        .map((s) => s.averageResponseTime)
        .reduce((a, b) => a > b ? a : b),
    queries: stats.fold(0, (sum, s) => sum + s.numberOfQueries),
    grabs: stats.fold(0, (sum, s) => sum + s.numberOfGrabs),
    failures: stats.fold(0, (sum, s) => sum + s.numberOfFailures),
  );
}

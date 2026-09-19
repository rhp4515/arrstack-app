import 'package:arrstack/features/indexers/indexer_stats.dart';
import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSlowResponse', () {
    test('is true above the threshold', () {
      expect(isSlowResponse(1284), isTrue);
    });

    test('is false at or below the threshold', () {
      expect(isSlowResponse(1000), isFalse);
      expect(isSlowResponse(55), isFalse);
    });
  });

  group('aggregateIndexerStats', () {
    test('sums grabs/queries/failures and finds the max response time', () {
      final stats = [
        const IndexerStat(
          indexerId: 1,
          averageResponseTime: 55,
          numberOfQueries: 100,
          numberOfGrabs: 10,
          numberOfFailures: 1,
        ),
        const IndexerStat(
          indexerId: 2,
          averageResponseTime: 1284,
          numberOfQueries: 200,
          numberOfGrabs: 6,
          numberOfFailures: 36,
        ),
      ];

      final totals = aggregateIndexerStats(stats);

      expect(totals.totalGrabs, 16);
      expect(totals.slowestResponseMs, 1284);
      expect(totals.queries, 300);
      expect(totals.grabs, 16);
      expect(totals.failures, 37);
    });

    test('returns all zeros for an empty list', () {
      final totals = aggregateIndexerStats(const []);
      expect(totals.totalGrabs, 0);
      expect(totals.slowestResponseMs, 0);
      expect(totals.queries, 0);
      expect(totals.grabs, 0);
      expect(totals.failures, 0);
    });
  });
}

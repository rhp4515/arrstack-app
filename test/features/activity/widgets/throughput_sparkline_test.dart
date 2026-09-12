import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/throughput_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bucketThroughputSamples', () {
    test('places samples into their 5-minute bucket, averaging duplicates', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      final samples = [
        ThroughputSample(
          timestamp: now.subtract(const Duration(seconds: 30)),
          dlSpeedBytesPerSecond: 1000,
        ),
        ThroughputSample(
          timestamp: now.subtract(const Duration(seconds: 10)),
          dlSpeedBytesPerSecond: 2000,
        ),
      ];

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets, hasLength(12));
      expect(buckets.last, 1500); // both samples fall in the most recent bucket
      expect(buckets.sublist(0, 11).every((b) => b == 0), isTrue);
    });

    test('drops samples older than the 60-minute window', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      final samples = [
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 90)),
          dlSpeedBytesPerSecond: 5000,
        ),
      ];

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets.every((b) => b == 0), isTrue);
    });

    test('returns 12 zero buckets for an empty sample list', () {
      expect(bucketThroughputSamples(const []), List.filled(12, 0));
    });

    test('places a single sample in middle bucket (index 5)', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      // A sample ~35 minutes old should land in bucket index 5
      // (35 minutes / 5 minutes per bucket = index 7, but we're 35 min from now)
      // Actually: offset from windowStart = (now - 60 min) + 25 min = now - 35 min
      // So a sample at now - 35 min has offset = 25 min
      // index = 25 min / 5 min = 5
      final samples = [
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 35)),
          dlSpeedBytesPerSecond: 3000,
        ),
      ];

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets, hasLength(12));
      expect(buckets[5], 3000); // sample lands in bucket 5
      expect(
        buckets
            .asMap()
            .entries
            .where((e) => e.key != 5)
            .every((e) => e.value == 0),
        isTrue,
      ); // all other buckets are 0
    });

    test('spreads samples across multiple distinct buckets', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      final samples = [
        // windowStart = now - 60 min
        // Sample at now - 55 min: offset = 5 min, index = 1
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 55)),
          dlSpeedBytesPerSecond: 1000,
        ),
        // Sample at now - 40 min: offset = 20 min, index = 4
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 40)),
          dlSpeedBytesPerSecond: 2000,
        ),
        // Sample at now - 20 min: offset = 40 min, index = 8
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 20)),
          dlSpeedBytesPerSecond: 3000,
        ),
        // Sample at now - 5 min: offset = 55 min, index = 11
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 5)),
          dlSpeedBytesPerSecond: 4000,
        ),
      ];

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets, hasLength(12));
      expect(buckets[1], 1000); // 55 min old
      expect(buckets[4], 2000); // 40 min old
      expect(buckets[8], 3000); // 20 min old
      expect(buckets[11], 4000); // 5 min old
      // All other buckets except 1, 4, 8, 11 should be 0
      for (var i = 0; i < 12; i++) {
        if (i != 1 && i != 4 && i != 8 && i != 11) {
          expect(buckets[i], 0);
        }
      }
    });

    test('populates all 12 buckets with one sample every 5 minutes', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      final samples = <ThroughputSample>[];

      // Create 12 samples, one for each 5-minute bucket
      // Bucket 0 (oldest): now - 59:59 min
      // Bucket 1: now - 54:59 min
      // ...
      // Bucket 11 (newest): now - 0:01 sec (still within last bucket)
      for (var i = 0; i < 12; i++) {
        final minutesBack = 59 - (i * 5);
        samples.add(
          ThroughputSample(
            timestamp: now.subtract(Duration(minutes: minutesBack)),
            dlSpeedBytesPerSecond: (i + 1) * 1000, // 1000, 2000, ..., 12000
          ),
        );
      }

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets, hasLength(12));
      // Verify that all buckets have values (none are 0)
      for (var i = 0; i < 12; i++) {
        expect(
          buckets[i],
          greaterThan(0),
          reason: 'Bucket $i should be populated',
        );
      }
      // Verify ordering (oldest to newest) is roughly preserved
      // The bucket values should roughly increase as we go from old to new
      expect(
        buckets.last,
        greaterThan(buckets.first),
        reason: 'Most recent bucket should have higher value than oldest',
      );
    });
  });

  group('ThroughputSparkline widget', () {
    testWidgets('shows a "now" speed and a peak caption', (tester) async {
      final now = DateTime.now();
      final samples = [
        ThroughputSample(timestamp: now, dlSpeedBytesPerSecond: 5600000),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ThroughputSparkline(samples: samples)),
        ),
      );

      expect(find.textContaining('Last 60 min'), findsOneWidget);
      expect(find.textContaining('now'), findsOneWidget);
      expect(find.textContaining('peak'), findsOneWidget);
    });

    testWidgets('renders without error for an empty sample list', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThroughputSparkline(samples: [])),
        ),
      );

      expect(find.byType(ThroughputSparkline), findsOneWidget);
    });
  });
}

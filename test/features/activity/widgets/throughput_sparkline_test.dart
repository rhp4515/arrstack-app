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

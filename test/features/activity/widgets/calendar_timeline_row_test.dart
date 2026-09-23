// test/features/activity/widgets/calendar_timeline_row_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/activity/widgets/calendar_timeline_row.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry _entry({
  required DateTime date,
  bool hasFile = false,
  bool monitored = true,
  String? subtitle,
  String? network,
  bool allDay = false,
}) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: 'The Bear',
  subtitle: subtitle,
  network: network,
  hasFile: hasFile,
  monitored: monitored,
  allDay: allDay,
);

void main() {
  group('relativeAirLabel', () {
    test('future date under 24h shows hours', () {
      final now = DateTime(2026, 1, 1, 9);
      expect(relativeAirLabel(DateTime(2026, 1, 1, 20), now), 'airs in 11h');
    });

    test('future date 24h+ shows days', () {
      final now = DateTime(2026, 1, 1, 9);
      expect(relativeAirLabel(DateTime(2026, 1, 4, 9), now), 'airs in 3d');
    });

    test('past date under 24h shows hours ago', () {
      final now = DateTime(2026, 1, 1, 9);
      expect(relativeAirLabel(DateTime(2026, 1, 1, 3), now), 'aired 6h ago');
    });

    test('all-day dates count whole days rather than hours', () {
      final now = DateTime(2026, 1, 1, 21);
      expect(
        relativeAirLabel(DateTime(2026, 1, 1), now, allDay: true),
        'airs today',
      );
      expect(
        relativeAirLabel(DateTime(2026, 1, 2), now, allDay: true),
        'airs in 1d',
      );
      expect(
        relativeAirLabel(DateTime(2025, 12, 30), now, allDay: true),
        'aired 2d ago',
      );
    });
  });

  group('CalendarTimelineRow widget', () {
    testWidgets('shows title, subtitle/network line, and a Downloaded chip', (
      tester,
    ) async {
      final now = DateTime(2026, 1, 1, 12);
      final entry = _entry(
        date: DateTime(2026, 1, 1, 3),
        hasFile: true,
        subtitle: 'S04E03',
        network: 'FX',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalendarTimelineRow(entry: entry, now: now),
          ),
        ),
      );

      expect(find.text('The Bear'), findsOneWidget);
      expect(find.textContaining('S04E03'), findsOneWidget);
      expect(find.text('Downloaded'), findsOneWidget);
    });

    testWidgets(
      'shows a Monitored chip with a relative air caption when no file yet',
      (tester) async {
        final now = DateTime(2026, 1, 1, 9);
        final entry = _entry(date: DateTime(2026, 1, 1, 20));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CalendarTimelineRow(entry: entry, now: now),
            ),
          ),
        );

        expect(find.text('Monitored'), findsOneWidget);
        expect(find.text('airs in 11h'), findsOneWidget);
      },
    );

    testWidgets('shows an Unmonitored chip when not monitored and no file', (
      tester,
    ) async {
      final now = DateTime(2026, 1, 1, 9);
      final entry = _entry(date: DateTime(2026, 1, 1, 20), monitored: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalendarTimelineRow(entry: entry, now: now),
          ),
        ),
      );

      expect(find.text('Unmonitored'), findsOneWidget);
    });

    testWidgets('shows "All day" instead of a clock time for all-day entries', (
      tester,
    ) async {
      final now = DateTime(2026, 1, 1, 9);
      final entry = _entry(date: DateTime(2026, 1, 3), allDay: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalendarTimelineRow(entry: entry, now: now),
          ),
        ),
      );

      expect(find.text('All day'), findsOneWidget);
      expect(find.text('12:00 AM'), findsNothing);
      expect(find.text('airs in 2d'), findsOneWidget);
    });
  });
}

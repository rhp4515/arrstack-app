// ignore_for_file: avoid_print
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/activity/widgets/week_strip.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry _entry(DateTime date) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: 't',
);

void main() {
  group('buildWeekStrip', () {
    test('returns 6 days starting today, marking today', () {
      final today = DateTime(2026, 9, 2); // Wednesday
      final strip = buildWeekStrip(const [], today: today);

      expect(strip, hasLength(6));
      expect(strip.first.date, today);
      expect(strip.first.isToday, isTrue);
      expect(strip.last.date, today.add(const Duration(days: 5)));
      expect(strip.last.isToday, isFalse);
    });

    test('classifies load by entry count: empty/light/busy', () {
      final today = DateTime(2026, 9, 2);
      final days = [
        CalendarDay(
          date: today,
          entries: [_entry(today), _entry(today), _entry(today)],
        ),
        CalendarDay(
          date: today.add(const Duration(days: 1)),
          entries: [_entry(today)],
        ),
      ];

      final strip = buildWeekStrip(days, today: today);

      expect(strip[0].load, DayLoad.busy); // 3 entries
      expect(strip[1].load, DayLoad.light); // 1 entry
      expect(strip[2].load, DayLoad.empty); // no entries
    });
  });

  group('WeekStrip widget', () {
    testWidgets('renders 6 day cells with weekday and date text', (
      tester,
    ) async {
      final today = DateTime(2026, 9, 2);
      final days = [
        CalendarDay(date: today, entries: [_entry(today)]),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeekStrip(days: days, today: today),
          ),
        ),
      );

      expect(find.text('WED'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}

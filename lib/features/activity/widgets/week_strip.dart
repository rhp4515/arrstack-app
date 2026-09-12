/// The Calendar lens's week strip (spec screen 2i): six day cells, each a
/// weekday label, a tabular date, and a load bar sized by how many entries
/// land on that day. Today gets an accent ring and accent text.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';

enum DayLoad { empty, light, busy }

class WeekStripDay {
  const WeekStripDay({
    required this.date,
    required this.load,
    required this.isToday,
  });

  final DateTime date;
  final DayLoad load;
  final bool isToday;
}

const List<String> _weekdayAbbrev = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN',
];

/// Six days starting at [today] (defaults to `DateTime.now()`), each
/// classified by how many [days] entries land on it: 0 → empty, 1-2 →
/// light, 3+ → busy. Pure — unit-testable without a widget tree.
List<WeekStripDay> buildWeekStrip(List<CalendarDay> days, {DateTime? today}) {
  final now = today ?? DateTime.now();
  final referenceDate = DateTime(now.year, now.month, now.day);

  final countByDate = <DateTime, int>{
    for (final day in days)
      DateTime(day.date.year, day.date.month, day.date.day): day.entries.length,
  };

  return [
    for (var i = 0; i < 6; i++)
      _dayFor(referenceDate.add(Duration(days: i)), countByDate, referenceDate),
  ];
}

WeekStripDay _dayFor(
  DateTime date,
  Map<DateTime, int> countByDate,
  DateTime today,
) {
  final count = countByDate[date] ?? 0;
  final load = count == 0
      ? DayLoad.empty
      : (count >= 3 ? DayLoad.busy : DayLoad.light);
  return WeekStripDay(date: date, load: load, isToday: date == today);
}

class WeekStrip extends StatelessWidget {
  const WeekStrip({required this.days, this.today, super.key});

  final List<CalendarDay> days;

  /// Injected for deterministic tests; defaults to `DateTime.now()` in
  /// production via [buildWeekStrip].
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final strip = buildWeekStrip(days, today: today);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (final day in strip)
          Expanded(
            child: _DayCell(day: day, colorScheme: colorScheme),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.colorScheme});

  final WeekStripDay day;
  final ColorScheme colorScheme;

  double get _barWidth => switch (day.load) {
    DayLoad.busy => 14,
    DayLoad.light => 8,
    DayLoad.empty => 0,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final activeColor = colorScheme.primary;
    final mutedColor = isDark ? AppColors.n400 : colorScheme.onSurfaceVariant;
    final textColor = day.isToday ? activeColor : colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: day.isToday ? Border.all(color: activeColor) : null,
      ),
      child: Column(
        children: [
          Text(
            _weekdayAbbrev[day.date.weekday - 1],
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: day.isToday ? activeColor : mutedColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${day.date.day}',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: _barWidth,
            height: 2,
            color: day.isToday ? activeColor : mutedColor,
          ),
        ],
      ),
    );
  }
}

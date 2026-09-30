/// One day of the calendar timeline: an accent day kicker with the entry
/// count on the right, then the day's rows. Shared by Activity's Calendar
/// lens and the Library "Upcoming" sub-tab.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/activity/widgets/calendar_timeline_row.dart';
import 'package:arrstack/features/activity/widgets/section_header.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:flutter/material.dart';

class CalendarDaySection extends StatelessWidget {
  const CalendarDaySection({required this.day, super.key});

  final CalendarDay day;

  @override
  Widget build(BuildContext context) {
    final relative = relativeDayLabel(day.date, DateTime.now());
    final header = relative == null
        ? formatDayHeader(day.date)
        : '$relative · ${formatDayHeader(day.date)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            kicker: header.toUpperCase(),
            trailing: '${day.entries.length}',
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final entry in day.entries) CalendarTimelineRow(entry: entry),
        ],
      ),
    );
  }
}

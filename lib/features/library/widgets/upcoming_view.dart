/// The "Upcoming" sub-tab: monitored movies releasing / episodes airing
/// soon on the selected instance, day-grouped. Reuses the Calendar
/// feature's schedule and the Activity calendar's timeline row.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/widgets/calendar_timeline_row.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:arrstack/features/library/library_section_providers.dart';
import 'package:arrstack/features/library/widgets/section_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LibraryUpcomingView extends ConsumerWidget {
  const LibraryUpcomingView({
    required this.type,
    required this.instanceId,
    this.query = '',
    super.key,
  });

  final ServiceType type;
  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingAsync = ref.watch(libraryUpcomingProvider(type, instanceId));
    Future<void> refresh() async => ref.invalidate(calendarScheduleProvider);

    return upcomingAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(refresh, _filter(value)),
        Err(:final error) => RefreshableError(
          onRefresh: refresh,
          title: "Couldn't load upcoming releases",
          message: error.userMessage,
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => RefreshableError(
        onRefresh: refresh,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  List<CalendarDay> _filter(List<CalendarDay> days) {
    if (query.isEmpty) return days;
    return [
      for (final day in days)
        if (day.entries.any((e) => matchesQuery(query, e.title)))
          CalendarDay(
            date: day.date,
            entries: day.entries
                .where((e) => matchesQuery(query, e.title))
                .toList(),
          ),
    ];
  }

  Widget _body(Future<void> Function() refresh, List<CalendarDay> days) {
    if (days.isEmpty) {
      return RefreshableMessage(
        onRefresh: refresh,
        icon: PhosphorIconsRegular.calendarX,
        title: 'Nothing upcoming',
        message: type == ServiceType.radarr
            ? 'Monitored movies releasing in the next 60 days will appear here.'
            : 'Monitored episodes airing in the next 60 days will appear here.',
      );
    }
    return RefreshableSection(
      onRefresh: refresh,
      children: [
        const SizedBox(height: AppSpacing.space2),
        for (final day in days) _DaySection(day: day),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day});

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
          Text(header.toUpperCase(), style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space3),
          for (final entry in day.entries) CalendarTimelineRow(entry: entry),
        ],
      ),
    );
  }
}

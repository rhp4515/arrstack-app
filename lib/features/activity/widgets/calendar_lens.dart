/// The Calendar lens (spec screen 2i): a week strip above a day-grouped,
/// searchable timeline. Reuses `calendarScheduleProvider` from the
/// Calendar feature providers.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/widgets/calendar_timeline_row.dart';
import 'package:arrstack/features/activity/widgets/week_strip.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class CalendarLens extends ConsumerStatefulWidget {
  const CalendarLens({super.key});

  @override
  ConsumerState<CalendarLens> createState() => _CalendarLensState();
}

class _CalendarLensState extends ConsumerState<CalendarLens> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(CalendarEntry entry) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return entry.title.toLowerCase().contains(q) ||
        (entry.subtitle?.toLowerCase().contains(q) ?? false) ||
        (entry.network?.toLowerCase().contains(q) ?? false);
  }

  List<CalendarDay> _filter(List<CalendarDay> days) {
    if (_query.isEmpty) return days;
    return [
      for (final day in days)
        if (day.entries.any(_matches))
          CalendarDay(
            date: day.date,
            entries: day.entries.where(_matches).toList(),
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(calendarScheduleProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space3,
            AppSpacing.space6,
            AppSpacing.space3,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Search calendar…',
              prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass, size: 18),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(calendarScheduleProvider),
            child: scheduleAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) => _CalendarBody(
                  allDays: value,
                  filteredDays: _filter(value),
                ),
                Err(:final error) => EmptyState(
                  icon: PhosphorIconsRegular.warning,
                  title: "Couldn't load the calendar",
                  message: error.userMessage,
                  action: FilledButton(
                    onPressed: () => ref.invalidate(calendarScheduleProvider),
                    child: const Text('Retry'),
                  ),
                ),
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => EmptyState(
                icon: PhosphorIconsRegular.warning,
                title: 'Unexpected error',
                message: err.toString(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody({required this.allDays, required this.filteredDays});

  final List<CalendarDay> allDays;
  final List<CalendarDay> filteredDays;

  @override
  Widget build(BuildContext context) {
    if (filteredDays.isEmpty) {
      return ListView(
        children: [
          Padding(
            padding: AppInsets.pageLg,
            child: WeekStrip(days: allDays),
          ),
          const SizedBox(height: AppSpacing.space8),
          const EmptyState(
            icon: PhosphorIconsRegular.calendarX,
            title: 'Nothing scheduled',
            message:
                'Monitored episodes and movie releases will appear here '
                'once your Sonarr and Radarr instances have upcoming items.',
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space6,
        0,
        AppSpacing.space6,
        AppSpacing.space8,
      ),
      children: [
        WeekStrip(days: allDays),
        const SizedBox(height: AppSpacing.space4),
        for (final day in filteredDays) _DaySection(day: day),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day});

  final CalendarDay day;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : colorScheme.primary;
    final mutedColor = isDark ? AppColors.n400 : colorScheme.onSurfaceVariant;
    final now = DateTime.now();
    final relative = relativeDayLabel(day.date, now);
    final header = relative == null
        ? formatDayHeader(day.date)
        : '$relative · ${formatDayHeader(day.date)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header.toUpperCase(),
                style: AppTypography.kicker.copyWith(color: accentColor),
              ),
              Text(
                '${day.entries.length}',
                style: AppTypography.meta.copyWith(color: mutedColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final entry in day.entries) CalendarTimelineRow(entry: entry),
        ],
      ),
    );
  }
}

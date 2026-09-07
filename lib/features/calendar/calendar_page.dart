/// Calendar tab: the merged air/release schedule for monitored series and
/// movies across all configured Sonarr and Radarr instances, grouped by day.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:arrstack/features/calendar/widgets/calendar_entry_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search calendar…',
              leading: const Icon(Icons.search),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(calendarScheduleProvider),
              child: scheduleAsync.when(
                data: (result) => switch (result) {
                  Ok(:final value) => _CalendarList(days: _filter(value)),
                  Err(:final error) => EmptyState(
                    icon: Icons.error_outline,
                    title: 'Couldn’t load the calendar',
                    message: error.userMessage,
                    action: FilledButton(
                      onPressed: () => ref.invalidate(calendarScheduleProvider),
                      child: const Text('Retry'),
                    ),
                  ),
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Unexpected error',
                  message: err.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarList extends StatelessWidget {
  const _CalendarList({required this.days});

  final List<CalendarDay> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return ListView(
        // A scrollable child keeps RefreshIndicator working on empty state.
        children: const [
          SizedBox(height: AppSpacing.xxl),
          EmptyState(
            icon: Icons.event_busy_outlined,
            title: 'Nothing scheduled',
            message:
                'Monitored episodes and movie releases will appear here once '
                'your Sonarr and Radarr instances have upcoming items.',
          ),
        ],
      );
    }

    final now = DateTime.now();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return _DaySection(day: day, today: now);
      },
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day, required this.today});

  final CalendarDay day;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final relative = relativeDayLabel(day.date, today);
    final header = relative == null
        ? formatDayHeader(day.date)
        : '$relative · ${formatDayHeader(day.date)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            header,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final entry in day.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: CalendarEntryTile(entry: entry),
          ),
      ],
    );
  }
}

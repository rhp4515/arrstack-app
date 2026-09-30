/// Providers for the Calendar feature: aggregates the release/air schedule
/// across every configured Sonarr and Radarr instance into one grouped list.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_providers.g.dart';

/// How many days forward the schedule window reaches from today. The list
/// starts at today — no lookback — so it always opens on the current day.
const int _lookaheadDays = 60;

/// The schedule window for [now]: local midnight today, and local midnight
/// [_lookaheadDays] calendar days later as the exclusive end.
///
/// The end is built as a calendar date rather than `today + 60 × 24h`: when
/// the window spans an autumn DST change that sum lands at 23:00 the day
/// before, and the day-based Radarr filter then loses its last day. Pure —
/// unit-testable without a clock.
({DateTime start, DateTime end}) calendarWindow(DateTime now) => (
  start: DateTime(now.year, now.month, now.day),
  end: DateTime(now.year, now.month, now.day + _lookaheadDays),
);

/// The merged, day-grouped schedule across all Sonarr + Radarr instances.
///
/// A single instance failing (offline, auth) is skipped rather than failing
/// the whole calendar — the schedule shows whatever could be reached. The
/// result is [Err] only when the instance list itself can't be read.
@riverpod
Future<Result<List<CalendarDay>>> calendarSchedule(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is Err<List<ServiceInstance>>) {
    return Err(instancesResult.error);
  }
  final instances = (instancesResult as Ok<List<ServiceInstance>>).value;

  final (start: today, :end) = calendarWindow(DateTime.now());

  final futures = <Future<List<CalendarEntry>>>[
    for (final instance in instances)
      if (instance.serviceType == ServiceType.sonarr)
        _sonarrEntries(ref, instance.id, today, end)
      else if (instance.serviceType == ServiceType.radarr)
        _radarrEntries(ref, instance.id, today, end),
  ];

  final lists = await Future.wait(futures);
  final entries = lists.expand((list) => list).toList();
  return Ok(groupEntriesByDay(entries));
}

Future<List<CalendarEntry>> _sonarrEntries(
  Ref ref,
  String instanceId,
  DateTime start,
  DateTime end,
) async {
  try {
    final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
    final result = await repo.listCalendar(start, end);
    if (result case Ok(:final value)) {
      return value
          .map(
            (ep) => CalendarEntry.fromSonarrEpisode(ep, instanceId: instanceId),
          )
          .whereType<CalendarEntry>()
          .toList();
    }
  } on Object {
    // Skip an unreachable/misconfigured instance; the calendar stays partial.
  }
  return const [];
}

Future<List<CalendarEntry>> _radarrEntries(
  Ref ref,
  String instanceId,
  DateTime start,
  DateTime end,
) async {
  try {
    final repo = await ref.watch(radarrRepositoryProvider(instanceId).future);
    // Release dates are UTC-midnight values, but [start]/[end] are local
    // midnights: pad the query a day each way so a release on the first or
    // last day isn't cut off by the timezone offset. `fromRadarrMovie` then
    // keeps only releases whose day is inside the window.
    final result = await repo.listCalendar(
      start.subtract(const Duration(days: 1)),
      end.add(const Duration(days: 1)),
    );
    // [end] is an instant, not a day: Sonarr receives it as a timestamp,
    // so its episodes stop at midnight on [end]'s day. `fromRadarrMovie`
    // filters by whole days *inclusively*, so handing it [end] directly
    // kept every movie released on that last day — a day showing movies
    // but none of its episodes. Stop at the day before instead. Built as a
    // calendar date rather than `end - 24h`, which across a DST change
    // lands on the wrong day.
    final lastDay = DateTime(end.year, end.month, end.day - 1);
    if (result case Ok(:final value)) {
      return value
          .map(
            (m) => CalendarEntry.fromRadarrMovie(
              m,
              instanceId: instanceId,
              windowStart: start,
              windowEnd: lastDay,
            ),
          )
          .whereType<CalendarEntry>()
          .toList();
    }
  } on Object {
    // Skip an unreachable/misconfigured instance; the calendar stays partial.
  }
  return const [];
}

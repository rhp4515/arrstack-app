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

/// How far forward the schedule window reaches from today. The list starts
/// at today — no lookback — so it always opens on the current day.
const Duration _lookahead = Duration(days: 60);

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

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final end = today.add(_lookahead);

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
    final result = await repo.listCalendar(start, end);
    if (result case Ok(:final value)) {
      return value
          .map((m) => CalendarEntry.fromRadarrMovie(m, instanceId: instanceId))
          .whereType<CalendarEntry>()
          .toList();
    }
  } on Object {
    // Skip an unreachable/misconfigured instance; the calendar stays partial.
  }
  return const [];
}

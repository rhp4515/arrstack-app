/// Providers behind the Library's Upcoming / Missing / Queue / History
/// sub-tabs for one Radarr or Sonarr instance.
///
/// Upcoming and Sonarr's Missing reuse the app-wide aggregations
/// ([calendarScheduleProvider], [sonarrMissingEpisodesProvider]) narrowed to
/// the selected instance; Queue reuses the per-instance queue providers.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/library/library_format.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_history.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_section_providers.g.dart';

/// Monitored releases/airings of [type] from [instanceId], day-grouped,
/// from the shared calendar window (today onward).
@riverpod
Future<Result<List<CalendarDay>>> libraryUpcoming(
  Ref ref,
  ServiceType type,
  String instanceId,
) async {
  final schedule = await ref.watch(calendarScheduleProvider.future);
  return schedule.map(
    (days) => groupEntriesByDay([
      for (final day in days)
        for (final entry in day.entries)
          if (entry.instanceId == instanceId &&
              entry.service == type &&
              entry.monitored)
            entry,
    ]),
  );
}

/// Sonarr's missing (aired, no file) episodes for [instanceId], most
/// recently aired first.
///
/// Fetched from this one instance, with its errors left in. It used to
/// filter the Activity Wanted lens's all-instance aggregation, which drops
/// an unreachable instance on purpose — right for a list spanning several
/// instances, where one dead Sonarr shouldn't blank the rest. But this tab
/// shows exactly one instance, so a dropped instance became an empty list,
/// and an offline Sonarr read "Nothing missing — every aired, monitored
/// episode has a file": a false all-clear in place of the error and Retry
/// the view already has. It also fetched every Sonarr instance to show one.
///
/// Returns the failure as an [Err] rather than throwing, like the rest of
/// the app's providers: a thrown error also trips Riverpod's automatic
/// retry, which holds the provider in loading instead of showing it.
@riverpod
Future<Result<List<SonarrMissingEpisode>>> libraryMissingEpisodes(
  Ref ref,
  String instanceId,
) async {
  final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  return (await repo.listMissingEpisodes()).map(
    (episodes) => sortMissingEpisodesByAirDate([
      for (final episode in episodes)
        SonarrMissingEpisode(instanceId: instanceId, episode: episode),
    ]).reversed.toList(),
  );
}

/// One download in the Queue sub-tab, normalized across services.
@immutable
class LibraryQueueEntry {
  const LibraryQueueEntry({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    this.releaseTitle,
    this.timeLeft,
    this.posterUrl,
  });

  final int id;

  /// Movie or series title when known, else the release name.
  final String title;

  /// The release name, when it differs from [title].
  final String? releaseTitle;

  /// Human status, e.g. "Downloading".
  final String status;

  /// Fraction downloaded, 0–1.
  final double progress;

  /// Short remaining-time label, e.g. "20m left".
  final String? timeLeft;
  final String? posterUrl;
}

/// The download queue for [instanceId], with titles and posters filled in
/// from the library list when it's already loaded.
@riverpod
Future<Result<List<LibraryQueueEntry>>> libraryQueue(
  Ref ref,
  ServiceType type,
  String instanceId,
) async {
  if (type == ServiceType.radarr) {
    final movies = ref
        .watch(radarrMoviesProvider(instanceId))
        .value
        ?.valueOrNull;
    final byId = {for (final m in movies ?? const <RadarrMovie>[]) m.id: m};
    final result = await ref.watch(radarrQueueProvider(instanceId).future);
    return result.map(
      (items) => [
        for (final item in items)
          _queueEntry(
            id: item.id,
            mediaTitle: byId[item.movieId]?.title,
            releaseTitle: item.title,
            status: item.status,
            size: item.size,
            sizeleft: item.sizeleft,
            timeleft: item.timeleft,
            posterUrl: byId[item.movieId]?.posterUrl,
          ),
      ],
    );
  }
  final series = ref.watch(sonarrSeriesProvider(instanceId)).value?.valueOrNull;
  final byId = {for (final s in series ?? const <SonarrSeries>[]) s.id: s};
  final result = await ref.watch(sonarrQueueProvider(instanceId).future);
  return result.map(
    (items) => [
      for (final item in items)
        _queueEntry(
          id: item.id,
          mediaTitle: byId[item.seriesId]?.title,
          releaseTitle: item.title,
          status: item.status,
          size: item.size,
          sizeleft: item.sizeleft,
          timeleft: item.timeleft,
          posterUrl: byId[item.seriesId]?.posterUrl,
        ),
    ],
  );
}

LibraryQueueEntry _queueEntry({
  required int id,
  required String? mediaTitle,
  required String? releaseTitle,
  required String? status,
  required int size,
  required int sizeleft,
  required String? timeleft,
  required String? posterUrl,
}) {
  final title = mediaTitle ?? releaseTitle ?? 'Unknown download';
  return LibraryQueueEntry(
    id: id,
    title: title,
    releaseTitle: releaseTitle == title ? null : releaseTitle,
    status: queueStatusLabel(status),
    progress: queueProgress(size, sizeleft),
    timeLeft: formatTimeLeft(timeleft),
    posterUrl: posterUrl,
  );
}

/// One row in the History sub-tab, normalized across services.
@immutable
class LibraryHistoryEntry {
  const LibraryHistoryEntry({
    required this.id,
    required this.title,
    required this.eventType,
    required this.date,
    this.quality,
    this.posterUrl,
  });

  factory LibraryHistoryEntry.fromRadarr(RadarrHistoryRecord record) =>
      LibraryHistoryEntry(
        id: record.id,
        title: record.displayTitle,
        eventType: record.eventType,
        date: record.date,
        quality: record.qualityName,
        posterUrl: record.posterUrl,
      );

  factory LibraryHistoryEntry.fromSonarr(SonarrHistoryRecord record) =>
      LibraryHistoryEntry(
        id: record.id,
        title: record.displayTitle,
        eventType: record.eventType,
        date: record.date,
        quality: record.qualityName,
        posterUrl: record.posterUrl,
      );

  final int id;
  final String title;
  final String eventType;
  final DateTime date;
  final String? quality;
  final String? posterUrl;
}

/// The pages of history loaded so far.
@immutable
class LibraryHistoryFeed {
  const LibraryHistoryFeed({
    required this.entries,
    required this.page,
    required this.hasMore,
  });

  final List<LibraryHistoryEntry> entries;

  /// The last page loaded (1-based).
  final int page;

  /// Whether another page may exist: by the server's total when it gives
  /// one, else whether the last page came back full.
  final bool hasMore;
}

/// Paged history for one instance: [build] loads page 1, [loadMore]
/// appends the next.
///
/// Pages are offsets into a newest-first list that keeps growing, so a
/// download finishing between two loads shifts every row down one and the
/// next page starts with the row that already ended the last. [loadMore]
/// drops rows it already has rather than listing them twice.
@riverpod
class LibraryHistory extends _$LibraryHistory {
  static const pageSize = 50;
  bool _loadingMore = false;

  @override
  Future<Result<LibraryHistoryFeed>> build(
    ServiceType type,
    String instanceId,
  ) async {
    // Subscribe to the repository so it stays alive for [loadMore] and a
    // changed endpoint/credential rebuilds the feed.
    if (type == ServiceType.radarr) {
      ref.watch(radarrRepositoryProvider(instanceId));
    } else {
      ref.watch(sonarrRepositoryProvider(instanceId));
    }
    final result = await _fetch(1);
    return result.map(
      (history) => LibraryHistoryFeed(
        entries: history.records,
        page: 1,
        hasMore: history.hasMoreAfter(page: 1, pageSize: pageSize),
      ),
    );
  }

  /// Appends the next page. Returns the error when it fails (the loaded
  /// entries stay), or null on success / when there's nothing to load.
  Future<AppError?> loadMore() async {
    final current = state.value?.valueOrNull;
    if (current == null || !current.hasMore || _loadingMore) return null;
    _loadingMore = true;
    try {
      final next = current.page + 1;
      final result = await _fetch(next);
      if (!ref.mounted) return null;
      switch (result) {
        case Ok(:final value):
          final seen = {for (final entry in current.entries) entry.id};
          state = AsyncData(
            Ok(
              LibraryHistoryFeed(
                entries: [
                  ...current.entries,
                  ...value.records.where((entry) => seen.add(entry.id)),
                ],
                page: next,
                hasMore: value.hasMoreAfter(page: next, pageSize: pageSize),
              ),
            ),
          );
          return null;
        case Err(:final error):
          return error;
      }
    } finally {
      _loadingMore = false;
    }
  }

  Future<Result<HistoryPage<LibraryHistoryEntry>>> _fetch(int page) async {
    if (type == ServiceType.radarr) {
      final repo = await ref.read(radarrRepositoryProvider(instanceId).future);
      final result = await repo.getHistoryPage(page: page, pageSize: pageSize);
      return result.map((h) => h.map(LibraryHistoryEntry.fromRadarr));
    }
    final repo = await ref.read(sonarrRepositoryProvider(instanceId).future);
    final result = await repo.getHistoryPage(page: page, pageSize: pageSize);
    return result.map((h) => h.map(LibraryHistoryEntry.fromSonarr));
  }
}

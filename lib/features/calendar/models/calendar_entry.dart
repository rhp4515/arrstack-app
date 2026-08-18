/// Unified calendar model that merges Sonarr episode air dates and Radarr
/// movie release dates into a single, service-agnostic schedule item.
///
/// The grouping logic ([groupEntriesByDay]) is pure so it can be unit-tested
/// without a running app or generated code.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/foundation.dart';

/// Whether a [CalendarEntry] is a TV episode or a movie release.
enum CalendarEntryKind { episode, movie }

/// One scheduled item on the calendar, normalized from either service.
@immutable
class CalendarEntry {
  const CalendarEntry({
    required this.kind,
    required this.service,
    required this.instanceId,
    required this.date,
    required this.title,
    this.subtitle,
    this.network,
    this.posterUrl,
    this.hasFile = false,
    this.monitored = true,
  });

  /// Episode vs movie — drives the row icon and subtitle shape.
  final CalendarEntryKind kind;

  /// Which service this came from, used to pick the right image-URL resolver.
  final ServiceType service;

  /// The instance the item belongs to (needed to sign relative image URLs).
  final String instanceId;

  /// Local date-time the item is scheduled for. Grouping keys off the day;
  /// the row shows the time.
  final DateTime date;

  /// Show title or movie title.
  final String title;

  /// "Season 4, Episode 1" for episodes, or a release-type label for movies.
  final String? subtitle;

  /// Network (episodes) or studio (movies).
  final String? network;

  /// Poster URL — may be a remote CDN URL or a relative service path that the
  /// UI resolves/signs via the matching image provider.
  final String? posterUrl;

  /// Whether the episode/movie file is already downloaded.
  final bool hasFile;

  /// Whether the item is monitored.
  final bool monitored;

  /// Builds an entry from a Sonarr calendar episode. Returns null when the
  /// episode has no air date (nothing to place on the calendar).
  static CalendarEntry? fromSonarrEpisode(
    SonarrCalendarEpisode episode, {
    required String instanceId,
  }) {
    final airDate = episode.airDateUtc;
    if (airDate == null) return null;
    final series = episode.series;
    return CalendarEntry(
      kind: CalendarEntryKind.episode,
      service: ServiceType.sonarr,
      instanceId: instanceId,
      date: airDate.toLocal(),
      title: series?.title ?? episode.title ?? 'Unknown series',
      subtitle:
          'Season ${episode.seasonNumber}, Episode ${episode.episodeNumber}',
      network: series?.network,
      posterUrl: series?.posterUrl,
      hasFile: episode.hasFile,
      monitored: episode.monitored,
    );
  }

  /// Builds an entry from a Radarr movie's most relevant release date. Returns
  /// null when the movie has no release date within the window.
  static CalendarEntry? fromRadarrMovie(
    RadarrMovie movie, {
    required String instanceId,
  }) {
    final date = movie.calendarDate;
    if (date == null) return null;
    return CalendarEntry(
      kind: CalendarEntryKind.movie,
      service: ServiceType.radarr,
      instanceId: instanceId,
      date: date.toLocal(),
      title: movie.title,
      subtitle: movie.calendarReleaseLabel,
      network: movie.studio,
      posterUrl: movie.posterUrl,
      hasFile: movie.hasFile,
      monitored: movie.monitored,
    );
  }
}

/// A single day's worth of calendar entries, sorted by time.
@immutable
class CalendarDay {
  const CalendarDay({required this.date, required this.entries});

  /// Midnight (local) of the day these entries fall on.
  final DateTime date;

  /// Entries for this day, ascending by scheduled time.
  final List<CalendarEntry> entries;
}

/// Groups a flat list of entries into day buckets, both the days and the
/// entries within each day sorted ascending by time. Pure — no I/O.
List<CalendarDay> groupEntriesByDay(List<CalendarEntry> entries) {
  final byDay = <DateTime, List<CalendarEntry>>{};
  for (final entry in entries) {
    final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
    (byDay[day] ??= <CalendarEntry>[]).add(entry);
  }

  final sortedDays = byDay.keys.toList()..sort();
  return [
    for (final day in sortedDays)
      CalendarDay(
        date: day,
        entries: byDay[day]!..sort((a, b) => a.date.compareTo(b.date)),
      ),
  ];
}

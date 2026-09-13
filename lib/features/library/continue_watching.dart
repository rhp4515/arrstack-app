/// Pure logic backing the Library "Continue watching" row (spec 2d):
/// which shows qualify, and how to caption the nearest episode. Kept
/// dependency-free so it's testable without Riverpod or a widget tree.
library;

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class ContinueWatchingEntry {
  const ContinueWatchingEntry({
    required this.series,
    required this.caption,
    required this.referenceDate,
  });

  final SonarrSeries series;
  final String caption;
  final DateTime referenceDate;
}

/// True for a series with some but not all episodes downloaded — the
/// "actively watching" state this row surfaces.
bool hasPartialProgress(SonarrSeries series) {
  final stats = series.statistics;
  final have = stats?.episodeFileCount ?? 0;
  final total = stats?.totalEpisodeCount ?? 0;
  return total > 0 && have > 0 && have < total;
}

/// "9 PM" (later today), "today" (already aired today), "tomorrow",
/// "next Friday" (2-6 days out), or a relative "aired Nd ago" label for
/// the past. [episodeDate] and [now] are both local time.
String continueWatchingCaption(DateTime episodeDate, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final entryDay = DateTime(
    episodeDate.year,
    episodeDate.month,
    episodeDate.day,
  );
  final dayDiff = entryDay.difference(today).inDays;

  if (dayDiff == 0) {
    if (episodeDate.isAfter(now)) return _hourLabel(episodeDate);
    return 'today';
  }
  if (dayDiff == 1) return 'tomorrow';
  if (dayDiff > 1 && dayDiff <= 6) {
    return 'next ${_weekdayNames[entryDay.weekday - 1]}';
  }
  if (dayDiff < 0) {
    final agoDays = -dayDiff;
    return agoDays == 1 ? 'aired yesterday' : 'aired ${agoDays}d ago';
  }
  return 'in ${dayDiff}d';
}

String _hourLabel(DateTime date) {
  final isPm = date.hour >= 12;
  var hour = date.hour % 12;
  if (hour == 0) hour = 12;
  return '$hour ${isPm ? 'PM' : 'AM'}';
}

/// Picks the calendar entry closest to [now] for one series: the nearest
/// future airing if any exists, else the most recent past one. Returns
/// null when [episodes] is empty (series has nothing in the window).
SonarrCalendarEpisode? nearestEpisode(
  List<SonarrCalendarEpisode> episodes,
  DateTime now,
) {
  if (episodes.isEmpty) return null;

  SonarrCalendarEpisode? bestFuture;
  SonarrCalendarEpisode? bestPast;
  for (final ep in episodes) {
    final date = ep.airDateUtc?.toLocal();
    if (date == null) continue;
    if (date.isAfter(now)) {
      if (bestFuture == null ||
          date.isBefore(bestFuture.airDateUtc!.toLocal())) {
        bestFuture = ep;
      }
    } else {
      if (bestPast == null || date.isAfter(bestPast.airDateUtc!.toLocal())) {
        bestPast = ep;
      }
    }
  }
  return bestFuture ?? bestPast;
}

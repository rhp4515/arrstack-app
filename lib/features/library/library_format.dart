/// Pure display helpers for the Library's Queue and History sub-tabs:
/// history event labels, history dates and queue time-left/progress.
///
/// The app doesn't depend on `intl`, so dates are formatted by hand (the
/// clock part reuses the Calendar feature's formatter).
library;

import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';

/// A human label for a Radarr/Sonarr history `eventType`, e.g.
/// `downloadFolderImported` → "Imported from download folder". Unknown
/// types are prettified ("seriesFolderImported" → "Series folder
/// imported") rather than shown raw.
String historyEventLabel(String eventType) => switch (eventType) {
  'grabbed' => 'Grabbed release',
  'downloadFolderImported' => 'Imported from download folder',
  'downloadFailed' => 'Download failed',
  'movieFileDeleted' || 'episodeFileDeleted' => 'File deleted',
  'movieFileRenamed' || 'episodeFileRenamed' => 'File renamed',
  'downloadIgnored' => 'Download ignored',
  _ => prettifyIdentifier(eventType),
};

/// Whether a history `eventType` is a failure, for tinting its label.
bool isFailureEvent(String eventType) => eventType == 'downloadFailed';

/// "downloadFolderImported" → "Download folder imported";
/// "some_value" → "Some value". Empty input → "Unknown event".
String prettifyIdentifier(String raw) {
  final spaced = raw
      .replaceAll(RegExp('[_-]+'), ' ')
      .replaceAllMapped(RegExp('([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .trim()
      .toLowerCase();
  if (spaced.isEmpty) return 'Unknown event';
  return spaced[0].toUpperCase() + spaced.substring(1);
}

const List<String> _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// "September 20 at 8:45 AM" in local time; the year is added when it isn't
/// [now]'s year ("September 20, 2025 at 8:45 AM").
String formatHistoryDate(DateTime date, {DateTime? now}) {
  final local = date.toLocal();
  final reference = now ?? DateTime.now();
  final month = _months[local.month - 1];
  final year = local.year == reference.year ? '' : ', ${local.year}';
  return '$month ${local.day}$year at ${formatClockTime(local)}';
}

/// Sonarr/Radarr queue `timeleft` ("00:20:31", "1.02:03:04") as a short
/// label: "20m left", "1d 2h left", "under a minute left". Null when absent
/// or unparseable.
String? formatTimeLeft(String? timeleft) {
  if (timeleft == null || timeleft.isEmpty) return null;
  final match = RegExp(r'^(?:(\d+)\.)?(\d+):(\d{2}):(\d{2})')
      .firstMatch(timeleft);
  if (match == null) return null;
  final days = int.parse(match[1] ?? '0');
  final hours = int.parse(match[2]!);
  final minutes = int.parse(match[3]!);
  final totalHours = days * 24 + hours;
  if (totalHours >= 24) {
    final d = totalHours ~/ 24;
    final h = totalHours % 24;
    return h == 0 ? '${d}d left' : '${d}d ${h}h left';
  }
  if (totalHours > 0) {
    return minutes == 0
        ? '${totalHours}h left'
        : '${totalHours}h ${minutes}m left';
  }
  if (minutes > 0) return '${minutes}m left';
  return 'under a minute left';
}

/// Fraction downloaded (0–1) from a queue item's total and remaining bytes.
double queueProgress(int size, int sizeleft) {
  if (size <= 0) return 0;
  return ((size - sizeleft) / size).clamp(0.0, 1.0);
}

/// "downloading" → "Downloading", "downloadClientUnavailable" → "Download
/// client unavailable". Null/empty → "Queued".
String queueStatusLabel(String? status) {
  if (status == null || status.isEmpty) return 'Queued';
  return prettifyIdentifier(status);
}

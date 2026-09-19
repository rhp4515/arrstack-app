/// Plain value objects for the Activity feature that don't need freezed
/// (no JSON boundary, no nested equality beyond what Dart gives records/
/// simple classes for free) — mirrors `CalendarEntry`'s precedent
/// (`lib/features/calendar/models/calendar_entry.dart`).
library;

import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/foundation.dart';

/// Wanted subtitles aggregated across every configured Bazarr instance,
/// plus whether any instance failed to answer. Kept separate from a bare
/// `Result` because the Wanted lens must show both at once: the single
/// offline error card (2j) *and* whatever subtitles the working instances
/// still returned underneath it.
@immutable
class BazarrWantedAggregate {
  const BazarrWantedAggregate({
    required this.subtitles,
    required this.hasUnreachableInstance,
  });

  final List<BazarrWantedSubtitle> subtitles;
  final bool hasUnreachableInstance;
}

/// One sampled qBittorrent download-speed reading, kept in
/// [TransfersThroughputHistory]'s rolling 60-minute buffer.
@immutable
class ThroughputSample {
  const ThroughputSample({
    required this.timestamp,
    required this.dlSpeedBytesPerSecond,
  });

  final DateTime timestamp;
  final int dlSpeedBytesPerSecond;
}

/// Pure helpers for classifying and describing Uptime Kuma monitors
/// (README §2k): up/down/paused counts and human-readable down/paused
/// durations. Kept free of Flutter imports so they're unit-testable without
/// pumping widgets.
library;

import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';

bool isMonitorUp(KumaMonitor monitor) => monitor.active && monitor.status == 1;

bool isMonitorDown(KumaMonitor monitor) =>
    monitor.active && monitor.status == 0;

bool isMonitorPaused(KumaMonitor monitor) => !monitor.active;

/// A human-readable label for an active monitor whose status is neither
/// up (1) nor down (0) — i.e. Kuma's "Pending" (2) or "Maintenance" (3)
/// states. These monitors are still active/configured, so they must not
/// silently disappear from the page (README §2k final-review finding 6).
String statusLabel(KumaMonitor monitor) => switch (monitor.status) {
  2 => 'Pending',
  3 => 'Maintenance',
  _ => 'Unknown',
};

/// How long [monitor] has been down, as a compact string ("38m", "2h", "3d"),
/// or "just now" if the down-transition can't be determined from the
/// (newest-first) heartbeat history.
String downDurationLabel(KumaMonitor monitor, {DateTime? now}) {
  final heartbeats = monitor.heartbeats;
  if (heartbeats.isEmpty || heartbeats.first.status != 0) return 'just now';

  var last = heartbeats.first;
  for (final hb in heartbeats) {
    if (hb.status != 0) break;
    last = hb;
  }
  final reference = now ?? DateTime.now();
  return FormatUtils.formatReleaseAge(
    reference.difference(last.time).inMinutes,
  );
}

/// How long [monitor] has been paused, as "paused {duration}", or just
/// "paused" if there's no heartbeat history to measure from.
String pausedDurationLabel(KumaMonitor monitor, {DateTime? now}) {
  if (monitor.heartbeats.isEmpty) return 'paused';
  final reference = now ?? DateTime.now();
  final minutes = reference.difference(monitor.heartbeats.first.time).inMinutes;
  return 'paused ${FormatUtils.formatReleaseAge(minutes)}';
}

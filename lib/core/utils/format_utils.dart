/// Utility functions for formatting data (sizes, speeds, etc.).
library;

import 'dart:math';

abstract final class FormatUtils {
  /// Formats bytes into a human-readable string (e.g. 1.2 GB).
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Formats bits per second into a human-readable speed (e.g. 5.4 MB/s).
  static String formatSpeed(int bytesPerSecond, {int decimals = 1}) {
    return '${formatBytes(bytesPerSecond, decimals: decimals)}/s';
  }

  /// Formats a qBittorrent ETA (seconds) into "∞" for the sentinel value
  /// (8640000 = 100 days) or a compact "2h 5m" / "5m" / "30s" string.
  static String formatEta(int seconds) {
    if (seconds <= 0 || seconds >= 8640000) return '∞';
    final d = seconds ~/ 86400;
    final h = (seconds % 86400) ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (d > 0) return '${d}d ${h}h';
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  /// Extracts a bare host from a tracker URL (e.g.
  /// "https://open.demonii.com:443/announce" → "open.demonii.com").
  static String? trackerHost(String? tracker) {
    if (tracker == null || tracker.isEmpty) return null;
    final host = Uri.tryParse(tracker)?.host;
    return (host == null || host.isEmpty) ? null : host;
  }
}

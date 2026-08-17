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
}

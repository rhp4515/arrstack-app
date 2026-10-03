/// One line of the on-device diagnostic log (Settings → Advanced →
/// Diagnostic logs). Messages are redacted before they are stored, so an
/// entry is always safe to display or share.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_entry.freezed.dart';
part 'log_entry.g.dart';

enum LogLevel {
  info,
  warn,
  error;

  String get label => name.toUpperCase();
}

@freezed
abstract class LogEntry with _$LogEntry {
  const factory LogEntry({
    required DateTime time,
    required LogLevel level,

    /// Where the entry came from: a service name ("Radarr"), a feature
    /// ("Backup", "Notifications"), or "App" for uncaught errors.
    required String tag,
    required String message,
  }) = _LogEntry;

  factory LogEntry.fromJson(Map<String, dynamic> json) =>
      _$LogEntryFromJson(json);
}

/// Persistence for the diagnostic log: a capped, newest-first list of
/// [LogEntry]s kept in a JSON file in the app's support directory, so it
/// survives restarts and can be read by the background notification worker
/// as well as the UI isolate.
///
/// Those two isolates each hold their own [FileDiagnosticLogStore] over the
/// same file, so the file is the only state they share — see
/// [FileDiagnosticLogStore] for what that rules out.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/logging/log_redaction.dart';
import 'package:json_annotation/json_annotation.dart';

abstract interface class DiagnosticLogStore {
  /// All stored entries, newest first.
  Future<List<LogEntry>> readAll();

  /// Stores [entry] (its message is redacted first), dropping the oldest
  /// entries beyond the cap.
  Future<void> append(LogEntry entry);

  Future<void> clear();

  /// Emits after every [append] or [clear], so an open log page refreshes.
  Stream<void> get changes;
}

/// The default cap: enough history to cover a few days of intermittent
/// failures without the file growing without bound.
const int defaultDiagnosticLogCap = 300;

/// [DiagnosticLogStore] over a single JSON file. Writes are serialized
/// through one queue so concurrent appends can't interleave, and a corrupt
/// file reads as empty rather than breaking the log page.
///
/// The background notification worker runs in its own isolate with its own
/// instance of this class, writing the same file. So nothing is cached:
/// every read and every read-modify-write goes back to disk. An in-memory
/// copy used to be kept, and since it was never refreshed the UI isolate
/// served a stale list forever — background entries never appeared on an
/// open log page, and the UI's next append wrote that stale list back over
/// the file, erasing them.
///
/// Writes land through a temp file and a rename, which is atomic, so a
/// reader in the other isolate sees the old file or the new one, never a
/// half-written one. That matters more than it looks: a truncated read
/// parses as corrupt, reads as empty, and the reader's next append would
/// then save a one-entry log over everything.
///
/// What remains is two isolates appending within the same few milliseconds:
/// both read, both write, and one entry is lost. A cross-isolate lock would
/// close it, but `RandomAccessFile.lock` is per process, not per isolate, so
/// it can't. For a diagnostic log that is an acceptable residue.
class FileDiagnosticLogStore implements DiagnosticLogStore {
  FileDiagnosticLogStore(
    this._file, {
    this.maxEntries = defaultDiagnosticLogCap,
  });

  final Future<File> Function() _file;
  final int maxEntries;

  Future<void> _queue = Future.value();
  final StreamController<void> _changes = StreamController.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<List<LogEntry>> readAll() async {
    await _queue;
    return List.unmodifiable(await _readFile());
  }

  @override
  Future<void> append(LogEntry entry) => _enqueue(() async {
    final current = await _readFile();
    final next = [_redacted(entry), ...current].take(maxEntries).toList();
    await _save(next);
  });

  @override
  Future<void> clear() => _enqueue(() => _save(const []));

  Future<void> _enqueue(Future<void> Function() action) {
    final next = _queue.then((_) => action()).then((_) {
      if (!_changes.isClosed) _changes.add(null);
    });
    // A failed write must not wedge every later one behind it.
    _queue = next.catchError((Object _) {});
    return next;
  }

  Future<List<LogEntry>> _readFile() async {
    try {
      final file = await _file();
      if (!file.existsSync()) return const [];
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is! List) return const [];
      final entries = <LogEntry>[];
      for (final json in decoded.whereType<Map<String, dynamic>>()) {
        try {
          entries.add(LogEntry.fromJson(json));
        } on CheckedFromJsonException {
          continue;
        } on TypeError {
          continue;
        } on ArgumentError {
          continue;
        } on FormatException {
          continue;
        }
      }
      return entries;
    } on FormatException {
      return const [];
    } on FileSystemException {
      return const [];
    }
  }

  Future<void> _save(List<LogEntry> entries) async {
    final file = await _file();
    await file.parent.create(recursive: true);
    // Unique per writer: both isolates share a pid, so the pid alone could
    // collide.
    final temp = File(
      '${file.path}.$pid.${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    try {
      await temp.writeAsString(
        jsonEncode(entries.map((e) => e.toJson()).toList()),
        flush: true,
      );
      await temp.rename(file.path);
    } on Object {
      if (temp.existsSync()) await temp.delete();
      rethrow;
    }
  }
}

/// [entry] as it may be stored. The tag is redacted along with the message:
/// callers pass a user-chosen instance name as the tag, and a user who names
/// an instance after its address ("192.168.1.20 Radarr") would otherwise put
/// that address straight into a log that exists to be shared.
LogEntry _redacted(LogEntry entry) => entry.copyWith(
  tag: redactDiagnosticMessage(entry.tag),
  message: redactDiagnosticMessage(entry.message),
);

/// In-memory [DiagnosticLogStore] for tests and for platforms without a
/// writable support directory.
class InMemoryDiagnosticLogStore implements DiagnosticLogStore {
  InMemoryDiagnosticLogStore({this.maxEntries = defaultDiagnosticLogCap});

  final int maxEntries;
  List<LogEntry> _entries = const [];
  final StreamController<void> _changes = StreamController.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<List<LogEntry>> readAll() async => _entries;

  @override
  Future<void> append(LogEntry entry) async {
    _entries = List.unmodifiable(
      [_redacted(entry), ..._entries].take(maxEntries),
    );
    _changes.add(null);
  }

  @override
  Future<void> clear() async {
    _entries = const [];
    _changes.add(null);
  }
}

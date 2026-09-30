/// Persistence for the diagnostic log: a capped, newest-first list of
/// [LogEntry]s kept in a JSON file in the app's support directory, so it
/// survives restarts and can be read by the background notification worker
/// as well as the UI isolate.
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
class FileDiagnosticLogStore implements DiagnosticLogStore {
  FileDiagnosticLogStore(
    this._file, {
    this.maxEntries = defaultDiagnosticLogCap,
  });

  final Future<File> Function() _file;
  final int maxEntries;

  List<LogEntry>? _cache;
  Future<void> _queue = Future.value();
  final StreamController<void> _changes = StreamController.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  @override
  Future<List<LogEntry>> readAll() async {
    await _queue;
    return List.unmodifiable(await _load());
  }

  @override
  Future<void> append(LogEntry entry) => _enqueue(() async {
    final current = await _load();
    final next = [
      entry.copyWith(message: redactDiagnosticMessage(entry.message)),
      ...current,
    ].take(maxEntries).toList();
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

  Future<List<LogEntry>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;
    final loaded = await _readFile();
    _cache = loaded;
    return loaded;
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
    _cache = List.unmodifiable(entries);
    final file = await _file();
    await file.parent.create(recursive: true);
    await file.writeAsString(
      jsonEncode(entries.map((e) => e.toJson()).toList()),
      flush: true,
    );
  }
}

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
      [
        entry.copyWith(message: redactDiagnosticMessage(entry.message)),
        ..._entries,
      ].take(maxEntries),
    );
    _changes.add(null);
  }

  @override
  Future<void> clear() async {
    _entries = const [];
    _changes.add(null);
  }
}

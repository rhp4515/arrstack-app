/// Riverpod wiring for the diagnostic log.
library;

import 'dart:io';

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/diagnostic_logger.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logging_providers.g.dart';

const String diagnosticLogFileName = 'diagnostic_log.json';

/// The on-disk log file, shared by the UI and the background worker.
Future<File> diagnosticLogFile() async {
  final dir = await getApplicationSupportDirectory();
  return File('${dir.path}/$diagnosticLogFileName');
}

@Riverpod(keepAlive: true)
DiagnosticLogStore diagnosticLogStore(Ref ref) =>
    FileDiagnosticLogStore(diagnosticLogFile);

@Riverpod(keepAlive: true)
DiagnosticLogger diagnosticLogger(Ref ref) =>
    DiagnosticLogger(ref.watch(diagnosticLogStoreProvider));

/// The stored entries, newest first; re-reads whenever the store changes.
@riverpod
Stream<List<LogEntry>> diagnosticLogEntries(Ref ref) async* {
  final store = ref.watch(diagnosticLogStoreProvider);
  yield await store.readAll();
  await for (final _ in store.changes) {
    yield await store.readAll();
  }
}

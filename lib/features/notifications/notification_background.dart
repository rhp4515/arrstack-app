/// The background entry point for the periodic notification check. Runs in
/// its own isolate with no widget tree, so it builds a bare
/// [ProviderContainer] over the same providers the app uses.
library;

import 'dart:ui' show DartPluginRegistrant;

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/diagnostic_logger.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/features/notifications/notification_providers.dart';
import 'package:arrstack/features/notifications/notification_scheduler.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void notificationCallbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != notificationCheckTask) return true;
    return runBackgroundNotificationCheck();
  });
}

/// Always reports success to the scheduler: a failed check is logged and
/// simply tried again at the next interval, rather than retried with
/// backoff against a server that is probably still down.
Future<bool> runBackgroundNotificationCheck() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final logStore = FileDiagnosticLogStore(diagnosticLogFile);
  final logger = DiagnosticLogger(logStore);
  final container = ProviderContainer(
    overrides: [
      diagnosticLogStoreProvider.overrideWithValue(logStore),
      diagnosticLoggerProvider.overrideWithValue(logger),
    ],
  );
  try {
    final posted = await container.read(notificationCheckRunnerProvider)();
    if (posted > 0) {
      logger.info('Notifications', 'Background check posted $posted');
    }
  } on Object catch (error) {
    logger.error(
      'Notifications',
      'Background check failed | ${describeError(error)}',
    );
  } finally {
    // Give queued log writes a moment to land before the isolate ends.
    await logStore.readAll();
    container.dispose();
  }
  return true;
}

/// Called once from `main` so the OS knows which function to run.
Future<void> initializeNotificationBackgroundWork() =>
    Workmanager().initialize(notificationCallbackDispatcher);

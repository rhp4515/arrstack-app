import 'dart:ui' show PlatformDispatcher;

import 'package:arrstack/app/app.dart';
import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/diagnostic_logger.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding, runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Created before the ProviderScope so errors thrown before (or outside)
  // the widget tree still reach Settings → Advanced → Diagnostic logs.
  final logStore = FileDiagnosticLogStore(diagnosticLogFile);
  final logger = DiagnosticLogger(logStore);
  final presentError = FlutterError.onError;
  FlutterError.onError = (details) {
    logger.error('App', describeError(details.exception));
    presentError?.call(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('App', 'Uncaught ${describeError(error)}');
    // Not handled: keep the platform's default reporting too.
    return false;
  };

  runApp(
    ProviderScope(
      overrides: [
        diagnosticLogStoreProvider.overrideWithValue(logStore),
        diagnosticLoggerProvider.overrideWithValue(logger),
      ],
      child: const ArrStackApp(),
    ),
  );
}

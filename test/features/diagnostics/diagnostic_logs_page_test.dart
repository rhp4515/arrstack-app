import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/features/diagnostics/diagnostic_logs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

void main() {
  late InMemoryDiagnosticLogStore store;
  late List<String> shared;

  Future<void> pump(WidgetTester tester) async {
    shared = [];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          diagnosticLogStoreProvider.overrideWithValue(store),
          logTextSharerProvider.overrideWithValue(
            (text) async => shared.add(text),
          ),
        ],
        child: const MaterialApp(home: DiagnosticLogsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() async {
    store = InMemoryDiagnosticLogStore();
  });

  Future<void> seed() async {
    await store.append(
      LogEntry(
        time: DateTime(2026, 8, 17, 23, 27, 42),
        level: LogLevel.warn,
        tag: 'Bazarr',
        message: 'GET api/system/status failed | NetworkError: abort',
      ),
    );
    // Same second, same text: a separate entry, not a duplicate.
    await store.append(
      LogEntry(
        time: DateTime(2026, 8, 17, 23, 27, 42),
        level: LogLevel.warn,
        tag: 'Bazarr',
        message: 'GET api/system/status failed | NetworkError: abort',
      ),
    );
    await store.append(
      LogEntry(
        time: DateTime(2026, 8, 17, 23, 30, 20),
        level: LogLevel.error,
        tag: 'Add service',
        message: 'Radarr local connection test failed',
      ),
    );
  }

  testWidgets('shows an empty state with no entries', (tester) async {
    await pump(tester);
    expect(find.text('No log entries'), findsOneWidget);
  });

  testWidgets('lists entries newest first with level and time', (tester) async {
    await seed();
    await pump(tester);
    expect(find.text('ENTRIES · 3'), findsOneWidget);
    expect(
      find.text('Add service · ERROR · 2026-08-17 23:30:20'),
      findsOneWidget,
    );
    expect(find.text('Bazarr · WARN · 2026-08-17 23:27:42'), findsNWidgets(2));
  });

  testWidgets('long-press selects one entry and shares only it', (
    tester,
  ) async {
    await seed();
    await pump(tester);
    await tester.longPress(find.text('Radarr local connection test failed'));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    expect(find.byIcon(PhosphorIconsFill.checkCircle), findsOneWidget);

    await tester.longPress(find.textContaining('NetworkError').first);
    await tester.pumpAndSettle();
    expect(
      find.text('2 selected'),
      findsOneWidget,
      reason: 'equal-looking entries are selected individually',
    );

    await tester.tap(find.byTooltip('Share selected'));
    await tester.pumpAndSettle();
    expect(shared, hasLength(1));
    expect(shared.single, contains('(2 entries)'));
    expect(shared.single, contains('ERROR Add service'));
    expect(find.text('Diagnostic logs'), findsOneWidget);
  });

  testWidgets('Clear logs asks first, then empties the log', (tester) async {
    await seed();
    await pump(tester);
    await tester.tap(find.byTooltip('Clear logs'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear'));
    await tester.pumpAndSettle();
    expect(await store.readAll(), isEmpty);
    expect(find.text('No log entries'), findsOneWidget);
  });
}

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/features/activity/widgets/logs_lens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

LogEntry _entry(int n, {LogLevel level = LogLevel.info}) => LogEntry(
  time: DateTime(2026, 10, 3, 22, n),
  level: level,
  tag: 'Sonarr',
  message: 'entry number $n',
);

Future<GoRouter> _pump(WidgetTester tester, List<LogEntry> entries) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: LogsLens()),
      ),
      GoRoute(
        path: RoutePaths.logs,
        builder: (_, _) => const Scaffold(body: Text('full logs page')),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        diagnosticLogEntriesProvider.overrideWith(
          (ref) => Stream.value(entries),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

void main() {
  testWidgets('previews only the newest entries and counts problems', (
    tester,
  ) async {
    final entries = [
      _entry(9, level: LogLevel.error),
      _entry(8, level: LogLevel.warn),
      for (var n = 7; n >= 0; n--) _entry(n),
    ];
    await _pump(tester, entries);

    expect(find.text('LATEST · $logsLensPreviewCount OF 10'), findsOneWidget);
    expect(find.text('2 warnings or errors recorded.'), findsOneWidget);
    expect(find.text('entry number 9'), findsOneWidget);
    expect(find.text('entry number 4'), findsOneWidget);
    expect(find.text('entry number 3'), findsNothing);
  });

  testWidgets('says so when nothing has gone wrong', (tester) async {
    await _pump(tester, [_entry(1)]);

    expect(find.text('No warnings or errors recorded.'), findsOneWidget);
  });

  testWidgets('shows an empty state with no entries', (tester) async {
    await _pump(tester, const []);

    expect(find.text('No log entries'), findsOneWidget);
    expect(find.text('Open diagnostic logs'), findsNothing);
  });

  testWidgets('Open diagnostic logs pushes the standalone page and back '
      'returns', (tester) async {
    final router = await _pump(tester, [_entry(1)]);

    await tester.tap(find.text('Open diagnostic logs'));
    await tester.pumpAndSettle();
    expect(find.text('full logs page'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('full logs page'), findsNothing);
    expect(find.byType(LogsLens), findsOneWidget);
  });
}

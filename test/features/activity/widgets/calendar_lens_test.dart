import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/widgets/calendar_lens.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry _entry(String title, DateTime date) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: title,
);

void main() {
  testWidgets('shows an empty state when the schedule has no days', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarScheduleProvider.overrideWith((ref) async => const Ok([])),
        ],
        child: const MaterialApp(home: Scaffold(body: CalendarLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing scheduled'), findsOneWidget);
  });

  testWidgets('shows day entries and filters them by search text', (
    tester,
  ) async {
    final today = DateTime.now();
    final days = [
      CalendarDay(
        date: today,
        entries: [_entry('The Bear', today), _entry('Severance', today)],
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarScheduleProvider.overrideWith((ref) async => Ok(days)),
        ],
        child: const MaterialApp(home: Scaffold(body: CalendarLens())),
      ),
    );
    await tester.pump();

    expect(find.text('The Bear'), findsOneWidget);
    expect(find.text('Severance'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bear');
    await tester.pump();

    expect(find.text('The Bear'), findsOneWidget);
    expect(find.text('Severance'), findsNothing);
  });

  testWidgets('shows the error state and a retry button on Err', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarScheduleProvider.overrideWith(
            (ref) async => const Err(NetworkError()),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: CalendarLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Retry'), findsOneWidget);
  });
}

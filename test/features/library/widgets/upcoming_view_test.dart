import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/library/widgets/upcoming_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Future<Result<List<CalendarDay>>> Function() schedule) =>
    ProviderScope(
      overrides: [calendarScheduleProvider.overrideWith((ref) => schedule())],
      child: const MaterialApp(
        home: Scaffold(
          body: LibraryUpcomingView(type: ServiceType.radarr, instanceId: 'r1'),
        ),
      ),
    );

void main() {
  testWidgets('shows a spinner while loading', (tester) async {
    final pending = Completer<Result<List<CalendarDay>>>();
    await tester.pumpWidget(_host(() => pending.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an empty state when nothing is upcoming', (tester) async {
    await tester.pumpWidget(_host(() async => const Ok([])));
    await tester.pump();

    expect(find.text('Nothing upcoming'), findsOneWidget);
  });

  testWidgets('shows the error with Retry', (tester) async {
    await tester.pumpWidget(
      _host(() async => const Err(StorageError(userMessage: 'Disk on fire'))),
    );
    await tester.pump();

    expect(find.text("Couldn't load upcoming releases"), findsOneWidget);
    expect(find.text('Disk on fire'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('lists this instance\'s monitored releases by day', (
    tester,
  ) async {
    final day = DateTime.now().add(const Duration(days: 3));
    CalendarEntry entry(String title, {String instanceId = 'r1'}) =>
        CalendarEntry(
          kind: CalendarEntryKind.movie,
          service: ServiceType.radarr,
          instanceId: instanceId,
          date: DateTime(day.year, day.month, day.day),
          title: title,
          subtitle: 'Digital Release',
          network: 'Legendary',
          allDay: true,
        );
    await tester.pumpWidget(
      _host(
        () async => Ok(
          groupEntriesByDay([
            entry('Dune: Part Three'),
            entry('Elsewhere', instanceId: 'r2'),
          ]),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Dune: Part Three'), findsOneWidget);
    expect(find.text('Digital Release · Legendary'), findsOneWidget);
    expect(find.text('Elsewhere'), findsNothing);
  });
}

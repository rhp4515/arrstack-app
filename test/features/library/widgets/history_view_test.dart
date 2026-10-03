import 'dart:async';

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/history_view.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRadarrRepository extends Mock implements RadarrRepository {}

Widget _host(RadarrRepository repo) => ProviderScope(
  overrides: [radarrRepositoryProvider('r1').overrideWith((ref) async => repo)],
  child: const MaterialApp(
    home: Scaffold(
      body: LibraryHistoryView(type: ServiceType.radarr, instanceId: 'r1'),
    ),
  ),
);

RadarrHistoryRecord _record(int id, {String eventType = 'grabbed'}) =>
    RadarrHistoryRecord(
      id: id,
      eventType: eventType,
      date: DateTime(DateTime.now().year, 9, 20, 8, 45),
      movie: RadarrHistoryMovie(title: 'Movie $id', year: 2021),
      quality: const RadarrQualityInfo(
        quality: RadarrQuality(name: 'Bluray-1080p'),
      ),
    );

HistoryPage<RadarrHistoryRecord> _page(List<RadarrHistoryRecord> records) =>
    HistoryPage(records: records, received: records.length);

void main() {
  late _MockRadarrRepository repo;

  setUp(() => repo = _MockRadarrRepository());

  testWidgets('shows a spinner while loading', (tester) async {
    final pending = Completer<Result<HistoryPage<RadarrHistoryRecord>>>();
    when(() => repo.getHistoryPage(page: 1, pageSize: 50))
        .thenAnswer((_) => pending.future);

    await tester.pumpWidget(_host(repo));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an empty state when there is no history', (tester) async {
    when(() => repo.getHistoryPage(page: 1, pageSize: 50))
        .thenAnswer((_) async => Ok(_page(const [])));

    await tester.pumpWidget(_host(repo));
    await tester.pumpAndSettle();

    expect(find.text('No history yet'), findsOneWidget);
  });

  testWidgets('shows the error with Retry', (tester) async {
    when(
      () => repo.getHistoryPage(page: 1, pageSize: 50),
    ).thenAnswer((_) async => const Err(AuthError(userMessage: 'Bad API key')));

    await tester.pumpWidget(_host(repo));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load history"), findsOneWidget);
    expect(find.text('Bad API key'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows title, event label, date and quality chip', (
    tester,
  ) async {
    when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
      (_) async => Ok(
        _page([_record(1), _record(2, eventType: 'downloadFolderImported')]),
      ),
    );

    await tester.pumpWidget(_host(repo));
    await tester.pumpAndSettle();

    expect(find.text('Movie 1 (2021)'), findsOneWidget);
    expect(find.text('Grabbed release'), findsOneWidget);
    expect(find.text('Imported from download folder'), findsOneWidget);
    expect(find.text('September 20 at 8:45 AM'), findsNWidgets(2));
    expect(find.text('Bluray-1080p'), findsNWidgets(2));
    expect(find.text('Load more'), findsNothing);
    expect(find.text('HISTORY · 2'), findsOneWidget);
    expect(find.text('Radarr'), findsOneWidget);
  });

  testWidgets('quality chip is green normally but neutral on failures', (
    tester,
  ) async {
    when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
      (_) async =>
          Ok(_page([_record(1), _record(2, eventType: 'downloadFailed')])),
    );

    await tester.pumpWidget(_host(repo));
    await tester.pumpAndSettle();

    final chips = tester.widgetList<Text>(find.text('Bluray-1080p')).toList();
    expect(chips, hasLength(2));
    expect(chips[0].style!.color, AppColors.up);
    expect(chips[1].style!.color, AppColors.n500);
  });

  testWidgets('Load more appends the next page', (tester) async {
    when(() => repo.getHistoryPage(page: 1, pageSize: 50)).thenAnswer(
      (_) async => Ok(_page([for (var i = 1; i <= 50; i++) _record(i)])),
    );
    when(() => repo.getHistoryPage(page: 2, pageSize: 50))
        .thenAnswer((_) async => Ok(_page([_record(51)])));

    await tester.pumpWidget(_host(repo));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Load more'), 300);
    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();

    expect(find.text('Load more'), findsNothing);
    await tester.scrollUntilVisible(find.text('Movie 51 (2021)'), 300);
    expect(find.text('Movie 51 (2021)'), findsOneWidget);
  });
}

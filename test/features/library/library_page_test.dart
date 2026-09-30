import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/library/library_page.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/history_view.dart';
import 'package:arrstack/features/library/widgets/library_section_chips.dart';
import 'package:arrstack/features/library/widgets/missing_view.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/features/library/widgets/queue_view.dart';
import 'package:arrstack/features/library/widgets/upcoming_view.dart';
import 'package:arrstack/services/radarr/models/radarr_history.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../support/fixtures.dart';

class _MockRadarrRepository extends Mock implements RadarrRepository {}

class _MoviesTab extends ActiveLibraryTab {
  @override
  LibraryTab build() => LibraryTab.movies;
}

void main() {
  testWidgets('renders the Library title without throwing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LibraryPage())),
    );
    await tester.pump();

    expect(find.text('Library'), findsOneWidget);
    expect(find.byType(LibraryPage), findsOneWidget);
  });

  testWidgets('header fits a 320px phone with a long instance name', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(960, 1920)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith(
            (ref) async => Ok([
              buildInstance(id: 'r1', name: 'A very long Radarr instance name'),
              buildInstance(id: 'r2', name: 'Second'),
            ]),
          ),
          activeLibraryTabProvider.overrideWith(_MoviesTab.new),
          radarrMoviesProvider('r1').overrideWith(
            (ref) async => const Ok([RadarrMovie(id: 1, title: 'Dune')]),
          ),
        ],
        child: const MaterialApp(home: LibraryPage()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('A very long Radarr instance name'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });

  testWidgets('shows the instance name and switches between sub-tabs', (
    tester,
  ) async {
    final repo = _MockRadarrRepository();
    when(() => repo.getHistory(page: 1, pageSize: 50))
        .thenAnswer((_) async => const Ok(<RadarrHistoryRecord>[]));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith(
            (ref) async => Ok([buildInstance(id: 'r1', name: 'Home Radarr')]),
          ),
          activeLibraryTabProvider.overrideWith(_MoviesTab.new),
          radarrMoviesProvider('r1')
              .overrideWith((ref) async => const Ok(<RadarrMovie>[])),
          calendarScheduleProvider.overrideWith((ref) async => const Ok([])),
          radarrQueueProvider('r1')
              .overrideWith((ref) async => const Ok(<RadarrQueueItem>[])),
          radarrRepositoryProvider('r1').overrideWith((ref) async => repo),
        ],
        child: const MaterialApp(home: LibraryPage()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Home Radarr'), findsOneWidget);
    expect(find.byType(LibrarySectionChips), findsOneWidget);
    for (final label in ['All', 'Upcoming', 'Missing', 'Queue', 'History']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byType(MovieList), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(LibraryPage)),
    );
    final expected = {
      'Upcoming': (LibraryUpcomingView, 'Nothing upcoming'),
      'Missing': (LibraryMissingView, 'Nothing missing'),
      'Queue': (LibraryQueueView, 'Queue is empty'),
      'History': (LibraryHistoryView, 'No history yet'),
    };
    for (final MapEntry(key: label, value: (type, empty)) in expected.entries) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(find.byType(type), findsOneWidget, reason: label);
      expect(find.text(empty), findsOneWidget, reason: label);
    }

    await tester.tap(find.text('All'));
    await tester.pump();
    expect(container.read(activeLibrarySectionProvider), LibrarySection.all);
    expect(find.byType(MovieList), findsOneWidget);
  });
}

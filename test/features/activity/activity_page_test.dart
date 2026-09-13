import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/activity_page.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Stands in for the real [SelectedDownloadInstanceId] so tests can supply
/// a fixed value (or null) without going through real instance-loading.
class _FakeSelectedDownloadInstanceId extends SelectedDownloadInstanceId {
  @override
  Future<String?> build() async => null;
}

List<Override> _baseOverrides() => [
  selectedDownloadInstanceIdProvider.overrideWith(
    _FakeSelectedDownloadInstanceId.new,
  ),
  calendarScheduleProvider.overrideWith((ref) async => const Ok([])),
  sonarrMissingEpisodesProvider.overrideWith((ref) async => []),
  bazarrWantedAggregateProvider.overrideWith(
    (ref) async => const BazarrWantedAggregate(
      subtitles: [],
      hasUnreachableInstance: false,
    ),
  ),
];

Widget _wrap({String? initialLens, List<Override> overrides = const []}) =>
    ProviderScope(
      overrides: [..._baseOverrides(), ...overrides],
      child: MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  ActivityPage(initialLens: initialLens),
            ),
            GoRoute(
              path: '/home/settings',
              builder: (context, state) =>
                  const Scaffold(body: Text('settings')),
            ),
          ],
        ),
      ),
    );

void main() {
  testWidgets('defaults to the Transfers lens with an add-torrent action', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(
      find.text('No qBittorrent instance'),
      findsOneWidget,
    ); // Transfers empty state
    expect(find.byTooltip('Add torrent'), findsOneWidget);
  });

  testWidgets('seeds the lens from initialLens', (tester) async {
    await tester.pumpWidget(_wrap(initialLens: 'wanted'));
    await tester.pump();

    expect(find.text('Search all'), findsOneWidget); // Wanted's trailing action
    expect(find.text('Nothing wanted'), findsOneWidget);
  });

  testWidgets(
    'tapping the Calendar chip switches lenses and hides the transfers action',
    (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.text('Calendar'));
      await tester.pump();
      await tester.pump();

      expect(find.byTooltip('Add torrent'), findsNothing);
      expect(find.text('Nothing scheduled'), findsOneWidget);
    },
  );
}

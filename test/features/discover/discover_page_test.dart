import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/discover/discover_page.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const instanceId = 'seerr-1';

class _FakeSelectedInstance extends SelectedSeerrInstanceId {
  @override
  Future<String?> build() async => instanceId;
}

// `trending` is a parameter (rather than always overriding to `const Ok([])`
// and letting the "In library" badge test spread this list plus a second,
// separate override for `seerrTrendingProvider(instanceId)`) because Riverpod
// rejects two overrides of the same family instance within one
// `ProviderScope` ("Tried to override a provider twice within the same
// container") — the spread-plus-append pattern throws at pump time.
List<Override> _emptyDiscoverOverrides({
  List<SeerrResult> trending = const [],
}) => [
  hasSeerrInstanceProvider.overrideWith((ref) async => true),
  selectedSeerrInstanceIdProvider.overrideWith(() => _FakeSelectedInstance()),
  instancesProvider.overrideWith((ref) async => const Ok(<ServiceInstance>[])),
  seerrMovieGenresProvider(instanceId)
      .overrideWith((ref) async => const Ok([])),
  seerrTvGenresProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrTrendingProvider(instanceId).overrideWith((ref) async => Ok(trending)),
  seerrDiscoverMoviesProvider(instanceId)
      .overrideWith((ref) async => const Ok([])),
  seerrUpcomingMoviesProvider(instanceId)
      .overrideWith((ref) async => const Ok([])),
  seerrDiscoverTvProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrUpcomingTvProvider(instanceId).overrideWith((ref) async => const Ok([])),
];

void main() {
  testWidgets('shows the SEERR kicker, Discover title, and a search field', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _emptyDiscoverOverrides(),
        child: const MaterialApp(home: DiscoverPage(instanceId: instanceId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SEERR'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Search movies and TV'), findsOneWidget);
  });

  testWidgets('the receipt button navigates to Requests', (tester) async {
    final router = GoRouter(
      initialLocation: '/discover',
      routes: [
        GoRoute(
          path: '/discover',
          builder: (context, state) =>
              const DiscoverPage(instanceId: instanceId),
        ),
        GoRoute(
          path: RoutePaths.homeRequests,
          builder: (context, state) =>
              const Scaffold(body: Text('Requests screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: _emptyDiscoverOverrides(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Requests'));
    await tester.pumpAndSettle();

    expect(find.text('Requests screen'), findsOneWidget);
  });

  testWidgets(
    'a trending item already in the library shows an "In library" badge',
    (tester) async {
      final trending = [
        const SeerrResult(
          id: 1,
          title: 'Sinners',
          mediaInfo: SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: _emptyDiscoverOverrides(trending: trending),
          child: const MaterialApp(home: DiscoverPage(instanceId: instanceId)),
        ),
      );
      // Bounded pumps rather than pumpAndSettle: the poster's CachedNetworkImage
      // never resolves in the test environment (no real network), so its
      // placeholder's indeterminate CircularProgressIndicator keeps scheduling
      // frames forever and pumpAndSettle would spin until its timeout. The
      // badge renders independently of image-load state, so a couple of pumps
      // (to let the async provider overrides resolve) is enough.
      await tester.pump();
      await tester.pump();

      expect(find.text('In library'), findsOneWidget);
    },
  );
}

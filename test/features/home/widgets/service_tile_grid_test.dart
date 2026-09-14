// ServiceTileGrid's Bazarr tile must select the Wanted lens and navigate
// to /activity (not the old /activity/subtitles/:instanceId route).
// The Sonarr tile must keep navigating to Library unchanged (regression).
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Records the [LibraryTab] the Sonarr tile selects, without depending on
/// the real (autoDispose) async build sequence.
class _SpyActiveLibraryTab extends ActiveLibraryTab {
  LibraryTab? selected;

  @override
  LibraryTab build() => LibraryTab.movies;

  @override
  void select(LibraryTab tab) {
    selected = tab;
    super.select(tab);
  }
}

/// Records the instance id the Sonarr tile selects, without depending on
/// the real (autoDispose) async build sequence.
class _SpySelectedLibraryInstanceId extends SelectedLibraryInstanceId {
  String? selectedId;

  @override
  Future<String?> build(ServiceType type) async => null;

  @override
  void selectInstance(String id) {
    selectedId = id;
    super.selectInstance(id);
  }
}

void main() {
  testWidgets(
    'tapping the Bazarr tile selects the Wanted lens and navigates to /activity',
    (tester) async {
      late ProviderContainer container;
      String? visitedPath;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [
                HomeServiceSummary(
                  instanceId: 'bazarr-1',
                  instanceName: 'Bazarr',
                  serviceType: ServiceType.bazarr,
                  isReachable: true,
                  summaryLine: '2 wanted subtitles',
                ),
              ],
            ),
          ],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp.router(
                routerConfig: GoRouter(
                  initialLocation: '/',
                  routes: [
                    GoRoute(
                      path: '/',
                      builder: (context, state) =>
                          const Scaffold(body: ServiceTileGrid()),
                    ),
                    GoRoute(
                      path: '/activity',
                      builder: (context, state) {
                        visitedPath = '/activity';
                        return const Scaffold(body: Text('activity'));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      // `activeActivityLensProvider` is autoDispose: without an active
      // listener it would reset to its default between the tap and this
      // assertion (the fake `/activity` route below doesn't watch it, unlike
      // the real ActivityPage). Holding a listener open for the test keeps it
      // alive so we can observe the value the tap actually selected.
      final subscription = container.listen(
        activeActivityLensProvider,
        (_, _) {},
      );
      addTearDown(subscription.close);

      await tester.tap(find.text('Bazarr'));
      await tester.pumpAndSettle();

      expect(visitedPath, '/activity');
      expect(container.read(activeActivityLensProvider), ActivityLens.wanted);
    },
  );

  testWidgets(
    'tapping the Sonarr tile still selects the TV Shows tab and navigates to /library',
    (tester) async {
      late ProviderContainer container;
      String? visitedPath;
      final fakeTab = _SpyActiveLibraryTab();
      final fakeInstanceId = _SpySelectedLibraryInstanceId();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeLibraryTabProvider.overrideWith(() => fakeTab),
            selectedLibraryInstanceIdProvider(ServiceType.sonarr)
                .overrideWith(() => fakeInstanceId),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [
                HomeServiceSummary(
                  instanceId: 'sonarr-1',
                  instanceName: 'Sonarr',
                  serviceType: ServiceType.sonarr,
                  isReachable: true,
                  summaryLine: '3 series',
                ),
              ],
            ),
          ],
          child: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return MaterialApp.router(
                routerConfig: GoRouter(
                  initialLocation: '/',
                  routes: [
                    GoRoute(
                      path: '/',
                      builder: (context, state) =>
                          const Scaffold(body: ServiceTileGrid()),
                    ),
                    GoRoute(
                      path: '/library',
                      builder: (context, state) {
                        visitedPath = '/library';
                        return const Scaffold(body: Text('library'));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Sonarr'));
      await tester.pumpAndSettle();

      expect(visitedPath, '/library');
      expect(fakeTab.selected, LibraryTab.tvShows);
      expect(fakeInstanceId.selectedId, 'sonarr-1');
      // Repointing Bazarr must not disturb the activity lens for Sonarr taps.
      expect(
        container.read(activeActivityLensProvider),
        ActivityLens.transfers,
      );
    },
  );
}

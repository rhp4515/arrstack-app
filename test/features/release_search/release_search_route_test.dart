// Router wiring: the generated RoutePaths strings must resolve to the
// GoRoute('search') entries in router.dart. If the two ever diverge, driving
// appRouter to a release-search path stops rendering ReleaseSearchPage and
// these tests fail (every other test still passes).

import 'package:arrstack/app/app.dart';
import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/router.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_page.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/storage/fakes.dart';

class _FakeSsidSource implements SsidSource {
  @override
  Future<String?> currentSsid() async => 'Home-WiFi';

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<PermissionStatus> permissionStatus() async => PermissionStatus.granted;
}

Widget _app() => ProviderScope(
  overrides: [
    configStoreProvider.overrideWithValue(FakeConfigStore()),
    secureStoreProvider.overrideWithValue(FakeSecureStore()),
    ssidSourceProvider.overrideWithValue(_FakeSsidSource()),
    // Keep the pages beneath the search route out of any loading spinner so
    // pumpAndSettle terminates deterministically.
    radarrMovieProvider(instanceId: 'i1', movieId: 5).overrideWith(
      (ref) async => const Err<RadarrMovie>(UnknownError(userMessage: 'stub')),
    ),
    sonarrEpisodeProvider(
      instanceId: 'i1',
      seriesId: 2,
      episodeId: 5,
    ).overrideWith(
      (ref) async =>
          const Err<SonarrEpisode>(UnknownError(userMessage: 'stub')),
    ),
    releaseSearchResultsProvider(
      service: ServiceType.radarr,
      instanceId: 'i1',
      targetId: 5,
    ).overrideWith((ref) async => const Ok<List<ReleaseCandidate>>([])),
    releaseSearchResultsProvider(
      service: ServiceType.sonarr,
      instanceId: 'i1',
      targetId: 5,
    ).overrideWith((ref) async => const Ok<List<ReleaseCandidate>>([])),
  ],
  child: const ArrStackApp(),
);

void main() {
  testWidgets('movie release-search path renders ReleaseSearchPage', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    appRouter.go(RoutePaths.movieReleaseSearch('i1', 5, 'Dune (2021)'));
    await tester.pumpAndSettle();

    expect(find.byType(ReleaseSearchPage), findsOneWidget);
    expect(find.text('Dune (2021)'), findsOneWidget);
    expect(find.text('No releases found'), findsOneWidget);
  });

  testWidgets('episode release-search path renders ReleaseSearchPage', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    appRouter.go(RoutePaths.episodeReleaseSearch('i1', 2, 5, 'S01E05 · Pilot'));
    await tester.pumpAndSettle();

    expect(find.byType(ReleaseSearchPage), findsOneWidget);
    expect(find.text('S01E05 · Pilot'), findsOneWidget);
    expect(find.text('No releases found'), findsOneWidget);
  });
}

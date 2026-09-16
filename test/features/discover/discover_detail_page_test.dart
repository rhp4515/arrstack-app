import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/discover/discover_detail_page.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

SeerrResult notInLibraryMovie() => const SeerrResult(
  id: 100,
  title: 'Nosferatu',
  mediaType: 'movie',
  voteAverage: 7.1,
);

Widget host(List<Override> overrides) {
  return ProviderScope(
    overrides: [
      seerrDetailProvider(
        instanceId: instanceId,
        id: 100,
        mediaType: 'movie',
      ).overrideWith((ref) async => Ok(notInLibraryMovie())),
      ...overrides,
    ],
    child: const MaterialApp(
      home: DiscoverDetailPage(
        instanceId: instanceId,
        id: 100,
        mediaType: 'movie',
      ),
    ),
  );
}

/// Overrides the radarr services-list provider with a single server at id
/// [id], marked default — the simple single-server case most Seerr setups
/// have.
Override singleDefaultRadarrService(int id) =>
    seerrRadarrServicesProvider(instanceId).overrideWith(
      (ref) async => Ok([SeerrServiceSummary(id: id, isDefault: true)]),
    );

void main() {
  testWidgets(
    'shows the title, a "Not in library" chip, and request fields on success',
    (tester) async {
      await tester.pumpWidget(
        host([
          singleDefaultRadarrService(0),
          seerrRadarrServiceProvider(
            instanceId: instanceId,
            serviceId: 0,
          ).overrideWith(
            (ref) async => const Ok(
              SeerrServiceDetails(
                profiles: [SeerrServiceProfile(id: 6, name: 'HD-1080p')],
                rootFolders: [
                  SeerrServiceRootFolder(
                    path: '/data/media/movies',
                    freeSpace: 2400000000000,
                    totalSpace: 18000000000000,
                  ),
                ],
              ),
            ),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nosferatu'), findsOneWidget);
      expect(find.text('Not in library'), findsOneWidget);
      expect(find.text('HD-1080p'), findsOneWidget);
      expect(find.text('/data/media/movies'), findsOneWidget);
      expect(find.textContaining('free of'), findsOneWidget);
    },
  );

  testWidgets(
    'a failed profile fetch disables Request and shows a visible error, not a silent fallback',
    (tester) async {
      await tester.pumpWidget(
        host([
          singleDefaultRadarrService(0),
          seerrRadarrServiceProvider(
            instanceId: instanceId,
            serviceId: 0,
          ).overrideWith(
            (ref) async =>
                const Err(UnknownError(userMessage: 'Could not reach Seerr')),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Could not reach Seerr'), findsOneWidget);
      final requestButton = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Request'),
      );
      expect(requestButton.onPressed, isNull);
    },
  );

  testWidgets('resolves to the server Seerr marked isDefault, not server 0', (
    tester,
  ) async {
    await tester.pumpWidget(
      host([
        seerrRadarrServicesProvider(instanceId).overrideWith(
          (ref) async => const Ok([
            SeerrServiceSummary(id: 0, isDefault: false),
            SeerrServiceSummary(id: 7, isDefault: true),
          ]),
        ),
        // Server 0 is not the default — if the page still queried it,
        // this Err would surface and the "Ultra-HD" profile below (from
        // server 7, the actual default) would never render.
        seerrRadarrServiceProvider(
          instanceId: instanceId,
          serviceId: 0,
        ).overrideWith(
          (ref) async => const Err(
            UnknownError(userMessage: 'server 0 should not be queried'),
          ),
        ),
        seerrRadarrServiceProvider(
          instanceId: instanceId,
          serviceId: 7,
        ).overrideWith(
          (ref) async => const Ok(
            SeerrServiceDetails(
              profiles: [SeerrServiceProfile(id: 9, name: 'Ultra-HD')],
              rootFolders: [
                SeerrServiceRootFolder(path: '/data/media/movies-4k'),
              ],
            ),
          ),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ultra-HD'), findsOneWidget);
    expect(find.textContaining('server 0 should not be queried'), findsNothing);
  });

  testWidgets('falls back to the first server when none is marked isDefault', (
    tester,
  ) async {
    await tester.pumpWidget(
      host([
        seerrRadarrServicesProvider(instanceId).overrideWith(
          (ref) async => const Ok([
            SeerrServiceSummary(id: 5, isDefault: false),
            SeerrServiceSummary(id: 9, isDefault: false),
          ]),
        ),
        seerrRadarrServiceProvider(
          instanceId: instanceId,
          serviceId: 5,
        ).overrideWith(
          (ref) async => const Ok(
            SeerrServiceDetails(
              profiles: [SeerrServiceProfile(id: 1, name: 'Standard')],
              rootFolders: [SeerrServiceRootFolder(path: '/data/movies')],
            ),
          ),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Standard'), findsOneWidget);
  });

  testWidgets(
    'shows an error and disables Request when Seerr has no configured server',
    (tester) async {
      await tester.pumpWidget(
        host([
          seerrRadarrServicesProvider(instanceId)
              .overrideWith((ref) async => const Ok([])),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error loading profiles'), findsOneWidget);
      final requestButton = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Request'),
      );
      expect(requestButton.onPressed, isNull);
    },
  );

  testWidgets(
    "prefers Seerr's activeProfileId/activeDirectory over the first entry",
    (tester) async {
      await tester.pumpWidget(
        host([
          singleDefaultRadarrService(0),
          seerrRadarrServiceProvider(
            instanceId: instanceId,
            serviceId: 0,
          ).overrideWith(
            (ref) async => const Ok(
              SeerrServiceDetails(
                profiles: [
                  SeerrServiceProfile(id: 6, name: 'HD-1080p'),
                  SeerrServiceProfile(id: 9, name: '4K'),
                ],
                rootFolders: [
                  SeerrServiceRootFolder(path: '/data/media/movies'),
                  SeerrServiceRootFolder(path: '/data/media/movies-4k'),
                ],
                activeProfileId: 9,
                activeDirectory: '/data/media/movies-4k',
              ),
            ),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('4K'), findsOneWidget);
      expect(find.text('/data/media/movies-4k'), findsOneWidget);
    },
  );

  testWidgets(
    "falls back to the first entry when Seerr's active profile/folder "
    'is not actually in the returned lists',
    (tester) async {
      await tester.pumpWidget(
        host([
          singleDefaultRadarrService(0),
          seerrRadarrServiceProvider(
            instanceId: instanceId,
            serviceId: 0,
          ).overrideWith(
            (ref) async => const Ok(
              SeerrServiceDetails(
                profiles: [
                  SeerrServiceProfile(id: 6, name: 'HD-1080p'),
                  SeerrServiceProfile(id: 9, name: '4K'),
                ],
                rootFolders: [
                  SeerrServiceRootFolder(path: '/data/media/movies'),
                ],
                // Neither value appears in the lists above — Seerr claiming
                // an active default that isn't actually offered.
                activeProfileId: 999,
                activeDirectory: '/data/media/does-not-exist',
              ),
            ),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('HD-1080p'), findsOneWidget);
      expect(find.text('/data/media/movies'), findsOneWidget);
    },
  );
}

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

void main() {
  testWidgets(
    'shows the title, a "Not in library" chip, and request fields on success',
    (tester) async {
      await tester.pumpWidget(
        host([
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
}

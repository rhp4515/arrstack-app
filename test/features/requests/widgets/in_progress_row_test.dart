import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/requests/widgets/in_progress_row.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

Widget host(SeerrRequest request) {
  return ProviderScope(
    overrides: [
      seerrDetailProvider(
        instanceId: instanceId,
        id: 200,
        mediaType: 'tv',
      ).overrideWith(
        (ref) async => const Ok(SeerrResult(id: 200, name: 'Andor')),
      ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: InProgressRow(instanceId: instanceId, request: request),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'a processing movie shows "searching indexers" and a Processing tag',
    (tester) async {
      const request = SeerrRequest(
        id: 1,
        status: SeerrRequestStatus.approved,
        media: SeerrRequestMedia(
          id: 200,
          tmdbId: 200,
          mediaType: 'tv',
          status: SeerrMediaStatus.processing,
        ),
        requestedBy: SeerrRequestUser(displayName: 'harivin'),
      );

      await tester.pumpWidget(host(request));
      await tester.pumpAndSettle();

      expect(find.text('Andor'), findsOneWidget);
      expect(find.textContaining('searching indexers'), findsOneWidget);
      expect(find.text('Processing'), findsOneWidget);
    },
  );

  testWidgets(
    'a partially available series shows the season list and a Partial tag',
    (tester) async {
      const request = SeerrRequest(
        id: 1,
        status: SeerrRequestStatus.approved,
        media: SeerrRequestMedia(
          id: 200,
          tmdbId: 200,
          mediaType: 'tv',
          status: SeerrMediaStatus.partiallyAvailable,
        ),
        requestedBy: SeerrRequestUser(displayName: 'devon'),
        seasons: [
          SeerrRequestSeason(id: 1, seasonNumber: 1),
          SeerrRequestSeason(id: 2, seasonNumber: 2),
        ],
      );

      await tester.pumpWidget(host(request));
      await tester.pumpAndSettle();

      expect(find.textContaining('seasons 1, 2'), findsOneWidget);
      expect(find.text('Partial'), findsOneWidget);
    },
  );
}

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/requests/widgets/in_progress_row.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

class _FakeRepository extends SeerrRepository {
  _FakeRepository({this.deleteError}) : super(SeerrClient(Dio()));

  final AppError? deleteError;
  int deleteCalls = 0;

  @override
  Future<Result<void>> deleteRequest(int requestId) async {
    deleteCalls++;
    final error = deleteError;
    if (error != null) return Err(error);
    return const Ok(null);
  }
}

Widget host(
  SeerrRequest request, {
  SeerrRepository? repository,
  VoidCallback? onDeleted,
}) {
  return ProviderScope(
    overrides: [
      seerrDetailProvider(
        instanceId: instanceId,
        id: 200,
        mediaType: 'tv',
      ).overrideWith(
        (ref) async => const Ok(SeerrResult(id: 200, name: 'Andor')),
      ),
      if (repository != null)
        seerrRepositoryProvider(instanceId)
            .overrideWith((ref) async => repository),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: InProgressRow(
          instanceId: instanceId,
          request: request,
          onDeleted: onDeleted ?? () {},
        ),
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

  testWidgets(
    'an available series shows "available", not "searching indexers", '
    'next to the Available tag',
    (tester) async {
      const request = SeerrRequest(
        id: 1,
        status: SeerrRequestStatus.approved,
        media: SeerrRequestMedia(
          id: 200,
          tmdbId: 200,
          mediaType: 'tv',
          status: SeerrMediaStatus.available,
        ),
        requestedBy: SeerrRequestUser(displayName: 'harivin'),
      );

      await tester.pumpWidget(host(request));
      await tester.pumpAndSettle();

      expect(find.textContaining('available'), findsOneWidget);
      expect(find.textContaining('searching indexers'), findsNothing);
      expect(find.text('Available'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping delete, then confirming, calls deleteRequest and notifies onDeleted',
    (tester) async {
      const request = SeerrRequest(
        id: 1,
        status: SeerrRequestStatus.approved,
        media: SeerrRequestMedia(
          id: 200,
          tmdbId: 200,
          mediaType: 'tv',
          status: SeerrMediaStatus.available,
        ),
        requestedBy: SeerrRequestUser(displayName: 'harivin'),
      );
      final repo = _FakeRepository();
      var deleted = false;

      await tester.pumpWidget(
        host(request, repository: repo, onDeleted: () => deleted = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Delete request'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(repo.deleteCalls, 1);
      expect(deleted, isTrue);
    },
  );

  testWidgets('cancelling the delete dialog does not call deleteRequest', (
    tester,
  ) async {
    const request = SeerrRequest(
      id: 1,
      status: SeerrRequestStatus.approved,
      media: SeerrRequestMedia(
        id: 200,
        tmdbId: 200,
        mediaType: 'tv',
        status: SeerrMediaStatus.available,
      ),
      requestedBy: SeerrRequestUser(displayName: 'harivin'),
    );
    final repo = _FakeRepository();

    await tester.pumpWidget(host(request, repository: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete request'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(repo.deleteCalls, 0);
  });

  testWidgets('a failed delete shows an error and re-enables the button', (
    tester,
  ) async {
    const request = SeerrRequest(
      id: 1,
      status: SeerrRequestStatus.approved,
      media: SeerrRequestMedia(
        id: 200,
        tmdbId: 200,
        mediaType: 'tv',
        status: SeerrMediaStatus.available,
      ),
      requestedBy: SeerrRequestUser(displayName: 'harivin'),
    );
    final repo = _FakeRepository(
      deleteError: const UnknownError(userMessage: 'boom'),
    );

    await tester.pumpWidget(host(request, repository: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete request'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.textContaining('boom'), findsOneWidget);
    final deleteButton = tester.widget<IconButton>(find.byType(IconButton));
    expect(deleteButton.onPressed, isNotNull);
  });
}

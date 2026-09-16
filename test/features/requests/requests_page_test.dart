import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/requests/requests_page.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

SeerrRequest req({
  required int id,
  required int status,
  int mediaStatus = SeerrMediaStatus.unknown,
}) => SeerrRequest(
  id: id,
  status: status,
  media: SeerrRequestMedia(id: id, status: mediaStatus),
);

class _FakeSelectedInstance extends SelectedSeerrInstanceId {
  @override
  Future<String?> build() async => instanceId;
}

Widget host(
  List<SeerrRequest> requests, {
  RequestsFilter filter = RequestsFilter.all,
}) {
  return ProviderScope(
    overrides: [
      selectedSeerrInstanceIdProvider.overrideWith(_FakeSelectedInstance.new),
      seerrAllRequestsProvider(instanceId)
          .overrideWith((ref) async => Ok(requests)),
    ],
    child: MaterialApp(home: RequestsPage(initialFilter: filter)),
  );
}

void main() {
  testWidgets('shows the pending/processing/available stat counts', (
    tester,
  ) async {
    final requests = [
      req(id: 1, status: SeerrRequestStatus.pending),
      req(
        id: 2,
        status: SeerrRequestStatus.approved,
        mediaStatus: SeerrMediaStatus.processing,
      ),
      req(
        id: 3,
        status: SeerrRequestStatus.completed,
        mediaStatus: SeerrMediaStatus.available,
      ),
    ];
    await tester.pumpWidget(host(requests));
    await tester.pumpAndSettle();

    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('PROCESSING'), findsOneWidget);
    expect(find.text('AVAILABLE'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(3));
  });

  testWidgets('a pending request renders under "NEEDS A DECISION"', (
    tester,
  ) async {
    await tester.pumpWidget(
      host([req(id: 1, status: SeerrRequestStatus.pending)]),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('NEEDS A DECISION'), findsOneWidget);
  });

  testWidgets('an in-progress request renders under "IN PROGRESS"', (
    tester,
  ) async {
    final requests = [
      req(
        id: 1,
        status: SeerrRequestStatus.approved,
        mediaStatus: SeerrMediaStatus.processing,
      ),
    ];
    await tester.pumpWidget(host(requests));
    await tester.pumpAndSettle();

    expect(find.textContaining('IN PROGRESS'), findsOneWidget);
  });

  testWidgets('a failed fetch shows a distinct error, not an empty list', (
    tester,
  ) async {
    final scope = ProviderScope(
      overrides: [
        selectedSeerrInstanceIdProvider.overrideWith(_FakeSelectedInstance.new),
        seerrAllRequestsProvider(instanceId).overrideWith(
          (ref) async =>
              const Err(UnknownError(userMessage: 'Could not reach Seerr')),
        ),
      ],
      child: const MaterialApp(home: RequestsPage()),
    );
    await tester.pumpWidget(scope);
    await tester.pumpAndSettle();

    expect(find.text('Could not reach Seerr'), findsOneWidget);
    expect(find.text('No requests'), findsNothing);
  });

  testWidgets(
    'lazily builds request rows: a far-down request\'s detail provider is '
    'never watched while only the top of a long list is on screen',
    (tester) async {
      const farDownId = 999;
      const farDownTmdbId = 4242;
      var farDownProviderWatched = false;

      final requests = [
        for (var i = 1; i <= 30; i++)
          req(id: i, status: SeerrRequestStatus.pending),
        const SeerrRequest(
          id: farDownId,
          status: SeerrRequestStatus.pending,
          media: SeerrRequestMedia(
            id: farDownId,
            tmdbId: farDownTmdbId,
            mediaType: 'movie',
          ),
        ),
      ];

      final scope = ProviderScope(
        overrides: [
          selectedSeerrInstanceIdProvider.overrideWith(
            _FakeSelectedInstance.new,
          ),
          seerrAllRequestsProvider(instanceId)
              .overrideWith((ref) async => Ok(requests)),
          // If SliverList ever stops being lazy (e.g. reverts to a plain
          // ListView(children: [...])), this far-down request's card would
          // be built immediately, this provider would be watched, and the
          // flag below would flip to true even though the item never
          // scrolled into view.
          seerrDetailProvider(
            instanceId: instanceId,
            id: farDownTmdbId,
            mediaType: 'movie',
          ).overrideWith((ref) async {
            farDownProviderWatched = true;
            return const Err(
              UnknownError(
                userMessage: 'far-down request should not be queried',
              ),
            );
          }),
        ],
        child: const MaterialApp(home: RequestsPage()),
      );

      await tester.pumpWidget(scope);
      await tester.pumpAndSettle();

      expect(
        farDownProviderWatched,
        isFalse,
        reason:
            'the 31st pending request is far below the fold; its detail '
            'provider must not be watched until it scrolls into view',
      );

      // Structural check: the pending-request list is built by a lazy
      // delegate, not a fixed-children container.
      expect(find.byType(ListView), findsNothing);
      final slivers = tester.widgetList<SliverList>(find.byType(SliverList));
      expect(slivers, isNotEmpty);
      expect(
        slivers.every((s) => s.delegate is SliverChildBuilderDelegate),
        isTrue,
      );
    },
  );
}

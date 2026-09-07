// The page: a long "searching all indexers" wait, then a sorted list; the
// segmented control re-sorts in place; tapping a row opens the detail sheet.

import 'dart:async';

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_page.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate rc(String guid, {int? seeders, int size = 0}) =>
    ReleaseCandidate(
      guid: guid,
      indexerId: 1,
      indexerName: 'ix',
      title: guid,
      sizeBytes: size,
      protocol: ReleaseProtocol.torrent,
      qualityLabel: 'q',
      qualityWeight: 0,
      ageMinutes: 0,
      isRejected: false,
      rejections: const [],
      downloadAllowed: true,
      seeders: seeders,
    );

Widget _host(Object dataOrFuture) => ProviderScope(
  overrides: [
    if (dataOrFuture is Result<List<ReleaseCandidate>>)
      releaseSearchResultsProvider(
        service: ServiceType.sonarr,
        instanceId: 'i1',
        targetId: 5,
      ).overrideWith((ref) async => dataOrFuture)
    else
      releaseSearchResultsProvider(
        service: ServiceType.sonarr,
        instanceId: 'i1',
        targetId: 5,
      ).overrideWith(
        (ref) => dataOrFuture as Future<Result<List<ReleaseCandidate>>>,
      ),
  ],
  child: const MaterialApp(
    home: ReleaseSearchPage(
      service: ServiceType.sonarr,
      instanceId: 'i1',
      targetId: 5,
      title: 'S01E01',
    ),
  ),
);

void main() {
  testWidgets('shows the long-search hint while loading', (tester) async {
    final never = Completer<Result<List<ReleaseCandidate>>>().future;
    await tester.pumpWidget(_host(never));
    await tester.pump();
    expect(find.textContaining('Searching all indexers'), findsOneWidget);
  });

  testWidgets('renders results sorted by peers by default', (tester) async {
    await tester.pumpWidget(
      _host(
        Ok<List<ReleaseCandidate>>([
          rc('low', seeders: 2),
          rc('high', seeders: 99),
        ]),
      ),
    );
    await tester.pumpAndSettle();

    final tiles = tester
        .widgetList<ReleaseTile>(find.byType(ReleaseTile))
        .toList();
    expect(tiles.first.release.guid, 'high');
    expect(tiles.last.release.guid, 'low');
  });

  testWidgets('switching sort to Size re-orders the list', (tester) async {
    await tester.pumpWidget(
      _host(
        Ok<List<ReleaseCandidate>>([
          rc('big', seeders: 1, size: 900),
          rc('small', seeders: 1, size: 10),
        ]),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Size'));
    await tester.pumpAndSettle();

    final tiles = tester
        .widgetList<ReleaseTile>(find.byType(ReleaseTile))
        .toList();
    expect(tiles.first.release.guid, 'small');
  });

  testWidgets('error result shows an EmptyState with retry', (tester) async {
    await tester.pumpWidget(
      _host(
        const Err<List<ReleaseCandidate>>(
          UnknownError(userMessage: 'search failed'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('search failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('empty result shows "No releases found"', (tester) async {
    await tester.pumpWidget(_host(const Ok<List<ReleaseCandidate>>([])));
    await tester.pumpAndSettle();
    expect(find.text('No releases found'), findsOneWidget);
  });

  testWidgets('tapping a row opens the detail sheet', (tester) async {
    await tester.pumpWidget(
      _host(Ok<List<ReleaseCandidate>>([rc('one', seeders: 5)])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ReleaseTile).first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
  });
}

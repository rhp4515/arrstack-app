// Seerr title lookups must fit inside the per-source time budget.
//
// Every request and issue carries only a TMDB id, so its title costs a
// lookup. Up to forty used to run one after another inside the checker's
// 20s per-source timeout; on a slow proxy that ran out, and a timed-out
// check never advances its checkpoint, so every later run met the same
// items and timed out again — Seerr notifications stopped for good.

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/features/notifications/sources/seerr_activity_source.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Twenty new requests and twenty new issues, with lookups that are
/// counted and can be made to hang.
class _FakeSeerr extends SeerrRepository {
  _FakeSeerr({this.hang = const {}}) : super(SeerrClient(Dio()));

  /// TMDB ids whose lookup never completes.
  final Set<int> hang;
  final List<int> looked = [];
  int inFlight = 0;
  int maxInFlight = 0;

  @override
  Future<Result<SeerrRequestsResponse>> getRequests({
    String filter = 'all',
    String sort = 'added',
    int take = 20,
    int skip = 0,
  }) async => Ok(
    SeerrRequestsResponse(
      pageInfo: const SeerrPageInfo(),
      results: [
        for (var id = 120; id > 100; id--)
          SeerrRequest(
            id: id,
            media: SeerrRequestMedia(id: id, tmdbId: id),
          ),
      ],
    ),
  );

  @override
  Future<Result<SeerrIssuesResponse>> getIssues({
    String filter = 'all',
    int take = 20,
    int skip = 0,
  }) async => Ok(
    SeerrIssuesResponse(
      pageInfo: const SeerrPageInfo(),
      results: [
        for (var id = 60; id > 40; id--)
          SeerrIssue(
            id: id,
            media: SeerrRequestMedia(id: id, tmdbId: 1000 + id),
          ),
      ],
    ),
  );

  @override
  Future<Result<SeerrResult>> getMovieDetail(int id) async {
    looked.add(id);
    inFlight++;
    if (inFlight > maxInFlight) maxInFlight = inFlight;
    try {
      if (hang.contains(id)) await Completer<void>().future;
      // Yield so overlapping lookups can be observed.
      await Future<void>.delayed(Duration.zero);
      return Ok(SeerrResult(id: id, title: 'Film $id'));
    } finally {
      inFlight--;
    }
  }
}

/// Everything before these ids counts as already seen.
const _checkpoint = 'r:100;i:40';

void main() {
  SeerrActivitySource source(_FakeSeerr repo) => SeerrActivitySource(
    instanceId: 'o1',
    instanceName: 'Seerr',
    repository: repo,
    titleLookupTimeout: const Duration(milliseconds: 50),
  );

  test('looks up only the titles that will be shown — at most '
      '$maxIndividualNotifications, not one per item', () async {
    final repo = _FakeSeerr();

    final result = await source(repo).check(_checkpoint);

    final items = (result as Ok<SourceCheck>).value.items;
    expect(items, hasLength(40), reason: 'every new item is still reported');
    expect(repo.looked, hasLength(maxIndividualNotifications));
    // The shown ones are named; the rest keep their fallback.
    expect(items.take(3).map((i) => i.title), [
      'Film 120',
      'Film 119',
      'Film 118',
    ]);
    expect(items[3].title, 'Request #117');
    expect(items.last.title, 'Issue #41');
  });

  test('runs those lookups together rather than one after another', () async {
    final repo = _FakeSeerr();

    await source(repo).check(_checkpoint);

    expect(repo.maxInFlight, maxIndividualNotifications);
  });

  test('a hung lookup falls back to its placeholder instead of holding '
      'the whole check past its budget', () async {
    final repo = _FakeSeerr(hang: {119});

    final result = await source(repo)
        .check(_checkpoint)
        .timeout(const Duration(seconds: 2));

    final items = (result as Ok<SourceCheck>).value.items;
    expect(items[0].title, 'Film 120');
    expect(items[1].title, 'Request #119', reason: 'its lookup hung');
    expect(items[2].title, 'Film 118');
  });

  test('still advances the checkpoint past every new item', () async {
    final result = await source(_FakeSeerr()).check(_checkpoint);

    expect((result as Ok<SourceCheck>).value.checkpoint, 'r:120;i:60');
  });
}

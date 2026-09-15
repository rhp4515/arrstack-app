// applySort orders the interactive-search results. Best match and Seeders
// both rank by seeders (high→low, unknown last) — see release_sort.dart's
// doc comment for why they're currently identical. Size is small→large.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate rc({String guid = 'g', int? seeders, int size = 0}) =>
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

void main() {
  group('applySort', () {
    test('best: descending by seeders, null seeders last', () {
      final out = applySort([
        rc(guid: 'a', seeders: 5),
        rc(guid: 'b', seeders: null),
        rc(guid: 'c', seeders: 50),
      ], ReleaseSort.best);

      expect(out.map((r) => r.guid), ['c', 'a', 'b']);
    });

    test('seeders: descending by seeders, null seeders last', () {
      final out = applySort([
        rc(guid: 'a', seeders: 5),
        rc(guid: 'b', seeders: null),
        rc(guid: 'c', seeders: 50),
      ], ReleaseSort.seeders);

      expect(out.map((r) => r.guid), ['c', 'a', 'b']);
    });

    test('size: ascending', () {
      final out = applySort([
        rc(guid: 'big', size: 40000),
        rc(guid: 'small', size: 2000),
        rc(guid: 'mid', size: 8000),
      ], ReleaseSort.size);

      expect(out.map((r) => r.guid), ['small', 'mid', 'big']);
    });

    test('does not mutate the input list', () {
      final input = [rc(guid: 'a', seeders: 1), rc(guid: 'b', seeders: 9)];
      applySort(input, ReleaseSort.best);
      expect(input.map((r) => r.guid), ['a', 'b']);
    });

    test('empty list returns empty', () {
      expect(applySort(const [], ReleaseSort.best), isEmpty);
    });
  });
}

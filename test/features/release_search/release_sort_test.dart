// applySort orders the interactive-search results. Peers is high→low with
// seeder-less releases last; Size is small→large (avoid the 40 GB remux
// when you wanted a 2 GB web-dl); Age is new→old; Quality is best→worst.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate rc({
  String guid = 'g',
  int? seeders,
  int size = 0,
  int ageMinutes = 0,
  int qualityWeight = 0,
}) => ReleaseCandidate(
  guid: guid,
  indexerId: 1,
  indexerName: 'ix',
  title: guid,
  sizeBytes: size,
  protocol: ReleaseProtocol.torrent,
  qualityLabel: 'q',
  qualityWeight: qualityWeight,
  ageMinutes: ageMinutes,
  isRejected: false,
  rejections: const [],
  downloadAllowed: true,
  seeders: seeders,
);

void main() {
  group('applySort', () {
    test('peers: descending, null seeders last', () {
      final out = applySort([
        rc(guid: 'a', seeders: 5),
        rc(guid: 'b', seeders: null),
        rc(guid: 'c', seeders: 50),
      ], ReleaseSort.peers);

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

    test('age: ascending (newest first)', () {
      final out = applySort([
        rc(guid: 'old', ageMinutes: 9000),
        rc(guid: 'new', ageMinutes: 30),
      ], ReleaseSort.age);

      expect(out.map((r) => r.guid), ['new', 'old']);
    });

    test('quality: descending by weight', () {
      final out = applySort([
        rc(guid: 'sd', qualityWeight: 1),
        rc(guid: 'uhd', qualityWeight: 20),
        rc(guid: 'hd', qualityWeight: 8),
      ], ReleaseSort.quality);

      expect(out.map((r) => r.guid), ['uhd', 'hd', 'sd']);
    });

    test('does not mutate the input list', () {
      final input = [rc(guid: 'a', seeders: 1), rc(guid: 'b', seeders: 9)];
      applySort(input, ReleaseSort.peers);
      expect(input.map((r) => r.guid), ['a', 'b']);
    });

    test('empty list returns empty', () {
      expect(applySort(const [], ReleaseSort.peers), isEmpty);
    });
  });
}

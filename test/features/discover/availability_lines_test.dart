import 'package:arrstack/features/discover/availability_lines.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns nothing when mediaInfo is null', () {
    expect(availabilityLines(null), isEmpty);
  });

  test('returns nothing for a pending/processing/unknown status', () {
    for (final status in [
      SeerrMediaStatus.unknown,
      SeerrMediaStatus.pending,
      SeerrMediaStatus.processing,
    ]) {
      expect(
        availabilityLines(SeerrMediaInfo(id: 1, status: status)),
        isEmpty,
        reason: 'status $status',
      );
    }
  });

  test('returns a single "Already available" line for available', () {
    final lines = availabilityLines(
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
    );
    expect(lines, [('Status', 'Already available')]);
  });

  test(
    'returns a single "Partially available" line for partiallyAvailable',
    () {
      final lines = availabilityLines(
        const SeerrMediaInfo(
          id: 1,
          status: SeerrMediaStatus.partiallyAvailable,
        ),
      );
      expect(lines, [('Status', 'Partially available')]);
    },
  );
}

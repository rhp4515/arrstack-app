import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/models/seerr_status_presentation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps pending to a warning-colored "Pending" label', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.pending)?.label, 'Pending');
  });

  test('maps processing to an accent-colored "Processing" label', () {
    expect(
      mediaStatusPresentation(SeerrMediaStatus.processing)?.label,
      'Processing',
    );
  });

  test(
    'maps partiallyAvailable to an up-colored "Partially Available" label',
    () {
      expect(
        mediaStatusPresentation(SeerrMediaStatus.partiallyAvailable)?.label,
        'Partially Available',
      );
    },
  );

  test('maps available to an up-colored "Available" label', () {
    expect(
      mediaStatusPresentation(SeerrMediaStatus.available)?.label,
      'Available',
    );
  });

  test('returns null for unknown', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.unknown), isNull);
  });

  test('returns null for deleted', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.deleted), isNull);
  });

  test('returns null for an unmapped int', () {
    expect(mediaStatusPresentation(999), isNull);
  });
}

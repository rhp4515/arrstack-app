import 'package:arrstack/features/requests/requests_bucketing.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter_test/flutter_test.dart';

SeerrRequest req({
  required int id,
  required int status,
  int mediaStatus = SeerrMediaStatus.unknown,
}) => SeerrRequest(
  id: id,
  status: status,
  media: SeerrRequestMedia(id: id, status: mediaStatus),
);

void main() {
  group('needsDecision', () {
    test('includes only pending requests', () {
      final requests = [
        req(id: 1, status: SeerrRequestStatus.pending),
        req(id: 2, status: SeerrRequestStatus.approved),
      ];
      expect(needsDecision(requests).map((r) => r.id), [1]);
    });
  });

  group('inProgress', () {
    test('an approved request whose media is still processing lands here, not dropped', () {
      final requests = [
        req(
          id: 1,
          status: SeerrRequestStatus.approved,
          mediaStatus: SeerrMediaStatus.processing,
        ),
      ];
      expect(inProgress(requests).map((r) => r.id), [1]);
    });

    test('excludes pending requests (those need a decision, not progress)', () {
      final requests = [req(id: 1, status: SeerrRequestStatus.pending)];
      expect(inProgress(requests), isEmpty);
    });

    test('excludes requests whose media is already available', () {
      final requests = [
        req(
          id: 1,
          status: SeerrRequestStatus.approved,
          mediaStatus: SeerrMediaStatus.available,
        ),
      ];
      expect(inProgress(requests), isEmpty);
    });
  });

  group('declined and failed requests appear in no bucket', () {
    for (final status in [
      SeerrRequestStatus.declined,
      SeerrRequestStatus.failed,
    ]) {
      test('status $status', () {
        final requests = [
          req(id: 1, status: status, mediaStatus: SeerrMediaStatus.processing),
        ];
        expect(needsDecision(requests), isEmpty);
        expect(inProgress(requests), isEmpty);
        expect(availableRequests(requests), isEmpty);
      });
    }
  });

  group('availableRequests', () {
    test('includes completed requests whose media is available', () {
      final requests = [
        req(
          id: 1,
          status: SeerrRequestStatus.completed,
          mediaStatus: SeerrMediaStatus.available,
        ),
      ];
      expect(availableRequests(requests).map((r) => r.id), [1]);
    });
  });

  group('requestStats', () {
    test('counts each bucket independently', () {
      final requests = [
        req(id: 1, status: SeerrRequestStatus.pending),
        req(id: 2, status: SeerrRequestStatus.pending),
        req(
          id: 3,
          status: SeerrRequestStatus.approved,
          mediaStatus: SeerrMediaStatus.processing,
        ),
        req(
          id: 4,
          status: SeerrRequestStatus.completed,
          mediaStatus: SeerrMediaStatus.available,
        ),
      ];
      final stats = requestStats(requests);
      expect(stats.pending, 2);
      expect(stats.processing, 1);
      expect(stats.available, 1);
    });
  });
}

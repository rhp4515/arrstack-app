/// Pure bucketing for the Requests queue (README §3c). Splits by two
/// different status axes on purpose: "needs a decision" is driven by the
/// *request's* own approval status; "in progress" and "available" are
/// driven by the *media's* fulfillment status among non-declined/
/// non-failed requests. A request can be `approved` (request status) while
/// its media is still `processing` (media status) — that's an in-progress
/// row, not a dropped one. See the Phase 7 design spec, Decision 7.
library;

import 'package:arrstack/services/seerr/models/seerr_models.dart';

List<SeerrRequest> needsDecision(List<SeerrRequest> requests) =>
    requests.where((r) => r.status == SeerrRequestStatus.pending).toList();

List<SeerrRequest> inProgress(List<SeerrRequest> requests) => requests
    .where(
      (r) =>
          r.status != SeerrRequestStatus.pending &&
          r.status != SeerrRequestStatus.declined &&
          r.status != SeerrRequestStatus.failed &&
          (r.media?.status ?? SeerrMediaStatus.unknown) !=
              SeerrMediaStatus.available,
    )
    .toList();

List<SeerrRequest> availableRequests(List<SeerrRequest> requests) => requests
    .where(
      (r) =>
          r.status != SeerrRequestStatus.declined &&
          r.status != SeerrRequestStatus.failed &&
          r.media?.status == SeerrMediaStatus.available,
    )
    .toList();

class RequestStats {
  const RequestStats({
    required this.pending,
    required this.processing,
    required this.available,
  });

  final int pending;
  final int processing;
  final int available;
}

RequestStats requestStats(List<SeerrRequest> requests) => RequestStats(
  pending: needsDecision(requests).length,
  processing: inProgress(requests).length,
  available: availableRequests(requests).length,
);

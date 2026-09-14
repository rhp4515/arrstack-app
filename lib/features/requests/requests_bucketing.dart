/// Pure bucketing for the Requests queue (README §3c). Splits by two
/// different status axes on purpose: "needs a decision" is driven by the
/// *request's* own approval status; "in progress" and "available" are
/// driven by the *media's* fulfillment status among requests that are
/// non-pending, non-declined, and non-failed (i.e. requests whose request-
/// status axis is "settled" one way or another). A request can be
/// `approved` (request status) while its media is still `processing`
/// (media status) — that's an in-progress row, not a dropped one. See the
/// Phase 7 design spec, Decision 7.
///
/// `_isEligibleForMediaBucketing` is the single shared predicate for the
/// request-status axis so `inProgress` and `availableRequests` can never
/// drift out of sync on which requests they consider (e.g. one excluding
/// `pending` while the other forgets to) — every request must land in at
/// most one of the three buckets.
library;

import 'package:arrstack/services/seerr/models/seerr_models.dart';

List<SeerrRequest> needsDecision(List<SeerrRequest> requests) =>
    requests.where((r) => r.status == SeerrRequestStatus.pending).toList();

/// True when [r]'s own approval status is settled (not pending, not
/// declined, not failed) — the shared entry condition for the two
/// media-status-driven buckets below.
bool _isEligibleForMediaBucketing(SeerrRequest r) =>
    r.status != SeerrRequestStatus.pending &&
    r.status != SeerrRequestStatus.declined &&
    r.status != SeerrRequestStatus.failed;

List<SeerrRequest> inProgress(List<SeerrRequest> requests) => requests
    .where(
      (r) =>
          _isEligibleForMediaBucketing(r) &&
          ![
            SeerrMediaStatus.available,
            SeerrMediaStatus.deleted,
          ].contains(r.media?.status ?? SeerrMediaStatus.unknown),
    )
    .toList();

List<SeerrRequest> availableRequests(List<SeerrRequest> requests) => requests
    .where(
      (r) =>
          _isEligibleForMediaBucketing(r) &&
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

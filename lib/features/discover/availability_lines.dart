/// Best-effort AVAILABILITY lines for the Discover detail/request page
/// (README §3b), built only from data Seerr's `MediaInfo` actually carries.
/// Today that's only `status` — no digital-release date, indexer-hit
/// count, or best-available quality/size exist on this model. Per the
/// Phase 7 design spec, Decision 2: omit rather than fabricate, so this
/// returns at most one line and an empty list when there's nothing honest
/// to say.
library;

import 'package:arrstack/services/seerr/models/seerr_models.dart';

List<(String label, String value)> availabilityLines(
  SeerrMediaInfo? mediaInfo,
) {
  return switch (mediaInfo?.status) {
    SeerrMediaStatus.available => const [('Status', 'Already available')],
    SeerrMediaStatus.partiallyAvailable => const [
      ('Status', 'Partially available'),
    ],
    _ => const [],
  };
}

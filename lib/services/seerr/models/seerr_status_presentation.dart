/// Single source of truth for how a Seerr [SeerrMediaStatus] presents as a
/// literal label + color — replaces the label switch statements previously
/// duplicated across `discover_detail_page.dart`'s `_RequestStatusChip` and
/// `request_list_tile.dart`'s `_mediaStatusChip`. Consumed directly by the
/// Requests queue's in-progress trailing tag (README §3c), where the
/// literal status name is exactly what's wanted (Processing/Partially
/// Available/Available). The Discover poster badge (§3a) and the detail
/// page's "Not in library" chip (§3b) want different framing ("In
/// library"/"Requested"/"Not in library" rather than a literal status
/// name), so they classify `status` directly instead — see
/// `media_status_badge.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';

({String label, Color color})? mediaStatusPresentation(int status) {
  return switch (status) {
    SeerrMediaStatus.pending => (label: 'Pending', color: AppColors.warning),
    SeerrMediaStatus.processing => (
      label: 'Processing',
      color: AppColors.accent,
    ),
    SeerrMediaStatus.partiallyAvailable => (
      label: 'Partially Available',
      color: AppColors.up,
    ),
    SeerrMediaStatus.available => (label: 'Available', color: AppColors.up),
    _ => null,
  };
}

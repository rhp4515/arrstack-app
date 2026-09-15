/// The poster-corner badge answering "do I already have this?" before the
/// tap (README §3a) — a small **solid**-fill pill, 5px inset from the
/// poster's top-left corner via `PosterCard`'s existing `badge` slot (no
/// change needed there). Classifies `mediaInfo.status` directly rather than
/// through `mediaStatusPresentation` (seerr_status_presentation.dart)
/// because "In library"/"Requested" don't match that function's literal
/// media-status vocabulary.
///
/// The "In library" variant's text uses `AppColors.n900` rather than
/// `AppColors.text`: `AppColors.text` on the `AppColors.accent` fill
/// measures roughly 2.6:1, below WCAG AA's 4.5:1 threshold for this
/// 9px/600 text (see `design_tokens.dart`'s own note that the accent ramp
/// is only ~3:1 on dark grounds — fine for icons/large text, not small
/// paragraph-weight copy). `n900` on `accent` gives real contrast. The
/// "Requested" variant's neutral-900 fill with `AppColors.text` is
/// unaffected — `text` on `n900` clears AA comfortably.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';

class MediaStatusBadge extends StatelessWidget {
  const MediaStatusBadge({required this.mediaInfo, super.key});

  final SeerrMediaInfo? mediaInfo;

  @override
  Widget build(BuildContext context) {
    final status = mediaInfo?.status;
    if (status == null) return const SizedBox.shrink();

    final style = switch (status) {
      SeerrMediaStatus.available || SeerrMediaStatus.partiallyAvailable => (
        label: 'In library',
        fill: AppColors.accent,
        // AppColors.text on accent is only ~2.6:1 — below WCAG AA for this
        // small text. n900 on accent gives real contrast.
        text: AppColors.n900,
      ),
      SeerrMediaStatus.pending || SeerrMediaStatus.processing => (
        label: 'Requested',
        fill: AppColors.n900,
        text: AppColors.text,
      ),
      _ => null,
    };
    if (style == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: style.fill,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.text,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

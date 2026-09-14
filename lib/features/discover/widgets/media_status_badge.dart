/// The poster-corner badge answering "do I already have this?" before the
/// tap (README §3a) — a small **solid**-fill pill, 5px inset from the
/// poster's top-left corner via `PosterCard`'s existing `badge` slot (no
/// change needed there). Classifies `mediaInfo.status` directly rather than
/// through `mediaStatusPresentation` (seerr_status_presentation.dart)
/// because "In library"/"Requested" don't match that function's literal
/// media-status vocabulary.
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
      ),
      SeerrMediaStatus.pending ||
      SeerrMediaStatus.processing => (label: 'Requested', fill: AppColors.n900),
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
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

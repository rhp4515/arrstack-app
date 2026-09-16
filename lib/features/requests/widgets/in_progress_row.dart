/// A compact row shared by three Requests-queue buckets (README §3c):
/// in-progress `processing`, in-progress `partiallyAvailable`, and the
/// "N available requests" drill-down's `available` rows. Renders a poster,
/// title, a status line, and a trailing tag. `processing` → "searching
/// indexers" for both movies and TV, since Overseerr's request API exposes
/// no per-episode download detail (Phase 7 design spec, Decision 9);
/// `partiallyAvailable` → a season-list line plus a green "Partial" tag,
/// shortened from `mediaStatusPresentation`'s literal "Partially Available"
/// label; `available` → an explicit "available" status line so it doesn't
/// contradict the green "Available" tag next to it.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/models/seerr_status_presentation.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InProgressRow extends ConsumerWidget {
  const InProgressRow({
    required this.instanceId,
    required this.request,
    super.key,
  });

  final String instanceId;
  final SeerrRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = request.media;
    final tmdbId = media?.tmdbId;
    final detailAsync = tmdbId == null
        ? null
        : ref.watch(
            seerrDetailProvider(
              instanceId: instanceId,
              id: tmdbId,
              mediaType: media!.mediaType,
            ),
          );
    final detail = switch (detailAsync?.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final title = detail?.displayTitle ?? 'Request #${request.id}';
    final posterUrl = detail?.posterUrl;
    final mediaStatus = media?.status ?? SeerrMediaStatus.unknown;
    final presentation = mediaStatusPresentation(mediaStatus);
    final isPartial = mediaStatus == SeerrMediaStatus.partiallyAvailable;
    final tagLabel = isPartial
        ? 'Partial'
        : (presentation?.label ?? 'Processing');
    final tagColor = isPartial
        ? AppColors.up
        : (presentation?.color ?? AppColors.accent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: posterUrl != null
                ? Image.network(
                    posterUrl,
                    width: 32,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                : Container(width: 32, height: 48, color: AppColors.n800),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.cardTitle),
                Text(
                  _statusLine(mediaStatus),
                  style: AppTypography.meta.copyWith(color: AppColors.n500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              tagLabel,
              style: TextStyle(
                color: tagColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Exhaustive over the three media statuses this row can actually
  /// represent (per the class doc): `partiallyAvailable` with known seasons,
  /// `available`, and everything else (`processing`, plus a
  /// `partiallyAvailable` row with no season data — Overseerr's request API
  /// doesn't always populate `seasons`), which falls back to the
  /// `processing` line since that's this row's most common state.
  String _statusLine(int mediaStatus) {
    final by = 'by ${request.requestedBy?.displayName ?? 'unknown'}';
    if (mediaStatus == SeerrMediaStatus.partiallyAvailable &&
        request.seasons.isNotEmpty) {
      final seasons = request.seasons.map((s) => s.seasonNumber).join(', ');
      return '$by · seasons $seasons';
    }
    if (mediaStatus == SeerrMediaStatus.available) {
      return '$by · available';
    }
    return '$by · searching indexers';
  }
}

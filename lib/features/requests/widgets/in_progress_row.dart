/// A compact "in progress" row (README §3c): poster, title, a status line,
/// and a trailing tag. `processing` → "searching indexers" for both movies
/// and TV, since Overseerr's request API exposes no per-episode download
/// detail (Phase 7 design spec, Decision 9); `partiallyAvailable` → a
/// season-list line plus a green "Partial" tag, shortened from
/// `mediaStatusPresentation`'s literal "Partially Available" label.
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
                  _statusLine(isPartial),
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

  String _statusLine(bool isPartial) {
    final by = 'by ${request.requestedBy?.displayName ?? 'unknown'}';
    if (isPartial && request.seasons.isNotEmpty) {
      final seasons = request.seasons.map((s) => s.seasonNumber).join(', ');
      return '$by · seasons $seasons';
    }
    return '$by · searching indexers';
  }
}

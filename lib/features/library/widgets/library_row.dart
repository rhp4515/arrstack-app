/// A fading-rule-separated library row (spec 2d "ALL SHOWS"/"RECENTLY
/// ADDED"): 36x54 poster, title + tabular meta, and a state-aware
/// trailing indicator. Replaces `MediaListTile`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

enum LibraryRowTrailing { none, percent, progress, unmonitored }

class LibraryRow extends StatelessWidget {
  const LibraryRow({
    required this.service,
    required this.instanceId,
    required this.title,
    required this.metaParts,
    required this.trailing,
    this.posterUrl,
    this.percent,
    this.progress,
    this.trailingText,
    this.onTap,
    this.showRule = true,
    this.showChevron = false,
    this.detail,
    this.metaColor,
    this.trailingNeutral = false,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final String? posterUrl;
  final String title;
  final List<String> metaParts;
  final LibraryRowTrailing trailing;
  final int? percent;
  final double? progress;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool showRule;

  /// Trailing caret signalling the row opens a detail page.
  final bool showChevron;

  /// Optional second meta line under [metaParts] (e.g. a date).
  final String? detail;

  /// Overrides the meta line's color (e.g. a failure tint).
  final Color? metaColor;

  /// Renders [trailingText] in neutral grey instead of the success green
  /// (e.g. a quality chip on a failed event).
  final bool trailingNeutral;

  @override
  Widget build(BuildContext context) {
    final isUnmonitored = trailing == LibraryRowTrailing.unmonitored;
    final row = InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isUnmonitored)
              const SizedBox(
                width: 36,
                height: 54,
                child: Icon(
                  PhosphorIconsRegular.bookmarkSimple,
                  color: AppColors.n600,
                ),
              )
            else
              ResolvedPoster(
                service: service,
                instanceId: instanceId,
                relativeUrl: posterUrl,
                width: 36,
                height: 54,
                radius: AppRadius.sm,
              ),
            const SizedBox(width: AppSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle,
                  ),
                  if (metaParts.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      metaParts.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.meta.copyWith(
                        color: metaColor,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                  if (detail != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      detail!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.meta.copyWith(
                        color: AppColors.n600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            _Trailing(
              trailing: trailing,
              percent: percent,
              progress: progress,
              trailingText: trailingText,
              trailingNeutral: trailingNeutral,
            ),
            if (showChevron) ...[
              const SizedBox(width: AppSpacing.space2),
              const Icon(
                PhosphorIconsRegular.caretRight,
                size: 14,
                color: AppColors.n600,
              ),
            ],
          ],
        ),
      ),
    );

    final content = isUnmonitored ? Opacity(opacity: 0.62, child: row) : row;

    if (!showRule) return content;
    return Column(children: [content, const FadingRule()]);
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.trailing,
    required this.percent,
    required this.progress,
    required this.trailingText,
    required this.trailingNeutral,
  });

  final LibraryRowTrailing trailing;
  final int? percent;
  final double? progress;
  final String? trailingText;
  final bool trailingNeutral;

  @override
  Widget build(BuildContext context) {
    switch (trailing) {
      case LibraryRowTrailing.percent:
        return Text(
          '${percent ?? 0}%',
          style: AppTypography.meta.copyWith(
            color: AppColors.up,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      case LibraryRowTrailing.progress:
        return SizedBox(
          width: 52,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress ?? 0,
              minHeight: 4,
              backgroundColor: AppColors.n800,
              valueColor: const AlwaysStoppedAnimation(AppColors.a300),
            ),
          ),
        );
      case LibraryRowTrailing.unmonitored:
        return Text(
          'Unmonitored',
          style: AppTypography.meta.copyWith(color: AppColors.n500),
        );
      case LibraryRowTrailing.none:
        if (trailingText == null) return const SizedBox.shrink();
        final chipColor = trailingNeutral ? AppColors.n500 : AppColors.up;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: chipColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            trailingText!,
            style: AppTypography.meta.copyWith(color: chipColor),
          ),
        );
    }
  }
}

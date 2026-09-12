/// "Right now" qBittorrent throughput card: kicker, tabular counts, and a
/// 3-segment progress bar (Phase 3 design §Widget plan).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class RightNowCard extends StatelessWidget {
  const RightNowCard({required this.summary, super.key});

  final RightNowSummary summary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final eta = summary.etaToNextFinishSeconds;
    final etaCaption = eta == null
        ? ''
        : ' · next in ${FormatUtils.formatEta(eta)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: AppShadows.ringSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RIGHT NOW',
            style: AppTypography.kicker.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Icon(
                PhosphorIconsRegular.downloadSimple,
                size: 16,
                color: isDark ? AppColors.a300 : colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.space2),
              Text(
                '${FormatUtils.formatSpeed(summary.downloadSpeed)} · '
                '${FormatUtils.formatSpeed(summary.uploadSpeed)}',
                style: AppTypography.statNumeral.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            '${summary.downloadingCount} downloading · '
            '${summary.seedingCount} seeding$etaCaption',
            style: AppTypography.meta.copyWith(
              color: isDark ? AppColors.n500 : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.space3),
          _SegmentBar(summary: summary),
        ],
      ),
    );
  }
}

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({required this.summary});

  final RightNowSummary summary;

  @override
  Widget build(BuildContext context) {
    final segments = <(double fraction, Color color)>[
      (summary.downloadingFraction, AppColors.accent),
      (summary.pausedOrStalledFraction, AppColors.warning),
      (summary.queuedFraction, AppColors.n700),
    ].where((segment) => segment.$1 > 0).toList();

    if (segments.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(height: 4, color: AppColors.n800),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: SizedBox(
        height: 4,
        child: Row(
          children: [
            for (final segment in segments)
              Expanded(
                flex: (segment.$1 * 1000).round().clamp(1, 1000),
                child: Container(color: segment.$2),
              ),
          ],
        ),
      ),
    );
  }
}

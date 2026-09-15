/// One row in the interactive-search results list (README §3e): a
/// regular-weight release name over a tabular spec line, with a trailing
/// download icon (allowed) or a red prohibit icon (rejected) instead of
/// leaving rejected rows with no icon at all.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class ReleaseTile extends StatelessWidget {
  const ReleaseTile({required this.release, required this.onTap, super.key});

  final ReleaseCandidate release;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const muted = AppColors.n500;

    final peers = release.protocol == ReleaseProtocol.torrent
        ? '▲${release.seeders ?? '—'} ▼${release.leechers ?? '—'}'
        : 'usenet';

    final facts = <String>[
      release.qualityLabel,
      FormatUtils.formatBytes(release.sizeBytes),
      peers,
      release.indexerName,
      FormatUtils.formatReleaseAge(release.ageMinutes),
    ].join('  ·  ');

    final textColumn = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            release.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: release.isRejected ? AppColors.n500 : AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            facts,
            style: AppTypography.meta.copyWith(
              color: muted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (release.isRejected && release.rejections.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              release.rejections.length > 1
                  ? '${release.rejections.first}  +${release.rejections.length - 1} more'
                  : release.rejections.first,
              style: AppTypography.meta.copyWith(color: AppColors.down),
            ),
          ],
        ],
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.space3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textColumn,
          const SizedBox(width: AppSpacing.space3),
          Icon(
            release.isRejected
                ? PhosphorIconsRegular.prohibit
                : PhosphorIconsRegular.downloadSimple,
            size: 15,
            color: release.isRejected ? AppColors.down : AppColors.accent,
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: release.isRejected
          ? Opacity(opacity: 0.55, child: content)
          : content,
    );
  }
}

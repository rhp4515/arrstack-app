/// One row in the interactive-search results list.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:flutter/material.dart';

class ReleaseTile extends StatelessWidget {
  const ReleaseTile({required this.release, required this.onTap, super.key});

  final ReleaseCandidate release;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

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

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            release.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(facts, style: theme.textTheme.bodySmall?.copyWith(color: muted)),
          if (release.isRejected && release.rejections.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              release.rejections.length > 1
                  ? '${release.rejections.first}  +${release.rejections.length - 1} more'
                  : release.rejections.first,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
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

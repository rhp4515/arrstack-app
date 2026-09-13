/// The "CONTINUE WATCHING" horizontal poster row (spec 2d): three 88px
/// cards with a 132px poster and a tabular status caption below the
/// title. Renders nothing when there's nothing to show.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';

class ContinueWatchingRow extends StatelessWidget {
  const ContinueWatchingRow({
    required this.instanceId,
    required this.entries,
    super.key,
  });

  final String instanceId;
  final List<ContinueWatchingEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CONTINUE WATCHING', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space4),
        SizedBox(
          height: 132 + AppSpacing.space2 + 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.space4),
            itemBuilder: (context, index) =>
                _Card(instanceId: instanceId, entry: entries[index]),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.instanceId, required this.entry});

  final String instanceId;
  final ContinueWatchingEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResolvedPoster(
            service: ServiceType.sonarr,
            instanceId: instanceId,
            relativeUrl: entry.series.posterUrl,
            width: 88,
            height: 132,
            radius: AppRadius.md,
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            entry.series.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle.copyWith(fontSize: 11.5),
          ),
          Text(
            entry.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.meta.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

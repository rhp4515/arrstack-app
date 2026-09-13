/// The poster-beside-title detail header shared by series (2e) and movie
/// (2g) detail screens: a 104x156 poster left, then title/meta/chips/a
/// 2-up stat row right. Replaces the old centered-poster layout.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:flutter/material.dart';

class MediaDetailHeader extends StatelessWidget {
  const MediaDetailHeader({
    required this.service,
    required this.instanceId,
    required this.posterUrl,
    required this.title,
    required this.metaParts,
    required this.chips,
    required this.stats,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final String? posterUrl;
  final String title;
  final List<String> metaParts;
  final List<Widget> chips;

  /// Exactly two (value, caption) pairs, e.g. ("19/19", "EPISODES").
  final List<(String value, String caption)> stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResolvedPoster(
          service: service,
          instanceId: instanceId,
          relativeUrl: posterUrl,
          width: 104,
          height: 156,
          radius: AppRadius.md,
        ),
        const SizedBox(width: AppSpacing.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.sectionTitle),
              if (metaParts.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space2),
                Text(
                  metaParts.join(' · '),
                  style: AppTypography.meta.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (chips.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space3),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space2,
                  children: chips,
                ),
              ],
              const SizedBox(height: AppSpacing.space4),
              Row(
                children: [
                  for (final (value, caption) in stats)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.space6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value, style: AppTypography.statNumeral),
                          Text(caption, style: AppTypography.statCaption),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

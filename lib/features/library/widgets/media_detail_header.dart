/// The poster-beside-title detail header shared by series (2e), movie
/// (2g), and Discover detail (3b): a poster left, then title/meta/chips/a
/// 2-up stat row right. The poster is caller-supplied (sized to 104×156)
/// rather than resolved internally — Radarr/Sonarr callers construct
/// `ResolvedPoster` (relative-URL-by-instance resolution); Seerr's Discover
/// detail page (3b) constructs a plain `CachedNetworkImage` from its
/// already-absolute TMDB URL, which `ResolvedPoster` has no branch for.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class MediaDetailHeader extends StatelessWidget {
  const MediaDetailHeader({
    required this.poster,
    required this.title,
    required this.metaParts,
    required this.chips,
    required this.stats,
    super.key,
  });

  final Widget poster;
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
        poster,
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

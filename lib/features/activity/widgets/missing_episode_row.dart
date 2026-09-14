/// One row in the Wanted lens's "MISSING EPISODES" section (spec screen
/// 2j): episode code, series/episode title, aired date, and a search
/// button that routes to the existing release-search page.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// "S04E03" — zero-padded, falling back to 00 for a missing part rather
/// than throwing. Pure — unit-testable without a widget tree.
String episodeCode(int? season, int? episode) {
  final s = (season ?? 0).toString().padLeft(2, '0');
  final e = (episode ?? 0).toString().padLeft(2, '0');
  return 'S${s}E$e';
}

/// "2022-03-25", or an em dash when there's no air date.
String formatAiredDate(DateTime? date) {
  if (date == null) return '—';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

class MissingEpisodeRow extends StatelessWidget {
  const MissingEpisodeRow({required this.missingEpisode, super.key});

  final SonarrMissingEpisode missingEpisode;

  @override
  Widget build(BuildContext context) {
    final episode = missingEpisode.episode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final seriesId = episode.seriesId;
    final canSearch = seriesId != null;
    final actionColor = canSearch
        ? (isDark ? AppColors.accent : colorScheme.primary)
        : colorScheme.outlineVariant;
    final onSurfaceMuted = isDark
        ? AppColors.n400
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Text(
              episodeCode(episode.seasonNumber, episode.episodeNumber),
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${episode.series?.title ?? 'Unknown series'} · '
                  '${episode.title ?? 'Untitled episode'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'aired ${formatAiredDate(episode.airDateUtc)}',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 10.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          SizedBox(
            height: 26,
            child: OutlinedButton.icon(
              onPressed: canSearch
                  ? () => context.go(
                      RoutePaths.episodeReleaseSearch(
                        missingEpisode.instanceId,
                        seriesId,
                        episode.id,
                        episode.title ?? 'Episode',
                      ),
                    )
                  : null,
              icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 14),
              label: const Text('Search releases'),
              style: OutlinedButton.styleFrom(
                foregroundColor: actionColor,
                side: BorderSide(color: actionColor),
                textStyle: const TextStyle(fontSize: 10.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

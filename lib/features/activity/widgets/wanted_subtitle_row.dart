/// One row in the Wanted lens's "WANTED SUBTITLES" section (spec screen 2j):
/// title, an optional series/episode meta line, and one tag per wanted
/// language. Replaces `lib/features/subtitles/widgets/wanted_subtitle_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';

class WantedSubtitleRow extends StatelessWidget {
  const WantedSubtitleRow({required this.subtitle, super.key});

  final BazarrWantedSubtitle subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEpisode = subtitle.type == 'episode';
    final metaLine = isEpisode && subtitle.seriesTitle != null
        ? '${subtitle.seriesTitle} · '
              '${_seasonEpisodeCode(subtitle.seasonNumber, subtitle.episodeNumber)}'
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                if (metaLine != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    metaLine,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 11.5,
                      color: _getMutedTextColor(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Wrap(
            spacing: 4,
            children: [
              for (final language in subtitle.languages)
                _LanguageTag(label: language),
            ],
          ),
        ],
      ),
    );
  }

  String _seasonEpisodeCode(int? season, int? episode) {
    final s = (season ?? 0).toString().padLeft(2, '0');
    final e = (episode ?? 0).toString().padLeft(2, '0');
    return 'S${s}E$e';
  }

  Color _getMutedTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return AppColors.n400;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

class _LanguageTag extends StatelessWidget {
  const _LanguageTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 9.5,
          fontWeight: FontWeight.w500,
          color: _getMutedTextColor(context),
        ),
      ),
    );
  }

  Color _getMutedTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return AppColors.n400;
    }
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}

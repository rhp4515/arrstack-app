/// A row widget for displaying a wanted subtitle item (simplified variant).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';

class WantedSubtitleRow extends StatelessWidget {
  const WantedSubtitleRow({required this.subtitle, super.key});

  final BazarrWantedSubtitle subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEpisode = subtitle.type == 'episode';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.space3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle.title, style: theme.textTheme.titleMedium),
          if (isEpisode && subtitle.seriesTitle != null) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              '${subtitle.seriesTitle} - S${subtitle.seasonNumber?.toString().padLeft(2, '0')}E${subtitle.episodeNumber?.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getMutedTextColor(context),
              ),
            ),
          ],
          if (subtitle.languages.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space3),
            Wrap(
              spacing: AppSpacing.space2,
              children: subtitle.languages
                  .map((language) => _LanguageChip(label: language))
                  .toList(),
            ),
          ],
        ],
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

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space3,
        vertical: AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

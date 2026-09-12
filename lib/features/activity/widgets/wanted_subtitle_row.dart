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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle.title, style: theme.textTheme.titleMedium),
          if (isEpisode && subtitle.seriesTitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${subtitle.seriesTitle} - S${subtitle.seasonNumber?.toString().padLeft(2, '0')}E${subtitle.episodeNumber?.toString().padLeft(2, '0')}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getMutedTextColor(context),
              ),
            ),
          ],
          if (subtitle.languages.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
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
      return const Color(0xFF999999); // AppColors.n400 equivalent
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
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
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

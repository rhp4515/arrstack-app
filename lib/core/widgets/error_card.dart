/// The one shared error pattern used across the app (README "Shared shell"
/// → "Error card", reused by screens 2j, 2n, 3f): a warning glyph, a title,
/// an explanation, and two actions — one recovery, one escape.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    required this.title,
    required this.message,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    required this.secondaryActionLabel,
    required this.onSecondaryAction,
    super.key,
  });

  final String title;
  final String message;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final String secondaryActionLabel;
  final VoidCallback onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.down.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                PhosphorIconsFill.warning,
                size: 15,
                color: AppColors.down,
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardTitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            message,
            style: AppTypography.meta.copyWith(
              color: isDark ? AppColors.n400 : colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrimaryAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.accent
                        : colorScheme.primary,
                    side: BorderSide(
                      color: isDark ? AppColors.accent : colorScheme.primary,
                    ),
                  ),
                  child: Text(primaryActionLabel),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondaryAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.n400
                        : colorScheme.onSurfaceVariant,
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Text(secondaryActionLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

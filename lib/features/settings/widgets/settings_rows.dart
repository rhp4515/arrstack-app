/// Shared building blocks for the Settings sub-pages (Advanced,
/// Notifications, Service Backup, Diagnostic logs): a kicker-headed
/// section and a tappable navigation row, in the app's Nocturne style.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// A kicker ("APPEARANCE") over its rows, separated from the next section
/// by a fading rule.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.kicker,
    required this.children,
    this.description,
    this.showRule = true,
    super.key,
  });

  final String kicker;
  final String? description;
  final List<Widget> children;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(kicker, style: AppTypography.kicker),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.space2),
          Text(description, style: AppTypography.meta),
        ],
        const SizedBox(height: AppSpacing.space3),
        ...children,
        if (showRule) ...[
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
        ],
      ],
    );
  }
}

/// Icon + title/subtitle + caret, opening a sub-page or running an action.
class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          children: [
            Icon(icon, size: 19, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.cardTitle),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: AppTypography.meta.copyWith(color: AppColors.n500),
                    ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: 12,
                  color: AppColors.n500,
                ),
          ],
        ),
      ),
    );
  }
}

/// The inline result banner shared by the Tools pages ("Saved backup for
/// 2 services." · Dismiss).
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    required this.message,
    required this.onDismiss,
    this.isError = false,
    super.key,
  });

  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.down : AppColors.up;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space2,
        AppSpacing.space2,
        AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.6)),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(
        children: [
          Icon(
            isError
                ? PhosphorIconsRegular.warningCircle
                : PhosphorIconsRegular.checkCircle,
            size: 17,
            color: color,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(child: Text(message, style: AppTypography.body)),
          TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
        ],
      ),
    );
  }
}

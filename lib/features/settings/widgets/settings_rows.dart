/// Shared building blocks for the Settings sub-pages (Advanced,
/// Notifications, Service Backup, Diagnostic logs): a kicker-headed
/// section and a tappable navigation row, in the app's Nocturne style
/// (the same shapes as Settings' INSTANCES list).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// A kicker ("INSTANCES · 3") over its rows, separated from the next
/// section by a fading rule.
///
/// [count] is appended to the kicker; [meta] sits at the kicker's right
/// edge ("tap to edit"); [description] is explanatory text between the
/// kicker and the rows.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.kicker,
    required this.children,
    this.count,
    this.meta,
    this.description,
    this.showRule = true,
    super.key,
  });

  final String kicker;
  final int? count;
  final String? meta;
  final String? description;
  final List<Widget> children;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    final meta = this.meta;
    final description = this.description;
    final count = this.count;
    final title = Text(
      count == null ? kicker : '$kicker · $count',
      style: AppTypography.kicker,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (meta == null)
          title
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title,
              Text(meta, style: AppTypography.meta),
            ],
          ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.space2),
          Text(description, style: AppTypography.meta),
        ],
        const SizedBox(height: AppSpacing.space4),
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

/// Title over meta + caret, opening a sub-page or running an action;
/// mirrors Settings' instance rows (flat, no leading icon).
class SettingsNavRow extends StatelessWidget {
  const SettingsNavRow({
    required this.title,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.trailing,
    super.key,
  });

  /// Accepted for source compatibility and deliberately not drawn: rows
  /// are flat, and a leading glyph is reserved for status.
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          children: [
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

/// A setting whose value is one of a few choices: title over meta on the
/// left, a bare dropdown on the right (like Settings' "Default endpoint").
class SettingsChoiceRow<T> extends StatelessWidget {
  const SettingsChoiceRow({
    required this.title,
    required this.meta,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String meta;
  final T value;

  /// Option value → label, in display order.
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.cardTitle),
              Text(meta, style: AppTypography.meta),
            ],
          ),
        ),
        DropdownButton<T>(
          value: value,
          underline: const SizedBox.shrink(),
          items: [
            for (final entry in options.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
        ),
      ],
    );
  }
}

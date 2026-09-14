/// Title/subtitle row with a trailing `Switch` (README §3b, §3d): "Search
/// immediately", "Search for it now". Replaces `SwitchListTile`'s default
/// `ListTile` chrome/padding; delegates to Flutter's `Switch` for the
/// toggle visuals themselves, which the app theme already colors.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class LabeledToggleRow extends StatelessWidget {
  const LabeledToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.cardTitle),
              const SizedBox(height: AppSpacing.space2),
              Text(
                subtitle,
                style: AppTypography.meta.copyWith(color: AppColors.n500),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

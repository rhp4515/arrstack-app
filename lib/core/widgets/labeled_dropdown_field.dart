/// A Nocturne-styled labeled dropdown (README §3b, §3d): label above a
/// surface-fill/divider-border/radius-md box, an optional caption below
/// (e.g. free-space text). Replaces the plain `DropdownButtonFormField`
/// (Material default chrome) used today in `add_movie_options.dart`/
/// `add_series_options.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LabeledDropdownField<T> extends StatelessWidget {
  const LabeledDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.caption,
    super.key,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.meta.copyWith(color: AppColors.n400)),
        const SizedBox(height: AppSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: const Icon(
                PhosphorIconsRegular.caretDown,
                size: 14,
                color: AppColors.n400,
              ),
              dropdownColor: AppColors.surface,
              style: AppTypography.body.copyWith(color: AppColors.text),
            ),
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: AppSpacing.space2),
          Text(
            caption!,
            style: AppTypography.meta.copyWith(color: AppColors.n500),
          ),
        ],
      ],
    );
  }
}

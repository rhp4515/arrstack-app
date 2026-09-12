/// The Transfers/Calendar/Wanted switcher (README "Shared shell" → "Lens
/// chips"): 5px/10px padding, radius-sm, 11px/500 text. Inactive is muted;
/// active is accent text plus a 1px inset accent ring — no fill.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LensChips extends ConsumerWidget {
  const LensChips({this.wantedCount = 0, super.key});

  final int wantedCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeActivityLensProvider);

    return Row(
      children: [
        _LensChip(
          label: 'Transfers',
          lens: ActivityLens.transfers,
          isActive: active == ActivityLens.transfers,
        ),
        const SizedBox(width: AppSpacing.space2),
        _LensChip(
          label: 'Calendar',
          lens: ActivityLens.calendar,
          isActive: active == ActivityLens.calendar,
        ),
        const SizedBox(width: AppSpacing.space2),
        _LensChip(
          label: wantedCount > 0 ? 'Wanted $wantedCount' : 'Wanted',
          lens: ActivityLens.wanted,
          isActive: active == ActivityLens.wanted,
        ),
      ],
    );
  }
}

class _LensChip extends ConsumerWidget {
  const _LensChip({
    required this.label,
    required this.lens,
    required this.isActive,
  });

  final String label;
  final ActivityLens lens;
  final bool isActive;

  static const TextStyle _chipText = TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final color = isActive
        ? isDark
              ? AppColors.accent
              : colorScheme.primary
        : isDark
        ? AppColors.n400
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => ref.read(activeActivityLensProvider.notifier).select(lens),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive ? Border.all(color: color, width: 1) : null,
        ),
        child: Text(label, style: _chipText.copyWith(color: color)),
      ),
    );
  }
}

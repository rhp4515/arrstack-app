/// The Transfers/Calendar/Wanted switcher (README "Shared shell" → "Lens
/// chips"): 5px/10px padding, radius-sm, 11px/500 text. Inactive is muted;
/// active is accent text plus a 1px inset accent ring — no fill.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/lens_chip.dart';
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
        LensChip(
          label: 'Transfers',
          isActive: active == ActivityLens.transfers,
          onTap: () => ref
              .read(activeActivityLensProvider.notifier)
              .select(ActivityLens.transfers),
        ),
        const SizedBox(width: AppSpacing.space2),
        LensChip(
          label: 'Calendar',
          isActive: active == ActivityLens.calendar,
          onTap: () => ref
              .read(activeActivityLensProvider.notifier)
              .select(ActivityLens.calendar),
        ),
        const SizedBox(width: AppSpacing.space2),
        LensChip(
          label: wantedCount > 0 ? 'Wanted $wantedCount' : 'Wanted',
          isActive: active == ActivityLens.wanted,
          onTap: () => ref
              .read(activeActivityLensProvider.notifier)
              .select(ActivityLens.wanted),
        ),
      ],
    );
  }
}

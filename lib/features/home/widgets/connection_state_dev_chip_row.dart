/// Debug-only chip row to switch Home's rendered [HomeConnectionState] for
/// visual QA (README §3f: "switchable via a chip row... for demo/dev
/// purposes"). Only ever mounted when [showDevConnectionSwitcherProvider]
/// is true — real production builds never render this.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionStateDevChipRow extends ConsumerWidget {
  const ConnectionStateDevChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(homeConnectionStateDevOverrideProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.space2,
      ),
      child: Row(
        children: [
          _chip(ref, label: 'Live', value: null, active: override == null),
          for (final state in HomeConnectionState.values)
            _chip(
              ref,
              label: state.name,
              value: state,
              active: override == state,
            ),
        ],
      ),
    );
  }

  Widget _chip(
    WidgetRef ref, {
    required String label,
    required HomeConnectionState? value,
    required bool active,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.space2),
      child: InkWell(
        onTap: () => ref
            .read(homeConnectionStateDevOverrideProvider.notifier)
            .set(value),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space3,
            vertical: AppSpacing.space2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: active ? AppColors.accent : AppColors.divider,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.chipLabel.copyWith(
              color: active ? AppColors.accent : AppColors.n400,
            ),
          ),
        ),
      ),
    );
  }
}

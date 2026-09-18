/// The flattened `section` band for Home's offline layout (README §3f):
/// no saturated color or glow when nothing is reachable, a red-ringed
/// "Remote · not on a home network" chip, and an em-dash where the
/// healthy-count numeral would be.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class OfflineBand extends StatelessWidget {
  const OfflineBand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space6),
      decoration: const BoxDecoration(color: AppColors.n900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space3,
                  vertical: AppSpacing.space2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: AppColors.down.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      PhosphorIconsRegular.cloudSlash,
                      size: 14,
                      color: AppColors.down,
                    ),
                    const SizedBox(width: AppSpacing.space2),
                    Text(
                      'Remote · not on a home network',
                      style: AppTypography.meta.copyWith(color: AppColors.down),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.gear,
                  color: AppColors.text,
                ),
                onPressed: () => context.go(RoutePaths.homeSettings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          Text(
            '—',
            style: AppTypography.heroNumeral.copyWith(color: AppColors.n600),
          ),
        ],
      ),
    );
  }
}

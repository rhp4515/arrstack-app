/// Static 2x2 ghost-block skeleton for [ServiceTileGrid] (README §3f "a
/// 2x2 tile-grid skeleton in neutral-800 (title bars) and neutral-900
/// (meta bars)").
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class ServiceTileGridSkeleton extends StatelessWidget {
  const ServiceTileGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.space4,
      crossAxisSpacing: AppSpacing.space4,
      childAspectRatio: 1.6,
      children: List.generate(4, (_) => const _TileSkeleton()),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.n900,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.n800,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const Spacer(),
          Container(
            width: 80,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.n900,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }
}

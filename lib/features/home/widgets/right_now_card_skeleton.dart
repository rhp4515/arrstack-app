/// Static ghost-block skeleton for [RightNowCard] (README §3f "a card
/// skeleton").
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class RightNowCardSkeleton extends StatelessWidget {
  const RightNowCardSkeleton({super.key});

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
          _bar(width: 70, height: 10, color: AppColors.n800),
          const SizedBox(height: AppSpacing.space3),
          _bar(width: 120, height: 16, color: AppColors.n800),
          const SizedBox(height: AppSpacing.space2),
          _bar(width: 160, height: 10, color: AppColors.n800),
        ],
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}

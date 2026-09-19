/// Static ghost-block skeleton for the `section` band, shown while Home's
/// initial fetch is in flight (README §3f "a real skeleton of 2c"). The
/// gear button stays real and tappable (dimmed along with the rest of the
/// band, per spec's "0.55 opacity") so Settings stays reachable while
/// loading.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomeBandSkeleton extends StatelessWidget {
  const HomeBandSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Full-bleed background, top inset added only to the internal padding
    // — see the identical comment in OfflineBand.build.
    final topInset = MediaQuery.paddingOf(context).top;
    return Opacity(
      opacity: 0.55,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.space6,
          AppSpacing.space6 + topInset,
          AppSpacing.space6,
          AppSpacing.space6,
        ),
        decoration: const BoxDecoration(color: AppColors.section),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ghostBlock(width: 96, height: 24),
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
            _ghostBlock(width: 72, height: 40),
            const SizedBox(height: AppSpacing.space3),
            _ghostBlock(width: 140, height: 12),
          ],
        ),
      ),
    );
  }

  Widget _ghostBlock({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.sectionGhost.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}

/// The loading layout for Home (README §3f): skeletons shaped like the
/// real band/card/grid, plus "Contacting N services on `<ssid>`…".
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/home_band_skeleton.dart';
import 'package:arrstack/features/home/widgets/right_now_card_skeleton.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLoadingState extends ConsumerWidget {
  const HomeLoadingState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final ssidAsync = ref.watch(currentSsidProvider);
    final instanceCount = switch (instancesAsync.value) {
      Ok(:final value) => value.length,
      _ => 0,
    };
    final ssid = ssidAsync.value;
    final caption = ssid == null
        ? 'Contacting $instanceCount services…'
        : 'Contacting $instanceCount services on $ssid…';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const HomeBandSkeleton(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              const RightNowCardSkeleton(),
              const SizedBox(height: AppSpacing.space6),
              const ServiceTileGridSkeleton(),
              const SizedBox(height: AppSpacing.space8),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    Text(
                      caption,
                      style: AppTypography.meta,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }
}

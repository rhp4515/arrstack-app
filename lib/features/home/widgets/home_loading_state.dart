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
      _ => null,
    };
    final ssid = ssidAsync.value;
    // HomeConnectionState.loading can be entered while instancesProvider is
    // itself still resolving, not just while the summaries/rightNow
    // providers are — so the count isn't always known yet on this frame.
    // The design spec requires the caption to always show a real N, never
    // a placeholder "0" (finding #4), so omit the count entirely rather
    // than interpolating one that hasn't been confirmed.
    final caption = switch ((instanceCount, ssid)) {
      (null, _) => 'Contacting your services…',
      (final count?, null) => 'Contacting $count services…',
      (final count?, final ssid?) => 'Contacting $count services on $ssid…',
    };

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

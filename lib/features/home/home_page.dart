// lib/features/home/home_page.dart
/// Home tab: Nocturne band, "Right now" card, and the service-tile grid
/// (Phase 3 design §Widget plan). Branches on
/// [effectiveHomeConnectionStateProvider] to show the empty, loading,
/// offline, or ready layout (README §3f). Each state embeds its own gear
/// button (matching HomeBand/OfflineBand/HomeBandSkeleton) rather than a
/// Scaffold AppBar, so the debug connection-state switcher can sit above
/// all four states uniformly.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:arrstack/features/home/widgets/right_now_card.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:arrstack/features/home/widgets/supported_services_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(effectiveHomeConnectionStateProvider);
    final showDevSwitcher = ref.watch(showDevConnectionSwitcherProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (showDevSwitcher) const ConnectionStateDevChipRow(),
            Expanded(
              child: switch (connectionState) {
                HomeConnectionState.unconfigured => const _EmptyHome(),
                HomeConnectionState.loading => const HomeLoadingState(),
                HomeConnectionState.offline => const HomeOfflineState(),
                HomeConnectionState.ready => RefreshIndicator(
                  onRefresh: () => refreshHome(ref),
                  child: const _HomeContent(),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rightNowAsync = ref.watch(rightNowProvider);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const HomeBand(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              rightNowAsync.when(
                data: (summary) => summary == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.space6,
                        ),
                        child: RightNowCard(
                          summary: summary,
                          onTap: () {
                            ref
                                .read(activeActivityLensProvider.notifier)
                                .select(ActivityLens.transfers);
                            context.go(RoutePaths.activity);
                          },
                        ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const Text('SERVICES', style: AppTypography.kicker),
              const SizedBox(height: AppSpacing.space4),
              const ServiceTileGrid(),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.space2,
              right: AppSpacing.space4,
            ),
            child: IconButton(
              icon: const Icon(PhosphorIconsRegular.gear),
              onPressed: () => context.go(RoutePaths.homeSettings),
            ),
          ),
        ),
        const Expanded(
          child: EmptyState(
            icon: PhosphorIconsRegular.hardDrives,
            title: 'No services yet',
            message:
                'Add Radarr or Sonarr and this screen fills with your '
                'library, your transfers and your uptime. Everything '
                'stays on your device.',
            action: _EmptyHomeActions(),
          ),
        ),
      ],
    );
  }
}

class _EmptyHomeActions extends StatelessWidget {
  const _EmptyHomeActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: () => context.go(RoutePaths.homeAddInstance),
          icon: const Icon(PhosphorIconsRegular.plus),
          label: const Text('Add a service'),
        ),
        const SizedBox(height: AppSpacing.space3),
        TextButton(
          onPressed: () => showSupportedServicesSheet(context),
          child: const Text("What's supported?"),
        ),
      ],
    );
  }
}

/// Home tab: Nocturne band, "Right now" card, and the service-tile grid
/// (Phase 3 design §Widget plan). Replaces `dashboard_page.dart`.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/right_now_card.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);

    return Scaffold(
      appBar: instancesAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) =>
            value.isEmpty
                ? AppBar(
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(PhosphorIconsRegular.gear),
                        onPressed: () => context.go(RoutePaths.homeSettings),
                      ),
                    ],
                  )
                : null,
          _ => null,
        },
        loading: () => null,
        error: (_, _) => null,
      ),
      body: instancesAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) =>
            value.isEmpty
                ? const _EmptyHome()
                : RefreshIndicator(
                    onRefresh: () => refreshHome(ref),
                    child: const _HomeContent(),
                  ),
          Err(:final error) => Center(
            child: Text('Error: ${error.userMessage}'),
          ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Unexpected error: $err')),
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
                        child: RightNowCard(summary: summary),
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
    return EmptyState(
      icon: PhosphorIconsRegular.house,
      title: 'No services yet',
      message: 'Add a service to see its status and activity here.',
      action: FilledButton.icon(
        onPressed: () => context.go(RoutePaths.homeAddInstance),
        icon: const Icon(PhosphorIconsRegular.plus),
        label: const Text('Add service'),
      ),
    );
  }
}

/// 2-column grid of `ServiceTile`s, one per configured non-qBittorrent
/// service type (Phase 3 design §Widget plan, Decisions 2+3).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/service_tile.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/uptime/uptime_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServiceTileGrid extends ConsumerWidget {
  const ServiceTileGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summariesAsync = ref.watch(homeServiceSummariesProvider);

    return summariesAsync.when(
      data: (summaries) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.space4,
        crossAxisSpacing: AppSpacing.space4,
        childAspectRatio: 1.6,
        children: summaries
            .map(
              (summary) => ServiceTile(
                summary: summary,
                onTap: () => _onTileTap(context, ref, summary),
              ),
            )
            .toList(),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.space8),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  void _onTileTap(
    BuildContext context,
    WidgetRef ref,
    HomeServiceSummary summary,
  ) {
    switch (summary.serviceType) {
      case ServiceType.radarr:
        ref
            .read(
              selectedLibraryInstanceIdProvider(ServiceType.radarr).notifier,
            )
            .selectInstance(summary.instanceId);
        context.go(RoutePaths.library);
      case ServiceType.sonarr:
        ref
            .read(
              selectedLibraryInstanceIdProvider(ServiceType.sonarr).notifier,
            )
            .selectInstance(summary.instanceId);
        context.go(RoutePaths.library);
      case ServiceType.bazarr:
        context.go(RoutePaths.activitySubtitles(summary.instanceId));
      case ServiceType.uptimeKuma:
        ref
            .read(selectedUptimeInstanceIdProvider.notifier)
            .selectInstance(summary.instanceId);
        context.go(RoutePaths.homeUptime);
      case ServiceType.prowlarr:
        context.go(RoutePaths.homeIndexers(summary.instanceId));
      case ServiceType.seerr:
        ref
            .read(selectedSeerrInstanceIdProvider.notifier)
            .selectInstance(summary.instanceId);
        context.go(RoutePaths.homeDiscover);
      case ServiceType.einthusan:
        context.go(RoutePaths.homeEinthusanImport(summary.instanceId));
      case ServiceType.qbittorrent:
        break;
    }
  }
}

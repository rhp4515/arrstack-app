/// Vertical list of Sonarr series as poster-left rows (spec §7), matching the
/// app mockups. Handles loading, empty, and error states for one instance.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/status_chip.dart';
import 'package:arrstack/features/library/widgets/media_list_tile.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeriesList extends ConsumerWidget {
  const SeriesList({required this.instanceId, this.query = '', super.key});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(sonarrSeriesProvider(instanceId));

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _list(context, ref, _filter(value)),
        Err(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load series',
          message: error.userMessage,
          action: FilledButton(
            onPressed: () => ref.invalidate(sonarrSeriesProvider(instanceId)),
            child: const Text('Retry'),
          ),
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  List<SonarrSeries> _filter(List<SonarrSeries> series) {
    if (query.isEmpty) return series;
    final q = query.toLowerCase();
    return series.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  Widget _list(BuildContext context, WidgetRef ref, List<SonarrSeries> series) {
    if (series.isEmpty) {
      return const EmptyState(
        icon: Icons.tv_off_outlined,
        title: 'No series found',
        message: 'Your Sonarr library is empty or no titles match your search.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      itemCount: series.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final show = series[index];
        return MediaListTile(
          service: ServiceType.sonarr,
          instanceId: instanceId,
          posterUrl: show.posterUrl,
          title: show.title,
          year: show.year,
          studioOrNetwork: show.network,
          pill: StatusChip(
            label: show.monitored ? 'Monitored' : 'Unmonitored',
            color: show.monitored ? Colors.green : Colors.grey,
          ),
          pillTrailing: show.episodeProgressLabel,
          onTap: show.id == null
              ? null
              : () => context.go(RoutePaths.seriesDetail(instanceId, show.id!)),
        );
      },
    );
  }
}

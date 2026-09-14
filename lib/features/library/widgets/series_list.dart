/// Vertical, fading-rule-separated list of Sonarr series (spec 2d "ALL
/// SHOWS"). Handles loading, empty, and error states for one instance.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeriesList extends ConsumerWidget {
  const SeriesList({
    required this.instanceId,
    this.query = '',
    this.shrinkWrap = false,
    this.physics,
    this.sort = LibrarySort.recentlyAdded,
    super.key,
  });

  final String instanceId;
  final String query;

  /// True when nested inside another scrollable (the Shows tab's outer
  /// list, which also hosts ContinueWatchingRow above this list).
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  /// Sort order applied to the filtered list before rendering rows.
  final LibrarySort sort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(sonarrSeriesProvider(instanceId));

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _list(context, ref, _sorted(_filter(value), sort)),
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

  List<SonarrSeries> _sorted(List<SonarrSeries> series, LibrarySort sort) {
    final copy = [...series];
    switch (sort) {
      case LibrarySort.recentlyAdded:
        copy.sort((a, b) {
          final da = a.added;
          final db = b.added;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          return db.compareTo(da);
        });
      case LibrarySort.title:
        copy.sort((a, b) => a.title.compareTo(b.title));
      case LibrarySort.year:
        copy.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
    }
    return copy;
  }

  Widget _list(BuildContext context, WidgetRef ref, List<SonarrSeries> series) {
    if (series.isEmpty) {
      return const EmptyState(
        icon: Icons.tv_off_outlined,
        title: 'No series found',
        message: 'Your Sonarr library is empty or no titles match your search.',
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final show = series[index];
        final stats = show.statistics;
        final have = stats?.episodeFileCount ?? 0;
        final total = stats?.totalEpisodeCount ?? stats?.episodeCount ?? 0;

        final LibraryRowTrailing trailing;
        int? percent;
        double? progress;
        if (!show.monitored) {
          trailing = LibraryRowTrailing.unmonitored;
        } else if (total > 0 && have >= total) {
          trailing = LibraryRowTrailing.percent;
          percent = 100;
        } else if (total > 0) {
          trailing = LibraryRowTrailing.progress;
          progress = have / total;
        } else {
          trailing = LibraryRowTrailing.none;
        }

        return LibraryRow(
          service: ServiceType.sonarr,
          instanceId: instanceId,
          posterUrl: show.posterUrl,
          title: show.title,
          metaParts: [
            if (show.year != null) '${show.year}',
            if (show.network != null && show.network!.isNotEmpty) show.network!,
            '$have/$total',
          ],
          trailing: trailing,
          percent: percent,
          progress: progress,
          showRule: index < series.length - 1,
          onTap: show.id == null
              ? null
              : () => context.go(RoutePaths.seriesDetail(instanceId, show.id!)),
        );
      },
    );
  }
}

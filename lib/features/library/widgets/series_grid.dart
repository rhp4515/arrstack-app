/// Adaptive grid of Sonarr series posters (spec §7).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeriesGrid extends ConsumerWidget {
  const SeriesGrid({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(sonarrSeriesProvider(instanceId));

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => value.isEmpty
            ? const EmptyState(
                icon: Icons.tv_off_outlined,
                title: 'No series found',
                message: 'Your Sonarr library is empty or the filter returned no results.',
              )
            : GridView.builder(
                padding: AppInsets.pageMd,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final series = value[index];
                  return _SeriesPoster(series: series, instanceId: instanceId);
                },
              ),
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
      error: (err, stack) => EmptyState(
        icon: Icons.error_outline,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }
}

class _SeriesPoster extends ConsumerWidget {
  const _SeriesPoster({required this.series, required this.instanceId});

  final SonarrSeries series;
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativeUrl = series.posterUrl;
    final fullUrlAsync = relativeUrl != null
        ? ref.watch(sonarrFullImageUrlProvider(
            instanceId: instanceId,
            relativeUrl: relativeUrl,
          ))
        : const AsyncData<String?>(null);

    return fullUrlAsync.when(
      data: (url) => PosterCard(
        imageUrl: url ?? '',
        title: series.title,
        monitored: series.monitored,
        onTap: () {
          context.go(RoutePaths.seriesDetail(instanceId, series.id!));
        },
      ),
      loading: () => const Card(child: Center(child: CircularProgressIndicator())),
      error: (_, __) => PosterCard(imageUrl: '', title: series.title),
    );
  }
}

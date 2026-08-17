/// Adaptive grid of Radarr movie posters (spec §7).
///
/// Handles loading, empty, and error states for a specific Radarr instance.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieGrid extends ConsumerWidget {
  const MovieGrid({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => value.isEmpty
            ? const EmptyState(
                icon: Icons.movie_filter_outlined,
                title: 'No movies found',
                message: 'Your Radarr library is empty or the filter returned no results.',
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
                  final movie = value[index];
                  return _MoviePoster(movie: movie, instanceId: instanceId);
                },
              ),
        Err(:final error) => EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load movies',
            message: error.userMessage,
            action: FilledButton(
              onPressed: () => ref.invalidate(radarrMoviesProvider(instanceId)),
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

class _MoviePoster extends ConsumerWidget {
  const _MoviePoster({required this.movie, required this.instanceId});

  final RadarrMovie movie;
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativeUrl = movie.posterUrl;
    final fullUrlAsync = relativeUrl != null
        ? ref.watch(radarrFullImageUrlProvider(
            instanceId: instanceId,
            relativeUrl: relativeUrl,
          ))
        : const AsyncData<String?>(null);

    return fullUrlAsync.when(
      data: (url) => PosterCard(
        imageUrl: url ?? '',
        title: movie.title,
        monitored: movie.monitored,
        onTap: () {
          context.go(RoutePaths.movieDetail(instanceId, movie.id!));
        },
      ),
      loading: () => const Card(child: Center(child: CircularProgressIndicator())),
      error: (_, __) => PosterCard(imageUrl: '', title: movie.title),
    );
  }
}

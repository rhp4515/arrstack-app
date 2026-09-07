/// Vertical list of Radarr movies as poster-left rows (spec §7), matching the
/// app mockups. Handles loading, empty, and error states for one instance.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/status_chip.dart';
import 'package:arrstack/features/library/widgets/media_list_tile.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieList extends ConsumerWidget {
  const MovieList({required this.instanceId, this.query = '', super.key});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _list(context, ref, _filter(value)),
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
      error: (err, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  List<RadarrMovie> _filter(List<RadarrMovie> movies) {
    if (query.isEmpty) return movies;
    final q = query.toLowerCase();
    return movies.where((m) => m.title.toLowerCase().contains(q)).toList();
  }

  Widget _list(BuildContext context, WidgetRef ref, List<RadarrMovie> movies) {
    if (movies.isEmpty) {
      return const EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'No movies found',
        message: 'Your Radarr library is empty or no titles match your search.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      itemCount: movies.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MediaListTile(
          service: ServiceType.radarr,
          instanceId: instanceId,
          posterUrl: movie.posterUrl,
          title: movie.title,
          year: movie.year,
          studioOrNetwork: movie.studio,
          pill: _qualityPill(movie),
          onTap: movie.id == null
              ? null
              : () => context.go(RoutePaths.movieDetail(instanceId, movie.id!)),
        );
      },
    );
  }

  Widget _qualityPill(RadarrMovie movie) {
    final quality = movie.displayQuality;
    if (quality != null && quality.isNotEmpty) {
      return StatusChip(label: quality, color: Colors.green);
    }
    return StatusChip(
      label: movie.monitored ? 'Missing' : 'Unmonitored',
      color: movie.monitored ? Colors.orange : Colors.grey,
    );
  }
}

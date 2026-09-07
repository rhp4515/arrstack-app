/// Grid of results for a single tapped genre pill — reuses the same
/// PosterCard grid treatment as the pre-redesign Discover grid.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GenreResultsPage extends ConsumerWidget {
  const GenreResultsPage({
    required this.instanceId,
    required this.genreId,
    required this.genreName,
    required this.mediaType,
    super.key,
  });

  final String instanceId;
  final int genreId;
  final String genreName;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveIdAsync = instanceId.isNotEmpty
        ? AsyncData(instanceId)
        : ref.watch(selectedSeerrInstanceIdProvider);

    return effectiveIdAsync.when(
      data: (finalId) {
        if (finalId == null) {
          return const Scaffold(
            body: Center(child: Text('No instance selected')),
          );
        }
        return _GenreResultsBody(
          instanceId: finalId,
          genreId: genreId,
          genreName: genreName,
          mediaType: mediaType,
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _GenreResultsBody extends ConsumerWidget {
  const _GenreResultsBody({
    required this.instanceId,
    required this.genreId,
    required this.genreName,
    required this.mediaType,
  });

  final String instanceId;
  final int genreId;
  final String genreName;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = mediaType == 'tv'
        ? ref.watch(
            seerrTvByGenreProvider(instanceId: instanceId, genreId: genreId),
          )
        : ref.watch(
            seerrMoviesByGenreProvider(
              instanceId: instanceId,
              genreId: genreId,
            ),
          );

    return Scaffold(
      appBar: AppBar(title: Text(genreName)),
      body: resultsAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) =>
            value.isEmpty
                ? const EmptyState(icon: Icons.search_off, title: 'No results')
                : GridView.builder(
                    padding: AppInsets.pageMd,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 150,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 2 / 3,
                        ),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final item = value[index];
                      return PosterCard(
                        imageUrl: item.posterUrl ?? '',
                        title: item.displayTitle ?? '',
                        onTap: () => context.go(
                          RoutePaths.discoverDetail(
                            instanceId,
                            item.id,
                            item.mediaType,
                          ),
                        ),
                      );
                    },
                  ),
          Err(:final error) => EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load genre',
            message: error.userMessage,
          ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

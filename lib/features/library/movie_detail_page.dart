/// Movie detail page (spec §7).
///
/// Displays artwork, overview, and management actions for a specific movie.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/service_accents.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/status_chip.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailPage extends ConsumerWidget {
  const MovieDetailPage({
    required this.instanceId,
    required this.movieId,
    super.key,
  });

  final String instanceId;
  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(radarrMovieProvider(
      instanceId: instanceId,
      movieId: movieId,
    ));

    return movieAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _MovieDetailContent(instanceId: instanceId, movie: value),
        Err(:final error) => Scaffold(
            appBar: AppBar(),
            body: EmptyState(
              icon: Icons.error_outline,
              title: 'Failed to load movie',
              message: error.userMessage,
            ),
          ),
      },
      loading: () => Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }
}

class _MovieDetailContent extends ConsumerWidget {
  const _MovieDetailContent({required this.instanceId, required this.movie});

  final String instanceId;
  final RadarrMovie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final fanartUrl = movie.images.firstWhere((i) => i.coverType == 'fanart', orElse: () => movie.images.first).url;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie.title),
              background: _HeaderImage(
                instanceId: instanceId,
                relativeUrl: fanartUrl,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppInsets.pageMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusChip(
                        label: movie.status,
                        color: movie.hasFile ? Colors.green : Colors.orange,
                        icon: movie.hasFile ? Icons.check : Icons.downloading,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (movie.monitored)
                        const StatusChip(
                          label: 'Monitored',
                          color: ServiceAccents.radarr,
                          icon: Icons.bookmark,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${movie.year} • ${movie.movieFile?.quality.quality.name ?? 'Unknown Quality'}',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Overview',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(movie.overview),
                  const SizedBox(height: AppSpacing.xxl),
                  _ActionsGrid(instanceId: instanceId, movie: movie),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderImage extends ConsumerWidget {
  const _HeaderImage({required this.instanceId, required this.relativeUrl});

  final String instanceId;
  final String relativeUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullUrlAsync = ref.watch(radarrFullImageUrlProvider(
      instanceId: instanceId,
      relativeUrl: relativeUrl,
    ));

    return fullUrlAsync.when(
      data: (url) => url != null
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              color: Colors.black26,
              colorBlendMode: BlendMode.darken,
            )
          : Container(color: Colors.grey),
      loading: () => Container(color: Colors.grey),
      error: (_, __) => Container(color: Colors.grey),
    );
  }
}

class _ActionsGrid extends ConsumerStatefulWidget {
  const _ActionsGrid({required this.instanceId, required this.movie});

  final String instanceId;
  final RadarrMovie movie;

  @override
  ConsumerState<_ActionsGrid> createState() => _ActionsGridState();
}

class _ActionsGridState extends ConsumerState<_ActionsGrid> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isProcessing) const LinearProgressIndicator(),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: widget.movie.monitored ? Icons.bookmark_remove : Icons.bookmark_add,
                label: widget.movie.monitored ? 'Unmonitor' : 'Monitor',
                onTap: _toggleMonitored,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionButton(
                icon: Icons.search,
                label: 'Search',
                onTap: () {
                  // Radarr search command is POST /command {name: "MovieSearch", movieIds: [id]}
                  // For now, just snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search command coming soon.')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit movie options coming soon.')),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: Colors.red,
                onTap: _deleteMovie,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _toggleMonitored() async {
    setState(() => _isProcessing = true);
    final repo = await ref.read(radarrRepositoryProvider(widget.instanceId).future);
    final updated = widget.movie.copyWith(monitored: !widget.movie.monitored);
    final result = await repo.updateMovie(updated);
    
    if (mounted) {
      setState(() => _isProcessing = false);
      if (result is Ok) {
        ref.invalidate(radarrMovieProvider(instanceId: widget.instanceId, movieId: widget.movie.id!));
        ref.invalidate(radarrMoviesProvider(widget.instanceId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
        );
      }
    }
  }

  Future<void> _deleteMovie() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Movie?'),
        content: Text('Remove "${widget.movie.title}" from library?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isProcessing = true);
      final repo = await ref.read(radarrRepositoryProvider(widget.instanceId).future);
      final result = await repo.deleteMovie(widget.movie.id!);
      
      if (mounted) {
        setState(() => _isProcessing = false);
        if (result is Ok) {
          ref.invalidate(radarrMoviesProvider(widget.instanceId));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
          );
        }
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalColor = color ?? theme.colorScheme.primary;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: finalColor),
      label: Text(label, style: TextStyle(color: finalColor)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: finalColor.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

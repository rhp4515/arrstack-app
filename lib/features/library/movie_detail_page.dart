/// Movie detail page (spec §7).
///
/// Displays artwork, overview, and management actions for a specific movie.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/service_accents.dart';
import 'package:arrstack/core/network/network.dart';
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
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) {
        if (result case Ok(:final value)) {
          final movie = value.firstWhere((m) => m.id == movieId);
          return _MovieDetailContent(instanceId: instanceId, movie: movie);
        }
        return Scaffold(appBar: AppBar(), body: const Center(child: Text('Error')));
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

class _ActionsGrid extends ConsumerWidget {
  const _ActionsGrid({required this.instanceId, required this.movie});

  final String instanceId;
  final RadarrMovie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: movie.monitored ? Icons.bookmark_remove : Icons.bookmark_add,
                label: movie.monitored ? 'Unmonitor' : 'Monitor',
                onTap: () {
                  // TODO: Implement toggle monitor
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionButton(
                icon: Icons.search,
                label: 'Search',
                onTap: () {
                  // TODO: Trigger search
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
                  // TODO: Edit movie
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: Colors.red,
                onTap: () {
                  // TODO: Delete movie
                },
              ),
            ),
          ],
        ),
      ],
    );
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

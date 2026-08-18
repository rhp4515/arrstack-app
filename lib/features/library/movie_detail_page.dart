/// Movie detail page (spec §7).
///
/// Poster-forward layout matching the app mockups: centered artwork, title,
/// "year · studio · certification", a row of rating/monitored/link chips, an
/// expandable Overview, and an expandable Details & File section. Management
/// actions live in the top-right overflow menu.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final movieAsync = ref.watch(
      radarrMovieProvider(instanceId: instanceId, movieId: movieId),
    );

    return movieAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) =>
          _MovieDetailContent(instanceId: instanceId, movie: value),
        Err(:final error) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load movie',
            message: error.userMessage,
          ),
        ),
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }
}

class _MovieDetailContent extends ConsumerStatefulWidget {
  const _MovieDetailContent({required this.instanceId, required this.movie});

  final String instanceId;
  final RadarrMovie movie;

  @override
  ConsumerState<_MovieDetailContent> createState() =>
      _MovieDetailContentState();
}

class _MovieDetailContentState extends ConsumerState<_MovieDetailContent> {
  bool _isProcessing = false;

  RadarrMovie get movie => widget.movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final metaParts = <String>[
      '${movie.year}',
      if (movie.studio != null && movie.studio!.isNotEmpty) movie.studio!,
      if (movie.certification != null && movie.certification!.isNotEmpty)
        movie.certification!,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'monitor',
                child: Text(movie.monitored ? 'Unmonitor' : 'Monitor'),
              ),
              const PopupMenuItem(value: 'search', child: Text('Search')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xxl,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: LinearProgressIndicator(),
            ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ResolvedPoster(
                service: ServiceType.radarr,
                instanceId: widget.instanceId,
                relativeUrl: movie.posterUrl,
                width: 210,
                height: 315,
                radius: AppRadius.lg,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            movie.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            metaParts.join(' · '),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.md),
          _ChipRow(movie: movie),
          const SizedBox(height: AppSpacing.lg),
          _OverviewCard(movie: movie),
          const SizedBox(height: AppSpacing.md),
          _DetailsCard(movie: movie),
        ],
      ),
    );
  }

  Future<void> _onMenuSelected(String value) async {
    switch (value) {
      case 'monitor':
        await _toggleMonitored();
      case 'search':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search command coming soon.')),
        );
      case 'delete':
        await _deleteMovie();
    }
  }

  Future<void> _toggleMonitored() async {
    setState(() => _isProcessing = true);
    final repo = await ref.read(
      radarrRepositoryProvider(widget.instanceId).future,
    );
    final updated = movie.copyWith(monitored: !movie.monitored);
    final result = await repo.updateMovie(updated);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(
        radarrMovieProvider(instanceId: widget.instanceId, movieId: movie.id!),
      );
      ref.invalidate(radarrMoviesProvider(widget.instanceId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }

  Future<void> _deleteMovie() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Movie?'),
        content: Text('Remove "${movie.title}" from library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isProcessing = true);
    final repo = await ref.read(
      radarrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repo.deleteMovie(movie.id!);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(radarrMoviesProvider(widget.instanceId));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }
}

/// Rating + monitored + external-link chips beneath the title.
class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.movie});

  final RadarrMovie movie;

  @override
  Widget build(BuildContext context) {
    final rating = movie.displayRating;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (rating != null && rating > 0)
          DetailChip(
            label: '★ ${rating.toStringAsFixed(1)}',
            color: const Color(0xFFF5C518),
          ),
        if (movie.monitored)
          const DetailChip(label: 'Monitored', color: Colors.green),
        if (movie.imdbId != null && movie.imdbId!.isNotEmpty)
          DetailChip(
            label: 'IMDb',
            color: const Color(0xFFD9A400),
            onTap: () => _copy(
              context,
              'https://www.imdb.com/title/${movie.imdbId}',
              'IMDb',
            ),
          ),
        DetailChip(
          label: 'TMDB',
          color: const Color(0xFF3B82F6),
          onTap: () => _copy(
            context,
            'https://www.themoviedb.org/movie/${movie.tmdbId}',
            'TMDB',
          ),
        ),
      ],
    );
  }

  Future<void> _copy(BuildContext context, String url, String name) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name link copied to clipboard')),
    );
  }
}

/// Expandable overview with genre chips.
class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.movie});

  final RadarrMovie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          title: Text(
            'Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                movie.overview.isEmpty
                    ? 'No overview available.'
                    : movie.overview,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (movie.genres.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  movie.genres.join(' · '),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Expandable file/technical details.
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.movie});

  final RadarrMovie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <(String, String)>[
      ('Quality', movie.displayQuality ?? '—'),
      ('Status', movie.status),
      if (movie.runtime != null && movie.runtime! > 0)
        ('Runtime', '${movie.runtime} min'),
      (
        'On disk',
        movie.hasFile ? _formatBytes(movie.sizeOnDisk) : 'Not downloaded',
      ),
      if (movie.path != null && movie.path!.isNotEmpty) ('Path', movie.path!),
    ];

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          title: Text(
            'Details & File',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 92,
                      child: Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(value, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    return '${size.toStringAsFixed(size >= 10 || unit == 0 ? 0 : 1)} ${units[unit]}';
  }
}

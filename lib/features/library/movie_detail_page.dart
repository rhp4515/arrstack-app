/// Movie detail page (spec 2g): same anatomy as series detail so the two
/// read as one product, with movie-specific stats, a genre line, and
/// IMDb/TMDB/Subtitles buttons.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:arrstack/features/library/widgets/spec_block.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        Ok(:final value) => _MovieDetailContent(
          instanceId: instanceId,
          movie: value,
        ),
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
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
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
    final file = movie.movieFile;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'monitor',
                child: Text(movie.monitored ? 'Unmonitor' : 'Monitor'),
              ),
              const PopupMenuItem(value: 'search', child: Text('Search Movie')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.screenHorizontal,
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.space4),
              child: LinearProgressIndicator(),
            ),
          MediaDetailHeader(
            service: ServiceType.radarr,
            instanceId: widget.instanceId,
            posterUrl: movie.posterUrl,
            title: movie.title,
            metaParts: [
              '${movie.year}',
              if (movie.studio != null && movie.studio!.isNotEmpty)
                movie.studio!,
              if (movie.certification != null &&
                  movie.certification!.isNotEmpty)
                movie.certification!,
            ],
            chips: [
              if ((movie.displayRating ?? 0) > 0)
                _tag(
                  '★ ${movie.displayRating!.toStringAsFixed(1)}',
                  filled: true,
                ),
              if (movie.monitored) _tag('Monitored', filled: false),
            ],
            stats: [
              (movie.displayQuality ?? '—', 'QUALITY'),
              (
                movie.hasFile
                    ? FormatUtils.formatBytes(movie.sizeOnDisk)
                    : '0 B',
                'ON DISK',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          if (movie.overview != null && movie.overview!.isNotEmpty)
            Text(movie.overview!, style: AppTypography.body),
          if (movie.genres != null && movie.genres!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              movie.genres!.join(' · '),
              style: AppTypography.meta.copyWith(
                color: AppColors.n500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          if (file != null)
            SpecBlock(
              kicker: 'FILE',
              rows: [
                if (file.releaseGroup != null) ('Release', file.releaseGroup!),
                if (_videoLabel(file.mediaInfo) != null)
                  ('Video', _videoLabel(file.mediaInfo)!),
                if (_audioLabel(file.mediaInfo) != null)
                  ('Audio', _audioLabel(file.mediaInfo)!),
                if (movie.added != null) ('Added', _formatDate(movie.added!)),
                if (movie.path != null && movie.path!.isNotEmpty)
                  ('Path', movie.path!),
              ],
            ),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              if (movie.imdbId != null && movie.imdbId!.isNotEmpty) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _copy(
                      'https://www.imdb.com/title/${movie.imdbId}',
                      'IMDb',
                    ),
                    child: const Text('IMDb'),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
              ],
              if (movie.tmdbId != null) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _copy(
                      'https://www.themoviedb.org/movie/${movie.tmdbId}',
                      'TMDB',
                    ),
                    child: const Text('TMDB'),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: _searchSubtitlesInBazarr,
                  child: const Text('Subtitles'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _videoLabel(RadarrMediaInfo? mediaInfo) {
    if (mediaInfo == null) return null;
    final parts = [
      if (mediaInfo.videoCodec != null) mediaInfo.videoCodec!,
      if (mediaInfo.videoDynamicRangeType != null)
        mediaInfo.videoDynamicRangeType!,
      if (mediaInfo.resolution != null) mediaInfo.resolution!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String? _audioLabel(RadarrMediaInfo? mediaInfo) {
    if (mediaInfo == null) return null;
    final parts = [
      if (mediaInfo.audioCodec != null) mediaInfo.audioCodec!,
      if (mediaInfo.audioChannels != null) '${mediaInfo.audioChannels}',
    ];
    return parts.isEmpty ? null : parts.join(' ');
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  Widget _tag(String label, {required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? AppColors.accent.withValues(alpha: 0.16) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.meta.copyWith(color: AppColors.accent),
      ),
    );
  }

  Future<void> _copy(String url, String name) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name link copied to clipboard')));
  }

  Future<void> _onMenuSelected(String value) async {
    switch (value) {
      case 'monitor':
        await _toggleMonitored();
      case 'search':
        {
          final label = movie.year != null
              ? '${movie.title} (${movie.year})'
              : movie.title;
          context.push(
            RoutePaths.movieReleaseSearch(widget.instanceId, movie.id!, label),
          );
        }
      case 'delete':
        await _deleteMovie();
    }
  }

  Future<void> _searchSubtitlesInBazarr() async {
    final bazarrInstance = await ref.read(primaryBazarrInstanceProvider.future);
    if (bazarrInstance == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Bazarr instance configured in the app.'),
          ),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    final repo = await ref.read(
      bazarrRepositoryProvider(bazarrInstance.id).future,
    );
    final result = await repo.searchSubtitle(
      BazarrWantedSubtitle(
        title: movie.title,
        type: 'movie',
        radarrId: movie.id,
        path: '',
      ),
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtitle search triggered in Bazarr for "${movie.title}"',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bazarr search failed: ${result.errorOrNull?.userMessage}',
          ),
        ),
      );
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

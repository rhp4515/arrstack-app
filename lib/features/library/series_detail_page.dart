/// Series detail page (spec 2e): poster beside the title, a 2-up stat
/// row, and expandable season rows with progress bars.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:arrstack/features/library/widgets/season_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SeriesDetailPage extends ConsumerWidget {
  const SeriesDetailPage({
    required this.instanceId,
    required this.seriesId,
    super.key,
  });

  final String instanceId;
  final int seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(
      sonarrSingleSeriesProvider(instanceId: instanceId, seriesId: seriesId),
    );

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _SeriesDetailContent(
          instanceId: instanceId,
          series: value,
        ),
        Err(:final error) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load series',
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

class _SeriesDetailContent extends ConsumerStatefulWidget {
  const _SeriesDetailContent({required this.instanceId, required this.series});

  final String instanceId;
  final SonarrSeries series;

  @override
  ConsumerState<_SeriesDetailContent> createState() =>
      _SeriesDetailContentState();
}

class _SeriesDetailContentState extends ConsumerState<_SeriesDetailContent> {
  bool _isProcessing = false;

  SonarrSeries get series => widget.series;

  @override
  Widget build(BuildContext context) {
    final stats = series.statistics;
    final have = stats?.episodeFileCount ?? 0;
    final total = stats?.totalEpisodeCount ?? stats?.episodeCount ?? 0;
    final seasons = [...?series.seasons]
      ..sort((a, b) => (a.seasonNumber ?? 0).compareTo(b.seasonNumber ?? 0));
    final rating = series.ratings?.value;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 17),
            tooltip: 'Search',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Search command coming soon.')),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'monitor',
                child: Text(series.monitored ? 'Unmonitor' : 'Monitor'),
              ),
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
            service: ServiceType.sonarr,
            instanceId: widget.instanceId,
            posterUrl: series.posterUrl,
            title: series.title,
            metaParts: [
              if (series.year != null) '${series.year}',
              if (series.network != null && series.network!.isNotEmpty)
                series.network!,
              if (series.certification != null &&
                  series.certification!.isNotEmpty)
                series.certification!,
            ],
            chips: [
              if (rating != null && rating > 0)
                _tag('★ ${rating.toStringAsFixed(1)}', filled: true),
              if (series.monitored) _tag('Monitored', filled: false),
            ],
            stats: [
              ('$have/$total', 'EPISODES'),
              (
                stats?.sizeOnDisk != null && stats!.sizeOnDisk! > 0
                    ? FormatUtils.formatBytes(stats.sizeOnDisk!)
                    : '0 B',
                'ON DISK',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          if (series.overview != null && series.overview!.isNotEmpty)
            Text(series.overview!, style: AppTypography.body),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          Text('SEASONS · ${seasons.length}', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space2),
          for (final season in seasons)
            SeasonRow(
              label: (season.seasonNumber ?? 0) == 0
                  ? 'Specials'
                  : 'Season ${season.seasonNumber}',
              have: season.statistics?.episodeFileCount ?? 0,
              total: season.statistics?.totalEpisodeCount ?? 0,
              episodes: (context) => _SeasonEpisodes(
                instanceId: widget.instanceId,
                seriesId: series.id!,
                seasonNumber: season.seasonNumber ?? 0,
              ),
            ),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
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

  Future<void> _onMenuSelected(String value) async {
    switch (value) {
      case 'monitor':
        await _toggleMonitored();
      case 'delete':
        await _deleteSeries();
    }
  }

  Future<void> _toggleMonitored() async {
    setState(() => _isProcessing = true);
    final repo = await ref.read(
      sonarrRepositoryProvider(widget.instanceId).future,
    );
    final updated = series.copyWith(monitored: !series.monitored);
    final result = await repo.updateSeries(updated);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(
        sonarrSingleSeriesProvider(
          instanceId: widget.instanceId,
          seriesId: series.id!,
        ),
      );
      ref.invalidate(sonarrSeriesProvider(widget.instanceId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }

  Future<void> _deleteSeries() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Series?'),
        content: Text('Remove "${series.title}" from library?'),
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
      sonarrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repo.deleteSeries(series.id!);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(sonarrSeriesProvider(widget.instanceId));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }
}

class _SeasonEpisodes extends ConsumerWidget {
  const _SeasonEpisodes({
    required this.instanceId,
    required this.seriesId,
    required this.seasonNumber,
  });

  final String instanceId;
  final int seriesId;
  final int seasonNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(
      sonarrEpisodesProvider(instanceId: instanceId, seriesId: seriesId),
    );

    return episodesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => Column(
          children: [
            for (final episode
                in value.where((e) => e.seasonNumber == seasonNumber).toList()
                  ..sort(
                    (a, b) =>
                        (a.episodeNumber ?? 0).compareTo(b.episodeNumber ?? 0),
                  ))
              InkWell(
                onTap: () => context.go(
                  RoutePaths.episodeDetail(instanceId, seriesId, episode.id),
                ),
                child: EpisodeRow(
                  code: episode.episodeCode,
                  title: episode.title ?? 'Unknown Episode',
                  hasFile: episode.hasFile,
                  qualityLabel: episode.qualityName,
                ),
              ),
          ],
        ),
        Err() => const Padding(
          padding: EdgeInsets.all(AppSpacing.space4),
          child: Text('Failed to load episodes'),
        ),
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.space4),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const Padding(
        padding: EdgeInsets.all(AppSpacing.space4),
        child: Text('Failed to load episodes'),
      ),
    );
  }
}

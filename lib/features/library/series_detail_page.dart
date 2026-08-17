/// Series detail page (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/status_chip.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final seriesAsync = ref.watch(sonarrSingleSeriesProvider(
      instanceId: instanceId,
      seriesId: seriesId,
    ));

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _SeriesDetailContent(instanceId: instanceId, series: value),
        Err(:final error) => Scaffold(
            appBar: AppBar(),
            body: EmptyState(
              icon: Icons.error_outline,
              title: 'Failed to load series',
              message: error.userMessage,
            ),
          ),
      },
      loading: () => Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }
}

class _SeriesDetailContent extends ConsumerWidget {
  const _SeriesDetailContent({required this.instanceId, required this.series});

  final String instanceId;
  final SonarrSeries series;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final images = series.images ?? [];
    final fanartUrl = images.isNotEmpty 
        ? images.firstWhere((i) => i.coverType == 'fanart', orElse: () => images.first).url
        : null;

    final seasons = series.seasons ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(series.title),
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
                        label: series.status ?? 'Unknown',
                        color: series.status == 'continuing' ? Colors.green : Colors.grey,
                        icon: series.status == 'continuing' ? Icons.play_circle_outline : Icons.stop_circle,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (series.monitored)
                        const StatusChip(
                          label: 'Monitored',
                          color: Colors.blue,
                          icon: Icons.bookmark,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${series.year ?? 'N/A'} • ${series.seriesType} • ${series.runtime ?? '??'} min',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Overview',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(series.overview ?? 'No overview available.'),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Seasons',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final season = seasons.reversed.toList()[index];
                return _SeasonTile(instanceId: instanceId, seriesId: series.id!, season: season);
              },
              childCount: seasons.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppInsets.pageMd,
              child: _ActionsGrid(instanceId: instanceId, series: series),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonTile extends ConsumerWidget {
  const _SeasonTile({
    required this.instanceId,
    required this.seriesId,
    required this.season,
  });

  final String instanceId;
  final int seriesId;
  final SonarrSeason season;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonNumber = season.seasonNumber ?? 0;
    return ExpansionTile(
      title: Text('Season ${seasonNumber == 0 ? 'Specials' : seasonNumber}'),
      subtitle: season.statistics != null
          ? Text('${season.statistics!.episodeFileCount ?? 0}/${season.statistics!.totalEpisodeCount ?? 0} episodes')
          : null,
      children: [
        _EpisodeList(instanceId: instanceId, seriesId: seriesId, seasonNumber: seasonNumber),
      ],
    );
  }
}

class _EpisodeList extends ConsumerWidget {
  const _EpisodeList({
    required this.instanceId,
    required this.seriesId,
    required this.seasonNumber,
  });

  final String instanceId;
  final int seriesId;
  final int seasonNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(sonarrEpisodesProvider(instanceId: instanceId, seriesId: seriesId));

    return episodesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => Column(
            children: value
                .where((e) => e.seasonNumber == seasonNumber)
                .map((e) => ListTile(
                      title: Text('${e.episodeNumber}. ${e.title}'),
                      trailing: Icon(
                        e.hasFile ? Icons.check_circle : Icons.download_for_offline_outlined,
                        color: e.hasFile ? Colors.green : Colors.grey,
                        size: 18,
                      ),
                    ))
                .toList(),
          ),
        Err() => const ListTile(title: Text('Error loading episodes')),
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: LinearProgressIndicator(),
      ),
      error: (_, __) => const ListTile(title: Text('Error')),
    );
  }
}

class _HeaderImage extends ConsumerWidget {
  const _HeaderImage({required this.instanceId, required this.relativeUrl});

  final String instanceId;
  final String? relativeUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relUrl = relativeUrl;
    if (relUrl == null || relUrl.isEmpty) return Container(color: Colors.grey);

    final fullUrlAsync = ref.watch(sonarrFullImageUrlProvider(
      instanceId: instanceId,
      relativeUrl: relUrl,
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
  const _ActionsGrid({required this.instanceId, required this.series});

  final String instanceId;
  final SonarrSeries series;

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
                icon: widget.series.monitored ? Icons.bookmark_remove : Icons.bookmark_add,
                label: widget.series.monitored ? 'Unmonitor' : 'Monitor',
                onTap: _toggleMonitored,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionButton(
                icon: Icons.search,
                label: 'Search',
                onTap: () {
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
                    const SnackBar(content: Text('Edit series options coming soon.')),
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
                onTap: _deleteSeries,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _toggleMonitored() async {
    setState(() => _isProcessing = true);
    final repo = await ref.read(sonarrRepositoryProvider(widget.instanceId).future);
    final updated = widget.series.copyWith(monitored: !widget.series.monitored);
    final result = await repo.updateSeries(updated);
    
    if (mounted) {
      setState(() => _isProcessing = false);
      if (result is Ok) {
        ref.invalidate(sonarrSingleSeriesProvider(instanceId: widget.instanceId, seriesId: widget.series.id!));
        ref.invalidate(sonarrSeriesProvider(widget.instanceId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
        );
      }
    }
  }

  Future<void> _deleteSeries() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Series?'),
        content: Text('Remove "${widget.series.title}" from library?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isProcessing = true);
      final repo = await ref.read(sonarrRepositoryProvider(widget.instanceId).future);
      final result = await repo.deleteSeries(widget.series.id!);
      
      if (mounted) {
        setState(() => _isProcessing = false);
        if (result is Ok) {
          ref.invalidate(sonarrSeriesProvider(widget.instanceId));
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

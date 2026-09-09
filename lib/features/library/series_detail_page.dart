/// Series detail page (spec §7).
///
/// Poster-forward layout matching the app mockups: artwork, title,
/// "year · network · certification", rating/monitored/link chips, expandable
/// Overview and Details, then a Seasons list that expands into episode cards.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final metaParts = <String>[
      if (series.year != null) '${series.year}',
      if (series.network != null && series.network!.isNotEmpty) series.network!,
      if (series.certification != null && series.certification!.isNotEmpty)
        series.certification!,
    ];

    final seasons = [...?series.seasons]
      ..sort((a, b) => (a.seasonNumber ?? 0).compareTo(b.seasonNumber ?? 0));

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
                child: Text(series.monitored ? 'Unmonitor' : 'Monitor'),
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
          LegacySpacing.md,
          LegacySpacing.xxl,
          LegacySpacing.md,
          LegacySpacing.xl,
        ),
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: LegacySpacing.md),
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
                service: ServiceType.sonarr,
                instanceId: widget.instanceId,
                relativeUrl: series.posterUrl,
                width: 210,
                height: 315,
                radius: AppRadius.lg,
              ),
            ),
          ),
          const SizedBox(height: LegacySpacing.lg),
          Text(
            series.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (metaParts.isNotEmpty) ...[
            const SizedBox(height: LegacySpacing.sm),
            Text(
              metaParts.join(' · '),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(color: muted),
            ),
          ],
          const SizedBox(height: LegacySpacing.md),
          _ChipRow(series: series),
          const SizedBox(height: LegacySpacing.lg),
          _OverviewCard(series: series),
          const SizedBox(height: LegacySpacing.md),
          _DetailsCard(series: series),
          const SizedBox(height: LegacySpacing.lg),
          Text(
            'Seasons',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: LegacySpacing.sm),
          for (final season in seasons)
            _SeasonTile(
              instanceId: widget.instanceId,
              seriesId: series.id!,
              season: season,
            ),
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

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.series});

  final SonarrSeries series;

  @override
  Widget build(BuildContext context) {
    final rating = series.ratings?.value;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: LegacySpacing.sm,
      runSpacing: LegacySpacing.sm,
      children: [
        if (rating != null && rating > 0)
          DetailChip(
            label: '★ ${rating.toStringAsFixed(1)}',
            color: const Color(0xFFF5C518),
          ),
        if (series.monitored)
          const DetailChip(label: 'Monitored', color: Colors.green),
        if (series.imdbId != null && series.imdbId!.isNotEmpty)
          DetailChip(
            label: 'IMDb',
            color: const Color(0xFFD9A400),
            onTap: () => _copy(
              context,
              'https://www.imdb.com/title/${series.imdbId}',
              'IMDb',
            ),
          ),
        if (series.tvdbId != null && series.tvdbId! > 0)
          DetailChip(
            label: 'TVDB',
            color: const Color(0xFF6DA13A),
            onTap: () => _copy(
              context,
              'https://thetvdb.com/?tab=series&id=${series.tvdbId}',
              'TVDB',
            ),
          ),
      ],
    );
  }

  Future<void> _copy(BuildContext context, String url, String name) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name link copied to clipboard')));
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.series});

  final SonarrSeries series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genres = series.genres ?? const [];
    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: LegacySpacing.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            LegacySpacing.md,
            0,
            LegacySpacing.md,
            LegacySpacing.md,
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
                (series.overview == null || series.overview!.isEmpty)
                    ? 'No overview available.'
                    : series.overview!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (genres.isNotEmpty) ...[
              const SizedBox(height: LegacySpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  genres.join(' · '),
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

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.series});

  final SonarrSeries series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = series.statistics;
    final rows = <(String, String)>[
      if (stats?.seasonCount != null) ('Seasons', '${stats!.seasonCount}'),
      if (stats != null)
        (
          'Episodes',
          '${stats.episodeFileCount ?? 0}/${stats.totalEpisodeCount ?? 0}',
        ),
      if (series.status != null) ('Status', _titleCase(series.status!)),
      if (series.network != null && series.network!.isNotEmpty)
        ('Network', series.network!),
      if (series.runtime != null && series.runtime! > 0)
        ('Runtime', '${series.runtime}m'),
      if (stats?.sizeOnDisk != null && stats!.sizeOnDisk! > 0)
        ('Size on Disk', FormatUtils.formatBytes(stats.sizeOnDisk!)),
      if (series.path != null && series.path!.isNotEmpty)
        ('Path', series.path!),
    ];

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: LegacySpacing.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            LegacySpacing.md,
            0,
            LegacySpacing.md,
            LegacySpacing.md,
          ),
          title: Text(
            'Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: LegacySpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 104,
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

  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

/// A collapsible season: name, monitored bookmark, count pill, and — when
/// expanded — the season's episode cards.
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
    final theme = Theme.of(context);
    final number = season.seasonNumber ?? 0;
    final title = number == 0 ? 'Specials' : 'Season $number';
    final have = season.statistics?.episodeFileCount ?? 0;
    final total = season.statistics?.totalEpisodeCount ?? 0;

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.only(bottom: LegacySpacing.sm),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: LegacySpacing.md,
            vertical: LegacySpacing.xs,
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                season.monitored ? Icons.bookmark : Icons.bookmark_border,
                size: 18,
                color: season.monitored
                    ? Colors.green
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: LegacySpacing.sm),
              _CountPill(have: have, total: total),
              const SizedBox(width: LegacySpacing.xs),
              const Icon(Icons.expand_more),
            ],
          ),
          children: [
            _SeasonEpisodes(
              instanceId: instanceId,
              seriesId: seriesId,
              seasonNumber: number,
            ),
          ],
        ),
      ),
    );
  }
}

/// A green/orange/red "have/total" pill for a season's download progress.
class _CountPill extends StatelessWidget {
  const _CountPill({required this.have, required this.total});

  final int have;
  final int total;

  @override
  Widget build(BuildContext context) {
    final color = total > 0 && have >= total
        ? Colors.green
        : have == 0
        ? Colors.red
        : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LegacySpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        '$have/$total',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
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
              _EpisodeCard(
                instanceId: instanceId,
                seriesId: seriesId,
                episode: episode,
              ),
          ],
        ),
        Err() => const Padding(
          padding: EdgeInsets.all(LegacySpacing.md),
          child: Text('Failed to load episodes'),
        ),
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(LegacySpacing.md),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const Padding(
        padding: EdgeInsets.all(LegacySpacing.md),
        child: Text('Failed to load episodes'),
      ),
    );
  }
}

class _EpisodeCard extends StatelessWidget {
  const _EpisodeCard({
    required this.instanceId,
    required this.seriesId,
    required this.episode,
  });

  final String instanceId;
  final int seriesId;
  final SonarrEpisode episode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final accent = theme.colorScheme.primary;
    final quality = episode.qualityName;

    final metaParts = <String>[
      if (episode.airDateUtc != null)
        _formatDate(episode.airDateUtc!.toLocal()),
      if (episode.runtime != null && episode.runtime! > 0)
        '${episode.runtime}m',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: LegacySpacing.sm),
      child: InkWell(
        onTap: () => context.go(
          RoutePaths.episodeDetail(instanceId, seriesId, episode.id),
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(LegacySpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    episode.episodeCode,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (quality != null && quality.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LegacySpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        quality,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: LegacySpacing.xs),
              Text(
                episode.title ?? 'Unknown Episode',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (metaParts.isNotEmpty) ...[
                const SizedBox(height: LegacySpacing.xs),
                Text(
                  metaParts.join('  ·  '),
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
              if (episode.overview != null && episode.overview!.isNotEmpty) ...[
                const SizedBox(height: LegacySpacing.sm),
                Text(
                  episode.overview!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
              Row(
                children: [
                  const Spacer(),
                  Icon(
                    episode.monitored ? Icons.bookmark : Icons.bookmark_border,
                    size: 18,
                    color: episode.monitored ? accent : muted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}

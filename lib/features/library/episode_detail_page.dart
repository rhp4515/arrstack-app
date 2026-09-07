import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EpisodeDetailPage extends ConsumerWidget {
  const EpisodeDetailPage({
    required this.instanceId,
    required this.seriesId,
    required this.episodeId,
    super.key,
  });

  final String instanceId;
  final int seriesId;
  final int episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeAsync = ref.watch(
      sonarrEpisodeProvider(
        instanceId: instanceId,
        seriesId: seriesId,
        episodeId: episodeId,
      ),
    );

    return episodeAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _EpisodeDetailContent(
          instanceId: instanceId,
          seriesId: seriesId,
          episode: value,
        ),
        Err(:final error) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load episode',
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

class _EpisodeDetailContent extends ConsumerStatefulWidget {
  const _EpisodeDetailContent({
    required this.instanceId,
    required this.seriesId,
    required this.episode,
  });

  final String instanceId;
  final int seriesId;
  final SonarrEpisode episode;

  @override
  ConsumerState<_EpisodeDetailContent> createState() =>
      _EpisodeDetailContentState();
}

class _EpisodeDetailContentState extends ConsumerState<_EpisodeDetailContent> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final episode = widget.episode;
    final muted = theme.colorScheme.onSurfaceVariant;

    final airDate = episode.airDateUtc != null
        ? _formatDate(episode.airDateUtc!.toLocal())
        : 'Unknown air date';

    return Scaffold(
      appBar: AppBar(
        title: Text(episode.episodeCode),
        actions: [
          IconButton(
            icon: const Icon(Icons.subtitles_outlined),
            tooltip: 'Search Subtitles (Bazarr)',
            onPressed: _searchSubtitlesInBazarr,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search releases',
            onPressed: () => context.go(
              RoutePaths.episodeReleaseSearch(
                widget.instanceId,
                widget.seriesId,
                episode.id,
                '${episode.episodeCode} · ${episode.title ?? ''}'.trim(),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: LinearProgressIndicator(),
            ),
          Text(
            episode.title ?? 'Unknown Episode',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Season ${episode.seasonNumber}, Episode ${episode.episodeNumber} · $airDate',
            style: theme.textTheme.titleMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.md),
          _ChipRow(episode: episode),
          const SizedBox(height: AppSpacing.lg),
          _OverviewCard(episode: episode),
          const SizedBox(height: AppSpacing.md),
          _DetailsCard(episode: episode),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
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
    final episode = widget.episode;
    final repo = await ref.read(
      bazarrRepositoryProvider(bazarrInstance.id).future,
    );
    final result = await repo.searchSubtitle(
      BazarrWantedSubtitle(
        title: episode.title ?? 'Episode ${episode.episodeNumber}',
        type: 'episode',
        episodeId: episode.id,
        path: '',
      ),
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtitle search triggered in Bazarr for "${episode.title ?? 'Episode'}"',
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
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.episode});

  final SonarrEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (episode.monitored)
          const DetailChip(label: 'Monitored', color: Colors.green),
        if (episode.hasFile)
          const DetailChip(label: 'Downloaded', color: Colors.blue),
        if (episode.qualityName != null)
          DetailChip(label: episode.qualityName!, color: Colors.purple),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.episode});

  final SonarrEpisode episode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              episode.overview == null || episode.overview!.isEmpty
                  ? 'No overview available.'
                  : episode.overview!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.episode});

  final SonarrEpisode episode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final file = episode.episodeFile;

    final rows = <(String, String)>[
      if (episode.runtime != null && episode.runtime! > 0)
        ('Runtime', '${episode.runtime}m'),
      if (file != null) ...[
        ('Quality', file.quality?.quality?.name ?? '—'),
        ('Size', FormatUtils.formatBytes(file.size)),
        if (file.relativePath != null) ('Path', file.relativePath!),
      ],
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
}

/// Episode detail page (spec 2f): real primary/secondary action buttons,
/// a FILE spec block, and a SUBTITLES spec block.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/spec_block.dart';
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
    final file = episode.episodeFile;
    final airDate = episode.airDateUtc != null
        ? _formatDate(episode.airDateUtc!.toLocal())
        : 'Unknown air date';
    final seriesTitle = ref
        .watch(
          sonarrSingleSeriesProvider(
            instanceId: widget.instanceId,
            seriesId: widget.seriesId,
          ),
        )
        .maybeWhen(
          data: (result) =>
              result is Ok<SonarrSeries> ? result.value.title : '',
          orElse: () => '',
        );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (seriesTitle.isNotEmpty)
              Text(seriesTitle, style: AppTypography.kicker),
            Text(
              episode.episodeCode,
              style: AppTypography.cardTitle.copyWith(
                color: theme.colorScheme.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: AppInsets.screenHorizontal,
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.space4),
              child: LinearProgressIndicator(),
            ),
          Text(
            episode.title ?? 'Unknown Episode',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Aired $airDate'
            '${episode.runtime != null && episode.runtime! > 0 ? ' · ${episode.runtime} min' : ''}',
            style: AppTypography.meta.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          _ChipRow(episode: episode),
          const SizedBox(height: AppSpacing.space4),
          if (episode.overview != null && episode.overview!.isNotEmpty)
            Text(episode.overview!, style: AppTypography.body),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          if (file != null)
            SpecBlock(
              kicker: 'FILE',
              rows: [
                ('Quality', file.quality?.quality?.name ?? '—'),
                ('Size', FormatUtils.formatBytes(file.size)),
                if (file.mediaInfo?.videoCodec != null)
                  ('Codec', file.mediaInfo!.videoCodec!),
                if (_audioLabel(file.mediaInfo) != null)
                  ('Audio', _audioLabel(file.mediaInfo)!),
                if (file.relativePath != null) ('Path', file.relativePath!),
              ],
            ),
          const SizedBox(height: AppSpacing.space4),
          _SubtitlesBlock(episodeId: episode.id),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => context.push(
                    RoutePaths.episodeReleaseSearch(
                      widget.instanceId,
                      widget.seriesId,
                      episode.id,
                      [
                        episode.episodeCode,
                        if (episode.title != null && episode.title!.isNotEmpty)
                          episode.title!,
                      ].join(' · '),
                    ),
                  ),
                  child: const Text('Find release'),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
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

  String? _audioLabel(SonarrMediaInfo? mediaInfo) {
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
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: [
        if (episode.monitored) _tag('Monitored', filled: false),
        if (episode.hasFile) _tag('Downloaded', filled: true),
      ],
    );
  }

  Widget _tag(String label, {required bool filled}) {
    const color = AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.16) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: AppTypography.meta.copyWith(color: color)),
    );
  }
}

/// Cross-references the episode against Bazarr's wanted-subtitle list
/// (spec decision 6): languages named there render "Wanted" in red;
/// this lighter approximation has no per-language downloaded/provider
/// data, so a "Downloaded" state isn't rendered per-language here — only
/// wanted languages are shown, and the block is omitted when there are
/// none.
class _SubtitlesBlock extends ConsumerWidget {
  const _SubtitlesBlock({required this.episodeId});

  final int episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bazarrInstanceAsync = ref.watch(primaryBazarrInstanceProvider);

    return bazarrInstanceAsync.when(
      data: (instance) {
        if (instance == null) return const SizedBox.shrink();
        final wantedAsync = ref.watch(bazarrWantedProvider(instance.id));
        return wantedAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _wantedLanguagesFor(value),
            Err() => const SizedBox.shrink(),
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _wantedLanguagesFor(List<BazarrWantedSubtitle> allWanted) {
    final wanted = allWanted
        .where((w) => w.episodeId == episodeId)
        .expand((w) => w.languages)
        .toSet();

    if (wanted.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SUBTITLES', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space3),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            for (final lang in wanted)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.n900,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      lang.toUpperCase(),
                      style: AppTypography.meta.copyWith(color: AppColors.n300),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space2),
                  Text(
                    'Wanted',
                    style: AppTypography.meta.copyWith(color: AppColors.down),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

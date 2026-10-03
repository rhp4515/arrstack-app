/// The Wanted lens (spec screen 2j): everything incomplete from Sonarr and
/// Bazarr in one list, with the shared offline error card when Bazarr is
/// unreachable.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/core/widgets/lens_chip.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/missing_episode_row.dart';
import 'package:arrstack/features/activity/widgets/section_header.dart';
import 'package:arrstack/features/activity/widgets/wanted_subtitle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

enum WantedFilter { everything, episodes, subtitles }

class WantedLens extends ConsumerStatefulWidget {
  const WantedLens({super.key});

  @override
  ConsumerState<WantedLens> createState() => _WantedLensState();
}

class _WantedLensState extends ConsumerState<WantedLens> {
  WantedFilter _filter = WantedFilter.everything;

  @override
  Widget build(BuildContext context) {
    final episodesAsync = ref.watch(sonarrMissingEpisodesProvider);
    final aggregateAsync = ref.watch(bazarrWantedAggregateProvider);

    if (episodesAsync.isLoading || aggregateAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final episodes = episodesAsync.value ?? const [];
    final aggregate =
        aggregateAsync.value ??
        const BazarrWantedAggregate(
          subtitles: [],
          hasUnreachableInstance: false,
        );

    return _WantedBody(
      episodes: episodes,
      aggregate: aggregate,
      filter: _filter,
      onFilterChanged: (filter) => setState(() => _filter = filter),
    );
  }
}

class _WantedBody extends ConsumerWidget {
  const _WantedBody({
    required this.episodes,
    required this.aggregate,
    required this.filter,
    required this.onFilterChanged,
  });

  final List<SonarrMissingEpisode> episodes;
  final BazarrWantedAggregate aggregate;
  final WantedFilter filter;
  final ValueChanged<WantedFilter> onFilterChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showEpisodes =
        filter != WantedFilter.subtitles && episodes.isNotEmpty;
    final showSubtitles =
        filter != WantedFilter.episodes && aggregate.subtitles.isNotEmpty;
    final nothingWanted =
        episodes.isEmpty &&
        aggregate.subtitles.isEmpty &&
        !aggregate.hasUnreachableInstance;

    if (nothingWanted) {
      return const EmptyState(
        icon: PhosphorIconsRegular.checkCircle,
        title: 'Nothing wanted',
        message: 'All your media has files and subtitles.',
      );
    }

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        if (aggregate.hasUnreachableInstance) ...[
          ErrorCard(
            title: 'Bazarr is unreachable',
            message:
                "Subtitle searches will queue until it's back. Radarr and "
                'Sonarr are unaffected.',
            primaryActionLabel: 'Retry now',
            onPrimaryAction: () =>
                ref.invalidate(bazarrWantedAggregateProvider),
            secondaryActionLabel: 'Open settings',
            onSecondaryAction: () => context.go(RoutePaths.homeSettings),
          ),
          const SizedBox(height: AppSpacing.space4),
        ],
        _SecondaryChips(
          filter: filter,
          onChanged: onFilterChanged,
          episodeCount: episodes.length,
          subtitleCount: aggregate.subtitles.length,
        ),
        const SizedBox(height: AppSpacing.space4),
        if (showEpisodes) ...[
          SectionHeader(
            kicker: 'MISSING EPISODES · ${episodes.length}',
            trailing: 'Sonarr',
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final episode in episodes)
            MissingEpisodeRow(missingEpisode: episode),
          const SizedBox(height: AppSpacing.space4),
        ],
        if (showSubtitles) ...[
          SectionHeader(
            kicker: 'WANTED SUBTITLES · ${aggregate.subtitles.length}',
            trailing: 'queued',
            trailingColor: AppColors.down,
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final subtitle in aggregate.subtitles)
            WantedSubtitleRow(subtitle: subtitle),
        ],
      ],
    );
  }
}

class _SecondaryChips extends StatelessWidget {
  const _SecondaryChips({
    required this.filter,
    required this.onChanged,
    required this.episodeCount,
    required this.subtitleCount,
  });

  final WantedFilter filter;
  final ValueChanged<WantedFilter> onChanged;
  final int episodeCount;
  final int subtitleCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LensChip(
          secondary: true,
          label: 'Everything ${episodeCount + subtitleCount}',
          isActive: filter == WantedFilter.everything,
          onTap: () => onChanged(WantedFilter.everything),
        ),
        const SizedBox(width: AppSpacing.space2),
        LensChip(
          secondary: true,
          label: 'Episodes',
          isActive: filter == WantedFilter.episodes,
          onTap: () => onChanged(WantedFilter.episodes),
        ),
        const SizedBox(width: AppSpacing.space2),
        LensChip(
          secondary: true,
          label: 'Subtitles',
          isActive: filter == WantedFilter.subtitles,
          onTap: () => onChanged(WantedFilter.subtitles),
        ),
      ],
    );
  }
}

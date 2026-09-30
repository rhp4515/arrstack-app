/// The "Missing" sub-tab: monitored items without a file on the selected
/// instance. Radarr derives it from the movie list (monitored && !hasFile)
/// and keeps the bulk "Search all" action; Sonarr reuses the Activity
/// Wanted lens's `wanted/missing` aggregation and its row.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/missing_episode_row.dart';
import 'package:arrstack/features/library/library_format.dart';
import 'package:arrstack/features/library/library_section_providers.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/features/library/widgets/section_states.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// Monitored movies without a file, newest release first. Pure.
List<RadarrMovie> missingMovies(Iterable<RadarrMovie> movies) =>
    movies.where((m) => m.monitored && !m.hasFile).toList()..sort((a, b) {
      final da = a.calendarDate;
      final db = b.calendarDate;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });

class LibraryMissingView extends StatelessWidget {
  const LibraryMissingView({
    required this.type,
    required this.instanceId,
    this.query = '',
    super.key,
  });

  final ServiceType type;
  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context) => type == ServiceType.radarr
      ? _RadarrMissing(instanceId: instanceId, query: query)
      : _SonarrMissing(instanceId: instanceId, query: query);
}

class _RadarrMissing extends ConsumerWidget {
  const _RadarrMissing({required this.instanceId, required this.query});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));
    Future<void> refresh() async =>
        ref.invalidate(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(
          context,
          ref,
          refresh,
          missingMovies(value.where((m) => matchesQuery(query, m.title))),
        ),
        Err(:final error) => RefreshableError(
          onRefresh: refresh,
          title: 'Failed to load movies',
          message: error.userMessage,
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => RefreshableError(
        onRefresh: refresh,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() refresh,
    List<RadarrMovie> missing,
  ) {
    if (missing.isEmpty) {
      return RefreshableMessage(
        onRefresh: refresh,
        icon: PhosphorIconsRegular.checkCircle,
        title: 'Nothing missing',
        message: 'Every monitored movie has a file.',
      );
    }
    return RefreshableSection(
      onRefresh: refresh,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'MISSING · ${missing.length}',
                style: AppTypography.kicker,
              ),
            ),
            TextButton(
              onPressed: () => _searchAll(context, ref, missing),
              child: const Text('Search all'),
            ),
          ],
        ),
        for (var i = 0; i < missing.length; i++)
          LibraryRow(
            service: ServiceType.radarr,
            instanceId: instanceId,
            posterUrl: missing[i].posterUrl,
            title: missing[i].title,
            metaParts: [
              ...movieMetaParts(missing[i]),
              if (missing[i].status != null)
                prettifyIdentifier(missing[i].status!),
            ],
            trailing: LibraryRowTrailing.none,
            showChevron: missing[i].id != null,
            showRule: i < missing.length - 1,
            onTap: missing[i].id == null
                ? null
                : () => context.go(
                    RoutePaths.movieDetail(instanceId, missing[i].id!),
                  ),
          ),
      ],
    );
  }

  Future<void> _searchAll(
    BuildContext context,
    WidgetRef ref,
    List<RadarrMovie> missing,
  ) async {
    final ids = missing.map((m) => m.id).whereType<int>().toList();
    if (ids.isEmpty) return;

    final repo = await ref.read(radarrRepositoryProvider(instanceId).future);
    final result = await repo.searchMovies(ids);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isOk
              ? 'Searching for missing movies...'
              : 'Search failed: ${result.errorOrNull?.userMessage}',
        ),
      ),
    );
  }
}

class _SonarrMissing extends ConsumerWidget {
  const _SonarrMissing({required this.instanceId, required this.query});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missingAsync = ref.watch(libraryMissingEpisodesProvider(instanceId));
    Future<void> refresh() async =>
        ref.invalidate(sonarrMissingEpisodesProvider);

    return missingAsync.when(
      data: (episodes) {
        final filtered = episodes
            .where((m) => matchesQuery(query, m.episode.series?.title ?? ''))
            .toList();
        if (filtered.isEmpty) {
          return RefreshableMessage(
            onRefresh: refresh,
            icon: PhosphorIconsRegular.checkCircle,
            title: 'Nothing missing',
            message: 'Every aired, monitored episode has a file.',
          );
        }
        return RefreshableSection(
          onRefresh: refresh,
          children: [
            const SizedBox(height: AppSpacing.space2),
            Text(
              'MISSING EPISODES · ${filtered.length}',
              style: AppTypography.kicker,
            ),
            const SizedBox(height: AppSpacing.space3),
            for (final missing in filtered)
              MissingEpisodeRow(missingEpisode: missing),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => RefreshableError(
        onRefresh: refresh,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }
}

/// Vertical list of Radarr movies (spec 2d "Movies"): a Missing section
/// with a bulk-search action, then the recently-added library proper.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieList extends ConsumerWidget {
  const MovieList({required this.instanceId, this.query = '', super.key});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(context, ref, _filter(value)),
        Err(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load movies',
          message: error.userMessage,
          action: FilledButton(
            onPressed: () => ref.invalidate(radarrMoviesProvider(instanceId)),
            child: const Text('Retry'),
          ),
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  List<RadarrMovie> _filter(List<RadarrMovie> movies) {
    if (query.isEmpty) return movies;
    final q = query.toLowerCase();
    return movies.where((m) => m.title.toLowerCase().contains(q)).toList();
  }

  Widget _body(BuildContext context, WidgetRef ref, List<RadarrMovie> movies) {
    if (movies.isEmpty) {
      return const EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'No movies found',
        message: 'Your Radarr library is empty or no titles match your search.',
      );
    }

    final missing = movies.where((m) => m.monitored && !m.hasFile).toList()
      ..sort((a, b) {
        final da = a.calendarDate;
        final db = b.calendarDate;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
    final onDisk = movies.where((m) => m.hasFile).toList()
      ..sort((a, b) {
        final da = a.added;
        final db = b.added;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
      children: [
        if (missing.isNotEmpty) ...[
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
          const SizedBox(height: AppSpacing.space2),
          for (var i = 0; i < missing.length; i++)
            LibraryRow(
              service: ServiceType.radarr,
              instanceId: instanceId,
              posterUrl: missing[i].posterUrl,
              title: missing[i].title,
              metaParts: [missing[i].status ?? 'Missing'],
              trailing: LibraryRowTrailing.none,
              showRule: i < missing.length - 1,
              onTap: missing[i].id == null
                  ? null
                  : () => context.go(
                      RoutePaths.movieDetail(instanceId, missing[i].id!),
                    ),
            ),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
        ],
        Row(
          children: [
            const Expanded(
              child: Text('RECENTLY ADDED', style: AppTypography.kicker),
            ),
            Text(
              '${onDisk.length} on disk',
              style: AppTypography.meta.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space2),
        for (var i = 0; i < onDisk.length; i++)
          LibraryRow(
            service: ServiceType.radarr,
            instanceId: instanceId,
            posterUrl: onDisk[i].posterUrl,
            title: onDisk[i].title,
            metaParts: [FormatUtils.formatBytes(onDisk[i].sizeOnDisk)],
            trailing: LibraryRowTrailing.none,
            trailingText: onDisk[i].displayQuality,
            showRule: i < onDisk.length - 1,
            onTap: onDisk[i].id == null
                ? null
                : () => context.go(
                    RoutePaths.movieDetail(instanceId, onDisk[i].id!),
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
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Searching for missing movies...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: ${result.errorOrNull?.userMessage}'),
        ),
      );
    }
  }
}

/// The Movies collection's "All" sub-tab (spec 2d "Movies"): every Radarr
/// movie in one sortable list. Rows show "year · studio" and, once the
/// movie has a file, its quality chip. Missing movies have their own
/// sub-tab (see `missing_view.dart`).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/features/library/widgets/library_sort_toggle.dart';
import 'package:arrstack/features/library/widgets/section_states.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// "2021 · Legendary Pictures" — the parts that are present.
List<String> movieMetaParts(RadarrMovie movie) => [
  if (movie.year != null && movie.year! > 0) '${movie.year}',
  if (movie.studio != null && movie.studio!.isNotEmpty) movie.studio!,
];

class MovieList extends ConsumerWidget {
  const MovieList({required this.instanceId, this.query = '', super.key});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));
    final sort = ref.watch(activeLibrarySortProvider);
    Future<void> refresh() async =>
        ref.invalidate(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(
          context,
          refresh,
          sortLibraryItems(
            value.where((m) => matchesQuery(query, m.title)),
            sort,
            added: (m) => m.added,
            title: (m) => m.sortTitle ?? m.title.toLowerCase(),
            year: (m) => m.year,
          ),
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
    Future<void> Function() refresh,
    List<RadarrMovie> movies,
  ) {
    if (movies.isEmpty) {
      return RefreshableMessage(
        onRefresh: refresh,
        icon: PhosphorIconsRegular.filmSlate,
        title: 'No movies found',
        message: 'Your Radarr library is empty or no titles match your search.',
      );
    }

    return RefreshableSection(
      onRefresh: refresh,
      children: [
        const SizedBox(height: AppSpacing.space2),
        LibraryListHeader(label: 'ALL MOVIES · ${movies.length}'),
        const SizedBox(height: AppSpacing.space2),
        for (var i = 0; i < movies.length; i++)
          _MovieRow(
            instanceId: instanceId,
            movie: movies[i],
            showRule: i < movies.length - 1,
          ),
      ],
    );
  }
}

class _MovieRow extends StatelessWidget {
  const _MovieRow({
    required this.instanceId,
    required this.movie,
    required this.showRule,
  });

  final String instanceId;
  final RadarrMovie movie;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    final id = movie.id;
    return LibraryRow(
      service: ServiceType.radarr,
      instanceId: instanceId,
      posterUrl: movie.posterUrl,
      title: movie.title,
      metaParts: movieMetaParts(movie),
      trailing: movie.monitored || movie.hasFile
          ? LibraryRowTrailing.none
          : LibraryRowTrailing.unmonitored,
      trailingText: movie.hasFile ? movie.displayQuality : null,
      showChevron: id != null,
      showRule: showRule,
      onTap: id == null
          ? null
          : () => context.go(RoutePaths.movieDetail(instanceId, id)),
    );
  }
}

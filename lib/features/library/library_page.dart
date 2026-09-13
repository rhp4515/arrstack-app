/// Main entry for the Library tab (spec 2d).
///
/// A Shows/Movies switch behind one chip row, matching the Nocturne
/// mockups. Sonarr drives Shows, Radarr drives Movies.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/collection_chips.dart';
import 'package:arrstack/features/library/widgets/continue_watching_row.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/features/library/widgets/series_list.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _searching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAdd(LibraryTab tab) {
    final type = tab == LibraryTab.movies
        ? ServiceType.radarr
        : ServiceType.sonarr;
    final instanceId = ref.read(selectedLibraryInstanceIdProvider(type)).value;
    if (instanceId != null) {
      context.go(
        type == ServiceType.radarr
            ? RoutePaths.addMovie(instanceId)
            : RoutePaths.addSeries(instanceId),
      );
    } else {
      final name = type == ServiceType.radarr ? 'Radarr' : 'Sonarr';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or configure a $name instance first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(activeLibraryTabProvider);
    ref.listen(activeLibraryTabProvider, (previous, next) {
      if (previous == null || previous == next) return;
      setState(() {
        _query = '';
        _searchController.clear();
        _searching = false;
      });
    });
    final isMovies = tab == LibraryTab.movies;

    final sonarrInstanceId = ref
        .watch(selectedLibraryInstanceIdProvider(ServiceType.sonarr))
        .value;
    final radarrInstanceId = ref
        .watch(selectedLibraryInstanceIdProvider(ServiceType.radarr))
        .value;

    final showsCount = sonarrInstanceId == null
        ? 0
        : ref
              .watch(sonarrSeriesProvider(sonarrInstanceId))
              .maybeWhen(
                data: (result) => switch (result) {
                  Ok(:final value) => value.length,
                  Err() => 0,
                },
                orElse: () => 0,
              );
    final moviesCount = radarrInstanceId == null
        ? 0
        : ref
              .watch(radarrMoviesProvider(radarrInstanceId))
              .maybeWhen(
                data: (result) => switch (result) {
                  Ok(:final value) => value.length,
                  Err() => 0,
                },
                orElse: () => 0,
              );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 21),
            onPressed: () => setState(() => _searching = !_searching),
          ),
          TextButton.icon(
            onPressed: () => _onAdd(tab),
            icon: const Icon(PhosphorIconsRegular.plus, size: 11),
            label: const Text('Add'),
          ),
        ],
      ),
      body: Padding(
        padding: AppInsets.screenHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searching) ...[
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: isMovies ? 'Search movies' : 'Search TV shows',
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.space3),
            ],
            Row(
              children: [
                Expanded(
                  child: CollectionChips(
                    showsCount: showsCount,
                    moviesCount: moviesCount,
                  ),
                ),
                const Icon(PhosphorIconsRegular.slidersHorizontal, size: 17),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            Expanded(
              child: isMovies
                  ? _MoviesTab(query: _query)
                  : _SeriesTab(query: _query),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeriesTab extends ConsumerWidget {
  const _SeriesTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(
      selectedLibraryInstanceIdProvider(ServiceType.sonarr),
    );

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const _NoSonarrInstance()
          : _SeriesTabBody(instanceId: id, query: query),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _SeriesTabBody extends ConsumerWidget {
  const _SeriesTabBody({required this.instanceId, required this.query});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueWatchingAsync = ref.watch(
      continueWatchingProvider(instanceId),
    );

    return ListView(
      children: [
        continueWatchingAsync.maybeWhen(
          data: (entries) => entries.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space6),
                  child: ContinueWatchingRow(
                    instanceId: instanceId,
                    entries: entries,
                  ),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
        const Text('ALL SHOWS', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space2),
        SeriesList(
          instanceId: instanceId,
          query: query,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

class _MoviesTab extends ConsumerWidget {
  const _MoviesTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(
      selectedLibraryInstanceIdProvider(ServiceType.radarr),
    );

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const _NoRadarrInstance()
          : MovieList(instanceId: id, query: query),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _NoSonarrInstance extends StatelessWidget {
  const _NoSonarrInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.tv_outlined,
      title: 'No Sonarr instance',
      message:
          'Configure a Sonarr service in Settings to browse your TV library.',
    );
  }
}

class _NoRadarrInstance extends StatelessWidget {
  const _NoRadarrInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.movie_outlined,
      title: 'No Radarr instance',
      message: 'Configure a Radarr service in Settings to browse your movie library.',
    );
  }
}

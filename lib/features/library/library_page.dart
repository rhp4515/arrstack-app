/// Main entry for the Library tab (spec §7).
///
/// A segmented TV Shows / Movies switch over search-filterable poster-left
/// lists, matching the app mockups. Sonarr drives TV Shows, Radarr drives
/// Movies.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/features/library/widgets/series_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged(LibraryTab tab) {
    ref.read(activeLibraryTabProvider.notifier).select(tab);
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
      // Reset the query when switching surfaces so a movie search doesn't
      // silently filter the series list.
      setState(() {
        _query = '';
        _searchController.clear();
      });
    });
    final isMovies = tab == LibraryTab.movies;

    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LegacySpacing.md,
              LegacySpacing.sm,
              LegacySpacing.md,
              LegacySpacing.sm,
            ),
            child: SearchBar(
              controller: _searchController,
              hintText: isMovies ? 'Search movies' : 'Search TV shows',
              leading: const Icon(Icons.search),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LegacySpacing.md),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<LibraryTab>(
                segments: const [
                  ButtonSegment(
                    value: LibraryTab.tvShows,
                    label: Text('TV Shows'),
                    icon: Icon(Icons.tv_outlined),
                  ),
                  ButtonSegment(
                    value: LibraryTab.movies,
                    label: Text('Movies'),
                    icon: Icon(Icons.movie_outlined),
                  ),
                ],
                selected: {tab},
                onSelectionChanged: (selection) =>
                    _onTabChanged(selection.first),
              ),
            ),
          ),
          const SizedBox(height: LegacySpacing.sm),
          Expanded(
            child: isMovies
                ? _MoviesTab(query: _query)
                : _SeriesTab(query: _query),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAdd(tab),
        child: const Icon(Icons.add),
      ),
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
          : Column(
              children: [
                _InstanceSelector(type: ServiceType.radarr, selectedId: id),
                Expanded(
                  child: MovieList(instanceId: id, query: query),
                ),
              ],
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
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
          : Column(
              children: [
                _InstanceSelector(type: ServiceType.sonarr, selectedId: id),
                Expanded(
                  child: SeriesList(instanceId: id, query: query),
                ),
              ],
            ),
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

class _InstanceSelector extends ConsumerWidget {
  const _InstanceSelector({required this.type, required this.selectedId});

  final ServiceType type;
  final String selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);

    return instancesAsync.when(
      data: (result) {
        if (result case Ok(:final value)) {
          final typed = value.where((i) => i.serviceType == type).toList();
          if (typed.length <= 1) return const SizedBox.shrink();

          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: LegacySpacing.md),
            child: Row(
              children: [
                Text(
                  'Instance:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: LegacySpacing.sm),
                DropdownButton<String>(
                  value: selectedId,
                  underline: const SizedBox.shrink(),
                  items: typed.map((i) {
                    return DropdownMenuItem(value: i.id, child: Text(i.name));
                  }).toList(),
                  onChanged: (id) => id != null
                      ? ref
                            .read(
                              selectedLibraryInstanceIdProvider(type).notifier,
                            )
                            .selectInstance(id)
                      : null,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

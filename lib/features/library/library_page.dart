/// Main entry for the Library tab (spec 2d).
///
/// A Shows/Movies switch behind one chip row, matching the Nocturne
/// mockups. Sonarr drives Shows, Radarr drives Movies. The header names the
/// selected instance (a dropdown when several exist), and the All ·
/// Upcoming · Missing · Queue · History sub-tabs apply within each
/// collection.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/collection_chips.dart';
import 'package:arrstack/features/library/widgets/history_view.dart';
import 'package:arrstack/features/library/widgets/instance_switcher.dart';
import 'package:arrstack/features/library/widgets/library_section_chips.dart';
import 'package:arrstack/features/library/widgets/missing_view.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/features/library/widgets/queue_view.dart';
import 'package:arrstack/features/library/widgets/series_all_view.dart';
import 'package:arrstack/features/library/widgets/upcoming_view.dart';
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
            icon: const Icon(PhosphorIconsRegular.plus, size: 15),
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
            // Same vertical rhythm as Activity's chip row (space3 above and
            // below); the two tiers read as lens + sub-lens.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CollectionChips(
                        showsCount: showsCount,
                        moviesCount: moviesCount,
                      ),
                      const SizedBox(width: AppSpacing.space3),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: LibraryInstanceSwitcher(
                            type: isMovies
                                ? ServiceType.radarr
                                : ServiceType.sonarr,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  const LibrarySectionChips(),
                ],
              ),
            ),
            Expanded(
              child: _CollectionBody(
                type: isMovies ? ServiceType.radarr : ServiceType.sonarr,
                query: _query,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The active sub-tab for the selected instance of [type], or the
/// "configure an instance" state when none exists.
class _CollectionBody extends ConsumerWidget {
  const _CollectionBody({required this.type, required this.query});

  final ServiceType type;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedLibraryInstanceIdProvider(type));
    final section = ref.watch(activeLibrarySectionProvider);
    final isMovies = type == ServiceType.radarr;

    return instanceIdAsync.when(
      data: (id) {
        if (id == null) {
          return isMovies
              ? const _NoRadarrInstance()
              : const _NoSonarrInstance();
        }
        return switch (section) {
          LibrarySection.all =>
            isMovies
                ? MovieList(instanceId: id, query: query)
                : SeriesAllView(instanceId: id, query: query),
          LibrarySection.upcoming => LibraryUpcomingView(
            type: type,
            instanceId: id,
            query: query,
          ),
          LibrarySection.missing => LibraryMissingView(
            type: type,
            instanceId: id,
            query: query,
          ),
          LibrarySection.queue => LibraryQueueView(
            type: type,
            instanceId: id,
            query: query,
          ),
          LibrarySection.history => LibraryHistoryView(
            type: type,
            instanceId: id,
            query: query,
          ),
        };
      },
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

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/discover/widgets/genre_pill_row.dart';
import 'package:arrstack/features/discover/widgets/poster_carousel_section.dart';
import 'package:arrstack/features/discover/widgets/requests_tab_view.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _MainTab { discover, requests }

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({this.instanceId, super.key});

  final String? instanceId;

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  _MainTab _mainTab = _MainTab.discover;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMainTabChanged(_MainTab tab) {
    setState(() {
      _mainTab = tab;
      _query = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final instanceIdAsync = ref.watch(selectedSeerrInstanceIdProvider);
    final hasSeerrAsync = ref.watch(hasSeerrInstanceProvider);

    return hasSeerrAsync.when(
      data: (enabled) {
        if (!enabled) {
          return Scaffold(
            appBar: AppBar(title: const Text('Discover')),
            body: const EmptyState(
              icon: Icons.search_off_outlined,
              title: 'Seerr not configured',
              message: 'Add a Seerr instance in Settings to enable discovery.',
            ),
          );
        }

        return instanceIdAsync.when(
          data: (id) {
            final finalId = widget.instanceId ?? id;
            if (finalId == null)
              return const Scaffold(
                body: Center(child: Text('No instance selected')),
              );

            return Scaffold(
              appBar: AppBar(
                title: const Text('Discover'),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(
                    _mainTab == _MainTab.discover ? 112 : 56,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: AppInsets.horizontalMd,
                        child: SegmentedButton<_MainTab>(
                          segments: const [
                            ButtonSegment(
                              value: _MainTab.discover,
                              label: Text('Discover'),
                              icon: Icon(Icons.explore_outlined),
                            ),
                            ButtonSegment(
                              value: _MainTab.requests,
                              label: Text('Requests'),
                              icon: Icon(Icons.receipt_long_outlined),
                            ),
                          ],
                          selected: {_mainTab},
                          onSelectionChanged: (set) =>
                              _onMainTabChanged(set.first),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (_mainTab == _MainTab.discover)
                        Padding(
                          padding: AppInsets.horizontalMd,
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search movies and TV...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (value) =>
                                setState(() => _query = value),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  const _InstanceSelector(),
                  Expanded(
                    child: _mainTab == _MainTab.discover
                        ? _DiscoverContent(instanceId: finalId, query: _query)
                        : RequestsTabView(instanceId: finalId),
                  ),
                ],
              ),
            );
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

class _DiscoverContent extends ConsumerWidget {
  const _DiscoverContent({required this.instanceId, required this.query});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isNotEmpty) {
      return _SearchList(instanceId: instanceId, query: query);
    }
    return _DiscoverSections(instanceId: instanceId);
  }
}

/// The sectioned "home" view: genre pill rows + poster carousels, matching
/// example_mockups/seerr_discover_listview.jpeg. Each section watches its
/// own provider independently — if one section's endpoint fails, the rest
/// of the page still renders rather than sinking the whole screen.
class _DiscoverSections extends ConsumerWidget {
  const _DiscoverSections({required this.instanceId});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(seerrMovieGenresProvider(instanceId))
          ..invalidate(seerrTvGenresProvider(instanceId))
          ..invalidate(seerrTrendingProvider(instanceId))
          ..invalidate(seerrDiscoverMoviesProvider(instanceId))
          ..invalidate(seerrUpcomingMoviesProvider(instanceId))
          ..invalidate(seerrDiscoverTvProvider(instanceId))
          ..invalidate(seerrUpcomingTvProvider(instanceId));
      },
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.sm),
          _GenreRow(
            instanceId: instanceId,
            label: 'Movie Genres',
            mediaType: 'movie',
            async: ref.watch(seerrMovieGenresProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.md),
          _Carousel(
            instanceId: instanceId,
            label: 'Trending',
            async: ref.watch(seerrTrendingProvider(instanceId)),
          ),
          _Carousel(
            instanceId: instanceId,
            label: 'Popular Movies',
            async: ref.watch(seerrDiscoverMoviesProvider(instanceId)),
          ),
          _Carousel(
            instanceId: instanceId,
            label: 'Upcoming Movies',
            async: ref.watch(seerrUpcomingMoviesProvider(instanceId)),
          ),
          _GenreRow(
            instanceId: instanceId,
            label: 'Series Genres',
            mediaType: 'tv',
            async: ref.watch(seerrTvGenresProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.md),
          _Carousel(
            instanceId: instanceId,
            label: 'Popular Series',
            async: ref.watch(seerrDiscoverTvProvider(instanceId)),
          ),
          _Carousel(
            instanceId: instanceId,
            label: 'Upcoming Series',
            async: ref.watch(seerrUpcomingTvProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({
    required this.instanceId,
    required this.label,
    required this.async,
  });

  final String instanceId;
  final String label;
  final AsyncValue<Result<List<SeerrResult>>> async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      data: (result) => switch (result) {
        Ok(:final value) => PosterCarouselSection(
          label: label,
          items: value,
          instanceId: instanceId,
        ),
        Err() => const SizedBox.shrink(),
      },
      loading: () => Padding(
        padding: AppInsets.pageMd,
        child: Row(
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(width: AppSpacing.sm),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _GenreRow extends StatelessWidget {
  const _GenreRow({
    required this.instanceId,
    required this.label,
    required this.mediaType,
    required this.async,
  });

  final String instanceId;
  final String label;
  final String mediaType;
  final AsyncValue<Result<List<SeerrGenre>>> async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppInsets.horizontalMd,
                      child: Text(
                        label.toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    GenrePillRow(
                      genres: value,
                      onTap: (genre) => context.go(
                        RoutePaths.discoverGenre(
                          instanceId,
                          genre.id,
                          mediaType,
                          genre.name,
                        ),
                      ),
                    ),
                  ],
                ),
        Err() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _SearchList extends ConsumerWidget {
  const _SearchList({required this.instanceId, required this.query});
  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(
      seerrSearchProvider(instanceId: instanceId, query: query),
    );

    return results.when(
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? const EmptyState(icon: Icons.search_off, title: 'No results')
              : ListView.builder(
                  padding: AppInsets.pageMd,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final item = value[index];
                    return ListTile(
                      leading: item.posterUrl != null
                          ? Image.network(item.posterUrl!, width: 40)
                          : const Icon(Icons.movie_outlined),
                      title: Text(item.displayTitle ?? 'Unknown'),
                      subtitle: Text(item.displayDate ?? ''),
                      onTap: () => context.go(
                        RoutePaths.discoverDetail(
                          instanceId,
                          item.id,
                          item.mediaType,
                        ),
                      ),
                    );
                  },
                ),
        Err(:final error) => Center(child: Text(error.userMessage)),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _InstanceSelector extends ConsumerWidget {
  const _InstanceSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instances = ref.watch(instancesProvider);
    final selectedIdAsync = ref.watch(selectedSeerrInstanceIdProvider);

    return instances.when(
      data: (result) => switch (result) {
        Ok<List<ServiceInstance>>(:final value) => () {
          final seerrInstances = value
              .where((i) => i.serviceType == ServiceType.seerr)
              .toList();
          if (seerrInstances.length <= 1) return const SizedBox.shrink();

          return Container(
            height: 48,
            padding: AppInsets.horizontalMd,
            child: Row(
              children: [
                Text(
                  'Instance: ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                DropdownButton<String>(
                  value:
                      selectedIdAsync.asData?.value ?? seerrInstances.first.id,
                  items: seerrInstances.map((i) {
                    return DropdownMenuItem(value: i.id, child: Text(i.name));
                  }).toList(),
                  onChanged: (id) => id != null
                      ? ref
                            .read(selectedSeerrInstanceIdProvider.notifier)
                            .selectInstance(id)
                      : null,
                ),
              ],
            ),
          );
        }(),
        Err() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _DiscoverTab { movies, tv }

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  _DiscoverTab _tab = _DiscoverTab.movies;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged(_DiscoverTab tab) {
    setState(() {
      _tab = tab;
      _query = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
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
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: AppInsets.horizontalMd,
                child: SegmentedButton<_DiscoverTab>(
                  segments: const [
                    ButtonSegment(
                      value: _DiscoverTab.movies,
                      label: Text('Movies'),
                      icon: Icon(Icons.movie_outlined),
                    ),
                    ButtonSegment(
                      value: _DiscoverTab.tv,
                      label: Text('TV Shows'),
                      icon: Icon(Icons.tv_outlined),
                    ),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (set) => _onTabChanged(set.first),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
      body: _DiscoverContent(
        instanceId: widget.instanceId,
        tab: _tab,
        query: _query,
      ),
    );
  }
}

class _DiscoverContent extends ConsumerWidget {
  const _DiscoverContent({
    required this.instanceId,
    required this.tab,
    required this.query,
  });

  final String instanceId;
  final _DiscoverTab tab;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isNotEmpty) {
      return _SearchList(instanceId: instanceId, query: query);
    }

    return _DiscoverGrid(instanceId: instanceId, tab: tab);
  }
}

class _SearchList extends ConsumerWidget {
  const _SearchList({required this.instanceId, required this.query});
  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(seerrSearchProvider(instanceId: instanceId, query: query));
    
    return results.when(
      data: (result) => switch (result) {
        Ok(:final value) => value.isEmpty
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
                      RoutePaths.discoverDetail(instanceId, item.id, item.mediaType),
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

class _DiscoverGrid extends ConsumerWidget {
  const _DiscoverGrid({required this.instanceId, required this.tab});
  final String instanceId;
  final _DiscoverTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoverAsync = tab == _DiscoverTab.movies
        ? ref.watch(seerrDiscoverMoviesProvider(instanceId))
        : ref.watch(seerrDiscoverTvProvider(instanceId));

    return RefreshIndicator(
      onRefresh: () async {
        if (tab == _DiscoverTab.movies) {
          ref.invalidate(seerrDiscoverMoviesProvider(instanceId));
        } else {
          ref.invalidate(seerrDiscoverTvProvider(instanceId));
        }
      },
      child: discoverAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) => GridView.builder(
              padding: AppInsets.pageMd,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 2 / 3,
              ),
              itemCount: value.length,
              itemBuilder: (context, index) {
                final item = value[index];
                return PosterCard(
                  imageUrl: item.posterUrl ?? '',
                  title: item.displayTitle ?? '',
                  onTap: () => context.go(
                    RoutePaths.discoverDetail(instanceId, item.id, item.mediaType),
                  ),
                );
              },
            ),
          Err(:final error) => EmptyState(
              icon: Icons.error_outline,
              title: 'Discover failed',
              message: error.userMessage,
            ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

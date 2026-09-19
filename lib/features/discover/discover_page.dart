/// Discover (README §3a): search, alternating genre-pill rows and poster
/// carousels, each poster badged with its library/request status before
/// the tap. The Requests queue is its own route (`/home/requests`) reached
/// via the header's receipt button, not an in-page tab (Phase 7 design
/// spec, Decision 4).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/discover/widgets/genre_pill_row.dart';
import 'package:arrstack/features/discover/widgets/poster_carousel_section.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({this.instanceId, super.key});

  final String? instanceId;

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instanceIdAsync = ref.watch(selectedSeerrInstanceIdProvider);
    final hasSeerrAsync = ref.watch(hasSeerrInstanceProvider);

    return hasSeerrAsync.when(
      data: (enabled) {
        if (!enabled) {
          return const Scaffold(
            appBar: SubPageHeader(kicker: 'SEERR', title: 'Discover'),
            body: EmptyState(
              icon: Icons.search_off_outlined,
              title: 'Seerr not configured',
              message: 'Add a Seerr instance in Settings to enable discovery.',
            ),
          );
        }

        return instanceIdAsync.when(
          data: (id) {
            final finalId = widget.instanceId ?? id;
            if (finalId == null) {
              return const Scaffold(
                body: Center(child: Text('No instance selected')),
              );
            }

            return Scaffold(
              appBar: SubPageHeader(
                kicker: 'SEERR',
                title: 'Discover',
                actions: [
                  IconButton(
                    icon: const Icon(PhosphorIconsRegular.receipt, size: 17),
                    tooltip: 'Requests',
                    onPressed: () => context.push(RoutePaths.homeRequests),
                  ),
                ],
              ),
              body: Column(
                children: [
                  const _InstanceSelector(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.space6,
                      AppSpacing.space4,
                      AppSpacing.space6,
                      AppSpacing.space4,
                    ),
                    child: _SearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  Expanded(
                    child: _DiscoverContent(instanceId: finalId, query: _query),
                  ),
                ],
              ),
            );
          },
          loading: () => const Scaffold(
            appBar: SubPageHeader(kicker: 'SEERR', title: 'Discover'),
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
            body: Center(child: Text('Error: $err')),
          ),
        );
      },
      loading: () => const Scaffold(
        appBar: SubPageHeader(kicker: 'SEERR', title: 'Discover'),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsRegular.magnifyingGlass,
            size: 17,
            color: AppColors.n500,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.body.copyWith(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Search movies and TV',
                hintStyle: TextStyle(color: AppColors.n500),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
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

/// The sectioned "home" view: genre pill rows + poster carousels. Each
/// section watches its own provider independently — if one section's
/// endpoint fails, the rest of the page still renders rather than sinking
/// the whole screen.
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
          const SizedBox(height: AppSpacing.space2),
          _GenreRow(
            instanceId: instanceId,
            label: 'Movie Genres',
            mediaType: 'movie',
            async: ref.watch(seerrMovieGenresProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.space4),
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
          const SizedBox(height: AppSpacing.space4),
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
          const SizedBox(height: AppSpacing.space6),
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
        padding: AppInsets.screenHorizontal,
        child: Row(
          children: [
            Text(label.toUpperCase(), style: AppTypography.kicker),
            const SizedBox(width: AppSpacing.space3),
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
                      padding: AppInsets.screenHorizontal,
                      child: Text(
                        label.toUpperCase(),
                        style: AppTypography.kicker,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    GenrePillRow(
                      genres: value,
                      onTap: (genre) => context.go(
                        RoutePaths.homeDiscoverGenre(
                          mediaType,
                          genre.id,
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
                        RoutePaths.homeDiscoverDetail(item.id, item.mediaType),
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
            padding: AppInsets.screenHorizontal,
            child: Row(
              children: [
                const Text('Instance: ', style: AppTypography.meta),
                DropdownButton<String>(
                  value:
                      selectedIdAsync.asData?.value ?? seerrInstances.first.id,
                  items: seerrInstances
                      .map(
                        (i) =>
                            DropdownMenuItem(value: i.id, child: Text(i.name)),
                      )
                      .toList(),
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

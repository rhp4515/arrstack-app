/// Add movie (README §3d): TMDB lookup via Radarr, a primary/secondary
/// add-button hierarchy, and already-in-library rows dimmed with a check
/// instead of an add button so a duplicate can't be added by accident.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/features/library/widgets/add_movie_options.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AddMoviePage extends ConsumerStatefulWidget {
  const AddMoviePage({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends ConsumerState<AddMoviePage> {
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lookupAsync = ref.watch(
      radarrLookupProvider(instanceId: widget.instanceId, term: _searchTerm),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add movie'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space6,
              0,
              AppSpacing.space6,
              AppSpacing.space4,
            ),
            child: _ActiveSearchField(
              controller: _searchController,
              onSubmitted: (value) => setState(() => _searchTerm = value),
              onClear: () => setState(() => _searchTerm = ''),
            ),
          ),
        ),
      ),
      body: _searchTerm.isEmpty
          ? const EmptyState(
              icon: Icons.movie_filter_outlined,
              title: 'Search for a movie',
              message: 'Lookup movies by title to add them to your library.',
            )
          : lookupAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) =>
                  value.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off,
                          title: 'No results',
                        )
                      : _SearchResults(
                          movies: value,
                          instanceId: widget.instanceId,
                        ),
                Err(:final error) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Lookup failed',
                  message: error.userMessage,
                ),
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
    );
  }
}

class _ActiveSearchField extends StatelessWidget {
  const _ActiveSearchField({
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.accent),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsRegular.magnifyingGlass,
            size: 17,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: AppTypography.body.copyWith(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Search movies to add',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                PhosphorIconsRegular.x,
                size: 15,
                color: AppColors.n500,
              ),
              onPressed: () {
                controller.clear();
                onClear();
              },
            ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.movies, required this.instanceId});

  final List<RadarrMovie> movies;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space3,
            AppSpacing.space6,
            0,
          ),
          child: Text(
            '${movies.length} results from TMDB via Radarr',
            style: AppTypography.meta.copyWith(
              color: AppColors.n500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: AppInsets.pageMd,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _SearchResultTile(
                movie: movies[index],
                instanceId: instanceId,
                isPrimary: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({
    required this.movie,
    required this.instanceId,
    required this.isPrimary,
  });

  final RadarrMovie movie;
  final String instanceId;
  final bool isPrimary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativeUrl = movie.posterUrl;
    final fullUrlAsync = relativeUrl != null
        ? ref.watch(
            radarrFullImageUrlProvider(
              instanceId: instanceId,
              relativeUrl: relativeUrl,
            ),
          )
        : const AsyncData<String?>(null);
    final alreadyAdded = movie.id != null;

    final row = ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      leading: SizedBox(
        width: 40,
        child: fullUrlAsync.when(
          data: (url) => PosterCard(imageUrl: url ?? '', monitored: true),
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, _) => const Icon(Icons.movie_outlined),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(
        alreadyAdded ? '${movie.year} · already in library' : '${movie.year}',
      ),
      trailing: alreadyAdded
          ? const Icon(Icons.check_circle, color: AppColors.up)
          : _AddButton(
              primary: isPrimary,
              onPressed: () => _showAddOptions(context, ref, movie),
            ),
    );

    return alreadyAdded ? Opacity(opacity: 0.6, child: row) : row;
  }

  void _showAddOptions(
    BuildContext context,
    WidgetRef ref,
    RadarrMovie movie,
  ) async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddMovieOptionsSheet(instanceId: instanceId, movie: movie),
      ),
    );

    if (added == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.primary, required this.onPressed});

  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(PhosphorIconsRegular.plus, size: 15),
      color: primary ? AppColors.accent : AppColors.n400,
      style: IconButton.styleFrom(
        side: BorderSide(color: primary ? AppColors.accent : AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

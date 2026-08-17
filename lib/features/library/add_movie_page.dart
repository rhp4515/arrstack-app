/// Add movie page (spec §7).
///
/// Handles movie lookup via Radarr and selecting add-options (root folder, profile).
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
    final lookupAsync = ref.watch(radarrLookupProvider(
      instanceId: widget.instanceId,
      term: _searchTerm,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search TMDB...',
              onSubmitted: (value) => setState(() => _searchTerm = value),
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchTerm.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchTerm = '');
                    },
                  ),
              ],
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
                Ok(:final value) => value.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No results',
                        message: 'No movies found matching your search.',
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
              error: (err, stack) => Center(child: Text('Error: $err')),
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
    return ListView.builder(
      padding: AppInsets.pageMd,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _SearchResultTile(movie: movie, instanceId: instanceId);
      },
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({required this.movie, required this.instanceId});

  final RadarrMovie movie;
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativeUrl = movie.posterUrl;
    final fullUrlAsync = relativeUrl != null
        ? ref.watch(radarrFullImageUrlProvider(
            instanceId: instanceId,
            relativeUrl: relativeUrl,
          ))
        : const AsyncData<String?>(null);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      leading: SizedBox(
        width: 60,
        child: fullUrlAsync.when(
          data: (url) => PosterCard(imageUrl: url ?? '', monitored: true),
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => const Icon(Icons.movie_outlined),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text('${movie.year}'),
      trailing: movie.id != null
          ? const Icon(Icons.check_circle, color: Colors.green)
          : IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _showAddOptions(context, ref, movie),
            ),
    );
  }

  void _showAddOptions(BuildContext context, WidgetRef ref, RadarrMovie movie) async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddMovieOptionsSheet(
          instanceId: instanceId,
          movie: movie,
        ),
      ),
    );

    if (added == true && context.mounted) {
      // Return to library if added successfully
      Navigator.pop(context);
    }
  }
}

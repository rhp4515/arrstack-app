/// Add series page (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/features/library/widgets/add_series_options.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSeriesPage extends ConsumerStatefulWidget {
  const AddSeriesPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<AddSeriesPage> createState() => _AddSeriesPageState();
}

class _AddSeriesPageState extends ConsumerState<AddSeriesPage> {
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lookupAsync = ref.watch(sonarrLookupProvider(
      instanceId: widget.instanceId,
      term: _searchTerm,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Series'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search TVDB...',
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
              icon: Icons.tv_outlined,
              title: 'Search for a series',
              message: 'Lookup series by title to add them to your library.',
            )
          : lookupAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) => value.isEmpty
                    ? const EmptyState(
                        icon: Icons.search_off,
                        title: 'No results',
                        message: 'No series found matching your search.',
                      )
                    : _SearchResults(
                        series: value,
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
  const _SearchResults({required this.series, required this.instanceId});

  final List<SonarrSeries> series;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppInsets.pageMd,
      itemCount: series.length,
      itemBuilder: (context, index) {
        final item = series[index];
        return _SearchResultTile(series: item, instanceId: instanceId);
      },
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({required this.series, required this.instanceId});

  final SonarrSeries series;
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativeUrl = series.posterUrl;
    final fullUrlAsync = relativeUrl != null
        ? ref.watch(sonarrFullImageUrlProvider(
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
          error: (_, _) => const Icon(Icons.tv_outlined),
        ),
      ),
      title: Text(series.title),
      subtitle: Text('${series.year}'),
      trailing: series.id != null
          ? const Icon(Icons.check_circle, color: Colors.green)
          : IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _showAddOptions(context, ref, series),
            ),
    );
  }

  void _showAddOptions(BuildContext context, WidgetRef ref, SonarrSeries series) async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddSeriesOptionsSheet(
          instanceId: instanceId,
          series: series,
        ),
      ),
    );

    if (added == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}

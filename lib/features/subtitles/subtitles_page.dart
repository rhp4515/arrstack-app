/// Subtitles tab: Bazarr wanted list and search (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/subtitles/widgets/wanted_subtitle_tile.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubtitlesPage extends ConsumerStatefulWidget {
  const SubtitlesPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<SubtitlesPage> createState() => _SubtitlesPageState();
}

class _SubtitlesPageState extends ConsumerState<SubtitlesPage> {
  String _filter = 'all'; // 'all', 'movie', 'episode'

  @override
  Widget build(BuildContext context) {
    final wantedAsync = ref.watch(bazarrWantedProvider(widget.instanceId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wanted Subtitles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final repo = await ref.read(bazarrRepositoryProvider(widget.instanceId).future);
              final result = await repo.searchAllSubtitles();
              if (mounted) {
                if (result.isOk) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Global search triggered.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed: ${result.errorOrNull?.userMessage}')),
                  );
                }
              }
            },
            tooltip: 'Search All',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (val) => setState(() => _filter = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'movie', child: Text('Movies')),
              const PopupMenuItem(value: 'episode', child: Text('Episodes')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(bazarrWantedProvider(widget.instanceId)),
        child: wantedAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _buildList(value),
            Err(:final error) => EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load subtitles',
                message: error.userMessage,
                action: FilledButton(
                  onPressed: () => ref.invalidate(bazarrWantedProvider(widget.instanceId)),
                  child: const Text('Retry'),
                ),
              ),
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Unexpected error: $err')),
        ),
      ),
    );
  }

  Widget _buildList(List<BazarrWantedSubtitle> items) {
    final filtered = items.where((i) {
      if (_filter == 'all') return true;
      return i.type == _filter;
    }).toList();

    if (filtered.isEmpty) {
      return const EmptyState(
        icon: Icons.subtitles_off_outlined,
        title: 'No wanted subtitles',
        message: 'All your media has the required subtitles.',
      );
    }

    return ListView.builder(
      padding: AppInsets.pageMd,
      itemCount: filtered.length,
      itemBuilder: (context, index) => WantedSubtitleTile(
        instanceId: widget.instanceId,
        subtitle: filtered[index],
      ),
    );
  }
}

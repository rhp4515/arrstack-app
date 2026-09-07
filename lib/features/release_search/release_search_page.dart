/// Interactive release-search screen: runs the search on open, shows the
/// results sorted (default Peers ↓), and lets the user open any release.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/features/release_search/widgets/release_detail_sheet.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReleaseSearchPage extends ConsumerWidget {
  const ReleaseSearchPage({
    required this.service,
    required this.instanceId,
    required this.targetId,
    required this.title,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final int targetId;

  /// Human label for the episode/movie being searched (app-bar subtitle).
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = releaseSearchResultsProvider(
      service: service,
      instanceId: instanceId,
      targetId: targetId,
    );
    final resultsAsync = ref.watch(provider);
    final sort = ref.watch(releaseSortControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Releases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Search again',
            onPressed: () => ref.invalidate(provider),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<ReleaseSort>(
                    segments: const [
                      ButtonSegment(
                        value: ReleaseSort.peers,
                        label: Text('Peers'),
                      ),
                      ButtonSegment(
                        value: ReleaseSort.size,
                        label: Text('Size'),
                      ),
                      ButtonSegment(value: ReleaseSort.age, label: Text('Age')),
                      ButtonSegment(
                        value: ReleaseSort.quality,
                        label: Text('Quality'),
                      ),
                    ],
                    selected: {sort},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) => ref
                        .read(releaseSortControllerProvider.notifier)
                        .select(s.first),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const _SearchingState(),
        error: (err, _) => _ErrorState(
          message: '$err',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (result) => switch (result) {
          Err(:final error) => _ErrorState(
            message: error.userMessage,
            onRetry: () => ref.invalidate(provider),
          ),
          Ok(:final value) when value.isEmpty => const EmptyState(
            icon: Icons.search_off,
            title: 'No releases found',
            message: 'No indexer returned a release for this item.',
          ),
          Ok(:final value) => _Results(
            releases: applySort(value, sort),
            service: service,
            instanceId: instanceId,
          ),
        },
      ),
    );
  }
}

class _SearchingState extends StatelessWidget {
  const _SearchingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: AppInsets.pageLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text(
              'Searching all indexers… this can take up to a minute.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Search failed',
      message: message,
      action: FilledButton(onPressed: onRetry, child: const Text('Retry')),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.releases,
    required this.service,
    required this.instanceId,
  });

  final List<ReleaseCandidate> releases;
  final ServiceType service;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: releases.length + 1,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              '${releases.length} release${releases.length == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        }
        final release = releases[index - 1];
        return ReleaseTile(
          release: release,
          onTap: () => showReleaseDetailSheet(
            context,
            release: release,
            service: service,
            instanceId: instanceId,
          ),
        );
      },
    );
  }
}

// lib/features/release_search/release_search_page.dart
/// Interactive release-search screen (README §3e): runs the search on
/// open, shows the results sorted (default Best match), and lets the user
/// open any release. Rejected releases stay in the list, dimmed with the
/// reason spelled out in red.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/features/release_search/widgets/release_detail_sheet.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

const _sortLabels = {
  ReleaseSort.best: 'Best match',
  ReleaseSort.size: 'Size',
  ReleaseSort.seeders: 'Seeders',
};

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

  /// Human label for the episode/movie being searched (header kicker).
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title.toUpperCase(), style: AppTypography.kicker),
            const Text('Releases', style: AppTypography.sectionTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 17),
            tooltip: 'Search again',
            onPressed: () => ref.invalidate(provider),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space6,
              0,
              AppSpacing.space6,
              AppSpacing.space3,
            ),
            child: Row(
              children: [
                for (final option in ReleaseSort.values) ...[
                  _SortChip(
                    label: _sortLabels[option]!,
                    active: option == sort,
                    onTap: () => ref
                        .read(releaseSortControllerProvider.notifier)
                        .select(option),
                  ),
                  const SizedBox(width: AppSpacing.space2),
                ],
                const Spacer(),
                resultsAsync.maybeWhen(
                  data: (result) => switch (result) {
                    Ok(:final value) => Text(
                      '${value.length} found',
                      style: AppTypography.meta.copyWith(
                        color: AppColors.n500,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Err() => const SizedBox.shrink(),
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const _SearchingState(),
        error: (err, _) => _ErrorState(
          message: err is AppError ? err.userMessage : '$err',
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

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: active ? Border.all(color: AppColors.accent) : null,
        ),
        child: Text(
          label,
          style: AppTypography.chipLabel.copyWith(
            color: active ? AppColors.accent : AppColors.n400,
          ),
        ),
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
            SizedBox(height: AppSpacing.space4),
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
        if (index == releases.length) {
          return const Padding(
            padding: AppInsets.pageMd,
            child: Text(
              'Rejected releases stay listed — tapping one downloads it anyway, '
              'overriding the profile.',
              style: AppTypography.meta,
            ),
          );
        }
        final release = releases[index];
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

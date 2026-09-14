/// The Transfers lens (spec screen 2h): throughput sparkline, secondary
/// filter chips, and the torrent list. Ties together
/// `selectedDownloadInstanceIdProvider`/`qbitTorrentsProvider`/
/// `downloadFilterProvider` (from the Downloads feature) with
/// the new `TransfersThroughputHistory` and `TorrentBlock`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/throughput_sparkline.dart';
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// Applies [filter] to [all]. Pure — unit-testable without a widget tree.
/// Only `all`/`active`/`seeding` drive this lens's UI (2h's three secondary
/// chips); the other `TorrentFilter` values pass through unfiltered rather
/// than being unreachable dead code, in case a future screen reuses them.
List<QbitTorrent> filterTorrents(List<QbitTorrent> all, TorrentFilter filter) {
  return switch (filter) {
    TorrentFilter.all => all,
    TorrentFilter.active =>
      all
          .where(
            (t) =>
                !torrentIsComplete(t) &&
                t.state != 'pausedDL' &&
                t.state != 'stalledDL',
          )
          .toList(),
    TorrentFilter.seeding => all.where(torrentIsComplete).toList(),
    _ => all,
  };
}

class TransfersLens extends ConsumerWidget {
  const TransfersLens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedDownloadInstanceIdProvider);

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const EmptyState(
              icon: PhosphorIconsRegular.downloadSimple,
              title: 'No qBittorrent instance',
              message: 'Configure a qBittorrent service in Settings to see transfers.',
            )
          : _TransfersBody(instanceId: id),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _TransfersBody extends ConsumerWidget {
  const _TransfersBody({required this.instanceId});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final samples = ref.watch(transfersThroughputHistoryProvider(instanceId));
    final torrentsAsync = ref.watch(qbitTorrentsProvider(instanceId));
    final filter = ref.watch(downloadFilterProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(qbitTorrentsProvider(instanceId).future),
      child: torrentsAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) => _TorrentListView(
            instanceId: instanceId,
            all: value,
            filter: filter,
            samples: samples,
          ),
          Err(:final error) => EmptyState(
            icon: PhosphorIconsRegular.warning,
            title: 'Failed to load torrents',
            message: error.userMessage,
            action: FilledButton(
              onPressed: () => ref.invalidate(qbitTorrentsProvider(instanceId)),
              child: const Text('Retry'),
            ),
          ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Unexpected error: $err')),
      ),
    );
  }
}

class _TorrentListView extends ConsumerWidget {
  const _TorrentListView({
    required this.instanceId,
    required this.all,
    required this.filter,
    required this.samples,
  });

  final String instanceId;
  final List<QbitTorrent> all;
  final TorrentFilter filter;
  final List<ThroughputSample> samples;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = filterTorrents(all, filter);
    final activeCount = filterTorrents(all, TorrentFilter.active).length;
    final seedingCount = filterTorrents(all, TorrentFilter.seeding).length;

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        ThroughputSparkline(samples: samples),
        const SizedBox(height: AppSpacing.space4),
        _SecondaryChips(
          filter: filter,
          allCount: all.length,
          activeCount: activeCount,
          seedingCount: seedingCount,
        ),
        const SizedBox(height: AppSpacing.space3),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space8),
            child: EmptyState(
              icon: PhosphorIconsRegular.tray,
              title: 'Nothing here',
              message: 'Try a different filter.',
            ),
          )
        else
          for (final torrent in filtered)
            TorrentBlock(instanceId: instanceId, torrent: torrent),
      ],
    );
  }
}

class _SecondaryChips extends ConsumerWidget {
  const _SecondaryChips({
    required this.filter,
    required this.allCount,
    required this.activeCount,
    required this.seedingCount,
  });

  final TorrentFilter filter;
  final int allCount;
  final int activeCount;
  final int seedingCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _SecondaryChip(
          label: 'All $allCount',
          isActive: filter == TorrentFilter.all,
          onTap: () => ref
              .read(downloadFilterProvider.notifier)
              .setFilter(TorrentFilter.all),
        ),
        const SizedBox(width: AppSpacing.space2),
        _SecondaryChip(
          label: 'Downloading $activeCount',
          isActive: filter == TorrentFilter.active,
          onTap: () => ref
              .read(downloadFilterProvider.notifier)
              .setFilter(TorrentFilter.active),
        ),
        const SizedBox(width: AppSpacing.space2),
        _SecondaryChip(
          label: 'Seeding $seedingCount',
          isActive: filter == TorrentFilter.seeding,
          onTap: () => ref
              .read(downloadFilterProvider.notifier)
              .setFilter(TorrentFilter.seeding),
        ),
      ],
    );
  }
}

class _SecondaryChip extends StatelessWidget {
  const _SecondaryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final color = isActive
        ? isDark
              ? AppColors.accent
              : colorScheme.primary
        : isDark
        ? AppColors.n400
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive ? Border.all(color: color) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}

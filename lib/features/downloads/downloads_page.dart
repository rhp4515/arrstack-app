/// Downloads tab: qBittorrent torrent list and controls (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/features/downloads/widgets/add_torrent_dialog.dart';
import 'package:arrstack/features/downloads/widgets/torrent_tile.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadsPage extends ConsumerWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedDownloadInstanceIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        bottom: instanceIdAsync.when(
          data: (id) => id != null ? _GlobalStatsBar(instanceId: id) : null,
          loading: () => null,
          error: (_, __) => null,
        ),
      ),
      body: instanceIdAsync.when(
        data: (id) => id == null ? const _NoQbitInstance() : _TorrentList(instanceId: id),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = ref.read(selectedDownloadInstanceIdProvider).value;
          if (id != null) {
            showDialog(
              context: context,
              builder: (context) => AddTorrentDialog(instanceId: id),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please configure a qBittorrent instance first.')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TorrentList extends ConsumerWidget {
  const _TorrentList({required this.instanceId});
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torrentsAsync = ref.watch(qbitTorrentsProvider(instanceId));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(qbitTorrentsProvider(instanceId)),
      child: torrentsAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) => value.isEmpty
              ? const EmptyState(
                  icon: Icons.download_done_outlined,
                  title: 'No active downloads',
                  message: 'Your download queue is empty.',
                )
              : _SectionedTorrents(instanceId: instanceId, torrents: value),
          Err(:final error) => EmptyState(
              icon: Icons.error_outline,
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

/// Splits torrents into "Downloading" and "History" (completed) sections,
/// each with a counted header, matching the downloads mockup.
class _SectionedTorrents extends StatelessWidget {
  const _SectionedTorrents({required this.instanceId, required this.torrents});

  final String instanceId;
  final List<QbitTorrent> torrents;

  @override
  Widget build(BuildContext context) {
    final active = torrents.where((t) => !torrentIsComplete(t)).toList();
    final history = torrents.where(torrentIsComplete).toList();

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        if (active.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.download,
            label: 'Downloading',
            count: active.length,
          ),
          for (final t in active)
            TorrentTile(instanceId: instanceId, torrent: t),
        ],
        if (history.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SectionHeader(
            icon: Icons.history,
            label: 'History',
            count: history.length,
          ),
          for (final t in history)
            TorrentTile(instanceId: instanceId, torrent: t),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$label ($count)',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalStatsBar extends ConsumerWidget implements PreferredSizeWidget {
  const _GlobalStatsBar({required this.instanceId});
  final String instanceId;

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainDataAsync = ref.watch(qbitMainDataProvider(instanceId));
    final theme = Theme.of(context);

    return Container(
      height: 40,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: mainDataAsync.when(
        data: (result) {
          if (result case Ok(:final value)) {
            final stats = value.serverState;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '↓ ${FormatUtils.formatSpeed(stats.dlInfoSpeed)}',
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  '↑ ${FormatUtils.formatSpeed(stats.upInfoSpeed)}',
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text(
                  stats.connectionStatus.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _NoQbitInstance extends StatelessWidget {
  const _NoQbitInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.download_outlined,
      title: 'No qBittorrent instance',
      message: 'Configure a qBittorrent service in Settings to manage your downloads.',
    );
  }
}

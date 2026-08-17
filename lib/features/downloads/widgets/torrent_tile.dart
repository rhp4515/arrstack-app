/// A tile representing a single torrent in the downloads list (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TorrentTile extends ConsumerWidget {
  const TorrentTile({
    required this.instanceId,
    required this.torrent,
    super.key,
  });

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPaused = torrent.state == 'pausedDL' || torrent.state == 'pausedUP';
    final isDownloading = torrent.state == 'downloading' || torrent.state == 'stalledDL';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: AppInsets.pageMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    torrent.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                _StatusIcon(state: torrent.state),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: torrent.progress,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(torrent.progress * 100).toStringAsFixed(1)}% of ${FormatUtils.formatBytes(torrent.size)}',
                  style: theme.textTheme.bodySmall,
                ),
                if (isDownloading)
                  Text(
                    '↓ ${FormatUtils.formatSpeed(torrent.dlspeed)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                  onPressed: () => _toggleStatus(ref),
                  tooltip: isPaused ? 'Resume' : 'Pause',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(context, ref),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleStatus(WidgetRef ref) async {
    final repository = await ref.read(qbitRepositoryProvider(instanceId).future);
    final isPaused = torrent.state == 'pausedDL' || torrent.state == 'pausedUP';
    
    if (isPaused) {
      await repository.resumeTorrents([torrent.hash]);
    } else {
      await repository.pauseTorrents([torrent.hash]);
    }
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    bool deleteFiles = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Delete Torrent?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to remove "${torrent.name}"?'),
              const SizedBox(height: AppSpacing.md),
              CheckboxListTile(
                title: const Text('Also delete files on disk'),
                value: deleteFiles,
                onChanged: (val) => setState(() => deleteFiles = val!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final repository = await ref.read(qbitRepositoryProvider(instanceId).future);
      await repository.deleteTorrents([torrent.hash], deleteFiles: deleteFiles);
      ref.invalidate(qbitTorrentsProvider(instanceId));
    }
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.state});
  final String state;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (state) {
      'downloading' => (Icons.downloading, Colors.blue),
      'stalledDL' => (Icons.download_for_offline_outlined, Colors.orange),
      'uploading' || 'stalledUP' => (Icons.upload, Colors.green),
      'pausedDL' || 'pausedUP' => (Icons.pause_circle_outline, Colors.grey),
      'queuedDL' || 'queuedUP' => (Icons.timer_outlined, Colors.purple),
      'checkingDL' || 'checkingUP' => (Icons.sync, Colors.teal),
      _ => (Icons.help_outline, Colors.grey),
    };

    return Icon(icon, size: 18, color: color);
  }
}

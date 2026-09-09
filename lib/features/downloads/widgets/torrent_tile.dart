/// A torrent row for the downloads list, matching the app mockup: a state
/// pill and ETA, the torrent name, its tracker host, a progress bar, and a
/// size · ↓ · ↑ · Ratio footer. Tapping opens pause/resume/delete actions.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether a torrent has finished downloading (belongs in History).
bool torrentIsComplete(QbitTorrent t) =>
    t.progress >= 1.0 ||
    const {
      'uploading',
      'stalledUP',
      'forcedUP',
      'pausedUP',
      'queuedUP',
    }.contains(t.state);

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
    final muted = theme.colorScheme.onSurfaceVariant;
    final (label, color) = _stateStyle(torrent.state, theme);
    final host = FormatUtils.trackerHost(torrent.tracker);

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.only(bottom: LegacySpacing.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showActions(context, ref),
        child: Padding(
          padding: AppInsets.pageMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatePill(label: label, color: color),
                  const Spacer(),
                  Text(
                    'ETA ${FormatUtils.formatEta(torrent.eta)}',
                    style: theme.textTheme.labelMedium?.copyWith(color: muted),
                  ),
                ],
              ),
              const SizedBox(height: LegacySpacing.sm),
              Text(
                torrent.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (host != null) ...[
                const SizedBox(height: LegacySpacing.xs),
                Text(
                  host,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ],
              const SizedBox(height: LegacySpacing.sm),
              LinearProgressIndicator(
                value: torrent.progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              const SizedBox(height: LegacySpacing.sm),
              Row(
                children: [
                  Text(
                    FormatUtils.formatBytes(torrent.size),
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                  const SizedBox(width: LegacySpacing.md),
                  _Speed(
                    icon: '↓',
                    value: FormatUtils.formatBytes(torrent.dlspeed),
                    color: Colors.blue,
                  ),
                  const SizedBox(width: LegacySpacing.sm),
                  _Speed(
                    icon: '↑',
                    value: FormatUtils.formatBytes(torrent.upspeed),
                    color: Colors.green,
                  ),
                  const Spacer(),
                  Text(
                    'Ratio ${torrent.ratio.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _stateStyle(String state, ThemeData theme) {
    return switch (state) {
      'downloading' || 'forcedDL' || 'metaDL' => ('Downloading', Colors.blue),
      'stalledDL' => ('Stalled', theme.colorScheme.primary),
      'uploading' || 'forcedUP' => ('Seeding', Colors.green),
      'stalledUP' || 'pausedUP' => ('Completed', Colors.green),
      'pausedDL' => ('Paused', Colors.grey),
      'queuedDL' || 'queuedUP' => ('Queued', Colors.purple),
      'checkingDL' ||
      'checkingUP' ||
      'checkingResumeData' => ('Checking', Colors.teal),
      'error' || 'missingFiles' => ('Error', Colors.red),
      _ => (state, Colors.grey),
    };
  }

  Future<void> _showActions(BuildContext context, WidgetRef ref) async {
    final (icon, label) = _toggleAction(torrent.state);
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(icon),
              title: Text(label),
              onTap: () {
                Navigator.pop(sheetContext);
                _toggleStatus(ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(sheetContext);
                _confirmDelete(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Torrent actions map onto the same `torrents/stop` call for both a
  /// downloading and a seeding torrent, but the two read very differently to
  /// a user — "Pause" implies a download will continue later, "Stop Seeding"
  /// is the accurate label once the file is complete and just uploading.
  (IconData, String) _toggleAction(String state) {
    if (state == 'pausedDL' || state == 'pausedUP') {
      return (Icons.play_arrow, 'Resume');
    }
    if (state == 'uploading' || state == 'forcedUP' || state == 'stalledUP') {
      return (Icons.stop_circle_outlined, 'Stop Seeding');
    }
    return (Icons.pause, 'Pause');
  }

  Future<void> _toggleStatus(WidgetRef ref) async {
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    final isPaused = torrent.state == 'pausedDL' || torrent.state == 'pausedUP';
    if (isPaused) {
      await repository.startTorrents([torrent.hash]);
    } else {
      await repository.stopTorrents([torrent.hash]);
    }
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    var deleteFiles = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Delete Torrent?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to remove "${torrent.name}"?'),
              const SizedBox(height: LegacySpacing.md),
              CheckboxListTile(
                title: const Text('Also delete files on disk'),
                value: deleteFiles,
                onChanged: (val) => setState(() => deleteFiles = val ?? false),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final repository = await ref.read(
        qbitRepositoryProvider(instanceId).future,
      );
      await repository.deleteTorrents([torrent.hash], deleteFiles: deleteFiles);
      ref.invalidate(qbitTorrentsProvider(instanceId));
    }
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LegacySpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Speed extends StatelessWidget {
  const _Speed({required this.icon, required this.value, required this.color});

  final String icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $value',
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: color, fontWeight: FontWeight.w600),
    );
  }
}

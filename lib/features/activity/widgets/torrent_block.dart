/// One torrent, rendered as one of 2h's three block variants: downloading
/// (progress + pause/trash), stalled (recovery action surfaced, not
/// hidden), or seeding (compact row). Replaces
/// `lib/features/downloads/widgets/torrent_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// Whether a torrent has finished downloading (belongs in the Seeding
/// filter rather than Downloading/Stalled).
bool torrentIsComplete(QbitTorrent t) =>
    t.progress >= 1.0 ||
    const {
      'uploading',
      'stalledUP',
      'forcedUP',
      'pausedUP',
      'queuedUP',
    }.contains(t.state);

/// Whether a still-downloading torrent has no peers (2h's "Stalled" block).
bool torrentIsStalled(QbitTorrent t) => t.state == 'stalledDL';

class TorrentBlock extends ConsumerWidget {
  const TorrentBlock({
    required this.instanceId,
    required this.torrent,
    super.key,
  });

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (torrentIsComplete(torrent)) return _SeedingRow(torrent: torrent);
    if (torrentIsStalled(torrent)) {
      return _StalledBlock(instanceId: instanceId, torrent: torrent);
    }
    return _DownloadingBlock(instanceId: instanceId, torrent: torrent);
  }
}

class _DownloadingBlock extends ConsumerWidget {
  const _DownloadingBlock({required this.instanceId, required this.torrent});

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : theme.colorScheme.primary;
    final onSurfaceMuted = isDark
        ? AppColors.n400
        : theme.colorScheme.onSurfaceVariant;
    final host = FormatUtils.trackerHost(torrent.tracker);
    final percent = (torrent.progress * 100).round();
    final peers = torrent.numSeeds + torrent.numLeechs;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        border: AppShadows.ringSm,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: 'Downloading', color: accentColor),
              const Spacer(),
              Text(
                '${FormatUtils.formatEta(torrent.eta)} left',
                style: AppTypography.meta.copyWith(color: onSurfaceMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            torrent.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle.copyWith(height: 1.35),
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: LinearProgressIndicator(
                    value: torrent.progress,
                    minHeight: 3,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: AppColors.a300,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Text(
                '$percent%',
                style: AppTypography.meta.copyWith(color: AppColors.a300),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${FormatUtils.formatBytes(torrent.size)} · $peers peers'
                  '${host != null ? ' · $host' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.meta.copyWith(color: onSurfaceMuted),
                ),
              ),
              _IconAction(
                icon: PhosphorIconsRegular.pause,
                tooltip: 'Pause',
                onPressed: () => _pause(context, ref),
              ),
              _IconAction(
                icon: PhosphorIconsRegular.trash,
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pause(BuildContext context, WidgetRef ref) async {
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    await repository.stopTorrents([torrent.hash]);
    if (!context.mounted) return;
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
              const SizedBox(height: AppSpacing.space4),
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
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.down),
              ),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted) return;
    if (confirmed == true) {
      final repository = await ref.read(
        qbitRepositoryProvider(instanceId).future,
      );
      await repository.deleteTorrents([torrent.hash], deleteFiles: deleteFiles);
      if (!context.mounted) return;
      ref.invalidate(qbitTorrentsProvider(instanceId));
    }
  }
}

class _StalledBlock extends ConsumerWidget {
  const _StalledBlock({required this.instanceId, required this.torrent});

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = isDark ? AppColors.accent : theme.colorScheme.primary;
    final onSurfaceMuted = isDark
        ? AppColors.n400
        : theme.colorScheme.onSurfaceVariant;
    final percent = (torrent.progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        border: AppShadows.ringSm,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: 'Stalled', color: onSurfaceMuted),
              const Spacer(),
              Text(
                'no peers · ${FormatUtils.formatEta(torrent.eta)}',
                style: AppTypography.meta.copyWith(color: onSurfaceMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            torrent.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle.copyWith(height: 1.35),
          ),
          const SizedBox(height: AppSpacing.space3),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: torrent.progress,
              minHeight: 3,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: AppColors.n600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$percent%',
            style: AppTypography.meta.copyWith(color: onSurfaceMuted),
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _findAnotherRelease(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor),
                  ),
                  child: const Text('Find another release'),
                ),
              ),
              _IconAction(
                icon: PhosphorIconsRegular.trash,
                tooltip: 'Delete',
                onPressed: () => _delete(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _findAnotherRelease(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Search for a replacement release from the Library or Wanted tab.',
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    await repository.deleteTorrents([torrent.hash], deleteFiles: false);
    if (!context.mounted) return;
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }
}

class _SeedingRow extends StatelessWidget {
  const _SeedingRow({required this.torrent});

  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurfaceMuted = isDark
        ? AppColors.n400
        : theme.colorScheme.onSurfaceVariant;
    final arrowColor = torrent.ratio >= 1.0 ? AppColors.up : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Icon(PhosphorIconsRegular.arrowUp, size: 16, color: arrowColor),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              '${torrent.name}  ${FormatUtils.formatBytes(torrent.size)} · '
              '↑ ${FormatUtils.formatSpeed(torrent.upspeed)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.meta.copyWith(color: onSurfaceMuted),
            ),
          ),
          Text(
            torrent.ratio.toStringAsFixed(2),
            style: AppTypography.meta.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
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
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}

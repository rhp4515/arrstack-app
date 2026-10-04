/// Bottom sheet listing every file inside one torrent, downloaded or still
/// to come, with executables and disc images flagged so a fake release
/// grabbed by Radarr/Sonarr can be spotted and removed.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/activity/models/torrent_file_risk.dart';
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

Future<void> showTorrentFilesSheet(
  BuildContext context, {
  required String instanceId,
  required QbitTorrent torrent,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => TorrentFilesSheet(instanceId: instanceId, torrent: torrent),
  );
}

class TorrentFilesSheet extends ConsumerWidget {
  const TorrentFilesSheet({
    required this.instanceId,
    required this.torrent,
    super.key,
  });

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesAsync = ref.watch(
      qbitTorrentFilesProvider(instanceId, torrent.hash),
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) => filesAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) => _FileList(
            instanceId: instanceId,
            torrent: torrent,
            files: value,
            scrollController: scrollController,
          ),
          Err(:final error) => _Message(
            scrollController: scrollController,
            torrent: torrent,
            text: error.userMessage,
            onRetry: () => ref.invalidate(
              qbitTorrentFilesProvider(instanceId, torrent.hash),
            ),
          ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _Message(
          scrollController: scrollController,
          torrent: torrent,
          text: 'Unexpected error: $err',
        ),
      ),
    );
  }
}

class _FileList extends StatelessWidget {
  const _FileList({
    required this.instanceId,
    required this.torrent,
    required this.files,
    required this.scrollController,
  });

  final String instanceId;
  final QbitTorrent torrent;
  final List<QbitTorrentFile> files;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return _Message(
        scrollController: scrollController,
        torrent: torrent,
        text:
            'No file list yet — qBittorrent is still fetching this '
            "torrent's metadata. Pull to refresh Transfers and check again.",
      );
    }

    // Flagged files first so they can't hide below a long list of
    // samples and subtitles; otherwise keep qBittorrent's order.
    final sorted = [
      ...files.where((f) => torrentFileRisk(f.name) != TorrentFileRisk.none),
      ...files.where((f) => torrentFileRisk(f.name) == TorrentFileRisk.none),
    ];
    final flagged = flaggedExtensions(files.map((f) => f.name));

    return ListView(
      controller: scrollController,
      padding: AppInsets.pageMd,
      children: [
        _Header(torrent: torrent, fileCount: files.length),
        if (flagged.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space4),
          _RiskBanner(
            instanceId: instanceId,
            torrent: torrent,
            extensions: flagged,
            hasExecutable: files.any(
              (f) => torrentFileRisk(f.name) == TorrentFileRisk.executable,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.space4),
        for (var i = 0; i < sorted.length; i++)
          _FileRow(file: sorted[i], showRule: i < sorted.length - 1),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.torrent, this.fileCount});

  final QbitTorrent torrent;
  final int? fileCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = fileCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(torrent.name, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.space2),
        Text(
          [
            if (count != null) count == 1 ? '1 file' : '$count files',
            FormatUtils.formatBytes(torrent.size),
            '${(torrent.progress * 100).round()}% downloaded',
          ].join(' · '),
          style: AppTypography.meta.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RiskBanner extends ConsumerWidget {
  const _RiskBanner({
    required this.instanceId,
    required this.torrent,
    required this.extensions,
    required this.hasExecutable,
  });

  final String instanceId;
  final QbitTorrent torrent;
  final List<String> extensions;
  final bool hasExecutable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = hasExecutable ? AppColors.down : AppColors.warning;
    final list = extensions.join(', ');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIconsRegular.warning, size: 18, color: color),
              const SizedBox(width: AppSpacing.space2),
              Expanded(
                child: Text(
                  hasExecutable
                      ? 'Contains executable files ($list)'
                      : 'Contains disc images ($list)',
                  style: AppTypography.cardTitle.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            hasExecutable
                ? 'Movie and TV releases never need a program to play. '
                      'This is very likely a fake release carrying malware — '
                      "don't open these files."
                : 'Sonarr and Radarr can\'t import disc images, and fake '
                      'releases often use them to hide an installer.',
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space3),
          OutlinedButton.icon(
            onPressed: () => _remove(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
            ),
            icon: const Icon(PhosphorIconsRegular.trash, size: 16),
            label: const Text('Remove torrent'),
          ),
        ],
      ),
    );
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final removed = await confirmRemoveTorrent(
      context,
      ref,
      instanceId: instanceId,
      torrent: torrent,
      deleteFilesByDefault: true,
    );
    if (removed && context.mounted) Navigator.of(context).pop();
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.file, required this.showRule});

  final QbitTorrentFile file;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final muted = isDark ? AppColors.n400 : theme.colorScheme.onSurfaceVariant;
    final risk = torrentFileRisk(file.name);
    final riskColor = switch (risk) {
      TorrentFileRisk.executable => AppColors.down,
      TorrentFileRisk.diskImage => AppColors.warning,
      TorrentFileRisk.none => null,
    };

    final segments = file.name.split(RegExp(r'[/\\]'));
    final baseName = segments.last;
    final folder = segments.length > 1
        ? segments.sublist(0, segments.length - 1).join('/')
        : null;
    final skipped = file.priority == 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      decoration: showRule
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 0.5),
              ),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            switch (risk) {
              TorrentFileRisk.executable => PhosphorIconsRegular.warningOctagon,
              TorrentFileRisk.diskImage => PhosphorIconsRegular.warning,
              TorrentFileRisk.none => PhosphorIconsRegular.file,
            },
            size: 18,
            color: riskColor ?? muted,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baseName,
                  style: AppTypography.meta.copyWith(
                    color: riskColor ?? theme.colorScheme.onSurface,
                    fontWeight: riskColor != null ? FontWeight.w600 : null,
                  ),
                ),
                if (folder != null)
                  Text(
                    folder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.meta.copyWith(color: muted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                FormatUtils.formatBytes(file.size),
                style: AppTypography.meta.copyWith(color: muted),
              ),
              Text(
                skipped ? 'skipped' : '${(file.progress * 100).floor()}%',
                style: AppTypography.meta.copyWith(color: muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.scrollController,
    required this.torrent,
    required this.text,
    this.onRetry,
  });

  final ScrollController scrollController;
  final QbitTorrent torrent;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
    return ListView(
      controller: scrollController,
      padding: AppInsets.pageMd,
      children: [
        _Header(torrent: torrent),
        const SizedBox(height: AppSpacing.space6),
        Text(text, style: AppTypography.meta),
        if (retry != null) ...[
          const SizedBox(height: AppSpacing.space3),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(onPressed: retry, child: const Text('Retry')),
          ),
        ],
      ],
    );
  }
}

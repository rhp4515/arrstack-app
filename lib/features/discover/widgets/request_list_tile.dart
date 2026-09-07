/// Request-list row card — poster thumbnail, title, media-type/status pill
/// pair, "Requested by X • Nh ago" subtext, optional season count, and a
/// per-card overflow menu (Edit Request / View in TMDB / Delete Request).
/// Matches example_mockups/seerr_requests_listview.jpeg.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/status_chip.dart';
import 'package:arrstack/features/discover/utils/relative_time.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestListTile extends ConsumerWidget {
  const RequestListTile({
    required this.instanceId,
    required this.request,
    required this.onDeleted,
    super.key,
  });

  final String instanceId;
  final SeerrRequest request;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = request.media;
    final tmdbId = media?.tmdbId;

    if (media == null || tmdbId == null) {
      return _Tile(
        instanceId: instanceId,
        request: request,
        onDeleted: onDeleted,
      );
    }

    final detailAsync = ref.watch(
      seerrDetailProvider(
        instanceId: instanceId,
        id: tmdbId,
        mediaType: media.mediaType,
      ),
    );

    final resolved = detailAsync.asData?.value;
    final detail = resolved is Ok<SeerrResult> ? resolved.value : null;

    return _Tile(
      instanceId: instanceId,
      request: request,
      detail: detail,
      onDeleted: onDeleted,
    );
  }
}

class _Tile extends ConsumerWidget {
  const _Tile({
    required this.instanceId,
    required this.request,
    required this.onDeleted,
    this.detail,
  });

  final String instanceId;
  final SeerrRequest request;
  final SeerrResult? detail;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final media = request.media;
    final title = detail?.displayTitle ?? 'Request #${request.id}';
    final posterUrl = detail?.posterUrl;
    final isTv = media?.mediaType == 'tv';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Padding(
        padding: AppInsets.pageMd,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: posterUrl != null
                  ? Image.network(
                      posterUrl,
                      width: 56,
                      height: 84,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56,
                      height: 84,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.movie_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      StatusChip(
                        label: isTv ? 'TV' : 'Movie',
                        color: Colors.grey,
                      ),
                      if (media != null) _mediaStatusChip(media.status),
                    ],
                  ),
                  if (isTv && request.seasons.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Seasons: ${request.seasons.map((s) => s.seasonNumber).join(', ')}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Requested by ${request.requestedBy?.displayName ?? 'unknown'}'
                    '${request.createdAt != null ? ' • ${formatRelativeTime(request.createdAt!)}' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _onMenuSelected(context, ref, value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit Request')),
                const PopupMenuItem(value: 'tmdb', child: Text('View in TMDB')),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Delete Request',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mediaStatusChip(int status) {
    final (label, color) = switch (status) {
      SeerrMediaStatus.pending => ('Pending', Colors.orange),
      SeerrMediaStatus.processing => ('Processing', Colors.purple),
      SeerrMediaStatus.partiallyAvailable => ('Partial', Colors.lightGreen),
      SeerrMediaStatus.available => ('Available', Colors.green),
      SeerrMediaStatus.deleted => ('Deleted', Colors.grey),
      _ => ('Unknown', Colors.grey),
    };
    return StatusChip(label: label, color: color);
  }

  Future<void> _onMenuSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    final media = request.media;

    switch (value) {
      case 'edit':
        if (media?.tmdbId != null) {
          context.go(
            RoutePaths.discoverDetail(
              instanceId,
              media!.tmdbId!,
              media.mediaType,
            ),
          );
        }
      case 'tmdb':
        if (media?.tmdbId != null) {
          final uri = Uri.parse(media!.tmdbUrl);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Request?'),
            content: const Text('This will remove the request from Seerr.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        if (!context.mounted) return;

        final repository = await ref.read(
          seerrRepositoryProvider(instanceId).future,
        );
        final result = await repository.deleteRequest(request.id);
        if (!context.mounted) return;

        switch (result) {
          case Ok():
            onDeleted();
          case Err(:final error):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Delete failed: ${error.userMessage}')),
            );
        }
    }
  }
}

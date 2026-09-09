import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverDetailPage extends ConsumerWidget {
  const DiscoverDetailPage({
    required this.instanceId,
    required this.id,
    required this.mediaType,
    super.key,
  });

  final String instanceId;
  final int id;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveIdAsync = instanceId.isNotEmpty
        ? AsyncData(instanceId)
        : ref.watch(selectedSeerrInstanceIdProvider);

    return effectiveIdAsync.when(
      data: (finalId) {
        if (finalId == null) {
          return const Scaffold(
            body: Center(child: Text('No instance selected')),
          );
        }

        final detailAsync = ref.watch(
          seerrDetailProvider(
            instanceId: finalId,
            id: id,
            mediaType: mediaType,
          ),
        );

        return detailAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _DetailContent(
              instanceId: finalId,
              item: value,
            ),
            Err(:final error) => Scaffold(
              appBar: AppBar(),
              body: EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load details',
                message: error.userMessage,
              ),
            ),
          },
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: $err')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({required this.instanceId, required this.item});

  final String instanceId;
  final SeerrResult item;

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(title: Text(item.displayTitle ?? 'Details')),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          Center(
            child: item.posterUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Image.network(
                      item.posterUrl!,
                      width: 200,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.movie_outlined, size: 100),
          ),
          const SizedBox(height: LegacySpacing.lg),
          Text(
            item.displayTitle ?? '',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (item.displayDate != null) ...[
            const SizedBox(height: LegacySpacing.xs),
            Text(
              item.displayDate!,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
          const SizedBox(height: LegacySpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.voteAverage != null && item.voteAverage! > 0)
                DetailChip(
                  label: '★ ${item.voteAverage!.toStringAsFixed(1)}',
                  color: Colors.orange,
                ),
              const SizedBox(width: LegacySpacing.sm),
              _RequestStatusChip(mediaInfo: item.mediaInfo),
            ],
          ),
          const SizedBox(height: LegacySpacing.lg),
          Text('Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: LegacySpacing.sm),
          Text(item.overview ?? 'No overview available.'),
          const SizedBox(height: LegacySpacing.xl),
          if (_canRequest(item.mediaInfo))
            FilledButton.icon(
              onPressed: _isRequesting ? null : _handleRequest,
              icon: _isRequesting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add_circle_outline),
              label: const Text('Request Media'),
            ),
        ],
      ),
    );
  }

  bool _canRequest(SeerrMediaInfo? info) {
    if (info == null) return true;
    // MediaStatus (server/constants/media.ts): only a fully AVAILABLE item
    // has nothing left to request.
    return info.status != SeerrMediaStatus.available;
  }

  Future<void> _handleRequest() async {
    setState(() => _isRequesting = true);

    final repository = await ref.read(
      seerrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repository.request(
      widget.item.id,
      widget.item.mediaType,
    );

    if (mounted) {
      setState(() => _isRequesting = false);
      if (result is Ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        ref.invalidate(
          seerrDetailProvider(
            instanceId: widget.instanceId,
            id: widget.item.id,
            mediaType: widget.item.mediaType,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Request failed: ${(result as Err).error.userMessage}',
            ),
          ),
        );
      }
    }
  }
}

class _RequestStatusChip extends StatelessWidget {
  const _RequestStatusChip({this.mediaInfo});
  final SeerrMediaInfo? mediaInfo;

  @override
  Widget build(BuildContext context) {
    if (mediaInfo == null) return const SizedBox.shrink();

    final (label, color) = switch (mediaInfo!.status) {
      SeerrMediaStatus.pending => ('Pending', Colors.orange),
      SeerrMediaStatus.processing => ('Processing', Colors.purple),
      SeerrMediaStatus.partiallyAvailable => (
        'Partially Available',
        Colors.lightGreen,
      ),
      SeerrMediaStatus.available => ('Available', Colors.green),
      SeerrMediaStatus.deleted => ('Deleted', Colors.grey),
      _ => ('Unknown', Colors.grey),
    };

    return DetailChip(label: label, color: color);
  }
}

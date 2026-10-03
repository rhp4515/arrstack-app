/// The "History" sub-tab: the selected instance's grab/import/failure
/// events, newest first, with a quality chip and a "Load more" footer.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/widgets/section_header.dart';
import 'package:arrstack/features/library/library_format.dart';
import 'package:arrstack/features/library/library_section_providers.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/features/library/widgets/section_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LibraryHistoryView extends ConsumerWidget {
  const LibraryHistoryView({
    required this.type,
    required this.instanceId,
    this.query = '',
    super.key,
  });

  final ServiceType type;
  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = libraryHistoryProvider(type, instanceId);
    final historyAsync = ref.watch(provider);
    Future<void> refresh() async => ref.invalidate(provider);

    return historyAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(context, ref, refresh, value),
        Err(:final error) => RefreshableError(
          onRefresh: refresh,
          title: "Couldn't load history",
          message: error.userMessage,
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => RefreshableError(
        onRefresh: refresh,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() refresh,
    LibraryHistoryFeed feed,
  ) {
    final entries = feed.entries
        .where((e) => matchesQuery(query, e.title))
        .toList();
    if (entries.isEmpty && !feed.hasMore) {
      return RefreshableMessage(
        onRefresh: refresh,
        icon: PhosphorIconsRegular.clockCounterClockwise,
        title: 'No history yet',
        message: 'Grabs, imports and failures will appear here.',
      );
    }
    final now = DateTime.now();
    return RefreshableSection(
      onRefresh: refresh,
      children: [
        const SizedBox(height: AppSpacing.space2),
        SectionHeader(
          kicker: 'HISTORY · ${entries.length}',
          trailing: type == ServiceType.radarr ? 'Radarr' : 'Sonarr',
        ),
        const SizedBox(height: AppSpacing.space2),
        for (var i = 0; i < entries.length; i++)
          LibraryRow(
            service: type,
            instanceId: instanceId,
            posterUrl: entries[i].posterUrl,
            title: entries[i].title,
            metaParts: [historyEventLabel(entries[i].eventType)],
            metaColor: isFailureEvent(entries[i].eventType)
                ? AppColors.down
                : null,
            detail: formatHistoryDate(entries[i].date, now: now),
            trailing: LibraryRowTrailing.none,
            trailingText: entries[i].quality,
            trailingNeutral: isFailureEvent(entries[i].eventType),
            showRule: i < entries.length - 1,
          ),
        if (feed.hasMore)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space4),
            child: Center(
              child: TextButton(
                onPressed: () => _loadMore(context, ref),
                child: const Text('Load more'),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _loadMore(BuildContext context, WidgetRef ref) async {
    final error = await ref
        .read(libraryHistoryProvider(type, instanceId).notifier)
        .loadMore();
    if (error == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Couldn't load more: ${error.userMessage}")),
    );
  }
}

/// The "Queue" sub-tab: the selected instance's download queue with
/// status, progress % and time left.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/library_section_providers.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/features/library/widgets/section_states.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LibraryQueueView extends ConsumerWidget {
  const LibraryQueueView({
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
    final queueAsync = ref.watch(libraryQueueProvider(type, instanceId));
    Future<void> refresh() async => type == ServiceType.radarr
        ? ref.invalidate(radarrQueueProvider(instanceId))
        : ref.invalidate(sonarrQueueProvider(instanceId));

    return queueAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(
          refresh,
          value.where((e) => matchesQuery(query, e.title)).toList(),
        ),
        Err(:final error) => RefreshableError(
          onRefresh: refresh,
          title: "Couldn't load the queue",
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
    Future<void> Function() refresh,
    List<LibraryQueueEntry> entries,
  ) {
    if (entries.isEmpty) {
      return RefreshableMessage(
        onRefresh: refresh,
        icon: PhosphorIconsRegular.downloadSimple,
        title: 'Queue is empty',
        message: 'Nothing is downloading right now.',
      );
    }
    return RefreshableSection(
      onRefresh: refresh,
      children: [
        const SizedBox(height: AppSpacing.space2),
        Text('QUEUE · ${entries.length}', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space2),
        for (var i = 0; i < entries.length; i++)
          LibraryRow(
            service: type,
            instanceId: instanceId,
            posterUrl: entries[i].posterUrl,
            title: entries[i].title,
            metaParts: [
              entries[i].status,
              '${(entries[i].progress * 100).round()}%',
              if (entries[i].timeLeft != null) entries[i].timeLeft!,
            ],
            detail: entries[i].releaseTitle,
            trailing: LibraryRowTrailing.progress,
            progress: entries[i].progress,
            showRule: i < entries.length - 1,
          ),
      ],
    );
  }
}

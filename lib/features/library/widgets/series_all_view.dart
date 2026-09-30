/// The Shows collection's "All" sub-tab: the Continue Watching strip (when
/// anything qualifies) above the sortable ALL SHOWS list.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/continue_watching_row.dart';
import 'package:arrstack/features/library/widgets/library_sort_toggle.dart';
import 'package:arrstack/features/library/widgets/series_list.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeriesAllView extends ConsumerWidget {
  const SeriesAllView({
    required this.instanceId,
    required this.query,
    super.key,
  });

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueWatchingAsync = ref.watch(
      continueWatchingProvider(instanceId),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(sonarrSeriesProvider(instanceId))
          ..invalidate(continueWatchingProvider(instanceId));
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          continueWatchingAsync.maybeWhen(
            data: (entries) => entries.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.space6),
                    child: ContinueWatchingRow(
                      instanceId: instanceId,
                      entries: entries,
                    ),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          const LibraryListHeader(label: 'ALL SHOWS'),
          const SizedBox(height: AppSpacing.space2),
          SeriesList(
            instanceId: instanceId,
            query: query,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            sort: ref.watch(activeLibrarySortProvider),
          ),
        ],
      ),
    );
  }
}

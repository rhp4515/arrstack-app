/// The Activity tab (spec screens 2h/2i/2j): a lens-chip header switching
/// between Transfers, Calendar, and Wanted, replacing the old separate
/// Downloads/Calendar/Subtitles pages.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/calendar_lens.dart';
import 'package:arrstack/features/activity/widgets/lens_chips.dart';
import 'package:arrstack/features/activity/widgets/transfers_lens.dart';
import 'package:arrstack/features/activity/widgets/wanted_lens.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/features/downloads/widgets/add_torrent_dialog.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

ActivityLens? _lensFromQueryValue(String? value) => switch (value) {
  'transfers' => ActivityLens.transfers,
  'calendar' => ActivityLens.calendar,
  'wanted' => ActivityLens.wanted,
  _ => null,
};

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({this.initialLens, super.key});

  /// The `?lens=` query value from the route, used only to seed
  /// [activeActivityLensProvider] on first build (spec Decision 1).
  final String? initialLens;

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  @override
  void initState() {
    super.initState();
    final seeded = _lensFromQueryValue(widget.initialLens);
    if (seeded != null) {
      Future.microtask(() {
        ref.read(activeActivityLensProvider.notifier).select(seeded);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lens = ref.watch(activeActivityLensProvider);
    final episodeCount =
        ref.watch(sonarrMissingEpisodesProvider).value?.length ?? 0;
    final subtitleCount =
        ref.watch(bazarrWantedAggregateProvider).value?.subtitles.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [_TrailingAction(lens: lens)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space6,
              vertical: AppSpacing.space3,
            ),
            child: LensChips(wantedCount: episodeCount + subtitleCount),
          ),
          Expanded(
            child: switch (lens) {
              ActivityLens.transfers => const TransfersLens(),
              ActivityLens.calendar => const CalendarLens(),
              ActivityLens.wanted => const WantedLens(),
            },
          ),
        ],
      ),
    );
  }
}

class _TrailingAction extends ConsumerWidget {
  const _TrailingAction({required this.lens});

  final ActivityLens lens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (lens) {
      ActivityLens.transfers => IconButton(
        icon: const Icon(PhosphorIconsRegular.plus),
        tooltip: 'Add torrent',
        onPressed: () => _addTorrent(context, ref),
      ),
      ActivityLens.calendar => const SizedBox.shrink(),
      ActivityLens.wanted => TextButton(
        onPressed: () => _searchAllSubtitles(context, ref),
        child: const Text('Search all'),
      ),
    };
  }

  Future<void> _addTorrent(BuildContext context, WidgetRef ref) async {
    final id = await ref.read(selectedDownloadInstanceIdProvider.future);
    if (!context.mounted) return;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please configure a qBittorrent instance first.'),
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (context) => AddTorrentDialog(instanceId: id),
    );
  }

  Future<void> _searchAllSubtitles(BuildContext context, WidgetRef ref) async {
    final instancesResult = await ref.read(instancesProvider.future);
    if (instancesResult is! Ok<List<ServiceInstance>>) return;

    final bazarrInstances = instancesResult.value
        .where((i) => i.serviceType == ServiceType.bazarr)
        .toList();

    var successCount = 0;
    for (final instance in bazarrInstances) {
      final repo = await ref.read(bazarrRepositoryProvider(instance.id).future);
      final result = await repo.searchAllSubtitles();
      if (result.isOk) successCount++;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Global search triggered on $successCount of '
          '${bazarrInstances.length} Bazarr instance(s).',
        ),
      ),
    );
  }
}

/// Prowlarr indexer status + stats (README §2l): a headline stat row, one
/// row per indexer keyed by enabled/disabled and response time, and a
/// "LAST 24H" totals block.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/indexers/indexer_stats.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class IndexersPage extends ConsumerWidget {
  const IndexersPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexersAsync = ref.watch(prowlarrIndexersProvider(instanceId));
    final stats30dAsync = ref.watch(
      prowlarrIndexerStats30dProvider(instanceId),
    );
    final stats24hAsync = ref.watch(
      prowlarrIndexerStatsLast24hProvider(instanceId),
    );

    void refresh() {
      ref.invalidate(prowlarrIndexersProvider(instanceId));
      ref.invalidate(prowlarrIndexerStats30dProvider(instanceId));
      ref.invalidate(prowlarrIndexerStatsLast24hProvider(instanceId));
    }

    return Scaffold(
      appBar: SubPageHeader(
        kicker: 'PROWLARR',
        title: 'Indexers',
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 17),
            tooltip: 'Refresh',
            onPressed: refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: indexersAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _IndexersBody(
              indexers: value,
              stats30d: stats30dAsync.asData?.value,
              stats24h: stats24hAsync.asData?.value,
            ),
            Err(:final error) => EmptyState(
              icon: Icons.error_outline,
              title: 'Failed to load indexers',
              message: error.userMessage,
              action: FilledButton(
                onPressed: refresh,
                child: const Text('Retry'),
              ),
            ),
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Unexpected error: $err')),
        ),
      ),
    );
  }
}

class _IndexersBody extends StatelessWidget {
  const _IndexersBody({required this.indexers, this.stats30d, this.stats24h});

  final List<Indexer> indexers;
  final Result<IndexerStatsResponse>? stats30d;
  final Result<IndexerStatsResponse>? stats24h;

  @override
  Widget build(BuildContext context) {
    if (indexers.isEmpty) {
      return const EmptyState(
        icon: Icons.list_alt_outlined,
        title: 'No indexers configured',
        message: 'Add indexers in the Prowlarr web UI.',
      );
    }

    final stats30dList = switch (stats30d) {
      Ok(:final value) => value.indexers,
      _ => const <IndexerStat>[],
    };
    final stats24hList = switch (stats24h) {
      Ok(:final value) => value.indexers,
      _ => const <IndexerStat>[],
    };
    final totals30d = aggregateIndexerStats(stats30dList);
    final totals24h = aggregateIndexerStats(stats24hList);
    final enabledCount = indexers.where((i) => i.enable).length;

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        Row(
          children: [
            _Stat(value: '$enabledCount', label: 'ENABLED'),
            const SizedBox(width: AppSpacing.space8),
            _Stat(value: '${totals30d.totalGrabs}', label: 'GRABS 30D'),
            const SizedBox(width: AppSpacing.space8),
            _Stat(
              value: '${totals30d.slowestResponseMs}',
              label: 'SLOWEST ms',
              color: isSlowResponse(totals30d.slowestResponseMs)
                  ? AppColors.warning
                  : null,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space6),
        Text('INDEXERS · ${indexers.length}', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space4),
        for (final indexer in indexers)
          _IndexerRow(
            indexer: indexer,
            stat: stats30dList
                .where((s) => s.indexerId == indexer.id)
                .firstOrNull,
          ),
        const SizedBox(height: AppSpacing.space4),
        const FadingRule(),
        const SizedBox(height: AppSpacing.space4),
        Text('LAST 24H', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space3),
        _TotalsRow(label: 'Queries', value: totals24h.queries),
        _TotalsRow(label: 'Grabs', value: totals24h.grabs),
        _TotalsRow(
          label: 'Failures',
          value: totals24h.failures,
          color: totals24h.failures > 0 ? AppColors.warning : null,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.color});

  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.statNumeral.copyWith(color: color)),
        Text(label, style: AppTypography.statCaption),
      ],
    );
  }
}

class _IndexerRow extends StatelessWidget {
  const _IndexerRow({required this.indexer, required this.stat});

  final Indexer indexer;
  final IndexerStat? stat;

  @override
  Widget build(BuildContext context) {
    final stat = this.stat;
    final slow = stat != null && isSlowResponse(stat.averageResponseTime);
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Row(
        children: [
          Icon(
            indexer.enable
                ? PhosphorIconsFill.checkCircle
                : PhosphorIconsFill.xCircle,
            size: 16,
            color: indexer.enable ? AppColors.up : AppColors.down,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(indexer.name, style: AppTypography.cardTitle),
                Text(
                  '${indexer.protocol} · priority ${indexer.priority}'
                  '${slow ? ' · slow responses' : ''}',
                  style: AppTypography.meta.copyWith(
                    color: slow ? AppColors.warning : AppColors.n500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              indexer.enable && stat != null ? '${stat.numberOfGrabs}' : '—',
              textAlign: TextAlign.right,
              style: AppTypography.meta.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              indexer.enable && stat != null
                  ? '${stat.averageResponseTime} ms'
                  : '—',
              textAlign: TextAlign.right,
              style: AppTypography.meta.copyWith(
                color: slow ? AppColors.warning : null,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );

    return indexer.enable ? content : Opacity(opacity: 0.62, child: content);
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({required this.label, required this.value, this.color});

  final String label;
  final int value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.meta),
          Text(
            '$value',
            style: AppTypography.meta.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

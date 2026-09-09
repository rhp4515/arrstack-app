import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexersPage extends ConsumerWidget {
  const IndexersPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexersAsync = ref.watch(prowlarrIndexersProvider(instanceId));
    final statsAsync = ref.watch(prowlarrIndexerStatsProvider(instanceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Prowlarr Indexers')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(prowlarrIndexersProvider(instanceId));
          ref.invalidate(prowlarrIndexerStatsProvider(instanceId));
        },
        child: indexersAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _buildIndexersList(value, statsAsync),
            Err(:final error) => EmptyState(
              icon: Icons.error_outline,
              title: 'Failed to load indexers',
              message: error.userMessage,
              action: FilledButton(
                onPressed: () {
                  ref.invalidate(prowlarrIndexersProvider(instanceId));
                  ref.invalidate(prowlarrIndexerStatsProvider(instanceId));
                },
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

  Widget _buildIndexersList(
    List<Indexer> indexers,
    AsyncValue<Result<IndexerStatsResponse>> statsAsync,
  ) {
    if (indexers.isEmpty) {
      return const EmptyState(
        icon: Icons.list_alt_outlined,
        title: 'No indexers configured',
        message: 'Add indexers in Prowlarr web UI.',
      );
    }

    final statsResponse = statsAsync.asData?.value;
    final List<IndexerStat> statsResult = switch (statsResponse) {
      Ok(:final value) => value.indexers,
      _ => const [],
    };

    return ListView.builder(
      padding: AppInsets.pageMd,
      itemCount: indexers.length,
      itemBuilder: (context, index) {
        final indexer = indexers[index];
        final stat = statsResult
            .where((s) => s.indexerId == indexer.id)
            .firstOrNull;

        return Card(
          margin: const EdgeInsets.only(bottom: LegacySpacing.sm),
          child: ListTile(
            title: Text(indexer.name),
            subtitle: Text(
              'Priority: ${indexer.priority} • Protocol: ${indexer.protocol}',
            ),
            trailing: stat == null
                ? const SizedBox.shrink()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${stat.averageResponseTime}ms',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${stat.numberOfGrabs} grabs',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
            leading: Icon(
              indexer.enable ? Icons.check_circle : Icons.cancel,
              color: indexer.enable ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}

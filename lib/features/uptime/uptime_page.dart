/// Uptime tab: Uptime Kuma monitors and real-time status (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/uptime/uptime_providers.dart';
import 'package:arrstack/features/uptime/widgets/monitor_tile.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UptimePage extends ConsumerWidget {
  const UptimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedUptimeInstanceIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uptime Monitors'),
      ),
      body: instanceIdAsync.when(
        data: (id) => id == null ? const _NoKumaInstance() : _MonitorList(instanceId: id),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _MonitorList extends ConsumerWidget {
  const _MonitorList({required this.instanceId});
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monitorsAsync = ref.watch(kumaMonitorsProvider(instanceId));

    return Column(
      children: [
        _InstanceSelector(selectedId: instanceId),
        monitorsAsync.when(
          data: (result) {
            if (result case Ok(:final value)) {
              final upCount = value.where((m) => m.status == 1).length;
              return _SummaryHeader(upCount: upCount, totalCount: value.length);
            }
            return const SizedBox.shrink();
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        Expanded(
          child: monitorsAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => value.isEmpty
                  ? const EmptyState(
                      icon: Icons.monitor_heart_outlined,
                      title: 'No monitors found',
                      message: 'Your Uptime Kuma has no monitors configured.',
                    )
                  : ListView.builder(
                      padding: AppInsets.pageMd,
                      itemCount: value.length,
                      itemBuilder: (context, index) => MonitorTile(monitor: value[index]),
                    ),
              Err(:final error) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Failed to connect',
                  message: error.userMessage,
                  action: FilledButton(
                    onPressed: () => ref.invalidate(kumaMonitorsProvider(instanceId)),
                    child: const Text('Retry'),
                  ),
                ),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Socket error: $err')),
          ),
        ),
      ],
    );
  }
}

class _InstanceSelector extends ConsumerWidget {
  const _InstanceSelector({required this.selectedId});
  final String selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);

    return instancesAsync.when(
      data: (result) {
        if (result case Ok(:final value)) {
          final typed = value.where((i) => i.serviceType == ServiceType.uptimeKuma).toList();
          if (typed.length <= 1) return const SizedBox.shrink();

          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Text('Instance:', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: selectedId,
                  underline: const SizedBox.shrink(),
                  items: typed.map((i) => DropdownMenuItem(value: i.id, child: Text(i.name))).toList(),
                  onChanged: (id) => id != null ? ref.read(selectedUptimeInstanceIdProvider.notifier).selectInstance(id) : null,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _NoKumaInstance extends StatelessWidget {
  const _NoKumaInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.monitor_heart_outlined,
      title: 'No Uptime Kuma',
      message: 'Configure an Uptime Kuma service in Settings to see your monitors.',
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.upCount, required this.totalCount});
  final int upCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allUp = upCount == totalCount && totalCount > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      color: (allUp ? Colors.green : Colors.orange).withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            allUp ? Icons.check_circle_outline : Icons.warning_amber_outlined,
            color: allUp ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '$upCount / $totalCount Monitors Up',
            style: theme.textTheme.titleMedium?.copyWith(
              color: allUp ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

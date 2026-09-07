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
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UptimePage extends ConsumerWidget {
  const UptimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedUptimeInstanceIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Uptime Monitors')),
      body: instanceIdAsync.when(
        data: (id) =>
            id == null ? const _NoKumaInstance() : _MonitorList(instanceId: id),
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
        Expanded(
          child: monitorsAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) =>
                value.isEmpty
                    ? const EmptyState(
                        icon: Icons.monitor_heart_outlined,
                        title: 'No monitors found',
                        message: 'Your Uptime Kuma has no monitors configured.',
                      )
                    : ListView(
                        padding: AppInsets.pageMd,
                        children: [
                          _AdminOverview(monitors: value),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Monitors',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          for (final monitor in value)
                            MonitorTile(monitor: monitor),
                        ],
                      ),
              Err(:final error) => EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to connect',
                message: error.userMessage,
                action: FilledButton(
                  onPressed: () =>
                      ref.invalidate(kumaMonitorsProvider(instanceId)),
                  child: const Text('Retry'),
                ),
              ),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Socket error: $err')),
          ),
        ),
      ],
    );
  }
}

/// The 2×2 "Admin Overview" stat grid: Monitors / Paused / Down / Maintenance.
class _AdminOverview extends StatelessWidget {
  const _AdminOverview({required this.monitors});

  final List<KumaMonitor> monitors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paused = monitors.where((m) => !m.active).length;
    final down = monitors.where((m) => m.status == 0).length;
    final maintenance = monitors.where((m) => m.status == 3).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin Overview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.monitor_heart,
                iconColor: Colors.blue,
                value: monitors.length,
                label: 'MONITORS',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.pause,
                iconColor: Colors.orange,
                value: paused,
                label: 'PAUSED',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.red,
                value: down,
                label: 'DOWN',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.build,
                iconColor: Colors.green,
                value: maintenance,
                label: 'MAINTENANCE',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: iconColor.withValues(alpha: 0.16),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$value',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
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
          final typed = value
              .where((i) => i.serviceType == ServiceType.uptimeKuma)
              .toList();
          if (typed.length <= 1) return const SizedBox.shrink();

          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Text(
                  'Instance:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String>(
                  value: selectedId,
                  underline: const SizedBox.shrink(),
                  items: typed
                      .map(
                        (i) =>
                            DropdownMenuItem(value: i.id, child: Text(i.name)),
                      )
                      .toList(),
                  onChanged: (id) => id != null
                      ? ref
                            .read(selectedUptimeInstanceIdProvider.notifier)
                            .selectInstance(id)
                      : null,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
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
      message:
          'Configure an Uptime Kuma service in Settings to see your monitors.',
    );
  }
}

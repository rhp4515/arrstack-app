/// Uptime tab: Uptime Kuma monitors and real-time status (README §2k).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/features/uptime/uptime_providers.dart';
import 'package:arrstack/features/uptime/widgets/down_monitor_card.dart';
import 'package:arrstack/features/uptime/widgets/healthy_monitor_row.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class UptimePage extends ConsumerWidget {
  const UptimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedUptimeInstanceIdProvider);
    final instanceId = instanceIdAsync.asData?.value;

    return Scaffold(
      appBar: SubPageHeader(
        kicker: 'UPTIME KUMA',
        title: 'Monitors',
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 17),
            tooltip: 'Refresh',
            onPressed: instanceId == null
                ? null
                : () => ref.invalidate(kumaMonitorsProvider(instanceId)),
          ),
        ],
      ),
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

    return monitorsAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? const EmptyState(
                  icon: Icons.monitor_heart_outlined,
                  title: 'No monitors found',
                  message: 'Your Uptime Kuma has no monitors configured.',
                )
              : _MonitorContent(instanceId: instanceId, monitors: value),
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
      error: (err, _) => Center(child: Text('Socket error: $err')),
    );
  }
}

class _MonitorContent extends ConsumerWidget {
  const _MonitorContent({required this.instanceId, required this.monitors});

  final String instanceId;
  final List<KumaMonitor> monitors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final down = monitors.where(isMonitorDown).toList();
    final up = monitors.where(isMonitorUp).toList();
    final paused = monitors.where(isMonitorPaused).toList();
    // Active monitors whose Kuma status is neither up nor down (e.g.
    // Pending or Maintenance) — these must still show up somewhere on the
    // page rather than silently vanishing (README §2k final-review finding
    // 6).
    final other = monitors
        .where(
          (m) => !isMonitorUp(m) && !isMonitorDown(m) && !isMonitorPaused(m),
        )
        .toList();

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        _StatRow(up: up.length, down: down.length, paused: paused.length),
        const SizedBox(height: AppSpacing.space6),
        for (final monitor in down)
          DownMonitorCard(
            monitor: monitor,
            onRetest: () => ref.invalidate(kumaMonitorsProvider(instanceId)),
          ),
        if (up.isNotEmpty) ...[
          Text('HEALTHY · ${up.length}', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space4),
          for (final monitor in up) HealthyMonitorRow(monitor: monitor),
        ],
        if (other.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space4),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          Text('OTHER · ${other.length}', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space4),
          for (final monitor in other)
            _CompactMonitorRow(monitor: monitor, label: statusLabel(monitor)),
        ],
        if (paused.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space4),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          for (final monitor in paused)
            _CompactMonitorRow(
              monitor: monitor,
              label: pausedDurationLabel(monitor),
            ),
        ],
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.up, required this.down, required this.paused});

  final int up;
  final int down;
  final int paused;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(value: up, label: 'UP', color: AppColors.up),
        const SizedBox(width: AppSpacing.space8),
        _Stat(value: down, label: 'DOWN', color: AppColors.down),
        const SizedBox(width: AppSpacing.space8),
        _Stat(value: paused, label: 'PAUSED', color: AppColors.n500),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: AppTypography.statNumeral.copyWith(color: color)),
        Text(label, style: AppTypography.statCaption),
      ],
    );
  }
}

/// A small dot + name + status-label row used for monitors that don't get
/// a full [DownMonitorCard] or [HealthyMonitorRow] treatment — paused
/// monitors, and active monitors in a non-up/down Kuma status (Pending,
/// Maintenance).
class _CompactMonitorRow extends StatelessWidget {
  const _CompactMonitorRow({required this.monitor, required this.label});
  final KumaMonitor monitor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.n600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              monitor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle.copyWith(color: AppColors.n500),
            ),
          ),
          Text(label, style: AppTypography.meta),
        ],
      ),
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

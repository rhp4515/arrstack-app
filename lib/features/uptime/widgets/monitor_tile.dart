/// A monitor card for the Uptime Kuma view, matching the mockup: a status dot
/// and name with an overflow menu, the monitored URL, a heartbeat bar, and a
/// "Up · latency · uptime% · 24h" footer with a type badge (HTTP, etc.).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Number of heartbeat bars to render.
const int _heartbeatCount = 34;

class MonitorTile extends StatelessWidget {
  const MonitorTile({required this.monitor, super.key});

  final KumaMonitor monitor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final statusColor = _statusColor(monitor.status);
    final latestPing = monitor.heartbeats.isNotEmpty
        ? monitor.heartbeats.first.ping
        : null;

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: AppInsets.pageMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusDot(color: statusColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    monitor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (monitor.url != null && monitor.url!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _copyUrl(context),
                    tooltip: 'Copy URL',
                  ),
              ],
            ),
            if (monitor.url != null && monitor.url!.isNotEmpty)
              Text(
                monitor.url!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            const SizedBox(height: AppSpacing.md),
            _HeartbeatBar(heartbeats: monitor.heartbeats, upColor: statusColor),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  monitor.status.statusLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (latestPing != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    '$latestPing ms',
                    style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                  ),
                ],
                const SizedBox(width: AppSpacing.md),
                Text(
                  '${(monitor.uptime * 100).toStringAsFixed(2)}% 24h',
                  style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                ),
                const Spacer(),
                _TypeBadge(type: monitor.type),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyUrl(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: monitor.url!));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Monitor URL copied')),
    );
  }

  Color _statusColor(int status) => switch (status) {
    1 => const Color(0xFF5CDD8B),
    0 => Colors.red,
    2 => Colors.orange,
    3 => Colors.blue,
    _ => Colors.grey,
  };
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        type.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeartbeatBar extends StatelessWidget {
  const _HeartbeatBar({required this.heartbeats, required this.upColor});

  final List<KumaHeartbeat> heartbeats;
  final Color upColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Heartbeats are stored newest-first; show oldest→newest left→right.
    final recent = heartbeats.take(_heartbeatCount).toList().reversed.toList();
    final empty = _heartbeatCount - recent.length;

    return SizedBox(
      height: 28,
      child: Row(
        children: [
          for (var i = 0; i < empty; i++)
            _bar(theme.colorScheme.surfaceContainerHighest),
          for (final hb in recent)
            _bar(hb.status == 1 ? upColor : Colors.red),
        ],
      ),
    );
  }

  Widget _bar(Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

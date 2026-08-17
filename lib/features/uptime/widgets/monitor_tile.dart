/// A tile for a single Uptime Kuma monitor (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class MonitorTile extends StatelessWidget {
  const MonitorTile({required this.monitor, super.key});

  final KumaMonitor monitor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = monitor.status;
    
    final statusColor = switch (status) {
      1 => Colors.green,
      0 => Colors.red,
      2 => Colors.orange,
      3 => Colors.blue,
      _ => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: AppInsets.pageMd,
        child: Column(
          children: [
            Row(
              children: [
                _StatusIndicator(color: statusColor),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monitor.name,
                        style: theme.textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (monitor.url != null)
                        Text(
                          monitor.url!,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${(monitor.uptime * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'UPTIME',
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            if (monitor.heartbeats.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _HeartbeatBar(heartbeats: monitor.heartbeats),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.color});
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

class _HeartbeatBar extends StatelessWidget {
  const _HeartbeatBar({required this.heartbeats});
  final List<KumaHeartbeat> heartbeats;

  @override
  Widget build(BuildContext context) {
    // Show last 30 heartbeats
    final displayHeartbeats = heartbeats.take(30).toList().reversed.toList();

    return SizedBox(
      height: 20,
      child: Row(
        children: displayHeartbeats.map((hb) {
          final color = hb.status == 1 ? Colors.green : Colors.red;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

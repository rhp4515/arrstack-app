/// The down-monitor hero card in Uptime (README §2k): red inset ring, a
/// glowing status dot, the monitor's type and URL, a 24-beat heartbeat
/// strip, and a footer with the down duration, 24h uptime, and Retest.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/features/uptime/widgets/heartbeat_strip.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class DownMonitorCard extends StatelessWidget {
  const DownMonitorCard({
    required this.monitor,
    required this.onRetest,
    super.key,
  });

  final KumaMonitor monitor;
  final VoidCallback onRetest;

  @override
  Widget build(BuildContext context) {
    final uptimePercent = (monitor.uptime * 100).toStringAsFixed(2);
    final url = monitor.url;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space4),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.down.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.down,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.down.withValues(alpha: 0.9),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Text(
                  monitor.name,
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DetailChip(
                label: monitor.type.toUpperCase(),
                color: AppColors.n400,
              ),
            ],
          ),
          if (url != null && url.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.meta,
            ),
          ],
          const SizedBox(height: AppSpacing.space4),
          HeartbeatStrip(
            heartbeats: monitor.heartbeats,
            beatCount: 24,
            height: 22,
            upColor: AppColors.up,
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Down ${downDurationLabel(monitor)} · $uptimePercent% 24h',
                  style: AppTypography.meta.copyWith(
                    color: AppColors.down,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onRetest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                ),
                child: const Text('Retest'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

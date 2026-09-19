/// A compact healthy-monitor row in Uptime (README §2k): a small status dot,
/// name, a 12-beat heartbeat strip, and trailing latency.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/uptime/widgets/heartbeat_strip.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class HealthyMonitorRow extends StatelessWidget {
  const HealthyMonitorRow({required this.monitor, super.key});

  final KumaMonitor monitor;

  @override
  Widget build(BuildContext context) {
    final latestPing = monitor.heartbeats.isNotEmpty
        ? monitor.heartbeats.first.ping
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.up,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              monitor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          SizedBox(
            width: 74,
            child: HeartbeatStrip(
              heartbeats: monitor.heartbeats,
              beatCount: 12,
              height: 14,
              upColor: AppColors.up,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          if (latestPing != null)
            Text(
              '$latestPing ms',
              style: AppTypography.meta.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}

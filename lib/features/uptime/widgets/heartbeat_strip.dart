/// A row of heartbeat bars, oldest→newest left→right, for Uptime Kuma
/// monitors (README §2k): 24 beats/22px for a down monitor's hero card, 12
/// beats/14px for a healthy monitor's compact row.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class HeartbeatStrip extends StatelessWidget {
  const HeartbeatStrip({
    required this.heartbeats,
    required this.beatCount,
    required this.height,
    required this.upColor,
    super.key,
  });

  final List<KumaHeartbeat> heartbeats;
  final int beatCount;
  final double height;
  final Color upColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = heartbeats.take(beatCount).toList().reversed.toList();
    final empty = beatCount - recent.length;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (var i = 0; i < empty; i++)
            _bar(theme.colorScheme.surfaceContainerHighest),
          for (final hb in recent)
            _bar(hb.status == 1 ? upColor : AppColors.down),
        ],
      ),
    );
  }

  Widget _bar(Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.75),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1),
      ),
    ),
  );
}

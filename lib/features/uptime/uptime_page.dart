/// Uptime tab placeholder. Real Uptime Kuma monitor UI lands in Phase 9.
library;

import 'package:arrstack/core/widgets/coming_soon_page.dart';
import 'package:flutter/material.dart';

class UptimePage extends StatelessWidget {
  const UptimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComingSoonPage(
      title: 'Uptime',
      icon: Icons.monitor_heart_outlined,
    );
  }
}

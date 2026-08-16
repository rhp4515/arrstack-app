/// Dashboard tab: empty state until services are configured (Phase 3+).
library;

import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: EmptyState(
        icon: Icons.dashboard_customize_outlined,
        title: 'No services yet',
        message: 'Add a service to see its status and activity here.',
        action: FilledButton.icon(
          // Disabled placeholder — onboarding flow lands in Phase 3.
          onPressed: null,
          icon: const Icon(Icons.add),
          label: const Text('Add service'),
        ),
      ),
    );
  }
}

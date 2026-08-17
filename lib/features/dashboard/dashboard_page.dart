/// Dashboard tab: empty state until services are configured (Phase 3+).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/dashboard/widgets/endpoint_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          EndpointIndicator(),
        ],
      ),
      body: EmptyState(
        icon: Icons.dashboard_customize_outlined,
        title: 'No services yet',
        message: 'Add a service to see its status and activity here.',
        action: FilledButton.icon(
          onPressed: () => context.go(RoutePaths.addInstance),
          icon: const Icon(Icons.add),
          label: const Text('Add service'),
        ),
      ),
    );
  }
}

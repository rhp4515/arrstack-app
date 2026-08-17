/// Dashboard tab: service overview and activity (spec §7).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/dashboard/widgets/endpoint_indicator.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          EndpointIndicator(),
        ],
      ),
      body: instancesAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) => value.isEmpty
              ? const _EmptyDashboard()
              : ListView.builder(
                  padding: AppInsets.pageMd,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final instance = value[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(instance.serviceType.displayName[0]),
                        ),
                        title: Text(instance.name),
                        subtitle: Text(instance.serviceType.displayName),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          if (instance.serviceType == ServiceType.radarr) {
                            ref.read(selectedLibraryInstanceIdProvider(ServiceType.radarr).notifier).selectInstance(instance.id);
                            context.go(RoutePaths.library);
                          }
                        },
                      ),
                    );
                  },
                ),
          Err(:final error) => Center(child: Text('Error: ${error.userMessage}')),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Unexpected error: $err')),
      ),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.dashboard_customize_outlined,
      title: 'No services yet',
      message: 'Add a service to see its status and activity here.',
      action: FilledButton.icon(
        onPressed: () => context.go(RoutePaths.addInstance),
        icon: const Icon(Icons.add),
        label: const Text('Add service'),
      ),
    );
  }
}

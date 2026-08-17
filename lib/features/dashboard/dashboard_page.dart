/// Dashboard tab: aggregated stack health and activity (spec §7).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/dashboard/dashboard_providers.dart';
import 'package:arrstack/features/dashboard/widgets/activity_strip.dart';
import 'package:arrstack/features/dashboard/widgets/endpoint_indicator.dart';
import 'package:arrstack/features/dashboard/widgets/service_health_tile.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(stackHealthProvider);
    final activityAsync = ref.watch(stackActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          EndpointIndicator(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(stackHealthProvider);
          ref.invalidate(stackActivityProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          children: [
            _HealthSection(healthAsync: healthAsync),
            const SizedBox(height: AppSpacing.lg),
            _ActivitySection(activityAsync: activityAsync),
            const SizedBox(height: AppSpacing.xxl),
            _InstancesSection(ref: ref),
          ],
        ),
      ),
    );
  }
}

class _HealthSection extends StatelessWidget {
  const _HealthSection({required this.healthAsync});
  final AsyncValue<List<ServiceHealth>> healthAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'STACK HEALTH',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 100,
          child: healthAsync.when(
            data: (healths) => healths.isEmpty
                ? const Center(child: Text('No services configured'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: healths.length,
                    itemBuilder: (context, index) => ServiceHealthTile(
                      health: healths[index],
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

class _ActivitySection extends StatelessWidget {
  const _ActivitySection({required this.activityAsync});
  final AsyncValue<List<ActivityItem>> activityAsync;

  @override
  Widget build(BuildContext context) {
    return activityAsync.when(
      data: (items) => ActivityStrip(items: items),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading activity: $err')),
    );
  }
}

class _InstancesSection extends StatelessWidget {
  const _InstancesSection({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final instancesAsync = ref.watch(instancesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'ALL INSTANCES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        instancesAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => value.isEmpty
                ? const _EmptyDashboard()
                : Column(
                    children: value.map((instance) => _InstanceListTile(instance: instance, ref: ref)).toList(),
                  ),
            Err(:final error) => Center(child: Text('Error: ${error.userMessage}')),
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _InstanceListTile extends StatelessWidget {
  const _InstanceListTile({required this.instance, required this.ref});
  final ServiceInstance instance;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        } else if (instance.serviceType == ServiceType.sonarr) {
          ref.read(selectedLibraryInstanceIdProvider(ServiceType.sonarr).notifier).selectInstance(instance.id);
          context.go(RoutePaths.library);
        } else if (instance.serviceType == ServiceType.bazarr) {
          context.go(RoutePaths.subtitles(instance.id));
        } else if (instance.serviceType == ServiceType.qbittorrent) {
          context.go(RoutePaths.downloads);
        } else if (instance.serviceType == ServiceType.uptimeKuma) {
          context.go(RoutePaths.uptime);
        }
      },
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

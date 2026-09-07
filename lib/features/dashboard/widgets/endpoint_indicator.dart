/// A small indicator in the AppBar showing whether the app is using the
/// "Local" or "Remote" endpoint for a given instance (spec §6a, §7).
/// Tapping it allows manual session override.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'endpoint_indicator.g.dart';

/// Finds a "primary" instance to show the indicator for on the Dashboard.
@riverpod
Future<ServiceInstance?> primaryDashboardInstance(Ref ref) async {
  final result = await ref.watch(instancesProvider.future);
  if (result case Ok(:final value)) {
    if (value.isEmpty) return null;
    return value.firstWhere(
      (i) => i.isDefault && i.serviceType == ServiceType.radarr,
      orElse: () => value.firstWhere(
        (i) => i.isDefault && i.serviceType == ServiceType.sonarr,
        orElse: () =>
            value.firstWhere((i) => i.isDefault, orElse: () => value.first),
      ),
    );
  }
  return null;
}

class EndpointIndicator extends ConsumerWidget {
  const EndpointIndicator({super.key, this.instanceId});

  /// If null, uses the [primaryDashboardInstanceProvider].
  final String? instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idAsync = instanceId != null
        ? AsyncData(instanceId)
        : ref.watch(primaryDashboardInstanceProvider).whenData((i) => i?.id);

    return idAsync.when(
      data: (id) =>
          id == null ? const SizedBox.shrink() : _Indicator(instanceId: id),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _Indicator extends ConsumerWidget {
  const _Indicator({required this.instanceId});
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolutionAsync = ref.watch(resolvedEndpointProvider(instanceId));

    return resolutionAsync.when(
      data: (result) => switch (result) {
        Ok<EndpointResolution>(:final value) => _TappableChip(
          instanceId: instanceId,
          resolution: value,
        ),
        Err<EndpointResolution>() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _TappableChip extends ConsumerWidget {
  const _TappableChip({required this.instanceId, required this.resolution});

  final String instanceId;
  final EndpointResolution resolution;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLocal = resolution.endpoint == ResolvedEndpoint.local;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 8,
      ),
      child: ActionChip(
        avatar: Icon(
          isLocal ? Icons.lan_outlined : Icons.cloud_outlined,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        label: Text(
          isLocal ? 'Local' : 'Remote',
          style: const TextStyle(fontSize: 11),
        ),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        onPressed: () => _showOverrideMenu(context, ref),
        backgroundColor: resolution.needsManualOverride
            ? theme.colorScheme.errorContainer.withValues(alpha: 0.5)
            : null,
      ),
    );
  }

  void _showOverrideMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Endpoint Mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Override for this session only.'),
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: const Text('Auto (SSID-based)'),
              onTap: () {
                ref
                    .read(endpointSessionOverrideProvider.notifier)
                    .update(instanceId, null);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lan_outlined),
              title: const Text('Force Local (LAN)'),
              onTap: () {
                ref
                    .read(endpointSessionOverrideProvider.notifier)
                    .update(instanceId, EndpointMode.forceLocal);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('Force Remote (Tailscale)'),
              onTap: () {
                ref
                    .read(endpointSessionOverrideProvider.notifier)
                    .update(instanceId, EndpointMode.forceRemote);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

/// Settings tab: Instance management, networking configuration, and
/// appearance settings (spec §7).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:arrstack/features/settings/widgets/home_ssid_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          _SectionHeader(
            title: 'Instances',
            action: TextButton.icon(
              onPressed: () => context.go(RoutePaths.addInstance),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ),
          instancesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => value.isEmpty
                  ? const _EmptyInstances()
                  : Column(
                      children: value
                          .map((instance) => _InstanceTile(instance: instance))
                          .toList(),
                    ),
              Err(:final error) => Text('Error: ${error.userMessage}'),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const Divider(height: AppSpacing.xxl),
          const _SectionHeader(title: 'Networking'),
          const HomeSsidSetting(),
          const SizedBox(height: AppSpacing.lg),
          const _DefaultEndpointModeSetting(),
          const Divider(height: AppSpacing.xxl),
          const _SectionHeader(title: 'Appearance'),
          ListTile(
            title: const Text('Theme Mode'),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {themeMode},
              onSelectionChanged: (modes) =>
                  ref.read(appThemeModeProvider.notifier).update(modes.first),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final action = this.action;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.2,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }
}

class _InstanceTile extends ConsumerWidget {
  const _InstanceTile({required this.instance});
  final ServiceInstance instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () => context.go(RoutePaths.editInstance(instance.id)),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Text(instance.serviceType.displayName[0]),
      ),
      title: Text(instance.name),
      subtitle: Text(instance.serviceType.displayName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (instance.isDefault)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Badge(label: Text('Default')),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Instance?'),
                  content: Text('Are you sure you want to remove ${instance.name}?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(instanceRepositoryProvider).delete(instance.id);
                ref.invalidate(instancesProvider);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyInstances extends StatelessWidget {
  const _EmptyInstances();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Text(
          'No services configured yet.\nTap "Add" to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class _DefaultEndpointModeSetting extends ConsumerWidget {
  const _DefaultEndpointModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(defaultEndpointModeSettingsProvider);

    return modeAsync.when(
      data: (mode) => ListTile(
        title: const Text('Default Endpoint Mode'),
        subtitle: const Text('Preferred connection for new instances.'),
        trailing: DropdownButton<EndpointMode>(
          value: mode,
          items: EndpointMode.values.map((m) {
            return DropdownMenuItem(
              value: m,
              child: Text(m.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (newMode) => newMode != null
              ? ref.read(defaultEndpointModeSettingsProvider.notifier).updateMode(newMode)
              : null,
        ),
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

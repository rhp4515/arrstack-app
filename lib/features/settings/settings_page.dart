/// Settings tab: instance management, networking, and appearance
/// (README §2m).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:arrstack/features/settings/widgets/home_ssid_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final summariesAsync = ref.watch(homeServiceSummariesProvider);
    final summariesFailed = summariesAsync.hasError;

    return Scaffold(
      appBar: SubPageHeader(
        title: 'Settings',
        actions: [
          TextButton.icon(
            onPressed: () => context.go(RoutePaths.homeAddInstance),
            icon: const Icon(PhosphorIconsRegular.plus, size: 15),
            label: const Text('Add'),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          instancesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => _InstancesSection(
                instances: value,
                summaries: summariesAsync.asData?.value ?? const [],
                summariesFailed: summariesFailed,
              ),
              Err(:final error) => Text('Error: ${error.userMessage}'),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
          const Text('HOME NETWORKS', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space2),
          const Text(
            "On these networks the app uses each instance's Local URL; "
            'anywhere else it uses Remote.',
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space4),
          const HomeSsidSetting(),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
          const _DefaultEndpointModeSetting(),
          const SizedBox(height: AppSpacing.space4),
          const _ThemeSetting(),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }
}

class _InstancesSection extends StatelessWidget {
  const _InstancesSection({
    required this.instances,
    required this.summaries,
    required this.summariesFailed,
  });

  final List<ServiceInstance> instances;
  final List<HomeServiceSummary> summaries;
  final bool summariesFailed;

  @override
  Widget build(BuildContext context) {
    if (instances.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INSTANCES · 0', style: AppTypography.kicker),
          SizedBox(height: AppSpacing.space4),
          Text(
            'No services configured yet. Tap "Add" to get started.',
            style: AppTypography.meta,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'INSTANCES · ${instances.length}',
              style: AppTypography.kicker,
            ),
            const Text('tap to edit', style: AppTypography.meta),
          ],
        ),
        const SizedBox(height: AppSpacing.space4),
        for (final instance in instances)
          _InstanceRow(
            instance: instance,
            summary: summaries
                .where((s) => s.instanceId == instance.id)
                .firstOrNull,
            summariesFailed: summariesFailed,
          ),
      ],
    );
  }
}

class _InstanceRow extends ConsumerWidget {
  const _InstanceRow({
    required this.instance,
    required this.summary,
    required this.summariesFailed,
  });

  final ServiceInstance instance;
  final HomeServiceSummary? summary;
  final bool summariesFailed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = this.summary;
    final dotColor = summary == null
        ? AppColors.n600
        : (summary.isReachable ? AppColors.up : AppColors.down);
    // A `null` summary means either "the summaries fetch itself failed" or
    // "this instance has no matching summary in an otherwise successful
    // fetch" (a real design fallback, e.g. a non-default duplicate
    // instance). Those are different situations for the user, so give the
    // failed-fetch case its own distinct meta text instead of silently
    // falling back to the same neutral no-summary state.
    final statusLine = summary != null
        ? (summary.isReachable ? 'Reachable' : summary.summaryLine)
        : (summariesFailed ? 'Status unavailable' : null);

    return InkWell(
      onTap: () => context.go(RoutePaths.homeEditInstance(instance.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          instance.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cardTitle,
                        ),
                      ),
                      if (instance.isDefault) ...[
                        const SizedBox(width: AppSpacing.space2),
                        const DetailChip(
                          label: 'Default',
                          color: AppColors.accent,
                        ),
                      ],
                    ],
                  ),
                  if (statusLine != null)
                    Text(
                      statusLine,
                      style: AppTypography.meta.copyWith(
                        color: summary == null
                            ? AppColors.n500
                            : (summary.isReachable
                                  ? AppColors.n500
                                  : AppColors.down),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(PhosphorIconsRegular.trash, size: 15),
              onPressed: () => _confirmDelete(context, ref),
            ),
            const Icon(
              PhosphorIconsRegular.caretRight,
              size: 12,
              color: AppColors.n500,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Instance?'),
        content: Text('Are you sure you want to remove ${instance.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(instanceRepositoryProvider).delete(instance.id);
      ref.invalidate(instancesProvider);
    }
  }
}

class _DefaultEndpointModeSetting extends ConsumerWidget {
  const _DefaultEndpointModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(defaultEndpointModeSettingsProvider);

    return modeAsync.when(
      data: (mode) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Default endpoint', style: AppTypography.cardTitle),
              Text('For newly added instances', style: AppTypography.meta),
            ],
          ),
          DropdownButton<EndpointMode>(
            value: mode,
            underline: const SizedBox.shrink(),
            items: EndpointMode.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                .toList(),
            onChanged: (newMode) => newMode != null
                ? ref
                      .read(defaultEndpointModeSettingsProvider.notifier)
                      .updateMode(newMode)
                : null,
          ),
        ],
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

class _ThemeSetting extends ConsumerWidget {
  const _ThemeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Theme', style: AppTypography.cardTitle),
        DropdownButton<ThemeMode>(
          value: themeMode,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
          onChanged: (mode) => mode != null
              ? ref.read(appThemeModeProvider.notifier).update(mode)
              : null,
        ),
      ],
    );
  }
}

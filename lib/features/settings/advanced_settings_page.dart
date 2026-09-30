/// Settings → Advanced: appearance, the app lock, and the tools (service
/// backup, clearing cached data, diagnostic logs).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/security/app_lock_providers.dart';
import 'package:arrstack/features/settings/cache_clearing.dart';
import 'package:arrstack/features/settings/widgets/settings_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AdvancedSettingsPage extends ConsumerWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const SubPageHeader(kicker: 'Settings', title: 'Advanced'),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          const SettingsSection(
            kicker: 'APPEARANCE',
            children: [ThemeModeSelector()],
          ),
          const SettingsSection(kicker: 'SECURITY', children: [_AppLockRow()]),
          SettingsSection(
            kicker: 'TOOLS',
            showRule: false,
            children: [
              SettingsNavRow(
                icon: PhosphorIconsRegular.fileArrowUp,
                title: 'Service backup',
                subtitle: 'Export and restore saved services',
                onTap: () => context.go(RoutePaths.homeSettingsBackup),
              ),
              const _ClearCacheRow(),
              SettingsNavRow(
                icon: PhosphorIconsRegular.chatCircleText,
                title: 'Diagnostic logs',
                subtitle: 'View and share redacted logs',
                onTap: () => context.go(RoutePaths.homeSettingsLogs),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// System / Light / Dark as one segmented control.
class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appThemeModeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Theme', style: AppTypography.cardTitle),
        const SizedBox(height: AppSpacing.space3),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: ThemeMode.system, label: Text('System')),
            ButtonSegment(value: ThemeMode.light, label: Text('Light')),
            ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
          ],
          selected: {mode},
          onSelectionChanged: (selection) =>
              ref.read(appThemeModeProvider.notifier).update(selection.first),
        ),
      ],
    );
  }
}

class _AppLockRow extends ConsumerWidget {
  const _AppLockRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(appLockEnabledProvider).value ?? false;
    return LabeledToggleRow(
      title: 'Lock app',
      subtitle: enabled
          ? 'Fingerprint, face, or device PIN required to open the app'
          : 'Off — anyone holding your unlocked phone can open the app',
      value: enabled,
      onChanged: (value) async {
        final result = await ref
            .read(appLockEnabledProvider.notifier)
            .setEnabled(enabled: value);
        if (!context.mounted) return;
        final message = switch (result) {
          AppLockChangeResult.changed => null,
          AppLockChangeResult.unavailable =>
            'Set up a fingerprint, face, or screen lock on this device first.',
          AppLockChangeResult.notAuthenticated =>
            "Couldn't confirm it's you, so the lock wasn't changed.",
        };
        if (message != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
    );
  }
}

class _ClearCacheRow extends ConsumerWidget {
  const _ClearCacheRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clearing = ref.watch(cacheClearingProvider);
    return SettingsNavRow(
      icon: PhosphorIconsRegular.broom,
      title: 'Clear cached data',
      subtitle: 'Remove saved offline summaries and downloaded artwork',
      trailing: clearing
          ? const SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: clearing
          ? null
          : () async {
              final confirmed = await showDestructiveConfirmDialog(
                context,
                title: 'Clear cached data?',
                message:
                    'Posters and offline summaries are downloaded again the '
                    'next time they are needed. Your services and settings '
                    'are kept.',
                confirmLabel: 'Clear',
              );
              if (confirmed == null) return;
              final error = await ref
                  .read(cacheClearingProvider.notifier)
                  .clearAll();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error ?? 'Cached data cleared.')),
              );
            },
    );
  }
}

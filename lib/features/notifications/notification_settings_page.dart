/// Settings → Notifications: the background check's master switch, which
/// kinds of activity notify, and how often to check.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/discover/utils/relative_time.dart';
import 'package:arrstack/features/notifications/notification_providers.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:arrstack/features/settings/widgets/settings_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(notificationSettingsControllerProvider);
    return Scaffold(
      appBar: const SubPageHeader(kicker: 'SETTINGS', title: 'Notifications'),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: PhosphorIconsRegular.warning,
          title: 'Could not load notification settings',
          message: '$error',
          action: FilledButton(
            onPressed: () =>
                ref.invalidate(notificationSettingsControllerProvider),
            child: const Text('Retry'),
          ),
        ),
        data: (settings) => _Body(settings: settings),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.settings});

  final NotificationSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(
      notificationSettingsControllerProvider.notifier,
    );
    final configured = switch (ref.watch(instancesProvider).asData?.value) {
      Ok(:final value) => {for (final i in value) i.serviceType},
      _ => const <ServiceType>{},
    };
    final on = settings.enabled;

    /// A source row: shows off (not its stored value) while the master
    /// switch is off, and says so when there's no instance to watch.
    Widget sourceRow({
      required ServiceType type,
      required String title,
      required String subtitle,
      required bool value,
      required Future<void> Function({required bool value}) onChanged,
    }) {
      final hasInstance = configured.contains(type);
      return LabeledToggleRow(
        title: title,
        subtitle: hasInstance
            ? subtitle
            : 'Add a ${type.displayName} service to use this',
        value: on && hasInstance && value,
        onChanged: on && hasInstance ? (v) => onChanged(value: v) : null,
      );
    }

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        SettingsSection(
          kicker: 'BACKGROUND NOTIFICATIONS',
          children: [
            LabeledToggleRow(
              title: 'Enable notifications',
              subtitle: on
                  ? 'Checking your services in the background'
                  : 'Get notified about imports and requests while the app '
                        'is closed',
              value: on,
              onChanged: (value) => _setEnabled(context, ref, value),
            ),
          ],
        ),
        SettingsSection(
          kicker: 'NOTIFY ME ABOUT',
          children: [
            sourceRow(
              type: ServiceType.sonarr,
              title: 'Sonarr imports',
              subtitle: 'New episodes after Sonarr imports them',
              value: settings.sonarrImports,
              onChanged: controller.setSonarrImports,
            ),
            const SizedBox(height: AppSpacing.space4),
            sourceRow(
              type: ServiceType.radarr,
              title: 'Radarr imports',
              subtitle: 'New movies after Radarr imports them',
              value: settings.radarrImports,
              onChanged: controller.setRadarrImports,
            ),
            const SizedBox(height: AppSpacing.space4),
            sourceRow(
              type: ServiceType.seerr,
              title: 'Requests and issues',
              subtitle: 'New media requests and reported problems from Seerr',
              value: settings.seerrActivity,
              onChanged: controller.setSeerrActivity,
            ),
          ],
        ),
        SettingsSection(
          kicker: 'SCHEDULE',
          showRule: false,
          children: [
            SettingsChoiceRow<CheckFrequency>(
              title: 'Check every',
              meta:
                  'Approximate: battery optimization may delay a check, and '
                  'iOS decides on its own how often the app may refresh.',
              value: settings.frequency,
              options: {for (final f in CheckFrequency.values) f: f.label},
              onChanged: controller.setFrequency,
            ),
            if (on) ...[
              const SizedBox(height: AppSpacing.space4),
              const _LastRunRow(),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _setEnabled(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final result = await ref
        .read(notificationSettingsControllerProvider.notifier)
        .setEnabled(enabled: enabled);
    if (!context.mounted) return;
    final message = switch (result) {
      NotificationEnableResult.changed => null,
      NotificationEnableResult.permissionDenied =>
        'Notifications are blocked for this app. Allow them in system '
            'settings, then try again.',
      NotificationEnableResult.scheduleFailed =>
        "Couldn't schedule background checks. See Diagnostic logs for "
            'details.',
    };
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

class _LastRunRow extends ConsumerStatefulWidget {
  const _LastRunRow();

  @override
  ConsumerState<_LastRunRow> createState() => _LastRunRowState();
}

class _LastRunRowState extends ConsumerState<_LastRunRow> {
  bool _checking = false;

  Future<void> _checkNow() async {
    setState(() => _checking = true);
    final posted = await ref
        .read(notificationSettingsControllerProvider.notifier)
        .checkNow();
    if (!mounted) return;
    setState(() => _checking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          posted == 0
              ? 'Nothing new.'
              : 'Posted $posted notification${posted == 1 ? '' : 's'}.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lastRun = ref.watch(notificationLastRunProvider).value;
    return Row(
      children: [
        Expanded(
          child: Text(
            lastRun == null
                ? 'Not checked yet'
                : 'Last checked ${formatRelativeTime(lastRun)}',
            style: AppTypography.meta,
          ),
        ),
        TextButton(
          onPressed: _checking ? null : _checkNow,
          child: _checking
              ? const SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Check now'),
        ),
      ],
    );
  }
}

/// Settings → Advanced → Service Backup: export every configured service
/// (with its credentials) to a passphrase-encrypted file, or restore one.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/backup/service_backup_providers.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:arrstack/features/backup/widgets/backup_dialogs.dart';
import 'package:arrstack/features/settings/widgets/settings_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class ServiceBackupPage extends ConsumerWidget {
  const ServiceBackupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serviceBackupControllerProvider);
    final controller = ref.read(serviceBackupControllerProvider.notifier);
    final instances = switch (ref.watch(instancesProvider).asData?.value) {
      Ok(:final value) => value,
      _ => const <ServiceInstance>[],
    };
    final status = state.status;

    // A success is a passing confirmation; a failure stays on the page
    // (below) until it's dismissed or the next action starts.
    ref.listen(serviceBackupControllerProvider, (previous, next) {
      final result = next.status;
      if (result == null || result.isError || result == previous?.status) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.message)));
    });

    return Scaffold(
      appBar: const SubPageHeader(kicker: 'ADVANCED', title: 'Service Backup'),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          if (state.isBusy) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: AppSpacing.space2),
            Text(state.busyLabel!, style: AppTypography.meta),
            const SizedBox(height: AppSpacing.space4),
          ],
          if (status != null && status.isError) ...[
            ErrorCard(
              title: 'Backup problem',
              message: status.message,
              primaryActionLabel: 'Dismiss',
              onPrimaryAction: controller.dismissStatus,
              secondaryActionLabel: 'View logs',
              onSecondaryAction: () => context.go(RoutePaths.homeSettingsLogs),
            ),
            const SizedBox(height: AppSpacing.space6),
          ],
          SettingsSection(
            kicker: 'INSTANCES',
            count: instances.length,
            description:
                'Backups include API keys and passwords, encrypted with a '
                "passphrase you choose. Keep it safe — a backup can't be "
                'restored without it.',
            children: [
              if (instances.isEmpty)
                const Text(
                  'No services configured yet.',
                  style: AppTypography.meta,
                ),
              for (final instance in instances) _BackupInstanceRow(instance),
            ],
          ),
          SettingsSection(
            kicker: 'EXPORT',
            description: instances.isEmpty
                ? 'Add a service first; there is nothing to back up yet.'
                : 'Save ${_services(instances.length)} to an encrypted '
                      'backup file.',
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state.isBusy || instances.isEmpty
                      ? null
                      : () => _export(context, controller),
                  icon: const Icon(PhosphorIconsRegular.export, size: 17),
                  label: const Text('Export services'),
                ),
              ),
            ],
          ),
          SettingsSection(
            kicker: 'IMPORT',
            description:
                'Restore services from a backup file. A service already on '
                'this device with the same identity is replaced; the rest '
                'are added.',
            showRule: false,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: state.isBusy
                      ? null
                      : () => _import(context, controller),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                  ),
                  icon: const Icon(
                    PhosphorIconsRegular.downloadSimple,
                    size: 17,
                  ),
                  label: const Text('Import services'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _export(
    BuildContext context,
    ServiceBackupController controller,
  ) async {
    final passphrase = await showExportPassphraseDialog(context);
    if (passphrase == null) return;
    await controller.export(passphrase);
  }

  Future<void> _import(
    BuildContext context,
    ServiceBackupController controller,
  ) async {
    final picked = await controller.pick();
    if (picked == null || !context.mounted) return;
    final contents = await showImportPassphraseDialog(
      context,
      serviceCount: picked.serviceCount,
      decrypt: (passphrase) => controller.decrypt(picked, passphrase),
    );
    if (contents == null || !context.mounted) return;
    if (!await _confirmRestore(context, contents)) return;
    await controller.restore(contents);
  }

  Future<bool> _confirmRestore(
    BuildContext context,
    BackupContents contents,
  ) async {
    if (contents.instances.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nothing in this file can be read by this version of the app.',
          ),
        ),
      );
      return false;
    }
    final lines = [
      for (final instance in contents.instances)
        '${instance.name} · ${instance.serviceType.displayName}',
      if (contents.skippedCount > 0)
        '\n${_services(contents.skippedCount)} in this file '
            "can't be read by this version of the app and will be skipped.",
    ];
    final confirmed = await showDestructiveConfirmDialog(
      context,
      title: 'Restore ${_services(contents.instances.length)}?',
      message: lines.join('\n'),
      confirmLabel: 'Restore',
    );
    return confirmed != null;
  }
}

/// A saved service in the backup list: name over its type, flat like the
/// rows in Settings' INSTANCES.
class _BackupInstanceRow extends StatelessWidget {
  const _BackupInstanceRow(this.instance);

  final ServiceInstance instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            instance.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle,
          ),
          Text(
            instance.serviceType.displayName,
            style: AppTypography.meta.copyWith(color: AppColors.n500),
          ),
        ],
      ),
    );
  }
}

String _services(int count) => count == 1 ? '1 service' : '$count services';

/// Settings → Advanced → Service Backup: export every configured service
/// (with its credentials) to a passphrase-encrypted file, or restore one.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/backup/service_backup_providers.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:arrstack/features/backup/widgets/backup_dialogs.dart';
import 'package:arrstack/features/settings/widgets/settings_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: const SubPageHeader(kicker: 'Advanced', title: 'Service Backup'),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          if (state.isBusy) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: AppSpacing.space2),
            Text(state.busyLabel!, style: AppTypography.meta),
            const SizedBox(height: AppSpacing.space4),
          ],
          if (status != null) ...[
            StatusBanner(
              message: status.message,
              isError: status.isError,
              onDismiss: controller.dismissStatus,
            ),
            const SizedBox(height: AppSpacing.space6),
          ],
          SettingsSection(
            kicker: 'SAVED SERVICES · ${instances.length}',
            description:
                'Backups include API keys and passwords, encrypted with a '
                "passphrase you choose. Keep it safe — a backup can't be "
                'restored without it.',
            children: [
              for (final instance in instances)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.space2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          instance.name,
                          style: AppTypography.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        instance.serviceType.displayName,
                        style: AppTypography.meta,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SettingsSection(
            kicker: 'EXPORT',
            description: instances.isEmpty
                ? 'Add a service first; there is nothing to back up yet.'
                : 'Save ${_services(instances.length)} to an encrypted '
                      'backup file.',
            children: [
              FilledButton.icon(
                onPressed: state.isBusy || instances.isEmpty
                    ? null
                    : () => _export(context, controller),
                icon: const Icon(PhosphorIconsRegular.export, size: 17),
                label: const Text('Export services'),
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
              OutlinedButton.icon(
                onPressed: state.isBusy
                    ? null
                    : () => _import(context, controller),
                icon: const Icon(PhosphorIconsRegular.downloadSimple, size: 17),
                label: const Text('Import services'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore ${_services(contents.instances.length)}?'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final instance in contents.instances)
                Text(
                  '${instance.name} · ${instance.serviceType.displayName}',
                  style: AppTypography.body,
                ),
              if (contents.skippedCount > 0) ...[
                const SizedBox(height: AppSpacing.space3),
                Text(
                  '${_services(contents.skippedCount)} in this file '
                  "can't be read by this version of the app and will be "
                  'skipped.',
                  style: AppTypography.meta,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: contents.instances.isEmpty
                ? null
                : () => Navigator.of(context).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

String _services(int count) => count == 1 ? '1 service' : '$count services';

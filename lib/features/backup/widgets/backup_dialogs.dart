/// Passphrase dialogs for Service Backup: choose one (with confirmation) to
/// export, and enter one to decrypt an import — which stays open with an
/// inline error on a wrong passphrase instead of starting over.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/backup/service_backup_codec.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:flutter/material.dart';

Future<String?> showExportPassphraseDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (context) => const _ExportPassphraseDialog(),
  );
}

class _ExportPassphraseDialog extends StatefulWidget {
  const _ExportPassphraseDialog();

  @override
  State<_ExportPassphraseDialog> createState() =>
      _ExportPassphraseDialogState();
}

class _ExportPassphraseDialogState extends State<_ExportPassphraseDialog> {
  final _passphrase = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _passphrase.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final passphrase = _passphrase.text;
    setState(() {
      _error = passphrase.length < minBackupPassphraseLength
          ? 'Use at least $minBackupPassphraseLength characters.'
          : passphrase != _confirm.text
          ? "The passphrases don't match."
          : null;
    });
    if (_error == null) Navigator.of(context).pop(passphrase);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Encrypt backup'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose a passphrase. You'll need it to restore this backup, "
            "and it can't be recovered if you forget it.",
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space4),
          TextField(
            key: const Key('backup-passphrase'),
            controller: _passphrase,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Passphrase'),
          ),
          const SizedBox(height: AppSpacing.space3),
          TextField(
            key: const Key('backup-passphrase-confirm'),
            controller: _confirm,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm passphrase',
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Export')),
      ],
    );
  }
}

Future<BackupContents?> showImportPassphraseDialog(
  BuildContext context, {
  required int serviceCount,
  required Future<Result<BackupContents>> Function(String passphrase) decrypt,
}) {
  return showDialog<BackupContents>(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        _ImportPassphraseDialog(serviceCount: serviceCount, decrypt: decrypt),
  );
}

class _ImportPassphraseDialog extends StatefulWidget {
  const _ImportPassphraseDialog({
    required this.serviceCount,
    required this.decrypt,
  });

  final int serviceCount;
  final Future<Result<BackupContents>> Function(String passphrase) decrypt;

  @override
  State<_ImportPassphraseDialog> createState() =>
      _ImportPassphraseDialogState();
}

class _ImportPassphraseDialogState extends State<_ImportPassphraseDialog> {
  final _passphrase = TextEditingController();
  String? _error;
  bool _working = false;

  @override
  void dispose() {
    _passphrase.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_working || _passphrase.text.isEmpty) return;
    setState(() {
      _working = true;
      _error = null;
    });
    final result = await widget.decrypt(_passphrase.text);
    if (!mounted) return;
    switch (result) {
      case Ok(:final value):
        Navigator.of(context).pop(value);
      case Err(:final error):
        setState(() {
          _working = false;
          _error = error.userMessage;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.serviceCount;
    return AlertDialog(
      title: const Text('Unlock backup'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This backup holds ${count == 1 ? '1 service' : '$count services'}. '
            'Enter the passphrase it was exported with.',
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space4),
          TextField(
            key: const Key('backup-import-passphrase'),
            controller: _passphrase,
            obscureText: true,
            autofocus: true,
            enabled: !_working,
            decoration: InputDecoration(
              labelText: 'Passphrase',
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (_working) ...[
            const SizedBox(height: AppSpacing.space4),
            const LinearProgressIndicator(),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _working ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _working ? null : _submit,
          child: const Text('Unlock'),
        ),
      ],
    );
  }
}

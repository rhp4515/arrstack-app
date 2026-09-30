/// Riverpod wiring for Service Backup, plus the platform file boundary
/// (share sheet out, file picker in) behind an interface tests can fake.
library;

import 'dart:io';

import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'service_backup_providers.g.dart';

/// Largest file the import accepts; a real backup is a few kilobytes.
const int maxBackupFileBytes = 1024 * 1024;

abstract interface class BackupFileGateway {
  /// Hands [text] to the system share sheet as a file named [fileName].
  /// True when the user completed the share (or the platform can't tell).
  Future<bool> share({required String fileName, required String text});

  /// Lets the user pick a file; its text, or null if they cancelled.
  Future<String?> pickText();
}

class PlatformBackupFileGateway implements BackupFileGateway {
  const PlatformBackupFileGateway();

  @override
  Future<bool> share({required String fileName, required String text}) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(text, flush: true);
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          fileNameOverrides: [fileName],
          subject: 'ArrStack service backup',
        ),
      );
      return result.status != ShareResultStatus.dismissed;
    } finally {
      // The share target has its own copy by now; don't leave one behind.
      if (file.existsSync()) await file.delete();
    }
  }

  @override
  Future<String?> pickText() async {
    final picked = await FilePicker.pickFile(dialogTitle: 'Choose a backup');
    if (picked == null) return null;
    final length = await picked.length();
    if (length != null && length > maxBackupFileBytes) {
      throw const FileSystemException('That file is too large to be a backup.');
    }
    return picked.xFile.readAsString();
  }
}

@Riverpod(keepAlive: true)
BackupFileGateway backupFileGateway(Ref ref) =>
    const PlatformBackupFileGateway();

@riverpod
ServiceBackupService serviceBackupService(Ref ref) => ServiceBackupService(
  instances: ref.watch(instanceRepositoryProvider),
  secureStore: ref.watch(secureStoreProvider),
  configStore: ref.watch(configStoreProvider),
);

/// The outcome of the last export or import: the page shows a success as
/// a snackbar and an error as an inline error card.
class BackupStatus {
  const BackupStatus(this.message, {this.isError = false});

  final String message;
  final bool isError;
}

class BackupPageState {
  const BackupPageState({this.busyLabel, this.status});

  /// Non-null while an export/import runs ("Encrypting…").
  final String? busyLabel;
  final BackupStatus? status;

  bool get isBusy => busyLabel != null;
}

@riverpod
class ServiceBackupController extends _$ServiceBackupController {
  @override
  BackupPageState build() => const BackupPageState();

  void dismissStatus() => state = const BackupPageState();

  void _busy(String label) => state = BackupPageState(busyLabel: label);

  void _done(String message, {bool isError = false}) {
    state = BackupPageState(status: BackupStatus(message, isError: isError));
    final logger = ref.read(diagnosticLoggerProvider);
    isError ? logger.warn('Backup', message) : logger.info('Backup', message);
  }

  Future<void> export(String passphrase) async {
    _busy('Encrypting backup…');
    final result = await ref
        .read(serviceBackupServiceProvider)
        .export(passphrase);
    switch (result) {
      case Err(:final error):
        _done(error.userMessage, isError: true);
      case Ok(:final value):
        try {
          final shared = await ref
              .read(backupFileGatewayProvider)
              .share(fileName: value.fileName, text: value.fileText);
          shared
              ? _done('Saved backup for ${_services(value.serviceCount)}.')
              : state = const BackupPageState();
        } on Object catch (error) {
          _done('Could not share the backup file: $error', isError: true);
        }
    }
  }

  /// Picks a file and validates it. Returns its text for the passphrase
  /// step, or null when cancelled or invalid (the banner says which).
  Future<PickedBackup?> pick() async {
    final String? text;
    try {
      text = await ref.read(backupFileGatewayProvider).pickText();
    } on Object catch (error) {
      _done('Could not read that file: $error', isError: true);
      return null;
    }
    if (text == null) return null;
    switch (ref.read(serviceBackupServiceProvider).inspect(text)) {
      case Err(:final error):
        _done(error.userMessage, isError: true);
        return null;
      case Ok(:final value):
        return PickedBackup(text: text, serviceCount: value.serviceCount);
    }
  }

  /// Decrypts; on a wrong passphrase returns the message for the dialog to
  /// show inline instead of closing it.
  Future<Result<BackupContents>> decrypt(
    PickedBackup picked,
    String passphrase,
  ) {
    return ref
        .read(serviceBackupServiceProvider)
        .decrypt(picked.text, passphrase);
  }

  Future<void> restore(BackupContents contents) async {
    _busy('Restoring services…');
    final result = await ref
        .read(serviceBackupServiceProvider)
        .restore(contents);
    switch (result) {
      case Err(:final error):
        _done(error.userMessage, isError: true);
      case Ok(:final value):
        // Restored instances may reuse ids this device already had, so
        // every per-instance cache (config, credential, endpoint) must be
        // re-read, not just the list.
        ref
          ..invalidate(instancesProvider)
          ..invalidate(serviceInstanceProvider)
          ..invalidate(serviceCredentialProvider)
          ..invalidate(resolvedEndpointProvider)
          ..invalidate(homeSsidsProvider);
        final skipped = contents.skippedCount == 0
            ? ''
            : ' ${_services(contents.skippedCount)} in the file could not be '
                  'read by this version of the app.';
        _done('Restored ${_services(value.total)}.$skipped');
    }
  }
}

class PickedBackup {
  const PickedBackup({required this.text, required this.serviceCount});

  final String text;
  final int serviceCount;
}

String _services(int count) => count == 1 ? '1 service' : '$count services';

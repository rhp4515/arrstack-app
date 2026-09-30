/// Builds and restores Service Backups: the configured instances, their
/// credentials, and the home-network settings, via [ServiceBackupCodec].
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/features/backup/service_backup_codec.dart';
import 'package:json_annotation/json_annotation.dart';

/// A finished export, ready to write to a file and share.
class BackupExport {
  const BackupExport({
    required this.fileText,
    required this.fileName,
    required this.serviceCount,
  });

  final String fileText;
  final String fileName;
  final int serviceCount;
}

/// A decrypted backup, shown to the user before anything is written.
class BackupContents {
  const BackupContents({
    required this.instances,
    required this.credentials,
    required this.homeSsids,
    required this.skippedCount,
  });

  final List<ServiceInstance> instances;
  final Map<String, ServiceCredential> credentials;
  final List<String> homeSsids;

  /// Entries this version of the app can't read (e.g. a service type added
  /// in a later version); left out rather than failing the whole restore.
  final int skippedCount;
}

class RestoreSummary {
  const RestoreSummary({required this.added, required this.updated});

  final int added;
  final int updated;

  int get total => added + updated;
}

class ServiceBackupService {
  ServiceBackupService({
    required this._instances,
    required this._secureStore,
    required this._configStore,
    this._codec = const ServiceBackupCodec(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final InstanceRepository _instances;
  final SecureStore _secureStore;
  final ConfigStore _configStore;
  final ServiceBackupCodec _codec;
  final DateTime Function() _clock;

  Future<Result<BackupExport>> export(String passphrase) async {
    if (passphrase.length < minBackupPassphraseLength) {
      return const Err(
        ValidationError(
          field: 'passphrase',
          userMessage:
              'Use a passphrase of at least $minBackupPassphraseLength '
              'characters.',
        ),
      );
    }
    final listResult = await _instances.list();
    final List<ServiceInstance> instances;
    switch (listResult) {
      case Ok(:final value):
        instances = value;
      case Err(:final error):
        return Err(error);
    }
    if (instances.isEmpty) {
      return const Err(
        ValidationError(userMessage: 'There are no services to back up.'),
      );
    }

    try {
      final credentials = <String, Map<String, dynamic>>{};
      for (final instance in instances) {
        final credential = await _secureStore.readCredential(instance.id);
        if (credential != null) credentials[instance.id] = credential.toJson();
      }
      final now = _clock();
      final fileText = await _codec.encode(
        payload: {
          'instances': [for (final i in instances) i.toJson()],
          'credentials': credentials,
          'homeSsids': await _configStore.readHomeSsids(),
        },
        passphrase: passphrase,
        serviceCount: instances.length,
        createdAt: now,
      );
      return Ok(
        BackupExport(
          fileText: fileText,
          fileName: backupFileName(now),
          serviceCount: instances.length,
        ),
      );
    } catch (error) {
      return Err(
        StorageError(cause: error, userMessage: 'Could not create the backup.'),
      );
    }
  }

  /// Reads a backup's clear-text envelope (service count, date) so the
  /// import flow can describe the file before asking for its passphrase.
  Result<BackupEnvelope> inspect(String fileText) {
    try {
      return Ok(_codec.readEnvelope(fileText));
    } on BackupCodecException catch (error) {
      return Err(ValidationError(cause: error, userMessage: error.message));
    }
  }

  Future<Result<BackupContents>> decrypt(
    String fileText,
    String passphrase,
  ) async {
    final Map<String, dynamic> payload;
    try {
      payload = await _codec.decode(fileText: fileText, passphrase: passphrase);
    } on BackupCodecException catch (error) {
      return Err(ValidationError(cause: error, userMessage: error.message));
    }

    final instances = <ServiceInstance>[];
    final credentials = <String, ServiceCredential>{};
    var skipped = 0;
    final rawInstances = payload['instances'];
    final rawCredentials = payload['credentials'];
    for (final raw in rawInstances is List ? rawInstances : const []) {
      final instance = _decode(() {
        final decoded = ServiceInstance.fromJson(raw as Map<String, dynamic>);
        return validateServiceInstance(decoded) is Ok ? decoded : null;
      });
      if (instance == null) {
        skipped++;
        continue;
      }
      instances.add(instance);
      final rawCredential = rawCredentials is Map
          ? rawCredentials[instance.id]
          : null;
      final credential = rawCredential is Map<String, dynamic>
          ? _decode(() => ServiceCredential.fromJson(rawCredential))
          : null;
      if (credential != null) credentials[instance.id] = credential;
    }
    final rawSsids = payload['homeSsids'];
    return Ok(
      BackupContents(
        instances: List.unmodifiable(instances),
        credentials: Map.unmodifiable(credentials),
        homeSsids: List.unmodifiable(
          rawSsids is List ? rawSsids.whereType<String>() : const <String>[],
        ),
        skippedCount: skipped,
      ),
    );
  }

  /// Writes [contents] into this device's configuration: an instance whose
  /// id already exists here (restoring onto the same device) is replaced,
  /// anything else is added. Home SSIDs are merged, never removed.
  Future<Result<RestoreSummary>> restore(BackupContents contents) async {
    final listResult = await _instances.list();
    final Set<String> existingIds;
    switch (listResult) {
      case Ok(:final value):
        existingIds = {for (final i in value) i.id};
      case Err(:final error):
        return Err(error);
    }

    var added = 0;
    var updated = 0;
    for (final instance in contents.instances) {
      final credential = contents.credentials[instance.id];
      final exists = existingIds.contains(instance.id);
      final result = exists
          ? await _instances.update(instance, credential: credential)
          : await _instances.add(instance, credential: credential);
      if (result case Err(:final error)) return Err(error);
      exists ? updated++ : added++;
    }

    try {
      final ssids = await _configStore.readHomeSsids();
      final merged = {...ssids, ...contents.homeSsids}.toList();
      if (merged.length != ssids.length) {
        await _configStore.writeHomeSsids(merged);
      }
    } catch (error) {
      return Err(
        StorageError(
          cause: error,
          userMessage: 'Services were restored, but home networks were not.',
        ),
      );
    }
    return Ok(RestoreSummary(added: added, updated: updated));
  }
}

/// `arrstack-services-2026-09-30.arrbackup`
String backupFileName(DateTime time) {
  String two(int n) => n.toString().padLeft(2, '0');
  return 'arrstack-services-${time.year}-${two(time.month)}-${two(time.day)}'
      '.$backupFileExtension';
}

T? _decode<T>(T? Function() decode) {
  try {
    return decode();
  } on CheckedFromJsonException {
    return null;
  } on TypeError {
    return null;
  } on ArgumentError {
    return null;
  } on FormatException {
    return null;
  }
}

/// Per-instance secret storage (API key OR username+password), namespaced
/// by instance id. The **only** place a service credential is ever
/// persisted (spec §11) — never in [ConfigStore], a model, or a log line.
library;

import 'dart:convert';

import 'package:arrstack/core/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';

/// Reads/writes the secret credential for a service instance.
abstract interface class SecureStore {
  /// Returns the stored credential for [instanceId], or null if none.
  Future<ServiceCredential?> readCredential(String instanceId);

  /// Stores (overwriting) the credential for [instanceId].
  Future<void> writeCredential(String instanceId, ServiceCredential credential);

  /// Removes the credential for [instanceId], if any.
  Future<void> deleteCredential(String instanceId);
}

/// [SecureStore] backed by `flutter_secure_storage` (Keychain/Keystore).
class FlutterSecureCredentialStore implements SecureStore {
  const FlutterSecureCredentialStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static String _keyFor(String instanceId) => 'credential.$instanceId';

  @override
  Future<ServiceCredential?> readCredential(String instanceId) async {
    final raw = await _storage.read(key: _keyFor(instanceId));
    if (raw == null) return null;
    // A corrupted/legacy entry (malformed JSON, a non-map payload, or an
    // unrecognized union tag) must be treated as absent, never crash. Each
    // decode failure surfaces a different type: FormatException (bad JSON),
    // TypeError (not a map), ArgumentError, or CheckedFromJsonException (the
    // freezed union's discriminator) — catch the whole family.
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ServiceCredential.fromJson(json);
    } on FormatException {
      return null;
    } on CheckedFromJsonException {
      return null;
    } on TypeError {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  @override
  Future<void> writeCredential(
    String instanceId,
    ServiceCredential credential,
  ) {
    return _storage.write(
      key: _keyFor(instanceId),
      value: jsonEncode(credential.toJson()),
    );
  }

  @override
  Future<void> deleteCredential(String instanceId) {
    return _storage.delete(key: _keyFor(instanceId));
  }
}

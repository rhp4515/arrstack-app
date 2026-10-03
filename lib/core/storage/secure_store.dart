/// Per-instance secret storage (API key OR username+password), namespaced
/// by instance id. The **only** place a service credential is ever
/// persisted (spec §11) — never in [ConfigStore], a model, or a log line.
library;

import 'dart:convert';

import 'package:arrstack/core/models/models.dart';
import 'package:flutter/services.dart';
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

/// Where credentials are kept. On iOS this is readable after the first
/// unlock since boot rather than only while unlocked: background refresh,
/// which posts the notifications, mostly runs with the phone locked, and
/// under the plugin's default (`unlocked`) every credential read there
/// failed, so no instance could be checked. Android ignores the option.
const FlutterSecureStorage _credentialStorage = FlutterSecureStorage(
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

/// Where credentials were kept before: the plugin default, `unlocked`.
const FlutterSecureStorage _legacyCredentialStorage = FlutterSecureStorage();

/// [SecureStore] backed by `flutter_secure_storage` (Keychain/Keystore).
///
/// Moving to [_credentialStorage] needs a migration, not just a new option.
/// The plugin puts the accessibility into every keychain *query*, so a read
/// with the new setting can't see an item stored under the old one —
/// switching outright would make every iOS user's credentials vanish on
/// update. And keychain uniqueness ignores accessibility, so writing the
/// new kind over an old item fails as a duplicate. Reads therefore fall
/// back to the old setting and re-store what they find under the new one,
/// and writes clear an old item that is in the way.
class FlutterSecureCredentialStore implements SecureStore {
  const FlutterSecureCredentialStore([
    FlutterSecureStorage? storage,
    FlutterSecureStorage? legacyStorage,
  ]) : _storage = storage ?? _credentialStorage,
       // An injected store with no separate legacy one has nothing to
       // migrate from.
       _legacy = legacyStorage ?? storage ?? _legacyCredentialStorage;

  final FlutterSecureStorage _storage;
  final FlutterSecureStorage _legacy;

  static String _keyFor(String instanceId) => 'credential.$instanceId';

  @override
  Future<ServiceCredential?> readCredential(String instanceId) async {
    final key = _keyFor(instanceId);
    final raw = await _storage.read(key: key) ?? await _migrate(key);
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

  /// Moves an item stored under the old accessibility to the new one.
  ///
  /// Runs on whichever read first meets it, which in practice is the
  /// foreground app after an update. A background read while locked can't
  /// see the old item either way, so it fails exactly as it did before and
  /// the next foreground read migrates.
  Future<String?> _migrate(String key) async {
    if (identical(_legacy, _storage)) return null;
    final legacy = await _legacy.read(key: key);
    if (legacy == null) return null;
    // Delete first: the add would collide with the old item. The plugin's
    // delete ignores accessibility, so this removes it whatever it was.
    await _storage.delete(key: key);
    try {
      await _storage.write(key: key, value: legacy);
    } on Object {
      // Never lose a credential to the migration: put the old item back.
      await _legacy.write(key: key, value: legacy);
      rethrow;
    }
    return legacy;
  }

  @override
  Future<void> writeCredential(
    String instanceId,
    ServiceCredential credential,
  ) async {
    final key = _keyFor(instanceId);
    final value = jsonEncode(credential.toJson());
    try {
      await _storage.write(key: key, value: value);
    } on PlatformException {
      if (identical(_legacy, _storage)) rethrow;
      // An item under the old accessibility can't be updated or added over
      // — keychain uniqueness ignores accessibility — so a not-yet-migrated
      // instance fails here as a duplicate. Clear it and write again.
      await _storage.delete(key: key);
      await _storage.write(key: key, value: value);
    }
  }

  @override
  Future<void> deleteCredential(String instanceId) {
    return _storage.delete(key: _keyFor(instanceId));
  }
}

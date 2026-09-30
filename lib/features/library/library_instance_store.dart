/// Remembers which Radarr/Sonarr instance the Library last showed, so the
/// instance switcher's choice survives a restart.
///
/// A convenience only: every read and write swallows failures (no platform
/// channel in tests, cleared storage) and the Library falls back to the
/// default instance.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'library_instance_store.g.dart';

abstract interface class LibraryInstanceStore {
  /// The saved instance id for [type], or null if none/unreadable.
  Future<String?> read(ServiceType type);

  /// Saves [instanceId] as the Library's choice for [type].
  Future<void> write(ServiceType type, String instanceId);
}

/// [LibraryInstanceStore] backed by `shared_preferences`' async API. The
/// preferences handle is created lazily because its constructor throws when
/// no platform implementation is registered (widget tests).
class SharedPreferencesLibraryInstanceStore implements LibraryInstanceStore {
  SharedPreferencesLibraryInstanceStore([this._preferences]);

  SharedPreferencesAsync? _preferences;

  SharedPreferencesAsync get _prefs =>
      _preferences ??= SharedPreferencesAsync();

  static String _key(ServiceType type) =>
      'library.selectedInstance.${type.name}';

  @override
  Future<String?> read(ServiceType type) async {
    try {
      return await _prefs.getString(_key(type));
    } on Object {
      return null;
    }
  }

  @override
  Future<void> write(ServiceType type, String instanceId) async {
    try {
      await _prefs.setString(_key(type), instanceId);
    } on Object {
      // Best effort: the in-memory selection still applies this session.
    }
  }
}

@Riverpod(keepAlive: true)
LibraryInstanceStore libraryInstanceStore(Ref ref) =>
    SharedPreferencesLibraryInstanceStore();

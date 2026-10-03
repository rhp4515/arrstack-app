/// Remembers which Radarr/Sonarr instance the Library last showed, so the
/// instance switcher's choice survives a restart.
///
/// A convenience only: every read and write swallows failures (no platform
/// channel in tests, cleared storage) and the Library falls back to the
/// default instance.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_instance_store.g.dart';

abstract interface class LibraryInstanceStore {
  /// The saved instance id for [type], or null if none/unreadable.
  Future<String?> read(ServiceType type);

  /// Saves [instanceId] as the Library's choice for [type].
  Future<void> write(ServiceType type, String instanceId);
}

/// [LibraryInstanceStore] over the app's [AppPreferences], under the key
/// the store has always used, so a choice saved by an earlier version is
/// still found.
class PreferencesLibraryInstanceStore implements LibraryInstanceStore {
  const PreferencesLibraryInstanceStore(this._preferences);

  final AppPreferences _preferences;

  static String _key(ServiceType type) =>
      'library.selectedInstance.${type.name}';

  @override
  Future<String?> read(ServiceType type) async {
    try {
      return await _preferences.readString(_key(type));
    } on Object {
      return null;
    }
  }

  @override
  Future<void> write(ServiceType type, String instanceId) async {
    try {
      await _preferences.writeString(_key(type), instanceId);
    } on Object {
      // Best effort: the in-memory selection still applies this session.
    }
  }
}

@Riverpod(keepAlive: true)
LibraryInstanceStore libraryInstanceStore(Ref ref) =>
    PreferencesLibraryInstanceStore(ref.watch(appPreferencesProvider));

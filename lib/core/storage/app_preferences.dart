/// Small non-secret key/value preferences that aren't part of the service
/// configuration [ConfigStore] owns: the app lock switch and the
/// background-notification settings. Readable from the background worker's
/// isolate too, since `shared_preferences` is process-wide.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences.g.dart';

abstract interface class AppPreferences {
  Future<bool?> readBool(String key);

  Future<void> writeBool(String key, {required bool value});

  Future<int?> readInt(String key);

  Future<void> writeInt(String key, int value);

  Future<String?> readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> remove(String key);

  /// Every stored key, for clearing a family of keys by prefix.
  Future<Set<String>> keys();
}

/// The preferences handle is created on first use, not on construction:
/// its constructor throws when no platform implementation is registered
/// (widget tests), and a provider that merely depends on this one
/// shouldn't fail to build because of that.
class SharedPreferencesAppPreferences implements AppPreferences {
  SharedPreferencesAppPreferences([this._handle]);

  SharedPreferencesAsync? _handle;

  SharedPreferencesAsync get _preferences =>
      _handle ??= SharedPreferencesAsync();

  @override
  Future<bool?> readBool(String key) => _preferences.getBool(key);

  @override
  Future<void> writeBool(String key, {required bool value}) =>
      _preferences.setBool(key, value);

  @override
  Future<int?> readInt(String key) => _preferences.getInt(key);

  @override
  Future<void> writeInt(String key, int value) =>
      _preferences.setInt(key, value);

  @override
  Future<String?> readString(String key) => _preferences.getString(key);

  @override
  Future<void> writeString(String key, String value) =>
      _preferences.setString(key, value);

  @override
  Future<void> remove(String key) => _preferences.remove(key);

  @override
  Future<Set<String>> keys() => _preferences.getKeys();
}

/// [AppPreferences] held in memory, for tests.
class InMemoryAppPreferences implements AppPreferences {
  InMemoryAppPreferences([Map<String, Object>? initial])
    : _values = {...?initial};

  final Map<String, Object> _values;

  @override
  Future<bool?> readBool(String key) async => _values[key] as bool?;

  @override
  Future<void> writeBool(String key, {required bool value}) async =>
      _values[key] = value;

  @override
  Future<int?> readInt(String key) async => _values[key] as int?;

  @override
  Future<void> writeInt(String key, int value) async => _values[key] = value;

  @override
  Future<String?> readString(String key) async => _values[key] as String?;

  @override
  Future<void> writeString(String key, String value) async =>
      _values[key] = value;

  @override
  Future<void> remove(String key) async => _values.remove(key);

  @override
  Future<Set<String>> keys() async => {..._values.keys};
}

@Riverpod(keepAlive: true)
AppPreferences appPreferences(Ref ref) => SharedPreferencesAppPreferences();

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
}

class SharedPreferencesAppPreferences implements AppPreferences {
  SharedPreferencesAppPreferences([SharedPreferencesAsync? preferences])
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

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
}

@Riverpod(keepAlive: true)
AppPreferences appPreferences(Ref ref) => SharedPreferencesAppPreferences();

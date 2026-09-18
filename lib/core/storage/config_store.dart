/// Non-secret app configuration: the serialized instance list, the
/// app-level home SSIDs, default endpoint mode, and theme mode (spec §5,
/// §6a). Backed by `shared_preferences` — never store secrets here.
library;

import 'dart:convert';

import 'package:arrstack/core/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads/writes non-secret app configuration.
abstract interface class ConfigStore {
  /// The persisted service instances, as raw JSON maps (the caller decodes
  /// them via [ServiceInstance.fromJson]).
  Future<List<Map<String, dynamic>>> readInstances();

  /// Persists the full instance list (raw JSON maps).
  Future<void> writeInstances(List<Map<String, dynamic>> instances);

  /// App-level "home" SSIDs used by [EndpointResolver] when an instance has
  /// no per-instance override.
  Future<List<String>> readHomeSsids();

  Future<void> writeHomeSsids(List<String> ssids);

  /// The default [EndpointMode] applied to newly created instances.
  Future<EndpointMode> readDefaultEndpointMode();

  Future<void> writeDefaultEndpointMode(EndpointMode mode);

  /// The persisted theme mode selection (`system`/`light`/`dark`), or null
  /// if never set.
  Future<String?> readThemeMode();

  Future<void> writeThemeMode(String mode);

  /// The persisted last-known-good service summaries, as raw JSON maps
  /// (the caller decodes them via [CachedServiceSummary.fromJson]) — used
  /// by the offline layout (README §3f) to show stale-but-honest data.
  Future<List<Map<String, dynamic>>> readCachedSummaries();

  /// Persists the full cached-summary list (raw JSON maps).
  Future<void> writeCachedSummaries(List<Map<String, dynamic>> summaries);
}

const String _instancesKey = 'config.instances';
const String _homeSsidsKey = 'config.homeSsids';
const String _defaultEndpointModeKey = 'config.defaultEndpointMode';
const String _themeModeKey = 'config.themeMode';
const String _cachedSummariesKey = 'config.cachedSummaries';

/// [ConfigStore] backed by `shared_preferences`' async API.
class SharedPreferencesConfigStore implements ConfigStore {
  SharedPreferencesConfigStore([SharedPreferencesAsync? preferences])
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<List<Map<String, dynamic>>> readInstances() async {
    final raw = await _preferences.getString(_instancesKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> writeInstances(List<Map<String, dynamic>> instances) {
    return _preferences.setString(_instancesKey, jsonEncode(instances));
  }

  @override
  Future<List<String>> readHomeSsids() async {
    final ssids = await _preferences.getStringList(_homeSsidsKey);
    return ssids ?? const [];
  }

  @override
  Future<void> writeHomeSsids(List<String> ssids) {
    return _preferences.setStringList(_homeSsidsKey, ssids);
  }

  @override
  Future<EndpointMode> readDefaultEndpointMode() async {
    final raw = await _preferences.getString(_defaultEndpointModeKey);
    return EndpointMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => EndpointMode.auto,
    );
  }

  @override
  Future<void> writeDefaultEndpointMode(EndpointMode mode) {
    return _preferences.setString(_defaultEndpointModeKey, mode.name);
  }

  @override
  Future<String?> readThemeMode() => _preferences.getString(_themeModeKey);

  @override
  Future<void> writeThemeMode(String mode) {
    return _preferences.setString(_themeModeKey, mode);
  }

  @override
  Future<List<Map<String, dynamic>>> readCachedSummaries() async {
    final raw = await _preferences.getString(_cachedSummariesKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      // Valid JSON can still have the wrong shape (an object instead of a
      // list, or a list containing a scalar) — degrade to an empty/filtered
      // list rather than a throwing cast, so shape-corrupt storage can't
      // fail the whole cached-summary provider and hide otherwise-valid
      // history (unlike a single corrupt element, which the provider's own
      // per-entry decode loop already tolerates).
      if (decoded is! List) return const [];
      return decoded.whereType<Map<String, dynamic>>().toList();
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> writeCachedSummaries(List<Map<String, dynamic>> summaries) {
    return _preferences.setString(_cachedSummariesKey, jsonEncode(summaries));
  }
}

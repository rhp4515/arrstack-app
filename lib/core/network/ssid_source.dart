/// Reads the currently connected WiFi SSID, kept as a thin, fakeable
/// boundary around `network_info_plus` so [EndpointResolver] tests never
/// touch a platform plugin (spec §6a).
library;

import 'package:network_info_plus/network_info_plus.dart';

/// Source of the currently connected WiFi SSID.
abstract interface class SsidSource {
  /// Returns the current SSID, or null when unavailable: no permission,
  /// not connected to WiFi, location services disabled, or the platform
  /// (e.g. desktop) doesn't support it. Never throws.
  Future<String?> currentSsid();
}

/// [SsidSource] backed by `network_info_plus`.
class NetworkInfoSsidSource implements SsidSource {
  const NetworkInfoSsidSource([NetworkInfo? networkInfo])
    : _networkInfo = networkInfo;

  final NetworkInfo? _networkInfo;

  NetworkInfo get _instance => _networkInfo ?? NetworkInfo();

  @override
  Future<String?> currentSsid() async {
    try {
      final raw = await _instance.getWifiName();
      return _normalize(raw);
    } on Exception {
      // Permission denied, location services off, platform unsupported,
      // etc. — degrade to "unavailable" rather than surfacing an error;
      // EndpointResolver treats null as "fall back to remote" (spec §6a).
      return null;
    }
  }

  /// Android/iOS sometimes wrap the SSID in double quotes (e.g. `"Home"`)
  /// or return the sentinel `<unknown ssid>` when permission is denied.
  static String? _normalize(String? raw) {
    if (raw == null) return null;
    var value = raw.trim();
    if (value.startsWith('"') && value.endsWith('"') && value.length >= 2) {
      value = value.substring(1, value.length - 1);
    }
    if (value.isEmpty || value == '<unknown ssid>') return null;
    return value;
  }
}

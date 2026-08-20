/// Reads the currently connected WiFi SSID, kept as a thin, fakeable
/// boundary around `network_info_plus` so [EndpointResolver] tests never
/// touch a platform plugin (spec §6a).
library;

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Source of the currently connected WiFi SSID.
abstract interface class SsidSource {
  /// Returns the current SSID, or null when unavailable.
  Future<String?> currentSsid();

  /// Requests the necessary location permissions to read the SSID.
  /// Returns true if granted.
  Future<bool> requestPermission();

  /// Returns the current permission status.
  Future<PermissionStatus> permissionStatus();
}

/// [SsidSource] backed by `network_info_plus` and `permission_handler`.
class NetworkInfoSsidSource implements SsidSource {
  const NetworkInfoSsidSource([NetworkInfo? networkInfo])
    : _networkInfo = networkInfo;

  final NetworkInfo? _networkInfo;

  NetworkInfo get _instance => _networkInfo ?? NetworkInfo();

  @override
  Future<String?> currentSsid() async {
    try {
      final locationStatus = await Permission.locationWhenInUse.status;
      final nearbyStatus = await Permission.nearbyWifiDevices.status;

      if (!locationStatus.isGranted && !nearbyStatus.isGranted) {
        return null;
      }

      final raw = await _instance.getWifiName();
      return _normalize(raw);
    } on Exception {
      return null;
    }
  }

  @override
  Future<bool> requestPermission() async {
    final statuses = await [
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
    ].request();
    
    return statuses[Permission.locationWhenInUse]?.isGranted == true ||
           statuses[Permission.nearbyWifiDevices]?.isGranted == true;
  }

  @override
  Future<PermissionStatus> permissionStatus() async {
    final status = await Permission.nearbyWifiDevices.status;
    if (status.isGranted) return status;
    return Permission.locationWhenInUse.status;
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

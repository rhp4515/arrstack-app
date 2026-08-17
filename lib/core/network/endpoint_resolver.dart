/// Picks the local-LAN or Tailscale-remote URL for a [ServiceInstance]
/// based on the connected WiFi SSID (spec §6a). This is the heart of the
/// network-aware endpoint switch: a pure, synchronous function so the full
/// resolution matrix is unit-testable without touching any plugin.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';

/// Which of an instance's two URLs was ultimately selected.
enum ResolvedEndpoint { local, remote }

/// The result of resolving a [ServiceInstance] to a concrete base URL.
/// Immutable — construct a new instance rather than mutating one.
class EndpointResolution {
  const EndpointResolution({
    required this.baseUrl,
    required this.endpoint,
    required this.needsManualOverride,
  });

  /// The base URL Dio should use for this instance right now.
  final String baseUrl;

  /// Which URL ([ServiceInstance.localBaseUrl] or `.remoteBaseUrl]`) this
  /// came from.
  final ResolvedEndpoint endpoint;

  /// True when auto-mode had to guess (SSID unavailable) rather than
  /// confirm a match — the UI should offer a one-tap "Use local" override
  /// (spec §6a).
  final bool needsManualOverride;

  @override
  bool operator ==(Object other) =>
      other is EndpointResolution &&
      other.baseUrl == baseUrl &&
      other.endpoint == endpoint &&
      other.needsManualOverride == needsManualOverride;

  @override
  int get hashCode => Object.hash(baseUrl, endpoint, needsManualOverride);

  @override
  String toString() =>
      'EndpointResolution($endpoint, $baseUrl, '
      'needsManualOverride: $needsManualOverride)';
}

/// Resolves which base URL a [ServiceInstance] should use right now,
/// following the algorithm in spec §6a:
///
/// 1. A forced [EndpointMode] always wins.
/// 2. Otherwise, match the current SSID against the effective home-SSID
///    list (the instance's override, else the app-level list): a match
///    means local, anything else means remote.
/// 3. If the chosen URL is blank, fall back to the other URL.
/// 4. If the SSID is unavailable (no permission, not on WiFi, desktop),
///    default to remote (Tailscale works from anywhere) and flag that a
///    manual override may be useful.
class EndpointResolver {
  const EndpointResolver();

  /// Returns an [Err] only when the instance has no usable URL at all.
  Result<EndpointResolution> resolve({
    required ServiceInstance instance,
    required List<String> appHomeSsids,
    required String? currentSsid,
  }) {
    final local = instance.localBaseUrl;
    final remote = instance.remoteBaseUrl;

    if (_isBlank(local) && _isBlank(remote)) {
      return const Err(
        ValidationError(
          field: 'localBaseUrl/remoteBaseUrl',
          userMessage: 'This instance has no local or remote URL configured.',
        ),
      );
    }

    final isAuto = instance.endpointMode == EndpointMode.auto;
    final preferred = switch (instance.endpointMode) {
      EndpointMode.forceLocal => ResolvedEndpoint.local,
      EndpointMode.forceRemote => ResolvedEndpoint.remote,
      EndpointMode.auto => _autoPreferred(
        currentSsid: currentSsid,
        homeSsids: instance.homeSsidsOverride ?? appHomeSsids,
      ),
    };

    final resolved = _withFallback(preferred, local: local, remote: remote);
    if (resolved == null) {
      // Unreachable given the blank-check above, but keeps this total.
      return const Err(
        ValidationError(
          userMessage: 'The selected endpoint has no URL configured.',
        ),
      );
    }

    // needsManualOverride is true if:
    // 1. Auto-mode had to guess (SSID unavailable).
    // 2. A forced mode had to fall back to the other URL.
    final fellBack = preferred != resolved.endpoint;

    return Ok(
      EndpointResolution(
        baseUrl: resolved.url,
        endpoint: resolved.endpoint,
        needsManualOverride: (isAuto && currentSsid == null) || fellBack,
      ),
    );
  }

  static ResolvedEndpoint _autoPreferred({
    required String? currentSsid,
    required List<String> homeSsids,
  }) {
    if (currentSsid == null) return ResolvedEndpoint.remote;
    final normalizedSsid = currentSsid.trim().toLowerCase();
    final isHome = homeSsids.any(
      (ssid) => ssid.trim().toLowerCase() == normalizedSsid,
    );
    return isHome ? ResolvedEndpoint.local : ResolvedEndpoint.remote;
  }

  static ({ResolvedEndpoint endpoint, String url})? _withFallback(
    ResolvedEndpoint preferred, {
    required String? local,
    required String? remote,
  }) {
    final preferredUrl = preferred == ResolvedEndpoint.local ? local : remote;
    if (!_isBlank(preferredUrl)) {
      return (endpoint: preferred, url: preferredUrl!.trim());
    }

    final fallback = preferred == ResolvedEndpoint.local
        ? ResolvedEndpoint.remote
        : ResolvedEndpoint.local;
    final fallbackUrl = fallback == ResolvedEndpoint.local ? local : remote;
    if (!_isBlank(fallbackUrl)) {
      return (endpoint: fallback, url: fallbackUrl!.trim());
    }

    return null;
  }

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}

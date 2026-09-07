/// The set of supported service integrations (spec §3, §6).
library;

import 'package:arrstack/core/models/auth_type.dart';

/// One integration this app knows how to talk to.
///
/// Adding a post-v1 service (Lidarr, SABnzbd, ...) means adding a case here
/// plus a new `services/<name>/` plugin — no other core changes (spec §5).
enum ServiceType {
  sonarr,
  radarr,
  bazarr,
  prowlarr,
  qbittorrent,
  uptimeKuma,
  seerr;

  /// Human-readable name shown in onboarding/settings UI.
  String get displayName => switch (this) {
    ServiceType.sonarr => 'Sonarr',
    ServiceType.radarr => 'Radarr',
    ServiceType.bazarr => 'Bazarr',
    ServiceType.prowlarr => 'Prowlarr',
    ServiceType.qbittorrent => 'qBittorrent',
    ServiceType.uptimeKuma => 'Uptime Kuma',
    ServiceType.seerr => 'Seerr',
  };

  /// Default HTTP port for this service.
  int get defaultPort => switch (this) {
    ServiceType.sonarr => 8989,
    ServiceType.radarr => 7878,
    ServiceType.bazarr => 6767,
    ServiceType.prowlarr => 9696,
    ServiceType.qbittorrent => 8090,
    ServiceType.uptimeKuma => 3001,
    ServiceType.seerr => 5055,
  };

  /// The auth style this service uses out of the box (spec §6). Onboarding
  /// may still let a user pick differently if a service ever supports both.
  AuthType get defaultAuthType => switch (this) {
    // Uptime Kuma's real-time socket.io API authenticates with the dashboard
    // username/password — its API keys are REST/metrics-only and cannot log in
    // over the socket, so username/password is the correct default here.
    ServiceType.qbittorrent ||
    ServiceType.uptimeKuma => AuthType.usernamePassword,
    ServiceType.sonarr ||
    ServiceType.radarr ||
    ServiceType.bazarr ||
    ServiceType.prowlarr ||
    ServiceType.seerr => AuthType.apiKey,
  };
}

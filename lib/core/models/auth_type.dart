/// Authentication style a service integration uses (spec §6).
library;

/// How a service instance authenticates its requests.
enum AuthType {
  /// A static `X-Api-Key` header (the *arr services + Seerr).
  apiKey,

  /// Username + password, exchanged for a session (qBittorrent cookie,
  /// Uptime Kuma socket login).
  usernamePassword,
}

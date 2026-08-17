/// Manual override for [EndpointResolver] endpoint selection (spec §6a).
library;

/// How a [ServiceInstance] picks between its local and remote base URL.
enum EndpointMode {
  /// Auto-select based on the connected WiFi SSID.
  auto,

  /// Always use `localBaseUrl`, regardless of network.
  forceLocal,

  /// Always use `remoteBaseUrl`, regardless of network.
  forceRemote,
}

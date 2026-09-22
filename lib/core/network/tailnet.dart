/// Recognises addresses that only exist inside a tailnet.
///
/// Worth singling out because a failure against one of these has a cause
/// the generic copy gets wrong. Android routes traffic per app: an app
/// excluded from Tailscale's VPN (Tailscale → avatar → App-based split
/// tunneling) has "its traffic and DNS queries" bypass the tunnel, so
/// MagicDNS names stop resolving *and* tailnet IPs stop answering for that
/// app alone while every other app on the device is fine. Telling that user
/// to connect Tailscale is useless — it is already connected.
///
/// The failure mode is a timeout rather than a fast "no route", which is
/// easy to misread as a dead service: Tailscale addresses live in
/// 100.64.0.0/10, the CGNAT range, so a mobile carrier usually has a route
/// for it. Packets leave the device and vanish instead of being rejected.
library;

/// MagicDNS suffix for a tailnet name.
const _magicDnsSuffix = '.ts.net';

/// True when [host] can only be reached from inside a tailnet: a MagicDNS
/// name, or an address in Tailscale's 100.64.0.0/10 range.
///
/// [host] may carry a port (`nas.example.ts.net:8989`), as the user-facing
/// host labels do.
bool isTailnetHost(String host) {
  final bare = _withoutPort(host).trim().toLowerCase();
  if (bare.isEmpty) return false;
  if (bare.endsWith(_magicDnsSuffix)) return true;
  return _isCgnatAddress(bare);
}

/// Strips a trailing `:port`. Leaves a bracketed IPv6 literal alone —
/// tailnet IPv6 (`fd7a:115c:a1e0::/48`) isn't matched here, and splitting
/// on its colons would corrupt it.
String _withoutPort(String host) {
  if (host.startsWith('[')) return host;
  final colon = host.lastIndexOf(':');
  if (colon < 0) return host;
  final tail = host.substring(colon + 1);
  return int.tryParse(tail) == null ? host : host.substring(0, colon);
}

/// 100.64.0.0/10 — the shared-address (CGNAT) block Tailscale assigns
/// from, i.e. 100.64.x.x through 100.127.x.x.
bool _isCgnatAddress(String host) {
  final octets = host.split('.');
  if (octets.length != 4) return false;
  final parsed = octets.map(int.tryParse).toList();
  if (parsed.any((o) => o == null || o < 0 || o > 255)) return false;
  return parsed[0] == 100 && parsed[1]! >= 64 && parsed[1]! <= 127;
}

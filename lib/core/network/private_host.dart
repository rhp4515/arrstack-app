/// Recognises hosts that live on the user's own network.
///
/// Used to decide whether a redirect may carry the app's credentials with
/// it: a hop to another address *inside* the home network or tailnet is the
/// same trust domain, while a hop to a public host is not.
library;

import 'package:arrstack/core/network/tailnet.dart';

/// True for loopback, link-local, private-range (10/8, 172.16/12,
/// 192.168/16) and tailnet addresses, IPv6 unique-local/link-local, and
/// names that only resolve locally (`nas`, `nas.local`, `box.lan`, …).
bool isPrivateNetworkHost(String host) {
  var h = host.trim().toLowerCase();
  if (h.isEmpty) return false;
  if (h.startsWith('[') && h.endsWith(']')) h = h.substring(1, h.length - 1);

  if (isTailnetHost(h)) return true;
  if (h == 'localhost' || h.endsWith('.localhost')) return true;

  if (h.contains(':')) return _isPrivateIpv6(h);

  final octets = h.split('.');
  final parsed = octets.map(int.tryParse).toList();
  if (octets.length == 4 &&
      parsed.every((o) => o != null && o >= 0 && o <= 255)) {
    final a = parsed[0]!;
    final b = parsed[1]!;
    return a == 10 ||
        a == 127 ||
        (a == 172 && b >= 16 && b <= 31) ||
        (a == 192 && b == 168) ||
        (a == 169 && b == 254);
  }

  // A bare name (`sonarr`, `nas`) can only come from local DNS.
  if (!h.contains('.')) return true;
  const localSuffixes = [
    '.local',
    '.lan',
    '.home',
    '.home.arpa',
    '.internal',
    '.localdomain',
  ];
  return localSuffixes.any(h.endsWith);
}

bool _isPrivateIpv6(String h) =>
    h == '::1' ||
    h.startsWith('fc') ||
    h.startsWith('fd') ||
    h.startsWith('fe8') ||
    h.startsWith('fe9') ||
    h.startsWith('fea') ||
    h.startsWith('feb');

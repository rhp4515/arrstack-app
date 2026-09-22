// isTailnetHost: which hosts are only reachable from inside a tailnet.
//
// This drives the split-tunneling diagnosis, so a false positive would
// send someone with an ordinary dead service to go fiddle with Tailscale's
// app list, and a false negative brings back the "connect Tailscale"
// advice for someone whose Tailscale is already connected.

import 'package:arrstack/core/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MagicDNS names', () {
    test('recognises a tailnet name, with or without a port', () {
      expect(isTailnetHost('harivin-nas.worm-banded.ts.net'), isTrue);
      expect(isTailnetHost('harivin-nas.worm-banded.ts.net:8989'), isTrue);
    });

    test('ignores case', () {
      expect(isTailnetHost('HARIVIN-NAS.WORM-BANDED.TS.NET'), isTrue);
    });

    test('rejects a host that merely contains the suffix', () {
      expect(isTailnetHost('ts.net.example.com'), isFalse);
      expect(isTailnetHost('nots.net'), isFalse);
      expect(isTailnetHost('example.com'), isFalse);
    });
  });

  group('the 100.64.0.0/10 range', () {
    test('recognises addresses across the whole block', () {
      expect(isTailnetHost('100.64.0.1'), isTrue);
      expect(isTailnetHost('100.100.100.100'), isTrue);
      expect(isTailnetHost('100.127.255.255'), isTrue);
      expect(isTailnetHost('100.101.5.7:7878'), isTrue);
    });

    test('excludes 100.x addresses outside the block: 100.0.0.0/10 and '
        '100.128.0.0/9 are ordinary public space', () {
      expect(isTailnetHost('100.63.255.255'), isFalse);
      expect(isTailnetHost('100.128.0.1'), isFalse);
      expect(isTailnetHost('100.0.0.1'), isFalse);
    });

    test('excludes private LAN and loopback addresses', () {
      expect(isTailnetHost('192.168.1.10'), isFalse);
      expect(isTailnetHost('192.168.1.10:7878'), isFalse);
      expect(isTailnetHost('10.0.0.1'), isFalse);
      expect(isTailnetHost('127.0.0.1'), isFalse);
    });

    test('rejects malformed and out-of-range dotted quads', () {
      expect(isTailnetHost('100.64.0'), isFalse);
      expect(isTailnetHost('100.64.0.1.5'), isFalse);
      expect(isTailnetHost('100.999.0.1'), isFalse);
      expect(isTailnetHost('100.64.0.x'), isFalse);
      expect(isTailnetHost(''), isFalse);
      expect(isTailnetHost('   '), isFalse);
    });
  });

  test('leaves a bracketed IPv6 literal intact rather than splitting it on '
      'its own colons', () {
    // Not claimed as tailnet (that would need the fd7a:115c:a1e0::/48
    // check), but it must not be mangled into a false match either.
    expect(isTailnetHost('[fd7a:115c:a1e0::1]'), isFalse);
    expect(isTailnetHost('[::1]:8989'), isFalse);
  });
}

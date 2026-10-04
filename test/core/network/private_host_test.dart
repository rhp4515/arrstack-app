import 'package:arrstack/core/network/private_host.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recognises hosts on the user\'s own network', () {
    for (final host in [
      '192.168.1.87',
      '10.0.0.5',
      '172.16.0.1',
      '172.31.255.255',
      '127.0.0.1',
      '169.254.1.1',
      '100.100.1.2', // tailnet
      'nas.tail1234.ts.net',
      'localhost',
      'sonarr',
      'nas.local',
      'box.lan',
      'router.home.arpa',
      '[::1]',
      'fd00::1',
    ]) {
      expect(isPrivateNetworkHost(host), isTrue, reason: host);
    }
  });

  test('rejects public hosts', () {
    for (final host in [
      '8.8.8.8',
      '172.32.0.1',
      '172.15.0.1',
      '192.169.1.1',
      '100.128.0.1',
      'example.com',
      'sonarr.example.com',
      '',
    ]) {
      expect(isPrivateNetworkHost(host), isFalse, reason: host);
    }
  });
}

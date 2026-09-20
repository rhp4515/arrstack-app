// Uptime Kuma sends `ping: null` on heartbeats where no latency was
// measured — most commonly a "Down" status heartbeat, since a failed check
// has nothing to time. KumaHeartbeat.fromJson must tolerate that: before
// this fix it threw, and reached production as an unhandled exception in
// kuma_client.dart's 'heartbeat' socket listener (that listener is now
// wrapped in try/catch and logs failures, but the model itself must still
// parse this real payload shape correctly rather than relying on the
// listener to mask a parsing bug).

import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KumaHeartbeat.fromJson', () {
    test('parses a down heartbeat whose ping is null', () {
      final heartbeat = KumaHeartbeat.fromJson({
        'monitorID': 3,
        'status': 0,
        'time': '2026-01-01T00:00:00.000Z',
        'msg': 'Connection refused',
        'ping': null,
        'important': true,
      });

      expect(heartbeat.monitorId, 3);
      expect(heartbeat.status, 0);
      expect(heartbeat.ping, isNull);
      expect(heartbeat.important, isTrue);
    });

    test('parses an up heartbeat with a real ping value', () {
      final heartbeat = KumaHeartbeat.fromJson({
        'monitorID': 3,
        'status': 1,
        'time': '2026-01-01T00:00:00.000Z',
        'msg': null,
        'ping': 42,
        'important': false,
      });

      expect(heartbeat.ping, 42);
    });
  });
}

// test/features/uptime/monitor_status_test.dart
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter_test/flutter_test.dart';

KumaMonitor _monitor({
  required bool active,
  required int status,
  List<KumaHeartbeat> heartbeats = const [],
}) => KumaMonitor(
  id: 1,
  name: 'Test',
  type: 'http',
  active: active,
  interval: 60,
  status: status,
  heartbeats: heartbeats,
);

KumaHeartbeat _hb(int status, DateTime time) => KumaHeartbeat(
  monitorId: 1,
  status: status,
  time: time,
  ping: 10,
  important: false,
);

void main() {
  group('classification', () {
    test('isMonitorUp is true only when active and status is up', () {
      expect(isMonitorUp(_monitor(active: true, status: 1)), isTrue);
      expect(isMonitorUp(_monitor(active: false, status: 1)), isFalse);
      expect(isMonitorUp(_monitor(active: true, status: 0)), isFalse);
    });

    test('isMonitorDown is true only when active and status is down', () {
      expect(isMonitorDown(_monitor(active: true, status: 0)), isTrue);
      expect(isMonitorDown(_monitor(active: false, status: 0)), isFalse);
    });

    test('isMonitorPaused is true whenever the monitor is inactive', () {
      expect(isMonitorPaused(_monitor(active: false, status: 1)), isTrue);
      expect(isMonitorPaused(_monitor(active: true, status: 1)), isFalse);
    });
  });

  group('statusLabel', () {
    test('maps status 2 to Pending', () {
      expect(statusLabel(_monitor(active: true, status: 2)), 'Pending');
    });

    test('maps status 3 to Maintenance', () {
      expect(statusLabel(_monitor(active: true, status: 3)), 'Maintenance');
    });
  });

  group('downDurationLabel', () {
    test('measures back to the oldest heartbeat in the current down run', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final monitor = _monitor(
        active: true,
        status: 0,
        heartbeats: [
          _hb(0, now.subtract(const Duration(minutes: 5))),
          _hb(0, now.subtract(const Duration(minutes: 38))),
          _hb(1, now.subtract(const Duration(minutes: 90))),
        ],
      );

      expect(downDurationLabel(monitor, now: now), '38m');
    });

    test('falls back to "just now" when there is no heartbeat history', () {
      final monitor = _monitor(active: true, status: 0);
      expect(downDurationLabel(monitor), 'just now');
    });

    test('falls back to "just now" when the newest heartbeat is not down', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final monitor = _monitor(
        active: true,
        status: 0,
        heartbeats: [_hb(1, now)],
      );
      expect(downDurationLabel(monitor, now: now), 'just now');
    });
  });

  group('pausedDurationLabel', () {
    test('measures from the most recent heartbeat before pausing', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final monitor = _monitor(
        active: false,
        status: 1,
        heartbeats: [_hb(1, now.subtract(const Duration(days: 4)))],
      );
      expect(pausedDurationLabel(monitor, now: now), 'paused 4d');
    });

    test(
      'falls back to "paused" with no duration when there is no history',
      () {
        final monitor = _monitor(active: false, status: 1);
        expect(pausedDurationLabel(monitor), 'paused');
      },
    );
  });
}

// test/features/uptime/widgets/healthy_monitor_row_test.dart
import 'package:arrstack/features/uptime/widgets/healthy_monitor_row.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

KumaMonitor _upMonitor() => KumaMonitor(
  id: 2,
  name: 'Radarr',
  type: 'http',
  active: true,
  interval: 60,
  status: 1,
  heartbeats: [
    KumaHeartbeat(
      monitorId: 2,
      status: 1,
      time: DateTime.now(),
      ping: 18,
      important: false,
    ),
  ],
);

void main() {
  testWidgets('shows the monitor name and latest latency', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HealthyMonitorRow(monitor: _upMonitor())),
      ),
    );

    expect(find.text('Radarr'), findsOneWidget);
    expect(find.text('18 ms'), findsOneWidget);
  });

  testWidgets('shows no latency text when there are no heartbeats', (
    tester,
  ) async {
    const monitor = KumaMonitor(
      id: 3,
      name: 'NoHeartbeats',
      type: 'http',
      active: true,
      interval: 60,
      status: 1,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: HealthyMonitorRow(monitor: monitor)),
      ),
    );

    expect(find.textContaining('ms'), findsNothing);
  });
}

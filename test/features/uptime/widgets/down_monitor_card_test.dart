// test/features/uptime/widgets/down_monitor_card_test.dart
import 'package:arrstack/features/uptime/widgets/down_monitor_card.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

KumaMonitor _downMonitor() => KumaMonitor(
  id: 1,
  name: 'Bazarr',
  type: 'http',
  url: 'http://192.168.1.10:6767',
  active: true,
  interval: 60,
  status: 0,
  uptime: 0.6842,
  heartbeats: [
    KumaHeartbeat(
      monitorId: 1,
      status: 0,
      time: DateTime.now().subtract(const Duration(minutes: 38)),
      ping: 0,
      important: true,
    ),
  ],
);

void main() {
  testWidgets('shows the monitor name, type, and url', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DownMonitorCard(monitor: _downMonitor(), onRetest: () {}),
        ),
      ),
    );

    expect(find.text('Bazarr'), findsOneWidget);
    expect(find.text('HTTP'), findsOneWidget);
    expect(find.text('http://192.168.1.10:6767'), findsOneWidget);
  });

  testWidgets('shows the down duration and 24h uptime', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DownMonitorCard(monitor: _downMonitor(), onRetest: () {}),
        ),
      ),
    );

    expect(find.textContaining('Down 38m'), findsOneWidget);
    expect(find.textContaining('68.42% 24h'), findsOneWidget);
  });

  testWidgets('calls onRetest when the Retest button is tapped', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DownMonitorCard(
            monitor: _downMonitor(),
            onRetest: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Retest'));
    expect(tapped, isTrue);
  });
}

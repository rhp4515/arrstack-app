import 'package:arrstack/features/uptime/widgets/heartbeat_strip.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

KumaHeartbeat _hb(int status) => KumaHeartbeat(
  monitorId: 1,
  status: status,
  time: DateTime(2026),
  ping: 20,
  important: false,
);

void main() {
  testWidgets('renders beatCount bars total, padding with empty slots first', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeartbeatStrip(
            heartbeats: [_hb(1), _hb(1)],
            beatCount: 5,
            height: 22,
            upColor: Colors.green,
          ),
        ),
      ),
    );

    expect(find.byType(Container), findsNWidgets(5));
  });

  testWidgets('colors a down heartbeat with the down color, not upColor', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeartbeatStrip(
            heartbeats: [_hb(0)],
            beatCount: 1,
            height: 22,
            upColor: Colors.green,
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, isNot(Colors.green));
  });

  testWidgets('sizes the strip to the given height', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeartbeatStrip(
            heartbeats: [_hb(1)],
            beatCount: 1,
            height: 14,
            upColor: Colors.green,
          ),
        ),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sizedBox.height, 14);
  });
}

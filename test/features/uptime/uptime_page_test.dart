import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/uptime/uptime_page.dart';
import 'package:arrstack/features/uptime/uptime_providers.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows UP/DOWN/PAUSED counts and no instance dropdown', (
    tester,
  ) async {
    const instanceId = 'kuma-1';
    final monitors = [
      const KumaMonitor(
        id: 1,
        name: 'Up1',
        type: 'http',
        active: true,
        interval: 60,
        status: 1,
      ),
      const KumaMonitor(
        id: 2,
        name: 'Down1',
        type: 'http',
        active: true,
        interval: 60,
        status: 0,
      ),
      const KumaMonitor(
        id: 3,
        name: 'Paused1',
        type: 'http',
        active: false,
        interval: 60,
        status: 1,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedUptimeInstanceIdProvider.overrideWith(
            () => _FakeSelectedUptimeInstanceId(instanceId),
          ),
          kumaMonitorsProvider(instanceId)
              .overrideWith(() => _FakeKumaMonitors(monitors)),
        ],
        child: const MaterialApp(home: UptimePage()),
      ),
    );
    await tester.pump();
    // A second pump is needed: the first resolves
    // selectedUptimeInstanceIdProvider's Future, which lets the widget tree
    // rebuild and watch kumaMonitorsProvider; the second pump then lets that
    // stream provider emit its first value.
    await tester.pump();

    expect(find.text('1'), findsNWidgets(3)); // UP, DOWN, PAUSED all count 1
    expect(find.text('UP'), findsOneWidget);
    expect(find.text('DOWN'), findsOneWidget);
    expect(find.text('PAUSED'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsNothing);
    expect(find.text('Down1'), findsOneWidget);
    expect(find.textContaining('HEALTHY'), findsOneWidget);
    expect(find.text('Up1'), findsOneWidget);
  });

  testWidgets(
    'shows a Pending monitor in an OTHER section instead of dropping it',
    (tester) async {
      const instanceId = 'kuma-1';
      final monitors = [
        const KumaMonitor(
          id: 1,
          name: 'Up1',
          type: 'http',
          active: true,
          interval: 60,
          status: 1,
        ),
        const KumaMonitor(
          id: 2,
          name: 'Pending1',
          type: 'http',
          active: true,
          interval: 60,
          status: 2,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedUptimeInstanceIdProvider.overrideWith(
              () => _FakeSelectedUptimeInstanceId(instanceId),
            ),
            kumaMonitorsProvider(instanceId)
                .overrideWith(() => _FakeKumaMonitors(monitors)),
          ],
          child: const MaterialApp(home: UptimePage()),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('OTHER'), findsOneWidget);
      expect(find.text('Pending1'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    },
  );
}

class _FakeSelectedUptimeInstanceId extends SelectedUptimeInstanceId {
  _FakeSelectedUptimeInstanceId(this._id);
  final String _id;

  @override
  Future<String?> build() async => _id;
}

class _FakeKumaMonitors extends KumaMonitors {
  _FakeKumaMonitors(this._monitors);
  final List<KumaMonitor> _monitors;

  @override
  Stream<Result<List<KumaMonitor>>> build(String instanceId) async* {
    yield Ok(_monitors);
  }
}

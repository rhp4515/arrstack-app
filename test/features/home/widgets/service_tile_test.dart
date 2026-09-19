import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/home/widgets/service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the instance name and summary line when reachable', (
    tester,
  ) async {
    const summary = HomeServiceSummary(
      instanceId: 'radarr-1',
      instanceName: 'Home Radarr',
      serviceType: ServiceType.radarr,
      isReachable: true,
      summaryLine: '412 movies · 3 missing',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ServiceTile(summary: summary, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Home Radarr'), findsOneWidget);
    expect(find.text('412 movies · 3 missing'), findsOneWidget);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    const summary = HomeServiceSummary(
      instanceId: 'radarr-1',
      instanceName: 'Home Radarr',
      serviceType: ServiceType.radarr,
      isReachable: true,
      summaryLine: '412 movies · 3 missing',
    );
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ServiceTile(summary: summary, onTap: () => tapped = true),
        ),
      ),
    );
    await tester.tap(find.byType(ServiceTile));

    expect(tapped, isTrue);
  });

  testWidgets('shows Unreachable summary text when the service is down', (
    tester,
  ) async {
    const summary = HomeServiceSummary(
      instanceId: 'bazarr-1',
      instanceName: 'Bazarr',
      serviceType: ServiceType.bazarr,
      isReachable: false,
      summaryLine: 'Unreachable',
      statusLabel: 'Unreachable',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ServiceTile(summary: summary, onTap: () {}),
        ),
      ),
    );

    expect(find.text('Unreachable'), findsOneWidget);
  });
}

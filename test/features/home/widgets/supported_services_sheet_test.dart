import 'package:arrstack/features/home/widgets/supported_services_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lists all seven supported services', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SupportedServicesSheet())),
    );

    for (final service in [
      'Sonarr',
      'Radarr',
      'Prowlarr',
      'Bazarr',
      'qBittorrent',
      'Uptime Kuma',
      'Seerr',
    ]) {
      expect(find.text(service), findsOneWidget);
    }
  });
}

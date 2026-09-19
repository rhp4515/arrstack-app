import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/home/widgets/supported_services_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lists every ServiceType, including Einthusan Downloader', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SupportedServicesSheet())),
    );

    for (final type in ServiceType.values) {
      expect(find.text(type.displayName), findsOneWidget);
    }
  });
}

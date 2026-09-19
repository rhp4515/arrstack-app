import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/home/widgets/endpoint_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

void main() {
  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showEndpointSheet(context, 'instance-1'),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows a check on the Auto row when no override is set', (
    tester,
  ) async {
    await pumpSheet(tester);

    expect(find.text('Auto'), findsOneWidget);
    expect(find.text('Force Local'), findsOneWidget);
    expect(find.text('Force Remote'), findsOneWidget);
    expect(find.byIcon(PhosphorIconsRegular.check), findsOneWidget);
  });

  testWidgets('tapping Force Local updates the override and closes the sheet', (
    tester,
  ) async {
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return MaterialApp(
              home: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showEndpointSheet(context, 'instance-1'),
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Force Local'));
    await tester.pumpAndSettle();

    expect(
      container.read(endpointSessionOverrideProvider)['instance-1'],
      EndpointMode.forceLocal,
    );
    expect(find.byType(EndpointSheet), findsNothing);
  });
}

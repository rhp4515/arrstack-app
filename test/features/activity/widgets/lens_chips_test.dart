import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/lens_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows all three lens labels, Wanted with its count', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: LensChips(wantedCount: 4))),
      ),
    );

    expect(find.text('Transfers'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.textContaining('Wanted'), findsOneWidget);
    expect(find.textContaining('4'), findsOneWidget);
  });

  testWidgets('tapping a chip updates ActiveActivityLens', (tester) async {
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(home: Scaffold(body: LensChips()));
          },
        ),
      ),
    );

    await tester.tap(find.text('Calendar'));
    await tester.pump();

    expect(container.read(activeActivityLensProvider), ActivityLens.calendar);
  });
}

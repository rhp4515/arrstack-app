import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title and subtitle with the given switch value', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledToggleRow(
            title: 'Search immediately',
            subtitle: 'Otherwise it waits for the next RSS sweep',
            value: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Search immediately'), findsOneWidget);
    expect(
      find.text('Otherwise it waits for the next RSS sweep'),
      findsOneWidget,
    );
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('tapping the switch calls onChanged with the toggled value', (
    tester,
  ) async {
    bool? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledToggleRow(
            title: 'Search for it now',
            subtitle: 'Uses your 3 enabled indexers',
            value: true,
            onChanged: (v) => captured = v,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(captured, isFalse);
  });
}

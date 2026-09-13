import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a 1px-tall gradient container', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FadingRule())),
    );

    final size = tester.getSize(find.byType(FadingRule));
    expect(size.height, 1);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(FadingRule),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.gradient, isA<LinearGradient>());
  });
}

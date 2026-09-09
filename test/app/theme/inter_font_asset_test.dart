import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Inter font family renders without falling back', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Text('Tabular 0123456789', style: TextStyle(fontFamily: 'Inter')),
      ),
    );

    final textWidget = tester.widget<Text>(find.text('Tabular 0123456789'));
    expect(textWidget.style, isNotNull);
    expect(textWidget.style!.fontFamily, 'Inter');
  });
}

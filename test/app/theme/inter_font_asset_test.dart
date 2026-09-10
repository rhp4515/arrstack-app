import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Inter font family renders without falling back', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Text('Tabular 0123456789', style: TextStyle(fontFamily: 'Inter')),
      ),
    );

    final textWidget = tester.widget<Text>(find.text('Tabular 0123456789'));
    expect(textWidget.style, isNotNull);
    expect(textWidget.style!.fontFamily, 'Inter');
  });

  test('Inter font asset is bundled and loadable', () async {
    final data = await rootBundle.load('assets/fonts/Inter-Variable.ttf');
    expect(data.lengthInBytes, greaterThan(0));
  });
}

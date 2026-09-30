import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/lens_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {Brightness brightness = Brightness.dark}) =>
    MaterialApp(
      theme: ThemeData(
        colorScheme: brightness == Brightness.dark
            ? const ColorScheme.dark()
            : const ColorScheme.light(),
      ),
      home: Scaffold(body: child),
    );

TextStyle _style(WidgetTester tester, String label) =>
    tester.widget<Text>(find.text(label)).style!;

Border? _border(WidgetTester tester) {
  final box = tester.widget<Container>(
    find.descendant(
      of: find.byType(LensChip),
      matching: find.byType(Container),
    ),
  );
  return (box.decoration! as BoxDecoration).border as Border?;
}

void main() {
  testWidgets('primary tier is 11px, secondary tier 10.5px', (tester) async {
    await tester.pumpWidget(
      _host(
        Row(
          children: [
            LensChip(label: 'Primary', isActive: false, onTap: () {}),
            LensChip(
              label: 'Secondary',
              isActive: false,
              secondary: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    expect(_style(tester, 'Primary').fontSize, 11);
    expect(_style(tester, 'Secondary').fontSize, 10.5);
    expect(_style(tester, 'Primary').fontWeight, FontWeight.w500);
    expect(
      _style(tester, 'Primary').fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });

  testWidgets('active chip uses the dark accent text and a 1px ring', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(LensChip(label: 'On', isActive: true, onTap: () {})),
    );

    expect(_style(tester, 'On').color, AppColors.accent);
    final border = _border(tester)!;
    expect(border.top.color, AppColors.accent);
    expect(border.top.width, 1);
  });

  testWidgets('active chip uses the scheme primary in light mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        LensChip(label: 'On', isActive: true, onTap: () {}),
        brightness: Brightness.light,
      ),
    );

    expect(_style(tester, 'On').color, const ColorScheme.light().primary);
  });

  testWidgets('inactive chip is muted with no ring; tap fires onTap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(LensChip(label: 'Off', isActive: false, onTap: () => taps++)),
    );

    expect(_style(tester, 'Off').color, AppColors.n400);
    expect(_border(tester), isNull);

    await tester.tap(find.text('Off'));
    expect(taps, 1);
  });
}

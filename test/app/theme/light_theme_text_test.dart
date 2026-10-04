import 'package:arrstack/app/theme/app_theme.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The Nocturne text styles used to hardcode near-white, so titles and row
/// labels vanished on the light theme.
void main() {
  Future<Color> renderedColor(
    WidgetTester tester,
    ThemeData theme,
    TextStyle style,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: Text('Title', style: style)),
      ),
    );
    final rich = tester.widget<RichText>(
      find.descendant(
        of: find.byType(Scaffold),
        matching: find.byType(RichText),
      ),
    );
    return rich.text.style!.color!;
  }

  final styles = {
    'screenTitle': AppTypography.screenTitle,
    'sectionTitle': AppTypography.sectionTitle,
    'cardTitle': AppTypography.cardTitle,
    'body': AppTypography.body,
  };

  for (final entry in styles.entries) {
    testWidgets('${entry.key} is dark on the light theme', (tester) async {
      final color = await renderedColor(tester, AppTheme.light(), entry.value);
      expect(color.computeLuminance(), lessThan(0.2));
    });

    testWidgets('${entry.key} stays near-white on the dark theme', (
      tester,
    ) async {
      final color = await renderedColor(tester, AppTheme.dark(), entry.value);
      expect(color, AppColors.text);
    });
  }
}

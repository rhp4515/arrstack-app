import 'package:arrstack/app/theme/app_theme.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme.dark()', () {
    final theme = AppTheme.dark();

    test('scaffold and surfaces use Nocturne bg/surface', () {
      expect(theme.scaffoldBackgroundColor, AppColors.bg);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.colorScheme.onSurface, AppColors.text);
    });

    test('primary is the single Nocturne accent', () {
      expect(theme.colorScheme.primary, AppColors.accent);
    });

    test('error color is the Nocturne down/error red', () {
      expect(theme.colorScheme.error, AppColors.down);
    });

    test('outline is the hairline divider', () {
      expect(theme.colorScheme.outline, AppColors.divider);
    });

    test('cards use radius-md and no fill elevation shadow by default', () {
      final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;
      expect((cardShape.borderRadius as BorderRadius).topLeft.x, AppRadius.md);
    });

    test('text theme defaults to Inter', () {
      expect(theme.textTheme.bodyMedium?.fontFamily, AppTypography.fontFamily);
    });
  });
}

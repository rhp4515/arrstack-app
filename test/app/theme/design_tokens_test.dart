import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors — core roles', () {
    test('matches the Nocturne spec hex values', () {
      expect(AppColors.bg.toARGB32(), 0xFF161826);
      expect(AppColors.surface.toARGB32(), 0xFF1C1E2E);
      expect(AppColors.text.toARGB32(), 0xFFE9E9ED);
      expect(AppColors.accent.toARGB32(), 0xFF9184D9);
      expect(AppColors.divider.toARGB32(), 0xFF2A2C3E);
      expect(AppColors.section.toARGB32(), 0xFF221E4A);
      expect(AppColors.sectionGlow.toARGB32(), 0xFF353B80);
      expect(AppColors.sectionGhost.toARGB32(), 0xFF4C5397);
    });

    test('status colors match up/down/warning', () {
      expect(AppColors.up.toARGB32(), 0xFF5CDD8B);
      expect(AppColors.down.toARGB32(), 0xFFF44336);
      expect(AppColors.warning.toARGB32(), 0xFFFFC230);
    });

    test('neutral ramp is 9 perceptually-spaced steps', () {
      expect(AppColors.n100.toARGB32(), 0xFFF3F5FE);
      expect(AppColors.n500.toARGB32(), 0xFF9397AB);
      expect(AppColors.n900.toARGB32(), 0xFF292B31);
    });

    test('accent ramp is 9 steps', () {
      expect(AppColors.a100.toARGB32(), 0xFFF5F4FF);
      expect(AppColors.a300.toARGB32(), 0xFFD2CEFD);
      expect(AppColors.a900.toARGB32(), 0xFF2B2741);
    });
  });

  group('AppSpacing', () {
    test('density-0.70 scale', () {
      expect(AppSpacing.space2, closeTo(5.6, 0.01));
      expect(AppSpacing.space3, closeTo(8.4, 0.01));
      expect(AppSpacing.space4, closeTo(11.2, 0.01));
      expect(AppSpacing.space6, closeTo(16.8, 0.01));
      expect(AppSpacing.space8, closeTo(22.4, 0.01));
    });
  });

  group('AppRadius', () {
    test('sm/md/lg/pill', () {
      expect(AppRadius.sm, 4);
      expect(AppRadius.md, 8);
      expect(AppRadius.lg, 12);
      expect(AppRadius.pill, 999);
    });
  });

  group('AppTypography', () {
    test('screen title is 26/1.15/500', () {
      expect(AppTypography.screenTitle.fontSize, 26);
      expect(AppTypography.screenTitle.height, closeTo(1.15, 0.001));
      expect(AppTypography.screenTitle.fontWeight, FontWeight.w500);
      expect(AppTypography.screenTitle.fontFamily, 'Inter');
    });

    test('kicker is the only 600-weight style', () {
      expect(AppTypography.kicker.fontWeight, FontWeight.w600);
      expect(AppTypography.kicker.fontSize, 10);
      expect(AppTypography.screenTitle.fontWeight, isNot(FontWeight.w600));
      expect(AppTypography.sectionTitle.fontWeight, isNot(FontWeight.w600));
    });

    test('numeral styles carry tabular figures', () {
      expect(
        AppTypography.heroNumeral.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
      expect(
        AppTypography.statNumeral.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });
  });
}

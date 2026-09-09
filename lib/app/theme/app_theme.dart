/// [ThemeData] built from the Nocturne design tokens.
///
/// Nocturne is a dark-first design (see design_handoff_arrstack_hub/README.md);
/// the spec gives no light palette, so [light] derives from the same accent
/// seed via Material 3's tonal algorithm as a functional fallback for users
/// who pick Light in Settings.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData light() => _buildTheme(Brightness.light);

  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = brightness == Brightness.dark
        ? const ColorScheme.dark(
            primary: AppColors.accent,
            onPrimary: AppColors.bg,
            secondary: AppColors.a300,
            onSecondary: AppColors.bg,
            surface: AppColors.surface,
            onSurface: AppColors.text,
            error: AppColors.down,
            onError: AppColors.text,
            outline: AppColors.divider,
            outlineVariant: AppColors.divider,
          )
        : ColorScheme.fromSeed(
            seedColor: AppColors.accent,
            brightness: Brightness.light,
          );

    final textTheme = _buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: brightness == Brightness.dark
          ? AppColors.bg
          : colorScheme.surface,
      textTheme: textTheme,
      fontFamily: AppTypography.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.dark
            ? AppColors.bg
            : colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.screenTitle.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: brightness == Brightness.dark
            ? AppColors.surface
            : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: brightness == Brightness.dark
              ? const BorderSide(color: AppColors.divider)
              : BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      // Primary buttons are an accent outline on transparent, never a
      // fill — Nocturne has no filled-button surface.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.cardTitle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: AppTypography.cardTitle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: AppTypography.cardTitle,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark
            ? AppColors.n900
            : colorScheme.surfaceContainerHighest,
        labelStyle: AppTypography.meta.copyWith(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme scheme) {
    return TextTheme(
      headlineMedium: AppTypography.screenTitle.copyWith(
        color: scheme.onSurface,
      ),
      titleLarge: AppTypography.sectionTitle.copyWith(color: scheme.onSurface),
      titleMedium: AppTypography.cardTitle.copyWith(color: scheme.onSurface),
      bodyMedium: AppTypography.body.copyWith(color: scheme.onSurface),
      bodySmall: AppTypography.meta,
      labelSmall: AppTypography.tabLabel.copyWith(color: scheme.onSurface),
    );
  }
}

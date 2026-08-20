/// Centralized design tokens for spacing, radius, motion, and elevation.
///
/// Never hardcode these values inline in widgets — reference the constants
/// here so the design system stays consistent and easy to retune.
library;

import 'package:flutter/widgets.dart';

/// Spacing scale, in logical pixels, used for padding/margin/gap values.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Corner radius scale used across cards, chips, buttons, and sheets.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;
}

/// Motion durations for compositor-friendly transitions.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 450);
}

/// Elevation levels for surfaces (Material 3 tonal elevation scale).
abstract final class AppElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 3;
  static const double high = 6;
}

/// Fixed component sizes (logical pixels) that don't belong to the spacing or
/// radius scales — e.g. bespoke widget heights and icon sizes.
abstract final class AppSizes {
  /// Height of the bottom [NavigationBar] shell.
  /// Standard Material 3 height is 80.
  static const double navBarHeight = 80;

  /// Icon size used by the shared [EmptyState] illustration.
  static const double emptyStateIcon = 56;
}

/// Common `EdgeInsets` built from [AppSpacing], to avoid repeating literals.
abstract final class AppInsets {
  static const EdgeInsets pageMd = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets pageLg = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
  );
}

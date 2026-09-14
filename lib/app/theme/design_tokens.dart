/// Centralized design tokens for the Nocturne design system: colors,
/// spacing, radius, typography, and shadows.
///
/// Never hardcode these values inline in widgets — reference the constants
/// here so the design system stays consistent and easy to retune.
///
/// Source: design_handoff_arrstack_hub/README.md ("Design tokens") for core
/// roles, status colors, spacing, and radius (marked final in the spec);
/// design_handoff_arrstack_hub/_ds/nocturne-*/styles.css for the numbered
/// neutral/accent ramps and shadow recipes, which the README describes only
/// qualitatively.
library;

import 'package:flutter/painting.dart';

/// Nocturne color roles: core surfaces, the neutral and accent ramps, and
/// the three semantic status colors. These are the only colors outside the
/// Nocturne ramps that carry meaning the mono accent can't.
abstract final class AppColors {
  // Core roles
  static const Color bg = Color(0xFF161826);
  static const Color surface = Color(0xFF1C1E2E);
  static const Color text = Color(0xFFE9E9ED);
  static const Color accent = Color(0xFF9184D9);
  static const Color divider = Color(0xFF2A2C3E);

  /// Saturated deep-indigo band. Used exactly twice in the full redesign:
  /// the Home summary band and the first-run hero.
  static const Color section = Color(0xFF221E4A);

  /// Blurred glow inside `section` bands only.
  static const Color sectionGlow = Color(0xFF353B80);

  /// Outlines and skeletons *inside* a `section` band.
  static const Color sectionGhost = Color(0xFF4C5397);

  // Status
  static const Color up = Color(0xFF5CDD8B);
  static const Color down = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC230);

  // Neutral ramp — text on tinted fills through tab-bar/chip fills.
  static const Color n100 = Color(0xFFF3F5FE);
  static const Color n200 = Color(0xFFE4E7F5);
  static const Color n300 = Color(0xFFCFD3E5);
  static const Color n400 = Color(0xFFB2B6CA);
  static const Color n500 = Color(0xFF9397AB);
  static const Color n600 = Color(0xFF75798C);
  static const Color n700 = Color(0xFF595D6C);
  static const Color n800 = Color(0xFF3F424D);
  static const Color n900 = Color(0xFF292B31);

  // Accent ramp — text on the `section` band, body-size accent text
  // (a300 — the base accent is only 3:1 on this ground, fine for icons and
  // large text but not paragraph copy), and the throughput sparkline.
  static const Color a100 = Color(0xFFF5F4FF);
  static const Color a200 = Color(0xFFE7E5FE);
  static const Color a300 = Color(0xFFD2CEFD);
  static const Color a400 = Color(0xFFB5ABFC);
  static const Color a500 = Color(0xFF968AE0);
  static const Color a600 = Color(0xFF796CBF);
  static const Color a700 = Color(0xFF5D5294);
  static const Color a800 = Color(0xFF423A6A);
  static const Color a900 = Color(0xFF2B2741);
}

/// Spacing scale, in logical pixels. Nocturne is dense on purpose —
/// density 0.70x. Use the scale, never raw numbers. Screen horizontal
/// padding is `space6` throughout; vertical rhythm between sections is
/// `space6`; between a section header and its first row, `space4`.
abstract final class AppSpacing {
  static const double space2 = 5.6;
  static const double space3 = 8.4;
  static const double space4 = 11.2;
  static const double space6 = 16.8;
  static const double space8 = 22.4;
}

/// Corner radius scale used across cards, chips, buttons, and sheets.
abstract final class AppRadius {
  static const double sm = 4; // tags, small marks
  static const double md = 8; // buttons, inputs, cards, tiles
  static const double lg = 12; // bottom sheets, dialogs
  static const double pill = 999; // toggles, status dots, progress bars
}

/// Motion durations for compositor-friendly transitions. Nothing in this
/// design bounces — near-linear easing, no bounce curves.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 450);
}

/// Elevation as Nocturne renders it on a dark ground: a 1px edge ring plus
/// ambient darkness, never stacked. `ringSm/Md/Lg` are borders; `blurMd/Lg`
/// are the accompanying ambient-shadow lists (shadow-sm has no blur term).
abstract final class AppShadows {
  static const Color _ringSmColor = AppColors.n800;
  static const Color _ringMdColor = AppColors.n700;
  static const Color _ringLgColor = AppColors.n500;

  static const Border ringSm = Border.fromBorderSide(
    BorderSide(color: _ringSmColor),
  );
  static const Border ringMd = Border.fromBorderSide(
    BorderSide(color: _ringMdColor),
  );
  static const Border ringLg = Border.fromBorderSide(
    BorderSide(color: _ringLgColor),
  );

  static const List<BoxShadow> blurMd = [
    BoxShadow(
      color: Color(0x8C000000), // rgba(0,0,0,0.55)
      offset: Offset(0, 6),
      blurRadius: 18,
    ),
  ];

  static const List<BoxShadow> blurLg = [
    BoxShadow(
      color: Color(0xA6000000), // rgba(0,0,0,0.65)
      offset: Offset(0, 16),
      blurRadius: 40,
    ),
  ];
}

/// Inter throughout, headings and body. Never bolder than 500 — hierarchy
/// is size and space — except the 600-weight kicker.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  /// "Library", "Activity" screen titles.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    height: 1.15,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: -0.52, // -0.02em @ 26px
    color: AppColors.text,
  );

  /// Detail-screen titles, sub-page titles.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 21,
    height: 1.15,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: -0.42, // -0.02em @ 21px
    color: AppColors.text,
  );

  /// Home's "10" — tabular, e.g. hero counts.
  static const TextStyle heroNumeral = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    height: 1.0,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    letterSpacing: -1.2, // -0.03em @ 40px
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.text,
  );

  /// Uptime and Indexers header stats.
  static const TextStyle statNumeral = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 1.0,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.text,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13.5,
    height: 1.3,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
    color: AppColors.text,
  );

  /// Overviews, descriptions.
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
    height: 1.6,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    color: AppColors.text,
  );

  /// Under row titles.
  static const TextStyle meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 1.45,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    color: AppColors.n500,
  );

  /// Section labels — the one 600-weight style, always uppercase accent.
  static const TextStyle kicker = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 1.0,
    fontWeight: FontWeight.w600,
    fontVariations: [FontVariation('wght', 600)],
    letterSpacing: 1.0, // 0.1em @ 10px
    color: AppColors.accent,
  );

  /// "UP", "DOWN", "ON DISK".
  static const TextStyle statCaption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 1.0,
    fontWeight: FontWeight.w400,
    fontVariations: [FontVariation('wght', 400)],
    color: AppColors.n500,
  );

  static const TextStyle tabLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 1.0,
    fontWeight: FontWeight.w500,
    fontVariations: [FontVariation('wght', 500)],
  );
}

/// Fixed component sizes (logical pixels) that don't belong to the spacing
/// or radius scales.
abstract final class AppSizes {
  /// Height of the Nocturne bottom tab bar.
  static const double navBarHeight = 62;

  /// Icon size used by the shared [EmptyState] illustration.
  static const double emptyStateIcon = 56;
}

/// Common `EdgeInsets` built from [AppSpacing], to avoid repeating
/// literals. Screen horizontal padding is `space6` throughout.
abstract final class AppInsets {
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: AppSpacing.space6,
  );
  static const EdgeInsets pageMd = EdgeInsets.all(AppSpacing.space4);
  static const EdgeInsets pageLg = EdgeInsets.all(AppSpacing.space6);
}

/// Deprecated aliases kept only until each old-shell widget is restyled in
/// a later redesign phase. New code must use [AppSpacing.space2] etc.
@Deprecated('Use the Nocturne AppSpacing.spaceN scale')
abstract final class LegacySpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

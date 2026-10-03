/// The app's one "lens chip" (README "Shared shell" -> "Lens chips"): 5px /
/// 10px padding, radius-sm, w500 text with tabular figures. Inactive is
/// muted; active is accent text plus a 1px accent ring — no fill.
///
/// Two tiers share it: the primary tier (11px) switches the top-level lens,
/// the [secondary] tier (10.5px) filters within it. Used by Activity's lens
/// rows and Library's collection / section rows.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class LensChip extends StatelessWidget {
  const LensChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.secondary = false,
    super.key,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  /// The smaller (10.5px) sub-lens tier instead of the 11px primary tier.
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final color = isActive
        ? (isDark ? AppColors.accent : colorScheme.primary)
        : (isDark ? AppColors.n400 : colorScheme.onSurfaceVariant);

    return Semantics(
      button: true,
      selected: isActive,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: isActive ? Border.all(color: color) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: secondary ? 10.5 : 11,
              fontWeight: FontWeight.w500,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}

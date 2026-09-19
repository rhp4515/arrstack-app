/// A tinted, optionally-tappable pill used on media detail pages for ratings,
/// monitored state, and external links (IMDb, TMDB, TVDB).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class DetailChip extends StatelessWidget {
  const DetailChip({
    required this.label,
    required this.color,
    this.onTap,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        side: BorderSide(color: color.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: LegacySpacing.md,
            vertical: LegacySpacing.sm,
          ),
          child: Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

/// A label/value spec block (README screens 2f/2g "FILE"/"SUBTITLES"):
/// an uppercase kicker, then rows of a muted label left and a tabular
/// value right that wraps and right-aligns.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class SpecBlock extends StatelessWidget {
  const SpecBlock({required this.kicker, required this.rows, super.key});

  final String kicker;
  final List<(String label, String value)> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kicker, style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space4),
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.space2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.meta.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.space6),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: AppTypography.meta.copyWith(
                      color: colorScheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

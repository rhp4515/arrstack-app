/// A single read-only "last known" row on Home's offline layout (README
/// §3f): grey status dot, name, cached summary line, trailing clock icon.
/// Deliberately has no tap handler — cached data being non-interactive is
/// a structural fact, not a convention that could drift.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class CachedSummaryRow extends StatelessWidget {
  const CachedSummaryRow({required this.summary, super.key});

  final CachedServiceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.n600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.instanceName, style: AppTypography.cardTitle),
                Text(
                  summary.summaryLine,
                  style: AppTypography.meta.copyWith(color: AppColors.n500),
                ),
              ],
            ),
          ),
          const Icon(
            PhosphorIconsRegular.clockCounterClockwise,
            size: 13,
            color: AppColors.n600,
          ),
        ],
      ),
    );
  }
}

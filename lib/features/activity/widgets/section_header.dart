/// The accent-kicker section header shared by Activity's lenses and the
/// Library sub-tabs: an accent kicker on the left, muted meta (or a trailing
/// action) on the right.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.kicker,
    this.trailing,
    this.trailingColor,
    this.trailingWidget,
    super.key,
  });

  final String kicker;

  /// Right-aligned meta text; ignored when [trailingWidget] is given.
  final String? trailing;
  final Color? trailingColor;

  /// A right-aligned action (e.g. a "Search all" button) replacing [trailing].
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final meta = trailing;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          kicker,
          style: AppTypography.kicker.copyWith(
            color: isDark ? AppColors.accent : colorScheme.primary,
          ),
        ),
        if (trailingWidget != null)
          trailingWidget!
        else if (meta != null)
          Text(
            meta,
            style: AppTypography.meta.copyWith(
              color:
                  trailingColor ??
                  (isDark ? AppColors.n400 : colorScheme.onSurfaceVariant),
            ),
          ),
      ],
    );
  }
}

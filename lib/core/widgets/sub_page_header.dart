/// Shared "back + kicker/title" header for sub-pages reached from Home
/// (Uptime, Indexers, Settings, Edit instance) — README "Shared shell" →
/// Header → Sub-pages. The back chevron comes from `AppBar`'s default
/// leading-back behavior; GoRouter supplies it automatically when there's a
/// route to pop.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class SubPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const SubPageHeader({
    required this.title,
    this.kicker,
    this.actions,
    super.key,
  });

  final String? kicker;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final kickerText = kicker;
    return AppBar(
      actions: actions,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kickerText != null) Text(kickerText, style: AppTypography.kicker),
          Text(title, style: AppTypography.sectionTitle),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

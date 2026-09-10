/// Bottom-navigation scaffold hosting the app's three Nocturne tabs.
///
/// Anatomy per design_handoff_arrstack_hub/README.md ("Shared shell" →
/// "Bottom tab bar"): 62px tall, neutral-900 fill, 1px divider top border.
/// Inactive icons/labels are neutral-500; the active tab is accent with a
/// fill-weight icon and an 18x2px accent bar flush to the top edge.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Home',
      regular: PhosphorIconsRegular.house,
      filled: PhosphorIconsFill.house,
    ),
    _TabSpec(
      label: 'Library',
      regular: PhosphorIconsRegular.filmSlate,
      filled: PhosphorIconsFill.filmSlate,
    ),
    _TabSpec(
      label: 'Activity',
      regular: PhosphorIconsRegular.downloadSimple,
      filled: PhosphorIconsFill.downloadSimple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.n900,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppSizes.navBarHeight,
            child: Row(
              children: [
                for (var i = 0; i < _tabs.length; i++)
                  Expanded(
                    child: _TabButton(
                      spec: _tabs[i],
                      selected: i == navigationShell.currentIndex,
                      onTap: () => _onDestinationSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      // Returning to the current tab pops it back to its root route.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _TabSpec {
  const _TabSpec({
    required this.label,
    required this.regular,
    required this.filled,
  });

  final String label;
  final IconData regular;
  final IconData filled;
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.n500;

    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (selected)
            Container(width: 18, height: 2, color: AppColors.accent),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? spec.filled : spec.regular,
                  size: 21,
                  color: color,
                ),
                const SizedBox(height: 5),
                Text(
                  spec.label,
                  style: AppTypography.tabLabel.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

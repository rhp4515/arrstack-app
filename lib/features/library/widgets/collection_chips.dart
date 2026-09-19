/// The Shows/Movies switch (README "Shared shell" -> "Lens chips", spec
/// 2d): built to the same visual spec as Activity's LensChips but kept
/// Library-local since LensChips is hardwired to Activity's own provider.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionChips extends ConsumerWidget {
  const CollectionChips({
    required this.showsCount,
    required this.moviesCount,
    super.key,
  });

  final int showsCount;
  final int moviesCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeLibraryTabProvider);

    return Row(
      children: [
        _Chip(
          label: 'Shows $showsCount',
          isActive: active == LibraryTab.tvShows,
          onTap: () => ref
              .read(activeLibraryTabProvider.notifier)
              .select(LibraryTab.tvShows),
        ),
        const SizedBox(width: AppSpacing.space2),
        _Chip(
          label: 'Movies $moviesCount',
          isActive: active == LibraryTab.movies,
          onTap: () => ref
              .read(activeLibraryTabProvider.notifier)
              .select(LibraryTab.movies),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
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
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

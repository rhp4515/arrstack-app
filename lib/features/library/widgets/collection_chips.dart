/// The Shows/Movies switch (README "Shared shell" -> "Lens chips", spec
/// 2d): the shared [LensChip] wired to the Library's own tab provider.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/lens_chip.dart';
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
        LensChip(
          label: 'Shows $showsCount',
          isActive: active == LibraryTab.tvShows,
          onTap: () => ref
              .read(activeLibraryTabProvider.notifier)
              .select(LibraryTab.tvShows),
        ),
        const SizedBox(width: AppSpacing.space2),
        LensChip(
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

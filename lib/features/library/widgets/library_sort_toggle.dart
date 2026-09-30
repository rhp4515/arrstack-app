/// The "Recently added ⌄" cycling sort toggle beside a list's kicker, shared
/// by the Shows and Movies "All" lists.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A kicker ([label]) on the left and the sort toggle on the right.
class LibraryListHeader extends StatelessWidget {
  const LibraryListHeader({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTypography.kicker)),
        const LibrarySortToggle(),
      ],
    );
  }
}

class LibrarySortToggle extends ConsumerWidget {
  const LibrarySortToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(activeLibrarySortProvider);
    return InkWell(
      onTap: () =>
          ref.read(activeLibrarySortProvider.notifier).select(switch (sort) {
            LibrarySort.recentlyAdded => LibrarySort.title,
            LibrarySort.title => LibrarySort.year,
            LibrarySort.year => LibrarySort.recentlyAdded,
          }),
      child: Text(switch (sort) {
        LibrarySort.recentlyAdded => 'Recently added ⌄',
        LibrarySort.title => 'Title ⌄',
        LibrarySort.year => 'Year ⌄',
      }, style: AppTypography.meta.copyWith(fontWeight: FontWeight.w500)),
    );
  }
}

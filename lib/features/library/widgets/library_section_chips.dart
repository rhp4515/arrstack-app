/// The All · Upcoming · Missing · Queue · History switch under the Library
/// header. The shared secondary-tier [LensChip] (10.5px), like Activity's
/// sub-lens row; scrolls horizontally when a narrow phone can't fit all five.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/lens_chip.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String librarySectionLabel(LibrarySection section) => switch (section) {
  LibrarySection.all => 'All',
  LibrarySection.upcoming => 'Upcoming',
  LibrarySection.missing => 'Missing',
  LibrarySection.queue => 'Queue',
  LibrarySection.history => 'History',
};

class LibrarySectionChips extends ConsumerWidget {
  const LibrarySectionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeLibrarySectionProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final section in LibrarySection.values) ...[
            if (section != LibrarySection.values.first)
              const SizedBox(width: AppSpacing.space2),
            LensChip(
              label: librarySectionLabel(section),
              isActive: section == active,
              secondary: true,
              onTap: () => ref
                  .read(activeLibrarySectionProvider.notifier)
                  .select(section),
            ),
          ],
        ],
      ),
    );
  }
}

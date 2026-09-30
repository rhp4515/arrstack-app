/// The All · Upcoming · Missing · Queue · History switch under the Library
/// header. Same visual spec as Activity's LensChips (5px/10px padding,
/// radius-sm, 11px/500, accent ring when active, no fill); scrolls
/// horizontally when a narrow phone can't fit all five.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
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
            _SectionChip(section: section, isActive: section == active),
          ],
        ],
      ),
    );
  }
}

class _SectionChip extends ConsumerWidget {
  const _SectionChip({required this.section, required this.isActive});

  final LibrarySection section;
  final bool isActive;

  static const TextStyle _chipText = TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final color = isActive
        ? isDark
              ? AppColors.accent
              : colorScheme.primary
        : isDark
        ? AppColors.n400
        : colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isActive,
      child: InkWell(
        onTap: () =>
            ref.read(activeLibrarySectionProvider.notifier).select(section),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: isActive ? Border.all(color: color) : null,
          ),
          child: Text(
            librarySectionLabel(section),
            style: _chipText.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

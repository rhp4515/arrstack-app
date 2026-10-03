/// The Library header's instance name ("Home Radarr ⌄"). A dropdown when
/// more than one instance of the collection's service exists, a plain label
/// when there's just one, and nothing when there are none.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LibraryInstanceSwitcher extends ConsumerWidget {
  const LibraryInstanceSwitcher({required this.type, super.key});

  final ServiceType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instances =
        ref.watch(libraryInstancesProvider(type)).value ?? const [];
    if (instances.isEmpty) return const SizedBox.shrink();
    final selectedId = ref.watch(selectedLibraryInstanceIdProvider(type)).value;
    final selected = instances.firstWhere(
      (i) => i.id == selectedId,
      orElse: () => instances.first,
    );

    final label = Text(
      selected.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.meta.copyWith(fontWeight: FontWeight.w500),
    );

    if (instances.length == 1) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160),
        child: label,
      );
    }

    return PopupMenuButton<String>(
      tooltip: 'Switch ${type.displayName} instance',
      initialValue: selected.id,
      onSelected: (id) => ref
          .read(selectedLibraryInstanceIdProvider(type).notifier)
          .selectInstance(id),
      itemBuilder: (context) => [
        for (final ServiceInstance instance in instances)
          CheckedPopupMenuItem<String>(
            value: instance.id,
            checked: instance.id == selected.id,
            child: Text(instance.name),
          ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180, minHeight: 32),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: label),
            const SizedBox(width: 4),
            const Icon(PhosphorIconsRegular.caretDown, size: 12),
          ],
        ),
      ),
    );
  }
}

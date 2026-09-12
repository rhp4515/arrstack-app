/// Bottom sheet for overriding an instance's resolved endpoint for the
/// current session only (Phase 3 design §Widget plan). Replaces the inline
/// `showModalBottomSheet` builder from the deleted `endpoint_indicator.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/endpoint_mode.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

Future<void> showEndpointSheet(BuildContext context, String instanceId) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => EndpointSheet(instanceId: instanceId),
  );
}

class EndpointSheet extends ConsumerWidget {
  const EndpointSheet({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overrides = ref.watch(endpointSessionOverrideProvider);
    final activeMode = overrides[instanceId];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Endpoint mode', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Override for this session only.',
              style: AppTypography.body.copyWith(color: AppColors.n500),
            ),
            const SizedBox(height: AppSpacing.space4),
            _EndpointOption(
              icon: PhosphorIconsRegular.magicWand,
              label: 'Auto',
              isActive: activeMode == null,
              onTap: () {
                ref
                    .read(endpointSessionOverrideProvider.notifier)
                    .update(instanceId, null);
                Navigator.pop(context);
              },
            ),
            _EndpointOption(
              icon: PhosphorIconsRegular.hardDrives,
              label: 'Force Local',
              isActive: activeMode == EndpointMode.forceLocal,
              onTap: () {
                ref
                    .read(endpointSessionOverrideProvider.notifier)
                    .update(instanceId, EndpointMode.forceLocal);
                Navigator.pop(context);
              },
            ),
            _EndpointOption(
              icon: PhosphorIconsRegular.cloud,
              label: 'Force Remote',
              isActive: activeMode == EndpointMode.forceRemote,
              onTap: () {
                ref
                    .read(endpointSessionOverrideProvider.notifier)
                    .update(instanceId, EndpointMode.forceRemote);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppSpacing.space2),
          ],
        ),
      ),
    );
  }
}

class _EndpointOption extends StatelessWidget {
  const _EndpointOption({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.accent),
            const SizedBox(width: AppSpacing.space3),
            Expanded(child: Text(label, style: AppTypography.cardTitle)),
            if (isActive)
              const Icon(
                PhosphorIconsRegular.check,
                size: 18,
                color: AppColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}

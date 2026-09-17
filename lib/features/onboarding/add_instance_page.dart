/// The page to add a new service instance, or edit an existing one — README
/// §2b (add) and §2n (edit, error-first when the local URL is unreachable).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:arrstack/features/onboarding/widgets/instance_form.dart'
    as widgets;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AddInstancePage extends ConsumerStatefulWidget {
  const AddInstancePage({super.key, this.instanceId});

  final String? instanceId;

  @override
  ConsumerState<AddInstancePage> createState() => _AddInstancePageState();
}

class _AddInstancePageState extends ConsumerState<AddInstancePage> {
  @override
  void initState() {
    super.initState();
    if (widget.instanceId != null) {
      Future.microtask(() {
        ref.read(instanceFormProvider.notifier).load(widget.instanceId!);
      });
    } else {
      Future.microtask(() {
        ref.read(instanceFormProvider.notifier).reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(instanceFormProvider);
    final notifier = ref.read(instanceFormProvider.notifier);
    final isEditing = state.isEditing;
    final localError = state.localTestResult;
    final showErrorFirst = isEditing && localError is Err<ServiceIdentity>;

    return Scaffold(
      appBar: SubPageHeader(
        kicker: isEditing ? state.type.displayName.toUpperCase() : null,
        title: isEditing ? 'Edit instance' : 'Add service',
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.trash, size: 17),
                  onPressed: () =>
                      _confirmDelete(context, state.id!, state.name),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: AppInsets.pageMd,
        child: Column(
          children: [
            if (showErrorFirst) ...[
              ErrorCard(
                title: errorCardTitle(localError.error),
                message:
                    (localError.error.cause ?? localError.error.userMessage)
                        .toString(),
                primaryActionLabel: 'Test again',
                onPrimaryAction: notifier.testLocal,
                secondaryActionLabel: 'Use Remote for now',
                onSecondaryAction: () {
                  notifier.useRemoteForNow();
                  context.pop();
                },
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
            const widgets.InstanceForm(),
            const SizedBox(height: AppSpacing.space8),
            if (state.saveError != null) ...[
              Text(
                state.saveError!.userMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: AppSpacing.space4),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: state.isValid && !state.isSaving
                    ? () async {
                        final success = await notifier.save();
                        if (success && context.mounted) {
                          context.pop();
                        }
                      }
                    : null,
                icon: state.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(isEditing ? Icons.save_outlined : Icons.add),
                label: Text(isEditing ? 'Save changes' : 'Add Instance'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    String instanceId,
    String instanceName,
  ) async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Remove $instanceName?',
      message:
          'This removes $instanceName and its stored credentials from '
          'this device. The service itself keeps running elsewhere.',
    );
    if (result == null || !context.mounted) return;
    await ref.read(instanceRepositoryProvider).delete(instanceId);
    ref.invalidate(instancesProvider);
    if (context.mounted) context.pop();
  }
}

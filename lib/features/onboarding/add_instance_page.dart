/// The page to add a new service instance (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:arrstack/features/onboarding/widgets/instance_form.dart' as widgets;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddInstancePage extends ConsumerWidget {
  const AddInstancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(instanceFormProvider);
    final notifier = ref.read(instanceFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: SingleChildScrollView(
        padding: AppInsets.pageMd,
        child: Column(
          children: [
            const widgets.InstanceForm(),
            const SizedBox(height: AppSpacing.xxl),
            if (state.saveError != null) ...[
              Text(
                state.saveError!.userMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: AppSpacing.md),
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
                    : const Icon(Icons.add),
                label: const Text('Add Instance'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

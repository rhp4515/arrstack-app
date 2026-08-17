/// Reusable form for adding or editing a [ServiceInstance].
/// Handles URL validation, credential fields, and connection testing (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InstanceForm extends ConsumerStatefulWidget {
  const InstanceForm({super.key});

  @override
  ConsumerState<InstanceForm> createState() => _InstanceFormState();
}

class _InstanceFormState extends ConsumerState<InstanceForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _localUrlController;
  late final TextEditingController _remoteUrlController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(instanceFormProvider);
    _nameController = TextEditingController(text: state.name);
    _localUrlController = TextEditingController(text: state.localUrl);
    _remoteUrlController = TextEditingController(text: state.remoteUrl);
    _apiKeyController = TextEditingController(text: state.apiKey);
    _usernameController = TextEditingController(text: state.username);
    _passwordController = TextEditingController(text: state.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _localUrlController.dispose();
    _remoteUrlController.dispose();
    _apiKeyController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(instanceFormProvider);
    final notifier = ref.read(instanceFormProvider.notifier);

    // Update controllers if state changes from outside (e.g. load)
    _syncController(_nameController, state.name);
    _syncController(_localUrlController, state.localUrl);
    _syncController(_remoteUrlController, state.remoteUrl);
    _syncController(_apiKeyController, state.apiKey);
    _syncController(_usernameController, state.username);
    _syncController(_passwordController, state.password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Instance Name',
            hintText: 'e.g. My Radarr',
            prefixIcon: Icon(Icons.label_outline),
          ),
          onChanged: notifier.updateName,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<ServiceType>(
          value: state.type,
          decoration: const InputDecoration(
            labelText: 'Service Type',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: ServiceType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.displayName),
            );
          }).toList(),
          onChanged: (type) => type != null ? notifier.updateType(type) : null,
        ),
        const SizedBox(height: AppSpacing.lg),
        _UrlField(
          controller: _localUrlController,
          label: 'Local URL (LAN)',
          hint: 'http://192.168.1.10:7878',
          onChanged: notifier.updateLocalUrl,
          isTesting: state.isTestingLocal,
          testResult: state.localTestResult,
          onTest: notifier.testLocal,
        ),
        const SizedBox(height: AppSpacing.md),
        _UrlField(
          controller: _remoteUrlController,
          label: 'Remote URL (Tailscale)',
          hint: 'http://nas.tailnet-xxxx.ts.net:7878',
          onChanged: notifier.updateRemoteUrl,
          isTesting: state.isTestingRemote,
          testResult: state.remoteTestResult,
          onTest: notifier.testRemote,
        ),
        const SizedBox(height: AppSpacing.lg),
        if (state.type.defaultAuthType == AuthType.apiKey)
          TextFormField(
            controller: _apiKeyController,
            decoration: const InputDecoration(
              labelText: 'API Key',
              prefixIcon: Icon(Icons.key_outlined),
            ),
            obscureText: true,
            onChanged: notifier.updateApiKey,
          )
        else ...[
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: notifier.updateUsername,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            onChanged: notifier.updatePassword,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          title: const Text('Default Instance'),
          subtitle: const Text('Use this as the primary instance for this service.'),
          value: state.isDefault,
          onChanged: notifier.updateIsDefault,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text != value) {
      controller.text = value;
    }
  }
}

class _UrlField extends StatelessWidget {
  const _UrlField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    required this.isTesting,
    required this.testResult,
    required this.onTest,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool isTesting;
  final Result<ServiceIdentity>? testResult;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  prefixIcon: const Icon(Icons.link),
                ),
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height: 48,
                child: isTesting
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: onTest,
                        child: const Text('Test'),
                      ),
              ),
            ),
          ],
        ),
        if (testResult != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _TestResultIndicator(result: testResult!),
        ],
      ],
    );
  }
}

class _TestResultIndicator extends StatelessWidget {
  const _TestResultIndicator({required this.result});
  final Result<ServiceIdentity> result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return switch (result) {
      Ok(:final value) => Row(
          children: [
            Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Success: v${value.version}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
      Err(:final error) => Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 16),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                error.userMessage,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
    };
  }
}

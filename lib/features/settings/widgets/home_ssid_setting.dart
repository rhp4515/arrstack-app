/// UI for managing "Home" WiFi SSIDs. Includes auto-detection via the
/// [SsidSource] (spec §6a, §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeSsidSetting extends ConsumerStatefulWidget {
  const HomeSsidSetting({super.key});

  @override
  ConsumerState<HomeSsidSetting> createState() => _HomeSsidSettingState();
}

class _HomeSsidSettingState extends ConsumerState<HomeSsidSetting> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      ref.read(homeSsidsSettingsProvider.notifier).addHomeSsid(value);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ssidsAsync = ref.watch(homeSsidsSettingsProvider);
    final notifier = ref.read(homeSsidsSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wifi_outlined, size: 24),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Text(
                'Home WiFi SSIDs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final current = await notifier.detectCurrentSsid();
                if (!context.mounted) return;

                if (current != null) {
                  final ssids = ssidsAsync.value ?? [];
                  if (ssids.contains(current)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '"$current" is already in your home networks.',
                        ),
                      ),
                    );
                  } else {
                    await notifier.addHomeSsid(current);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added "$current" to home networks.'),
                        ),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not detect SSID. Ensure WiFi and Location are on.',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.wifi_find, size: 18),
              label: const Text('Detect'),
            ),
          ],
        ),
        const Text(
          'Endpoints switch to "Local" automatically when connected to these networks.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: AppSpacing.sm),
        ssidsAsync.when(
          data: (ssids) => ssids.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    'No home SSIDs configured.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              : Wrap(
                  spacing: AppSpacing.sm,
                  children: ssids.map((ssid) {
                    return Chip(
                      label: Text(ssid),
                      onDeleted: () => notifier.removeHomeSsid(ssid),
                    );
                  }).toList(),
                ),
          loading: () => const LinearProgressIndicator(),
          error: (err, stack) => Text('Error loading SSIDs: $err'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter SSID manually',
            isDense: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _submit,
            ),
          ),
          onSubmitted: (_) => _submit(),
        ),
      ],
    );
  }
}

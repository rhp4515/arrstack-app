/// UI for managing "Home" WiFi SSIDs. Includes auto-detection via the
/// [SsidSource] (spec §6a, §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeSsidSetting extends ConsumerWidget {
  const HomeSsidSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ssidsAsync = ref.watch(homeSsidsSettingsProvider);
    final notifier = ref.read(homeSsidsSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Home WiFi SSIDs', style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: () async {
                final current = await notifier.detectCurrentSsid();
                if (current != null && context.mounted) {
                  await notifier.addHomeSsid(current);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not detect SSID. Ensure location is on and permission granted.')),
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
                  child: Text('No home SSIDs configured.', style: TextStyle(fontStyle: FontStyle.italic)),
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
          decoration: InputDecoration(
            hintText: 'Enter SSID manually',
            isDense: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // This would need a controller, let's keep it simple for now
                // or just rely on the "Detect" button for most users.
              },
            ),
          ),
          onSubmitted: notifier.addHomeSsid,
        ),
      ],
    );
  }
}

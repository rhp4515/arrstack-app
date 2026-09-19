/// UI for managing "Home" WiFi SSIDs. Includes auto-detection via the
/// [SsidSource] (spec §6a, §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

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
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
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
            icon: const Icon(PhosphorIconsRegular.wifiHigh, size: 17),
            label: const Text('Detect'),
          ),
        ),
        const SizedBox(height: LegacySpacing.sm),
        ssidsAsync.when(
          data: (ssids) => ssids.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: LegacySpacing.md),
                  child: Text(
                    'No home SSIDs configured.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              : Wrap(
                  spacing: AppSpacing.space3,
                  runSpacing: AppSpacing.space2,
                  children: ssids.map((ssid) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space3,
                        vertical: AppSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.n900,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(ssid, style: AppTypography.cardTitle),
                          const SizedBox(width: AppSpacing.space2),
                          Semantics(
                            label: 'Remove $ssid',
                            button: true,
                            child: InkWell(
                              onTap: () => notifier.removeHomeSsid(ssid),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child: Center(
                                  child: Icon(
                                    PhosphorIconsRegular.x,
                                    size: 12,
                                    color: AppColors.n500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
          loading: () => const LinearProgressIndicator(),
          error: (err, stack) => Text('Error loading SSIDs: $err'),
        ),
        const SizedBox(height: LegacySpacing.md),
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

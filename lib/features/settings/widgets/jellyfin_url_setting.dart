/// Settings row for the optional Jellyfin server URL, used by the Play
/// button when the Jellyfin app isn't installed.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/form_dialog.dart';
import 'package:arrstack/features/jellyfin/jellyfin_providers.dart';
import 'package:arrstack/features/settings/widgets/settings_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class JellyfinUrlSetting extends ConsumerWidget {
  const JellyfinUrlSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(jellyfinUrlProvider).value;
    return SettingsNavRow(
      title: 'Jellyfin server',
      subtitle:
          url ??
          'Optional — opened in the browser if the Jellyfin app '
              "isn't installed",
      trailing: const Icon(
        PhosphorIconsRegular.pencilSimple,
        size: 14,
        color: AppColors.n500,
      ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => _JellyfinUrlDialog(initial: url ?? ''),
      ),
    );
  }
}

class _JellyfinUrlDialog extends ConsumerStatefulWidget {
  const _JellyfinUrlDialog({required this.initial});

  final String initial;

  @override
  ConsumerState<_JellyfinUrlDialog> createState() => _JellyfinUrlDialogState();
}

class _JellyfinUrlDialogState extends ConsumerState<_JellyfinUrlDialog> {
  late final _controller = TextEditingController(text: widget.initial);
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    // Empty clears the setting.
    final url = text.isEmpty ? null : normalizeJellyfinUrl(text);
    if (text.isNotEmpty && url == null) {
      setState(() => _error = 'Enter an address like http://192.168.1.50:8096');
      return;
    }
    await ref.read(jellyfinUrlProvider.notifier).save(url);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      title: 'Jellyfin server',
      confirmLabel: 'Save',
      onConfirm: _save,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Play opens the Jellyfin app. If it isn\'t installed, this '
            'address opens in the browser instead. Leave empty to clear.',
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space4),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.url,
            autocorrect: false,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              hintText: 'http://192.168.1.50:8096',
              errorText: _error,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Play in Jellyfin" on the movie and episode detail pages.
///
/// Jellyfin can't be pointed at a title from outside, so the button copies
/// the title, opens the Jellyfin app, and says so; the viewer pastes it
/// into Jellyfin's search.
library;

import 'package:arrstack/core/utils/app_launcher.dart';
import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

final jellyfinLauncherProvider = Provider<JellyfinLauncher>(
  (ref) => const JellyfinLauncher(),
);

class JellyfinPlayButton extends ConsumerStatefulWidget {
  const JellyfinPlayButton({required this.title, super.key});

  /// What to search for in Jellyfin: a movie's title, or an episode's
  /// series title. Null while that isn't known yet (an episode's series is
  /// still loading, or failed to): the app still opens, but nothing useful
  /// can be copied, so nothing is.
  final String? title;

  @override
  ConsumerState<JellyfinPlayButton> createState() => _JellyfinPlayButtonState();
}

class _JellyfinPlayButtonState extends ConsumerState<JellyfinPlayButton> {
  bool _busy = false;

  Future<void> _play() async {
    if (_busy) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final launcher = ref.read(jellyfinLauncherProvider);
    final title = widget.title;
    final hasTitle = title != null && title.isNotEmpty;

    try {
      if (hasTitle) await Clipboard.setData(ClipboardData(text: title));
      final result = await launcher.open();

      final copied = hasTitle ? ' "$title" is on your clipboard.' : '';
      final message = switch (result) {
        // The app is in front by the time this shows, so say what to do
        // there, and keep it up long enough to still be here on return.
        AppLaunch.app =>
          hasTitle ? 'Search for "$title" in Jellyfin — it\'s copied.' : null,
        // Not "isn't installed": on iOS the app can be installed and still
        // not answer the link.
        AppLaunch.store =>
          "Couldn't open the Jellyfin app, so its store page opened.$copied",
        AppLaunch.unavailable =>
          "Couldn't open Jellyfin on this device.$copied",
      };
      if (message != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _busy ? null : _play,
        icon: const Icon(PhosphorIconsFill.play, size: 16),
        label: const Text('Play in Jellyfin'),
      ),
    );
  }
}

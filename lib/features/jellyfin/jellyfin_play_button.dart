/// "Play in Jellyfin" on the movie and episode detail pages.
///
/// Jellyfin can't be pointed at a title from outside, so the button copies
/// the title, opens the Jellyfin app, and says so; the viewer pastes it
/// into Jellyfin's search.
library;

import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:arrstack/features/jellyfin/jellyfin_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class JellyfinPlayButton extends ConsumerWidget {
  const JellyfinPlayButton({required this.title, super.key});

  /// What to search for in Jellyfin: a movie's title, or an episode's
  /// series title.
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => _play(context, ref),
        icon: const Icon(PhosphorIconsFill.play, size: 16),
        label: const Text('Play in Jellyfin'),
      ),
    );
  }

  Future<void> _play(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final launcher = ref.read(jellyfinLauncherProvider);

    await Clipboard.setData(ClipboardData(text: title));
    final stored = await ref.read(jellyfinUrlProvider.future);
    final result = await launcher.open(
      serverUrl: stored == null ? null : Uri.tryParse(stored),
    );

    final message = switch (result) {
      JellyfinLaunch.app => 'Copied "$title" — search for it in Jellyfin.',
      JellyfinLaunch.web =>
        'The Jellyfin app wasn\'t found, so your server opened in the '
            'browser. "$title" is copied — search for it there.',
      JellyfinLaunch.unavailable =>
        'The Jellyfin app wasn\'t found. Install it, or set your server '
            'URL in Settings. "$title" is copied.',
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

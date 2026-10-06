/// The optional Jellyfin server URL (Settings → Jellyfin) and the launcher
/// the Play button uses. The URL is only a fallback for when the Jellyfin
/// app isn't installed, so it's a plain preference rather than a service
/// instance with credentials.
library;

import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const jellyfinUrlPreferenceKey = 'jellyfin.serverUrl';

/// `http://nas:8096` for what a person typed, or null when it can't be a
/// server address. A bare `nas:8096` gets `http://` (a home server rarely
/// has https); the scheme must be http(s), and there must be a host.
String? normalizeJellyfinUrl(String input) {
  var text = input.trim();
  if (text.isEmpty) return null;
  if (!text.contains('://')) text = 'http://$text';
  final uri = Uri.tryParse(text);
  if (uri == null ||
      (uri.scheme != 'http' && uri.scheme != 'https') ||
      uri.host.isEmpty) {
    return null;
  }
  return text.endsWith('/') ? text.substring(0, text.length - 1) : text;
}

final jellyfinLauncherProvider = Provider<JellyfinLauncher>(
  (ref) => const JellyfinLauncher(),
);

final jellyfinUrlProvider = AsyncNotifierProvider<JellyfinUrl, String?>(
  JellyfinUrl.new,
);

class JellyfinUrl extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    try {
      final stored = await ref
          .read(appPreferencesProvider)
          .readString(jellyfinUrlPreferenceKey);
      return stored == null || stored.isEmpty ? null : stored;
    } on Object {
      // A convenience setting: unreadable storage just means "not set".
      return null;
    }
  }

  /// Saves [url] (already normalised), or clears the setting when null.
  Future<void> save(String? url) async {
    final prefs = ref.read(appPreferencesProvider);
    if (url == null) {
      await prefs.remove(jellyfinUrlPreferenceKey);
    } else {
      await prefs.writeString(jellyfinUrlPreferenceKey, url);
    }
    state = AsyncData(url);
  }
}

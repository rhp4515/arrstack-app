/// Opens the Jellyfin app from a movie or episode's Play button.
///
/// Jellyfin's mobile apps have no documented link that opens a given title
/// (the Android TV client has no `jellyfin://` filter at all), so this can
/// only bring the app itself to the front; the caller copies the title for
/// the viewer to search. Android opens the app by package, through
/// [AppLauncher] — that needs the `org.jellyfin.mobile` entry in
/// AndroidManifest.xml's `<queries>`, or Android 11+ hides the app and the
/// launch intent comes back null as if it weren't installed.
///
/// When the app isn't there, the configured server URL (if any) opens in
/// the browser instead.
library;

import 'package:arrstack/core/utils/tailscale_launcher.dart'
    show AppLauncher, UrlOpener;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// The official Jellyfin Android app.
const jellyfinPackage = 'org.jellyfin.mobile';

/// Tried on iOS, where there is no package launch. Best effort: if no
/// installed app claims it the launch simply fails and the URL fallback
/// takes over.
const _jellyfinIosScheme = 'jellyfin://';

enum JellyfinLaunch {
  /// The Jellyfin app came to the front.
  app,

  /// No app, so the server's web UI opened in the browser.
  web,

  /// Neither: no app, and no server URL to fall back to (or it wouldn't
  /// open).
  unavailable,
}

class JellyfinLauncher {
  const JellyfinLauncher({
    this.appLauncher = const AppLauncher(),
    this.openUrl = _defaultOpenUrl,
    this.platform,
  });

  final AppLauncher appLauncher;
  final UrlOpener openUrl;

  /// Overridable for tests; defaults to the running platform.
  final TargetPlatform? platform;

  static Future<bool> _defaultOpenUrl(Uri url, {LaunchMode? mode}) =>
      launchUrl(url, mode: mode ?? LaunchMode.platformDefault);

  Future<JellyfinLaunch> open({Uri? serverUrl}) async {
    final target = platform ?? defaultTargetPlatform;

    if (target == TargetPlatform.android &&
        await appLauncher.launchPackage(jellyfinPackage)) {
      return JellyfinLaunch.app;
    }
    if (target == TargetPlatform.iOS && await _tryOpen(_jellyfinIosScheme)) {
      return JellyfinLaunch.app;
    }
    if (serverUrl != null && await _tryOpen(serverUrl.toString())) {
      return JellyfinLaunch.web;
    }
    return JellyfinLaunch.unavailable;
  }

  Future<bool> _tryOpen(String url) async {
    try {
      return await openUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      // `launchUrl` throws instead of returning false when nothing can
      // handle the URL; this is a convenience button, so move on.
    } on Object {
      return false;
    }
  }
}

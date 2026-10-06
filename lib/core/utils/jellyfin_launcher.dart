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
/// Launching a missing app doesn't take anyone to the store by itself, so
/// when it isn't there this opens its store page, as the Tailscale button
/// does.
library;

import 'package:arrstack/core/utils/tailscale_launcher.dart'
    show AppLauncher, UrlOpener;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// The official Jellyfin Android app.
const jellyfinPackage = 'org.jellyfin.mobile';

const _playStoreUri = 'market://details?id=$jellyfinPackage';
const _playStoreWebUri =
    'https://play.google.com/store/apps/details?id=$jellyfinPackage';
const _appStoreUri = 'https://apps.apple.com/app/id1480192618';

/// Tried on iOS, where there is no package launch. Best effort: if no
/// installed app claims it the launch simply fails and the App Store page
/// opens instead.
const _jellyfinIosScheme = 'jellyfin://';

enum JellyfinLaunch {
  /// The Jellyfin app came to the front.
  app,

  /// The app isn't installed, so its store page opened.
  store,

  /// Nothing opened (no app, and no store on this platform).
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

  Future<JellyfinLaunch> open() async {
    switch (platform ?? defaultTargetPlatform) {
      case TargetPlatform.android:
        if (await appLauncher.launchPackage(jellyfinPackage)) {
          return JellyfinLaunch.app;
        }
        // `market://` hands straight to the Play Store app when it's there.
        if (await _tryOpen(_playStoreUri) || await _tryOpen(_playStoreWebUri)) {
          return JellyfinLaunch.store;
        }
        return JellyfinLaunch.unavailable;
      case TargetPlatform.iOS:
        if (await _tryOpen(_jellyfinIosScheme)) return JellyfinLaunch.app;
        return await _tryOpen(_appStoreUri)
            ? JellyfinLaunch.store
            : JellyfinLaunch.unavailable;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return JellyfinLaunch.unavailable;
    }
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

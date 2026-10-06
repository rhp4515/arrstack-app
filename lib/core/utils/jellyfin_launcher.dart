/// Opens the Jellyfin app from a movie or episode's Play button.
///
/// Jellyfin's mobile apps have no documented link that opens a given title
/// (the Android TV client has no `jellyfin://` filter at all), so this can
/// only bring the app itself to the front; the caller copies the title for
/// the viewer to search. See [AppStoreLauncher] for how the app is found
/// and what happens when it isn't.
///
/// Both official Android clients are tried, so a Google/Android TV device
/// with only the TV app isn't sent to the store. They need `<package>`
/// entries in AndroidManifest.xml's `<queries>`.
library;

import 'package:arrstack/core/utils/app_launcher.dart';
import 'package:flutter/foundation.dart';

/// The official Jellyfin phone/tablet app, and the Android TV one.
const jellyfinPackage = 'org.jellyfin.mobile';
const jellyfinTvPackage = 'org.jellyfin.androidtv';

class JellyfinLauncher {
  const JellyfinLauncher({
    this.appLauncher = const AppLauncher(),
    this.openUrl = defaultUrlOpener,
    this.platform,
  });

  final AppLauncher appLauncher;
  final UrlOpener openUrl;

  /// Overridable for tests; defaults to the running platform.
  final TargetPlatform? platform;

  Future<AppLaunch> open() => AppStoreLauncher(
    androidPackages: const [jellyfinPackage, jellyfinTvPackage],
    appStoreUrl: 'https://apps.apple.com/app/id1480192618',
    // Best effort: nothing documents a scheme the iOS client answers, so a
    // miss falls through to the App Store page.
    iosScheme: 'jellyfin://',
    appLauncher: appLauncher,
    openUrl: openUrl,
    platform: platform,
  ).open();
}

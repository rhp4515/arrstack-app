/// Opens the Tailscale app from Home's offline card.
///
/// This cannot go through `url_launcher` alone. Tailscale's Android client
/// does register a `tailscale://` scheme, but only with the host `navigate`
/// (`<data android:scheme="tailscale" android:host="navigate"/>`) for
/// in-app routing — a bare `tailscale://` has an empty host and matches no
/// intent filter, so it fails exactly as if the app were not installed. On
/// iOS there is no scheme at all (tailscale/tailscale#14679 is still open).
///
/// So Android opens the app by package (see [AppStoreLauncher]); it needs
/// the `<package android:name="com.tailscale.ipn"/>` entry in
/// AndroidManifest.xml's `<queries>`. When it isn't installed, and on every
/// other platform, the best available answer is wherever that platform
/// installs or starts it from.
library;

import 'package:arrstack/core/utils/app_launcher.dart';
import 'package:flutter/foundation.dart';

export 'package:arrstack/core/utils/app_launcher.dart'
    show AppLauncher, UrlOpener;

/// Tailscale's Android package / iOS App Store id.
const tailscalePackage = 'com.tailscale.ipn';
const _appStoreUri = 'https://apps.apple.com/app/id1470499037';

/// Covers macOS, Windows, Linux and the web build, where there is no
/// single store listing to send someone to.
const _downloadPageUri = 'https://tailscale.com/download';

class TailscaleLauncher {
  const TailscaleLauncher({
    this.appLauncher = const AppLauncher(),
    this.openUrl = defaultUrlOpener,
    this.platform,
  });

  final AppLauncher appLauncher;
  final UrlOpener openUrl;

  /// Overridable for tests; defaults to the running platform.
  final TargetPlatform? platform;

  /// Brings Tailscale to the front, or failing that opens somewhere the
  /// viewer can install or start it. Returns true when something opened.
  ///
  /// Every platform gets its own destination. Home's offline card is
  /// shared by the desktop and web builds too, and sending those to an
  /// iOS App Store listing is no more useful than the `tailscale://` this
  /// replaced.
  Future<bool> open() async {
    final result = await AppStoreLauncher(
      androidPackages: const [tailscalePackage],
      appStoreUrl: _appStoreUri,
      otherPlatformsUrl: _downloadPageUri,
      appLauncher: appLauncher,
      openUrl: openUrl,
      platform: platform,
    ).open();
    return result != AppLaunch.unavailable;
  }
}

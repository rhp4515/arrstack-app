/// Opens the Tailscale app from Home's offline card.
///
/// This cannot go through `url_launcher` alone. Tailscale's Android client
/// does register a `tailscale://` scheme, but only with the host `navigate`
/// (`<data android:scheme="tailscale" android:host="navigate"/>`) for
/// in-app routing — a bare `tailscale://` has an empty host and matches no
/// intent filter, so it fails exactly as if the app were not installed. On
/// iOS there is no scheme at all (tailscale/tailscale#14679 is still open).
///
/// So Android opens the app the way a launcher does, by package, through
/// [AppLauncher]; that needs the `<package android:name="com.tailscale.ipn"/>`
/// entry in AndroidManifest.xml's `<queries>`, or `getLaunchIntentForPackage`
/// returns null on Android 11+ even when the app is installed. When it
/// isn't installed, and on every other platform, the best available answer
/// is wherever that platform installs or starts it from.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tailscale's Android package / iOS App Store id.
const tailscalePackage = 'com.tailscale.ipn';
const _playStoreUri = 'market://details?id=$tailscalePackage';
const _playStoreWebUri =
    'https://play.google.com/store/apps/details?id=$tailscalePackage';
const _appStoreUri = 'https://apps.apple.com/app/id1470499037';

/// Covers macOS, Windows, Linux and the web build, where there is no
/// single store listing to send someone to.
const _downloadPageUri = 'https://tailscale.com/download';

/// Launches another installed app by its package id, over a method channel
/// implemented in `MainActivity.kt`. Android-only: every other platform
/// answers `notImplemented`, which surfaces here as `false`.
class AppLauncher {
  const AppLauncher([this.channel = const MethodChannel(channelName)]);

  static const channelName = 'dev.hraman.arrstack/app_launcher';

  final MethodChannel channel;

  /// True when the app was actually brought to the foreground. False when
  /// it isn't installed, isn't visible to us, or the platform has no
  /// implementation — all cases where the caller should fall back rather
  /// than report success.
  Future<bool> launchPackage(String packageName) async {
    try {
      final launched = await channel.invokeMethod<bool>('launchPackage', {
        'package': packageName,
      });
      return launched ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

/// Opens a URL; injectable so the fallback chain is testable without a
/// platform. Matches `url_launcher`'s [launchUrl] signature.
typedef UrlOpener = Future<bool> Function(Uri url, {LaunchMode mode});

class TailscaleLauncher {
  const TailscaleLauncher({
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

  /// Brings Tailscale to the front, or failing that opens somewhere the
  /// viewer can install or start it. Returns true when something opened.
  ///
  /// Every platform gets its own destination. Home's offline card is
  /// shared by the desktop and web builds too, and sending those to an
  /// iOS App Store listing is no more useful than the `tailscale://` this
  /// replaced.
  Future<bool> open() async {
    final target = platform ?? defaultTargetPlatform;

    switch (target) {
      case TargetPlatform.android:
        if (await appLauncher.launchPackage(tailscalePackage)) return true;
        // Not installed (or not visible): the store page is the useful
        // answer, and `market://` hands straight to the Play Store app
        // when it's there.
        if (await _tryOpen(_playStoreUri)) return true;
        return _tryOpen(_playStoreWebUri);
      case TargetPlatform.iOS:
        return _tryOpen(_appStoreUri);
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return _tryOpen(_downloadPageUri);
    }
  }

  Future<bool> _tryOpen(String url) async {
    try {
      return await openUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      // `launchUrl` throws rather than returning false when the platform
      // can find no handler at all, and this is a best-effort convenience
      // button — a failure here should move to the next target, never
      // surface a platform exception.
    } on Object {
      return false;
    }
  }
}

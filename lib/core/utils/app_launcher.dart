/// Bringing another installed app to the front, or failing that opening
/// wherever it can be installed. Shared by the Tailscale button on Home's
/// offline card and the Play button on the movie and episode pages.
///
/// Launching a missing app doesn't take anyone to a store by itself, and
/// some apps (Tailscale, Jellyfin) have no URL scheme that opens them, so
/// Android opens them the way a launcher does — by package, through
/// [AppLauncher] — and every miss falls through to a store page.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches another installed app by its package id, over a method channel
/// implemented in `MainActivity.kt`. Android-only: every other platform
/// answers `notImplemented`, which surfaces here as `false`.
///
/// Each package launched this way needs a `<package>` entry in
/// AndroidManifest.xml's `<queries>`, or `getLaunchIntentForPackage` returns
/// null on Android 11+ even when the app is installed.
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

Future<bool> defaultUrlOpener(Uri url, {LaunchMode? mode}) =>
    launchUrl(url, mode: mode ?? LaunchMode.platformDefault);

enum AppLaunch {
  /// The app came to the front.
  app,

  /// The app wasn't opened, but somewhere to install or start it was.
  store,

  /// Nothing opened.
  unavailable,
}

/// Opens an app, falling back to its store page.
class AppStoreLauncher {
  const AppStoreLauncher({
    required this.androidPackages,
    required this.appStoreUrl,
    this.iosScheme,
    this.otherPlatformsUrl,
    this.appLauncher = const AppLauncher(),
    this.openUrl = defaultUrlOpener,
    this.platform,
  });

  /// Package ids to try, in order, on Android; the first one's Play Store
  /// listing is the fallback.
  final List<String> androidPackages;

  /// The App Store listing, for iOS.
  final String appStoreUrl;

  /// A URL scheme that opens the app on iOS, when it has one. Tried before
  /// the App Store.
  final String? iosScheme;

  /// Where macOS, Windows, Linux and the web build are sent: there is no
  /// single store listing for them. Null means nothing is offered there.
  final String? otherPlatformsUrl;

  final AppLauncher appLauncher;
  final UrlOpener openUrl;

  /// Overridable for tests; defaults to the running platform.
  final TargetPlatform? platform;

  Future<AppLaunch> open() async {
    switch (platform ?? defaultTargetPlatform) {
      case TargetPlatform.android:
        for (final package in androidPackages) {
          if (await appLauncher.launchPackage(package)) return AppLaunch.app;
        }
        // `market://` hands straight to the Play Store app when it's there.
        final id = androidPackages.first;
        if (await _tryOpen('market://details?id=$id') ||
            await _tryOpen(
              'https://play.google.com/store/apps/details?id=$id',
            )) {
          return AppLaunch.store;
        }
        return AppLaunch.unavailable;
      case TargetPlatform.iOS:
        final scheme = iosScheme;
        if (scheme != null && await _tryOpen(scheme)) return AppLaunch.app;
        return await _tryOpen(appStoreUrl)
            ? AppLaunch.store
            : AppLaunch.unavailable;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        final url = otherPlatformsUrl;
        if (url == null) return AppLaunch.unavailable;
        return await _tryOpen(url) ? AppLaunch.store : AppLaunch.unavailable;
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

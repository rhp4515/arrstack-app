import 'package:arrstack/core/utils/app_launcher.dart';
import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

class _FakeAppLauncher implements AppLauncher {
  _FakeAppLauncher({required this.result, this.onlyPackage});

  final bool result;

  /// When set, only this package launches.
  final String? onlyPackage;
  final List<String> requested = [];

  @override
  MethodChannel get channel => const MethodChannel(AppLauncher.channelName);

  @override
  Future<bool> launchPackage(String packageName) async {
    requested.add(packageName);
    return onlyPackage == null ? result : packageName == onlyPackage;
  }
}

void main() {
  late List<String> opened;

  setUp(() => opened = []);

  UrlOpener opener({Set<String> failing = const {}, bool throws = false}) {
    return (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
      opened.add(url.toString());
      if (throws) throw PlatformException(code: 'no_handler');
      return !failing.contains(url.toString());
    };
  }

  JellyfinLauncher launcher(
    TargetPlatform platform, {
    bool appInstalled = true,
    UrlOpener? openUrl,
    _FakeAppLauncher? appLauncher,
  }) => JellyfinLauncher(
    appLauncher: appLauncher ?? _FakeAppLauncher(result: appInstalled),
    openUrl: openUrl ?? opener(),
    platform: platform,
  );

  test('Android opens the Jellyfin app by package and opens no URL', () async {
    final app = _FakeAppLauncher(result: true);
    final result = await launcher(
      TargetPlatform.android,
      appLauncher: app,
    ).open();

    expect(result, AppLaunch.app);
    expect(app.requested, [jellyfinPackage]);
    expect(opened, isEmpty);
  });

  test(
    'Android with only the TV app installed opens that, not the store',
    () async {
      final app = _FakeAppLauncher(
        result: false,
        onlyPackage: jellyfinTvPackage,
      );
      final result = await launcher(
        TargetPlatform.android,
        appLauncher: app,
      ).open();

      expect(result, AppLaunch.app);
      expect(app.requested, [jellyfinPackage, jellyfinTvPackage]);
      expect(opened, isEmpty);
    },
  );

  test('Android without the app opens its Play Store page', () async {
    final result = await launcher(
      TargetPlatform.android,
      appInstalled: false,
    ).open();

    expect(result, AppLaunch.store);
    expect(opened, ['market://details?id=org.jellyfin.mobile']);
  });

  test(
    'Android falls back to the Play Store website without the store app',
    () async {
      final result = await launcher(
        TargetPlatform.android,
        appInstalled: false,
        openUrl: opener(failing: {'market://details?id=org.jellyfin.mobile'}),
      ).open();

      expect(result, AppLaunch.store);
      expect(opened.last, startsWith('https://play.google.com/store/apps/'));
    },
  );

  test('a store that will not open reports unavailable, not a crash', () async {
    final result = await launcher(
      TargetPlatform.android,
      appInstalled: false,
      openUrl: opener(throws: true),
    ).open();

    expect(result, AppLaunch.unavailable);
  });

  test('iOS tries the jellyfin scheme, then the App Store', () async {
    expect(await launcher(TargetPlatform.iOS).open(), AppLaunch.app);
    expect(opened, ['jellyfin://']);

    opened.clear();
    final viaStore = await launcher(
      TargetPlatform.iOS,
      openUrl: opener(failing: {'jellyfin://'}),
    ).open();
    expect(viaStore, AppLaunch.store);
    expect(opened, ['jellyfin://', 'https://apps.apple.com/app/id1480192618']);
  });

  test('desktop has nothing to open', () async {
    expect(await launcher(TargetPlatform.linux).open(), AppLaunch.unavailable);
    expect(opened, isEmpty);
  });
}

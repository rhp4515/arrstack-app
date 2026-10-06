import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:arrstack/core/utils/tailscale_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

class _FakeAppLauncher implements AppLauncher {
  _FakeAppLauncher({required this.result});

  final bool result;
  final List<String> requested = [];

  @override
  MethodChannel get channel => const MethodChannel(AppLauncher.channelName);

  @override
  Future<bool> launchPackage(String packageName) async {
    requested.add(packageName);
    return result;
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
    ).open(serverUrl: Uri.parse('http://nas:8096'));

    expect(result, JellyfinLaunch.app);
    expect(app.requested, [jellyfinPackage]);
    expect(opened, isEmpty);
  });

  test('Android without the app opens the server URL in the browser', () async {
    final result = await launcher(
      TargetPlatform.android,
      appInstalled: false,
    ).open(serverUrl: Uri.parse('http://nas:8096'));

    expect(result, JellyfinLaunch.web);
    expect(opened, ['http://nas:8096']);
  });

  test('without the app or a URL there is nothing to open', () async {
    final result = await launcher(
      TargetPlatform.android,
      appInstalled: false,
    ).open();

    expect(result, JellyfinLaunch.unavailable);
    expect(opened, isEmpty);
  });

  test('a URL that will not open reports unavailable, not a crash', () async {
    final result = await launcher(
      TargetPlatform.android,
      appInstalled: false,
      openUrl: opener(throws: true),
    ).open(serverUrl: Uri.parse('http://nas:8096'));

    expect(result, JellyfinLaunch.unavailable);
  });

  test('iOS tries the jellyfin scheme, then the server URL', () async {
    final viaApp = await launcher(TargetPlatform.iOS).open();
    expect(viaApp, JellyfinLaunch.app);
    expect(opened, ['jellyfin://']);

    opened.clear();
    final viaWeb = await launcher(
      TargetPlatform.iOS,
      openUrl: opener(failing: {'jellyfin://'}),
    ).open(serverUrl: Uri.parse('http://nas:8096'));
    expect(viaWeb, JellyfinLaunch.web);
    expect(opened, ['jellyfin://', 'http://nas:8096']);
  });
}

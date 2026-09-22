// TailscaleLauncher: opening Tailscale from Home's offline card.
//
// The regression this guards: the button used to launch `tailscale://`,
// which matches no intent filter (Tailscale's scheme requires the host
// `navigate`) and so silently did nothing on a device that had Tailscale
// installed.

import 'package:arrstack/core/utils/tailscale_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

/// Records what was asked of the platform channel.
class _RecordingAppLauncher implements AppLauncher {
  _RecordingAppLauncher({required this.result});

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

  UrlOpener opener({bool succeeds = true, Set<String> failing = const {}}) {
    return (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
      opened.add(url.toString());
      if (failing.contains(url.toString())) return false;
      return succeeds;
    };
  }

  test('opens Tailscale by package on Android, never by URL', () async {
    final appLauncher = _RecordingAppLauncher(result: true);
    final launcher = TailscaleLauncher(
      appLauncher: appLauncher,
      openUrl: opener(),
      platform: TargetPlatform.android,
    );

    expect(await launcher.open(), isTrue);
    expect(appLauncher.requested, [tailscalePackage]);
    // The old `tailscale://` attempt is gone: no URL is opened at all when
    // the app itself comes to the front.
    expect(opened, isEmpty);
  });

  test(
    'falls back to the Play Store when Tailscale is not installed',
    () async {
      final appLauncher = _RecordingAppLauncher(result: false);
      final launcher = TailscaleLauncher(
        appLauncher: appLauncher,
        openUrl: opener(),
        platform: TargetPlatform.android,
      );

      expect(await launcher.open(), isTrue);
      expect(opened, ['market://details?id=$tailscalePackage']);
    },
  );

  test('falls back again to the Play Store website when `market://` has no '
      'handler', () async {
    final launcher = TailscaleLauncher(
      appLauncher: _RecordingAppLauncher(result: false),
      openUrl: opener(failing: {'market://details?id=$tailscalePackage'}),
      platform: TargetPlatform.android,
    );

    expect(await launcher.open(), isTrue);
    expect(opened, [
      'market://details?id=$tailscalePackage',
      'https://play.google.com/store/apps/details?id=$tailscalePackage',
    ]);
  });

  test('goes to the App Store on iOS, where no scheme opens the app', () async {
    final appLauncher = _RecordingAppLauncher(result: true);
    final launcher = TailscaleLauncher(
      appLauncher: appLauncher,
      openUrl: opener(),
      platform: TargetPlatform.iOS,
    );

    expect(await launcher.open(), isTrue);
    // The package channel is Android-only — iOS must not even be asked.
    expect(appLauncher.requested, isEmpty);
    expect(opened, ['https://apps.apple.com/app/id1470499037']);
  });

  test('sends each desktop platform to the cross-platform download page, '
      'not an iOS listing it cannot use', () async {
    for (final target in [
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    ]) {
      opened = [];
      final appLauncher = _RecordingAppLauncher(result: true);
      final launcher = TailscaleLauncher(
        appLauncher: appLauncher,
        openUrl: opener(),
        platform: target,
      );

      expect(await launcher.open(), isTrue, reason: '$target');
      expect(opened, ['https://tailscale.com/download'], reason: '$target');
      // The package channel only exists on Android.
      expect(appLauncher.requested, isEmpty, reason: '$target');
    }
  });

  test('a thrown platform error moves to the next target instead of '
      'escaping to the caller', () async {
    final launcher = TailscaleLauncher(
      appLauncher: _RecordingAppLauncher(result: false),
      openUrl: (Uri url, {LaunchMode mode = LaunchMode.platformDefault}) async {
        opened.add(url.toString());
        if (url.scheme == 'market') {
          throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
        }
        return true;
      },
      platform: TargetPlatform.android,
    );

    expect(await launcher.open(), isTrue);
    expect(opened, hasLength(2));
  });

  test('reports failure when nothing could be opened', () async {
    final launcher = TailscaleLauncher(
      appLauncher: _RecordingAppLauncher(result: false),
      openUrl: opener(succeeds: false),
      platform: TargetPlatform.android,
    );

    expect(await launcher.open(), isFalse);
  });

  group('AppLauncher', () {
    const channel = MethodChannel(AppLauncher.channelName);

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('passes the package to the platform and returns its answer', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      MethodCall? received;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            received = call;
            return true;
          });

      expect(await const AppLauncher().launchPackage(tailscalePackage), isTrue);
      expect(received?.method, 'launchPackage');
      expect(received?.arguments, {'package': tailscalePackage});
    });

    test('treats a platform with no implementation as "not launched", so '
        'the caller falls back rather than reporting success', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw MissingPluginException();
          });

      expect(
        await const AppLauncher().launchPackage(tailscalePackage),
        isFalse,
      );
    });

    test('treats a platform error as "not launched"', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            throw PlatformException(code: 'invalid_argument');
          });

      expect(
        await const AppLauncher().launchPackage(tailscalePackage),
        isFalse,
      );
    });
  });
}

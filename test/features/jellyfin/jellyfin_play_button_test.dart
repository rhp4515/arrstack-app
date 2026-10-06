import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:arrstack/features/jellyfin/jellyfin_play_button.dart';
import 'package:arrstack/features/jellyfin/jellyfin_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLauncher implements JellyfinLauncher {
  _FakeLauncher(this.result);

  final JellyfinLaunch result;
  final List<Uri?> servers = [];

  @override
  Future<JellyfinLaunch> open({Uri? serverUrl}) async {
    servers.add(serverUrl);
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late List<String> clipboard;

  setUp(() {
    clipboard = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard.add((call.arguments as Map)['text'] as String);
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Future<_FakeLauncher> pump(
    WidgetTester tester,
    JellyfinLaunch result, {
    Map<String, Object> prefs = const {},
  }) async {
    final launcher = _FakeLauncher(result);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          jellyfinLauncherProvider.overrideWithValue(launcher),
          appPreferencesProvider.overrideWithValue(
            InMemoryAppPreferences(prefs),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: JellyfinPlayButton(title: 'Dune: Part Two')),
        ),
      ),
    );
    return launcher;
  }

  testWidgets('copies the title, opens the app and says to search for it', (
    tester,
  ) async {
    final launcher = await pump(tester, JellyfinLaunch.app);

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pumpAndSettle();

    expect(clipboard, ['Dune: Part Two']);
    expect(launcher.servers, [null]);
    expect(
      find.text('Copied "Dune: Part Two" — search for it in Jellyfin.'),
      findsOneWidget,
    );
  });

  testWidgets('hands the saved server URL to the launcher as the fallback', (
    tester,
  ) async {
    final launcher = await pump(
      tester,
      JellyfinLaunch.web,
      prefs: {jellyfinUrlPreferenceKey: 'http://nas:8096'},
    );

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pumpAndSettle();

    expect(launcher.servers.single.toString(), 'http://nas:8096');
    expect(find.textContaining('opened in the browser'), findsOneWidget);
  });

  testWidgets('says what to do when neither the app nor a URL is there', (
    tester,
  ) async {
    await pump(tester, JellyfinLaunch.unavailable);

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pumpAndSettle();

    expect(clipboard, ['Dune: Part Two']); // still copied
    expect(
      find.textContaining('set your server URL in Settings'),
      findsOneWidget,
    );
  });
}

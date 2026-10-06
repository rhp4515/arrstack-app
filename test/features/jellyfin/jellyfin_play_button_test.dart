import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:arrstack/features/jellyfin/jellyfin_play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLauncher implements JellyfinLauncher {
  _FakeLauncher(this.result);

  final JellyfinLaunch result;
  int opens = 0;

  @override
  Future<JellyfinLaunch> open() async {
    opens++;
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

  Future<_FakeLauncher> pump(WidgetTester tester, JellyfinLaunch result) async {
    final launcher = _FakeLauncher(result);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [jellyfinLauncherProvider.overrideWithValue(launcher)],
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
    expect(launcher.opens, 1);
    expect(
      find.text('Copied "Dune: Part Two" — search for it in Jellyfin.'),
      findsOneWidget,
    );
  });

  testWidgets('explains that the store page opened when the app is missing', (
    tester,
  ) async {
    await pump(tester, JellyfinLaunch.store);

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pumpAndSettle();

    expect(clipboard, ['Dune: Part Two']);
    expect(find.textContaining('store page opened'), findsOneWidget);
  });

  testWidgets('still copies the title when nothing can be opened', (
    tester,
  ) async {
    await pump(tester, JellyfinLaunch.unavailable);

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pumpAndSettle();

    expect(clipboard, ['Dune: Part Two']);
    expect(find.textContaining("Couldn't open Jellyfin"), findsOneWidget);
  });
}

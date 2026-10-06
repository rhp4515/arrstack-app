import 'dart:async';

import 'package:arrstack/core/utils/app_launcher.dart';
import 'package:arrstack/core/utils/jellyfin_launcher.dart';
import 'package:arrstack/features/jellyfin/jellyfin_play_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLauncher implements JellyfinLauncher {
  _FakeLauncher(this.result);

  final Future<AppLaunch> Function() result;
  int opens = 0;

  @override
  Future<AppLaunch> open() {
    opens++;
    return result();
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
    Future<AppLaunch> Function() result, {
    String? title = 'Dune: Part Two',
  }) async {
    final launcher = _FakeLauncher(result);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [jellyfinLauncherProvider.overrideWithValue(launcher)],
        child: MaterialApp(
          home: Scaffold(body: JellyfinPlayButton(title: title)),
        ),
      ),
    );
    return launcher;
  }

  Future<void> tapPlay(WidgetTester tester) async {
    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pumpAndSettle();
  }

  testWidgets('copies the title, opens the app and says to search for it', (
    tester,
  ) async {
    final launcher = await pump(tester, () async => AppLaunch.app);

    await tapPlay(tester);

    expect(clipboard, ['Dune: Part Two']);
    expect(launcher.opens, 1);
    expect(
      find.text('Search for "Dune: Part Two" in Jellyfin — it\'s copied.'),
      findsOneWidget,
    );
  });

  testWidgets('the message stays up long enough to see after returning', (
    tester,
  ) async {
    await pump(tester, () async => AppLaunch.app);

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 6));

    expect(find.textContaining('Search for'), findsOneWidget);
  });

  testWidgets('does not claim the app is missing when the store opened', (
    tester,
  ) async {
    await pump(tester, () async => AppLaunch.store);

    await tapPlay(tester);

    expect(clipboard, ['Dune: Part Two']);
    expect(
      find.textContaining("Couldn't open the Jellyfin app, so its store page"),
      findsOneWidget,
    );
    expect(find.textContaining("isn't installed"), findsNothing);
    expect(find.textContaining("wasn't found"), findsNothing);
  });

  testWidgets('still copies the title when nothing can be opened', (
    tester,
  ) async {
    await pump(tester, () async => AppLaunch.unavailable);

    await tapPlay(tester);

    expect(clipboard, ['Dune: Part Two']);
    expect(find.textContaining("Couldn't open Jellyfin"), findsOneWidget);
  });

  testWidgets('with no title it opens the app and copies nothing', (
    tester,
  ) async {
    final launcher = await pump(tester, () async => AppLaunch.app, title: null);

    await tapPlay(tester);

    expect(launcher.opens, 1);
    expect(clipboard, isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a second tap while opening is ignored', (tester) async {
    final gate = Completer<AppLaunch>();
    final launcher = await pump(tester, () => gate.future);

    await tester.tap(find.text('Play in Jellyfin'));
    await tester.pump();
    await tester.tap(find.text('Play in Jellyfin'), warnIfMissed: false);
    await tester.pump();
    expect(launcher.opens, 1);

    gate.complete(AppLaunch.app);
    await tester.pumpAndSettle();
    expect(launcher.opens, 1);
    expect(clipboard, ['Dune: Part Two']);

    // It re-enables afterwards.
    await tapPlay(tester);
    expect(launcher.opens, 2);
  });
}

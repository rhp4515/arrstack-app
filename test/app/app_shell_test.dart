import 'package:arrstack/app/app.dart';
import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/router.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/storage/fakes.dart';

class _FakeSsidSource implements SsidSource {
  @override
  Future<String?> currentSsid() async => 'Home-WiFi';

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<PermissionStatus> permissionStatus() async => PermissionStatus.granted;
}

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configStoreProvider.overrideWithValue(FakeConfigStore()),
          secureStoreProvider.overrideWithValue(FakeSecureStore()),
          ssidSourceProvider.overrideWithValue(_FakeSsidSource()),
        ],
        child: const ArrStackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows exactly 3 tabs: Home, Library, Activity', (tester) async {
    await pumpApp(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Settings'), findsNothing); // no longer a top-level tab
    expect(find.text('Uptime'), findsNothing);
    expect(find.text('Discover'), findsNothing);
  });

  testWidgets('tapping Library switches the branch', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsWidgets); // tab label + app bar title
  });

  group('system back', () {
    final exitCalls = <MethodCall>[];

    setUp(() {
      exitCalls.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'SystemNavigator.pop') exitCalls.add(call);
            return null;
          });
      appRouter.go(RoutePaths.home);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('on Home asks before exiting, and No stays in the app', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Exit ArrStack?'), findsOneWidget);
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(find.text('Exit ArrStack?'), findsNothing);
      expect(exitCalls, isEmpty);
    });

    testWidgets('Yes exits the app', (tester) async {
      await pumpApp(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(exitCalls, hasLength(1));
    });

    testWidgets('from another tab goes back to Home without asking', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text('Activity'));
      await tester.pumpAndSettle();
      expect(appRouter.state.uri.path, RoutePaths.activity);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(appRouter.state.uri.path, RoutePaths.home);
      expect(find.text('Exit ArrStack?'), findsNothing);
      expect(exitCalls, isEmpty);
    });

    testWidgets('from a sub-page pops that page, not the app', (tester) async {
      await pumpApp(tester);
      appRouter.push(RoutePaths.homeSettings);
      await tester.pumpAndSettle();
      expect(appRouter.state.uri.path, RoutePaths.homeSettings);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(appRouter.state.uri.path, RoutePaths.home);
      expect(find.text('Exit ArrStack?'), findsNothing);
      expect(exitCalls, isEmpty);
    });
  });
}

import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/security/app_lock_gate.dart';
import 'package:arrstack/features/security/app_lock_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthenticator implements DeviceAuthenticator {
  FakeAuthenticator({this.available = true, this.succeeds = true});

  bool available;
  bool succeeds;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeeds;
  }
}

void main() {
  group('AppLockEnabled', () {
    late InMemoryAppPreferences prefs;
    late FakeAuthenticator auth;
    late ProviderContainer container;

    setUp(() {
      prefs = InMemoryAppPreferences();
      auth = FakeAuthenticator();
      container = ProviderContainer(
        overrides: [
          appPreferencesProvider.overrideWithValue(prefs),
          deviceAuthenticatorProvider.overrideWithValue(auth),
        ],
      );
    });

    tearDown(() => container.dispose());

    AppLockEnabled notifier() =>
        container.read(appLockEnabledProvider.notifier);

    test('defaults to off', () async {
      expect(await container.read(appLockEnabledProvider.future), isFalse);
    });

    test('turning on requires authentication and persists', () async {
      await container.read(appLockEnabledProvider.future);
      expect(
        await notifier().setEnabled(enabled: true),
        AppLockChangeResult.changed,
      );
      expect(auth.prompts, 1);
      expect(await prefs.readBool(appLockPreferenceKey), isTrue);
      expect(container.read(appLockEnabledProvider).value, isTrue);
    });

    test('is refused on a device with no biometrics or screen lock', () async {
      auth.available = false;
      await container.read(appLockEnabledProvider.future);
      expect(
        await notifier().setEnabled(enabled: true),
        AppLockChangeResult.unavailable,
      );
      expect(auth.prompts, 0);
      expect(await prefs.readBool(appLockPreferenceKey), isNull);
    });

    test('a failed authentication leaves the setting unchanged', () async {
      await prefs.writeBool(appLockPreferenceKey, value: true);
      auth.succeeds = false;
      await container.read(appLockEnabledProvider.future);
      expect(
        await notifier().setEnabled(enabled: false),
        AppLockChangeResult.notAuthenticated,
      );
      expect(await prefs.readBool(appLockPreferenceKey), isTrue);
    });
  });

  group('AppLockGate', () {
    Future<FakeAuthenticator> pumpGate(
      WidgetTester tester, {
      required bool enabled,
      bool succeeds = false,
      DateTime Function()? clock,
    }) async {
      final auth = FakeAuthenticator(succeeds: succeeds);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appPreferencesProvider.overrideWithValue(
              InMemoryAppPreferences({appLockPreferenceKey: enabled}),
            ),
            deviceAuthenticatorProvider.overrideWithValue(auth),
          ],
          child: MaterialApp(
            home: AppLockGate(
              clock: clock,
              child: const Scaffold(body: Text('secret content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return auth;
    }

    testWidgets('shows the app directly when the lock is off', (tester) async {
      final auth = await pumpGate(tester, enabled: false);
      expect(find.text('ArrStack is locked'), findsNothing);
      expect(auth.prompts, 0);
    });

    testWidgets('locks on launch and prompts immediately', (tester) async {
      final auth = await pumpGate(tester, enabled: true);
      expect(find.text('ArrStack is locked'), findsOneWidget);
      expect(auth.prompts, 1);
    });

    testWidgets('Unlock retries and a success reveals the app', (tester) async {
      final auth = await pumpGate(tester, enabled: true);
      auth.succeeds = true;
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();
      expect(find.text('ArrStack is locked'), findsNothing);
      expect(find.text('secret content'), findsOneWidget);
    });

    testWidgets('re-locks only after the background grace period', (
      tester,
    ) async {
      var now = DateTime(2026, 9, 30, 12);
      final auth = await pumpGate(
        tester,
        enabled: true,
        succeeds: true,
        clock: () => now,
      );
      expect(find.text('ArrStack is locked'), findsNothing);

      final binding = tester.binding;
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      now = now.add(const Duration(seconds: 5));
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(auth.prompts, 1, reason: 'a short trip away does not re-lock');

      auth.succeeds = false;
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      now = now.add(appLockGracePeriod);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(auth.prompts, 2);
      expect(find.text('ArrStack is locked'), findsOneWidget);
    });
  });
}

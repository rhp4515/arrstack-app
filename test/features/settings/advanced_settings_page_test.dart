import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/features/security/app_lock_providers.dart';
import 'package:arrstack/features/settings/advanced_settings_page.dart';
import 'package:arrstack/features/settings/cache_clearing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/storage/fakes.dart';
import '../security/app_lock_test.dart' show FakeAuthenticator;

void main() {
  late FakeConfigStore config;
  late FakeAuthenticator auth;
  var artworkCleared = 0;

  Future<void> pump(WidgetTester tester) async {
    config = FakeConfigStore();
    auth = FakeAuthenticator();
    artworkCleared = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          configStoreProvider.overrideWithValue(config),
          appPreferencesProvider.overrideWithValue(InMemoryAppPreferences()),
          deviceAuthenticatorProvider.overrideWithValue(auth),
          artworkCacheClearerProvider.overrideWithValue(
            () async => artworkCleared++,
          ),
        ],
        child: const MaterialApp(home: AdvancedSettingsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('groups appearance, security, and tools', (tester) async {
    await pump(tester);
    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('SECURITY'), findsOneWidget);
    expect(find.text('TOOLS'), findsOneWidget);
    expect(find.text('Service backup'), findsOneWidget);
    expect(find.text('Clear cached data'), findsOneWidget);
    expect(find.text('Diagnostic logs'), findsOneWidget);
  });

  testWidgets('the theme segments update the theme mode', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    final element = tester.element(find.byType(AdvancedSettingsPage));
    final container = ProviderScope.containerOf(element);
    expect(container.read(appThemeModeProvider), ThemeMode.dark);
    expect(await config.readThemeMode(), 'dark');
  });

  testWidgets('turning on the lock authenticates first', (tester) async {
    await pump(tester);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(auth.prompts, 1);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('an unavailable device lock explains itself', (tester) async {
    await pump(tester);
    auth.available = false;
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.textContaining('Set up a fingerprint'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
  });

  testWidgets('clearing the cache confirms, then empties both caches', (
    tester,
  ) async {
    await pump(tester);
    await config.writeCachedSummaries([
      {'instanceId': 'x'},
    ]);
    await tester.tap(find.text('Clear cached data'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear'));
    await tester.pumpAndSettle();
    expect(await config.readCachedSummaries(), isEmpty);
    expect(artworkCleared, 1);
    expect(find.text('Cached data cleared.'), findsOneWidget);
  });
}

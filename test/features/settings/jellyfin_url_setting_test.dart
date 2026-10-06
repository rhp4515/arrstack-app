import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/jellyfin/jellyfin_providers.dart';
import 'package:arrstack/features/settings/widgets/jellyfin_url_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryAppPreferences prefs;

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    Map<String, String> saved = const {},
  }) async {
    prefs = InMemoryAppPreferences(saved);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: Scaffold(body: JellyfinUrlSetting())),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(
      tester.element(find.byType(JellyfinUrlSetting)),
    );
  }

  testWidgets('saves a normalised URL and shows it on the row', (tester) async {
    final container = await pump(tester);
    expect(find.textContaining('Optional'), findsOneWidget);

    await tester.tap(find.text('Jellyfin server'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '192.168.1.50:8096/');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      await prefs.readString(jellyfinUrlPreferenceKey),
      'http://192.168.1.50:8096',
    );
    expect(
      container.read(jellyfinUrlProvider).value,
      'http://192.168.1.50:8096',
    );
    expect(find.text('http://192.168.1.50:8096'), findsOneWidget);
  });

  testWidgets('rejects an address that is not http(s) and keeps the dialog', (
    tester,
  ) async {
    await pump(tester);

    await tester.tap(find.text('Jellyfin server'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'ftp://nas');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Enter an address like'), findsOneWidget);
    expect(await prefs.readString(jellyfinUrlPreferenceKey), isNull);
  });

  testWidgets('saving an empty field clears the setting', (tester) async {
    await pump(tester, saved: {jellyfinUrlPreferenceKey: 'http://nas:8096'});
    expect(find.text('http://nas:8096'), findsOneWidget);

    await tester.tap(find.text('Jellyfin server'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(await prefs.readString(jellyfinUrlPreferenceKey), isNull);
    expect(find.textContaining('Optional'), findsOneWidget);
  });
}

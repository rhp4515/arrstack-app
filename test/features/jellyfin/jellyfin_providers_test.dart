import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/jellyfin/jellyfin_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeJellyfinUrl', () {
    test('adds http:// to a bare address and drops a trailing slash', () {
      expect(
        normalizeJellyfinUrl('192.168.1.50:8096'),
        'http://192.168.1.50:8096',
      );
      expect(
        normalizeJellyfinUrl(' https://jf.example.com/ '),
        'https://jf.example.com',
      );
      expect(
        normalizeJellyfinUrl('http://nas:8096/web'),
        'http://nas:8096/web',
      );
    });

    test('rejects anything that cannot be a server address', () {
      expect(normalizeJellyfinUrl(''), isNull);
      expect(normalizeJellyfinUrl('   '), isNull);
      expect(normalizeJellyfinUrl('ftp://nas'), isNull);
      expect(normalizeJellyfinUrl('http://'), isNull);
    });
  });

  test('the URL setting saves, reloads and clears', () async {
    final prefs = InMemoryAppPreferences();
    ProviderContainer container() => ProviderContainer(
      overrides: [appPreferencesProvider.overrideWithValue(prefs)],
    );

    final first = container();
    addTearDown(first.dispose);
    expect(await first.read(jellyfinUrlProvider.future), isNull);

    await first.read(jellyfinUrlProvider.notifier).save('http://nas:8096');
    expect(first.read(jellyfinUrlProvider).value, 'http://nas:8096');

    final second = container(); // a fresh start reads what was saved
    addTearDown(second.dispose);
    expect(await second.read(jellyfinUrlProvider.future), 'http://nas:8096');

    await second.read(jellyfinUrlProvider.notifier).save(null);
    final third = container();
    addTearDown(third.dispose);
    expect(await third.read(jellyfinUrlProvider.future), isNull);
  });
}

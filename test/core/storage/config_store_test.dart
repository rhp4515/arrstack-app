// SharedPreferencesConfigStore.readCachedSummaries decode-defensive
// behavior: a shape-corrupt (but syntactically valid) stored value must
// degrade gracefully, never throw — a real bug the app can otherwise hit
// if storage ever contains {} or a list with a non-object element.

import 'package:arrstack/core/storage/config_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  SharedPreferencesConfigStore storeWithRaw(String? raw) {
    SharedPreferencesAsyncPlatform.instance = raw == null
        ? InMemorySharedPreferencesAsync.empty()
        : InMemorySharedPreferencesAsync.withData({
            'config.cachedSummaries': raw,
          });
    return SharedPreferencesConfigStore(SharedPreferencesAsync());
  }

  group('readCachedSummaries', () {
    test('returns an empty list when nothing is stored', () async {
      final store = storeWithRaw(null);

      expect(await store.readCachedSummaries(), isEmpty);
    });

    test(
      'degrades to an empty list for a malformed (non-JSON) value',
      () async {
        final store = storeWithRaw('not json');

        expect(await store.readCachedSummaries(), isEmpty);
      },
    );

    test('degrades to an empty list when the root is valid JSON but not a '
        'list (e.g. an object)', () async {
      final store = storeWithRaw('{}');

      expect(await store.readCachedSummaries(), isEmpty);
    });

    test('filters out non-object elements rather than throwing on the whole '
        'list', () async {
      final store = storeWithRaw('[{"instanceId": "radarr-1"}, 42, "x"]');

      final result = await store.readCachedSummaries();
      expect(result, hasLength(1));
      expect(result.single['instanceId'], 'radarr-1');
    });

    test('decodes a well-formed list normally', () async {
      final store = storeWithRaw('[{"instanceId": "radarr-1"}]');

      final result = await store.readCachedSummaries();
      expect(result, [
        {'instanceId': 'radarr-1'},
      ]);
    });
  });
}

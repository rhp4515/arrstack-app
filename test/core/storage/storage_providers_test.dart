import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('cachedServiceSummariesProvider', () {
    test('decodes cached summaries written to ConfigStore', () async {
      final configStore = FakeConfigStore();
      await configStore.writeCachedSummaries([
        CachedServiceSummary(
          instanceId: 'radarr-1',
          instanceName: 'Home Radarr',
          serviceType: ServiceType.radarr,
          summaryLine: '412 movies · 3 missing',
          lastFetchedAt: DateTime.utc(2026, 9, 16, 12),
        ).toJson(),
      ]);

      final container = ProviderContainer(
        overrides: [configStoreProvider.overrideWithValue(configStore)],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(result, hasLength(1));
      expect(result.single.instanceId, 'radarr-1');
    });

    test(
      'skips a corrupt entry rather than discarding the whole cache',
      () async {
        final configStore = FakeConfigStore();
        final valid = CachedServiceSummary(
          instanceId: 'radarr-1',
          instanceName: 'Home Radarr',
          serviceType: ServiceType.radarr,
          summaryLine: '412 movies',
          lastFetchedAt: DateTime.utc(2026, 9, 16, 12),
        ).toJson();
        await configStore.writeCachedSummaries([
          valid,
          <String, dynamic>{'instanceId': 'broken'},
        ]);

        final container = ProviderContainer(
          overrides: [configStoreProvider.overrideWithValue(configStore)],
        );
        addTearDown(container.dispose);

        final result = await container.read(
          cachedServiceSummariesProvider.future,
        );
        expect(result, hasLength(1));
        expect(result.single.instanceId, 'radarr-1');
      },
    );

    test('returns an empty list when nothing is cached', () async {
      final container = ProviderContainer(
        overrides: [configStoreProvider.overrideWithValue(FakeConfigStore())],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(result, isEmpty);
    });
  });
}

// selectedLibraryInstanceIdProvider: default/first fallback, a persisted
// choice when several instances exist, and selectInstance persisting the
// switcher's pick. Also covers libraryInstancesProvider and the shared
// sortLibraryItems helper.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/library/library_instance_store.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../support/fixtures.dart';

class _FakeStore implements LibraryInstanceStore {
  final saved = <ServiceType, String>{};

  @override
  Future<String?> read(ServiceType type) async => saved[type];

  @override
  Future<void> write(ServiceType type, String instanceId) async =>
      saved[type] = instanceId;
}

final _instances = [
  buildInstance(id: 'r1', name: 'Home Radarr'),
  buildInstance(id: 'r2', name: 'Harivin Radarr', isDefault: true),
  buildInstance(id: 's1', name: 'Sonarr', serviceType: ServiceType.sonarr),
];

ProviderContainer _container(_FakeStore store) {
  final container = ProviderContainer(
    overrides: [
      instancesProvider.overrideWith((ref) async => Ok(_instances)),
      libraryInstanceStoreProvider.overrideWithValue(store),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('libraryInstances lists only the requested type', () async {
    final container = _container(_FakeStore());

    final radarr = await container.read(
      libraryInstancesProvider(ServiceType.radarr).future,
    );

    expect(radarr.map((i) => i.id), ['r1', 'r2']);
  });

  test('falls back to the default instance when nothing is saved', () async {
    final container = _container(_FakeStore());

    final id = await container.read(
      selectedLibraryInstanceIdProvider(ServiceType.radarr).future,
    );

    expect(id, 'r2');
  });

  test('uses the single instance without consulting the store', () async {
    final store = _FakeStore()..saved[ServiceType.sonarr] = 'gone';
    final container = _container(store);

    final id = await container.read(
      selectedLibraryInstanceIdProvider(ServiceType.sonarr).future,
    );

    expect(id, 's1');
  });

  test('prefers a saved choice that still exists', () async {
    final store = _FakeStore()..saved[ServiceType.radarr] = 'r1';
    final container = _container(store);

    final id = await container.read(
      selectedLibraryInstanceIdProvider(ServiceType.radarr).future,
    );

    expect(id, 'r1');
  });

  test('ignores a saved choice that no longer exists', () async {
    final store = _FakeStore()..saved[ServiceType.radarr] = 'deleted';
    final container = _container(store);

    final id = await container.read(
      selectedLibraryInstanceIdProvider(ServiceType.radarr).future,
    );

    expect(id, 'r2');
  });

  test('selectInstance switches and persists the choice', () async {
    final store = _FakeStore();
    final container = _container(store);
    final provider = selectedLibraryInstanceIdProvider(ServiceType.radarr);
    final sub = container.listen(provider, (_, _) {});
    addTearDown(sub.close);
    await container.read(provider.future);

    container.read(provider.notifier).selectInstance('r1');
    await Future<void>.delayed(Duration.zero);

    expect(container.read(provider).value, 'r1');
    expect(store.saved[ServiceType.radarr], 'r1');
  });

  group('SharedPreferencesLibraryInstanceStore', () {
    test('round-trips a choice per service type', () async {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      final store = SharedPreferencesLibraryInstanceStore();

      await store.write(ServiceType.radarr, 'r1');

      expect(await store.read(ServiceType.radarr), 'r1');
      expect(await store.read(ServiceType.sonarr), isNull);
    });

    test('swallows a missing platform implementation', () async {
      SharedPreferencesAsyncPlatform.instance = null;
      final store = SharedPreferencesLibraryInstanceStore();

      await store.write(ServiceType.radarr, 'r1');

      expect(await store.read(ServiceType.radarr), isNull);
    });
  });

  group('sortLibraryItems', () {
    final items = [
      (title: 'b', added: DateTime(2024), year: 2001),
      (title: 'a', added: null, year: 2020),
      (title: 'c', added: DateTime(2025), year: null),
    ];
    List<String> titles(LibrarySort sort) => sortLibraryItems(
      items,
      sort,
      added: (i) => i.added,
      title: (i) => i.title,
      year: (i) => i.year,
    ).map((i) => i.title).toList();

    test('recently added puts undated items last', () {
      expect(titles(LibrarySort.recentlyAdded), ['c', 'b', 'a']);
    });

    test('title sorts A to Z', () {
      expect(titles(LibrarySort.title), ['a', 'b', 'c']);
    });

    test('year sorts newest first', () {
      expect(titles(LibrarySort.year), ['a', 'b', 'c']);
    });
  });
}

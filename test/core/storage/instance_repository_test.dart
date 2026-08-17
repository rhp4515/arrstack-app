// InstanceRepository CRUD (spec §5, §11): add/get/update/delete/setDefault,
// with the credential landing in SecureStore, never in ConfigStore.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';
import 'fakes.dart';

void main() {
  late FakeConfigStore configStore;
  late FakeSecureStore secureStore;
  late InstanceRepository repository;

  setUp(() {
    configStore = FakeConfigStore();
    secureStore = FakeSecureStore();
    repository = ConfigStoreInstanceRepository(configStore, secureStore);
  });

  group('list', () {
    test('returns an empty list when nothing is stored', () async {
      final result = await repository.list();

      expect(result.valueOrNull, isEmpty);
    });

    test('degrades to a ValidationError (never throws) on an unknown '
        'serviceType — e.g. a post-v1 type or a hand-edited pref', () async {
      final corrupted = {
        ...buildInstance().toJson(),
        'serviceType': 'not-a-real-type',
      };
      await configStore.writeInstances([corrupted]);

      final result = await repository.list();

      expect(result.isErr, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test(
      'degrades to a ValidationError on a malformed instance shape',
      () async {
        await configStore.writeInstances([
          <String, dynamic>{'id': 'x'},
        ]);

        final result = await repository.list();

        expect(result.isErr, isTrue);
        expect(result.errorOrNull, isA<ValidationError>());
      },
    );
  });

  group('add', () {
    test('persists a valid instance and returns it', () async {
      final instance = buildInstance();

      final result = await repository.add(instance);

      expect(result.valueOrNull, instance);
      final listed = await repository.list();
      expect(listed.valueOrNull, [instance]);
    });

    test(
      'stores the credential in SecureStore, never in ConfigStore',
      () async {
        final instance = buildInstance();
        const credential = ServiceCredential.apiKey('super-secret');

        await repository.add(instance, credential: credential);

        expect(secureStore.storedCredentials[instance.id], credential);
        final rawConfig = await configStore.readInstances();
        final serialized = rawConfig.single.toString();
        expect(serialized, isNot(contains('super-secret')));
      },
    );

    test('rejects an instance that fails validation', () async {
      final instance = buildInstance(localBaseUrl: null, remoteBaseUrl: null);

      final result = await repository.add(instance);

      expect(result.isErr, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect((await repository.list()).valueOrNull, isEmpty);
    });

    test('rejects a duplicate id', () async {
      final instance = buildInstance();
      await repository.add(instance);

      final result = await repository.add(instance);

      expect(result.isErr, isTrue);
    });

    test('clears isDefault on other instances of the same type', () async {
      final first = buildInstance(id: 'radarr-1', isDefault: true);
      final second = buildInstance(id: 'radarr-2', isDefault: true);

      await repository.add(first);
      await repository.add(second);

      final listed = (await repository.list()).valueOrNull!;
      final updatedFirst = listed.firstWhere((i) => i.id == 'radarr-1');
      final updatedSecond = listed.firstWhere((i) => i.id == 'radarr-2');
      expect(updatedFirst.isDefault, isFalse);
      expect(updatedSecond.isDefault, isTrue);
    });
  });

  group('getById', () {
    test('returns the matching instance', () async {
      final instance = buildInstance();
      await repository.add(instance);

      final result = await repository.getById(instance.id);

      expect(result.valueOrNull, instance);
    });

    test('returns NotFoundError when no instance matches', () async {
      final result = await repository.getById('missing');

      expect(result.errorOrNull, isA<NotFoundError>());
    });
  });

  group('update', () {
    test('replaces the stored instance', () async {
      final instance = buildInstance();
      await repository.add(instance);
      final renamed = instance.copyWith(name: 'Renamed');

      final result = await repository.update(renamed);

      expect(result.valueOrNull?.name, 'Renamed');
      final listed = (await repository.list()).valueOrNull!;
      expect(listed, [renamed]);
    });

    test('updates the credential when one is supplied', () async {
      final instance = buildInstance();
      await repository.add(
        instance,
        credential: const ServiceCredential.apiKey('old-key'),
      );

      await repository.update(
        instance,
        credential: const ServiceCredential.apiKey('new-key'),
      );

      expect(
        secureStore.storedCredentials[instance.id],
        const ServiceCredential.apiKey('new-key'),
      );
    });

    test(
      'leaves the existing credential untouched when none is supplied',
      () async {
        final instance = buildInstance();
        await repository.add(
          instance,
          credential: const ServiceCredential.apiKey('unchanged'),
        );

        await repository.update(instance.copyWith(name: 'New name'));

        expect(
          secureStore.storedCredentials[instance.id],
          const ServiceCredential.apiKey('unchanged'),
        );
      },
    );

    test(
      'returns NotFoundError when updating a nonexistent instance',
      () async {
        final instance = buildInstance();

        final result = await repository.update(instance);

        expect(result.errorOrNull, isA<NotFoundError>());
      },
    );

    test('rejects an update that fails validation', () async {
      final instance = buildInstance();
      await repository.add(instance);

      final result = await repository.update(
        instance.copyWith(localBaseUrl: null, remoteBaseUrl: null),
      );

      expect(result.isErr, isTrue);
    });
  });

  group('delete', () {
    test('removes the instance and its credential', () async {
      final instance = buildInstance();
      await repository.add(
        instance,
        credential: const ServiceCredential.apiKey('key'),
      );

      final result = await repository.delete(instance.id);

      expect(result.isOk, isTrue);
      expect((await repository.list()).valueOrNull, isEmpty);
      expect(secureStore.storedCredentials.containsKey(instance.id), isFalse);
    });

    test('is a no-op when the id does not exist', () async {
      final result = await repository.delete('missing');

      expect(result.isOk, isTrue);
    });
  });

  group('setDefault', () {
    test(
      'marks the target default and clears others of the same type',
      () async {
        final first = buildInstance(id: 'radarr-1', isDefault: true);
        final second = buildInstance(id: 'radarr-2');
        await repository.add(first);
        await repository.add(second);

        final result = await repository.setDefault('radarr-2');

        expect(result.valueOrNull?.isDefault, isTrue);
        final listed = (await repository.list()).valueOrNull!;
        expect(listed.firstWhere((i) => i.id == 'radarr-1').isDefault, isFalse);
        expect(listed.firstWhere((i) => i.id == 'radarr-2').isDefault, isTrue);
      },
    );

    test('does not affect instances of a different service type', () async {
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final sonarr = buildInstance(
        id: 'sonarr-1',
        serviceType: ServiceType.sonarr,
        isDefault: true,
      );
      await repository.add(radarr);
      await repository.add(sonarr);

      await repository.setDefault('radarr-1');

      final listed = (await repository.list()).valueOrNull!;
      expect(listed.firstWhere((i) => i.id == 'sonarr-1').isDefault, isTrue);
    });

    test('returns NotFoundError for an unknown id', () async {
      final result = await repository.setDefault('missing');

      expect(result.errorOrNull, isA<NotFoundError>());
    });
  });
}

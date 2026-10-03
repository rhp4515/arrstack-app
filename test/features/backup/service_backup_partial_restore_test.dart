// A restore that can't fully apply.
//
// Restore writes instances one at a time, so a failure partway leaves the
// earlier ones applied. That used to read as a plain failure, and the
// controller skipped re-reading instances on any error — so what *was*
// written stayed invisible until a restart, and the message implied
// nothing had changed.

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/features/backup/service_backup_codec.dart';
import 'package:arrstack/features/backup/service_backup_providers.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/storage/fakes.dart';

/// Delegates to a real repository, but the [failOn]th write fails.
class _FailingRepository implements InstanceRepository {
  _FailingRepository(this._inner, {required this.failOn});

  final InstanceRepository _inner;
  final int failOn;
  int _writes = 0;

  Future<Result<ServiceInstance>> _write(
    Future<Result<ServiceInstance>> Function() action,
  ) {
    _writes++;
    if (_writes == failOn) {
      return Future.value(const Err(StorageError(userMessage: 'Disk full.')));
    }
    return action();
  }

  @override
  Future<Result<ServiceInstance>> add(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) => _write(() => _inner.add(instance, credential: credential));

  @override
  Future<Result<ServiceInstance>> update(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) => _write(() => _inner.update(instance, credential: credential));

  @override
  Future<Result<List<ServiceInstance>>> list() => _inner.list();

  @override
  Future<Result<ServiceInstance>> getById(String id) => _inner.getById(id);

  @override
  Future<Result<void>> delete(String id) => _inner.delete(id);

  @override
  Future<Result<ServiceInstance>> setDefault(String id) =>
      _inner.setDefault(id);
}

ServiceInstance _radarr(String id) => ServiceInstance(
  id: id,
  name: 'Radarr $id',
  serviceType: ServiceType.radarr,
  authType: AuthType.apiKey,
  localBaseUrl: 'http://10.0.0.2:7878',
);

BackupContents _contents(List<ServiceInstance> instances) => BackupContents(
  instances: instances,
  credentials: {
    for (final i in instances) i.id: const ServiceCredential.apiKey('k'),
  },
  homeSsids: const [],
  skippedCount: 0,
);

void main() {
  late FakeConfigStore config;
  late FakeSecureStore secure;

  setUp(() {
    config = FakeConfigStore();
    secure = FakeSecureStore();
  });

  ServiceBackupService service({int failOn = 0}) => ServiceBackupService(
    instances: _FailingRepository(
      ConfigStoreInstanceRepository(config, secure),
      failOn: failOn,
    ),
    secureStore: secure,
    configStore: config,
    codec: const ServiceBackupCodec(iterations: 1000),
  );

  Future<List<String>> storedIds() async => [
    for (final i in await config.readInstances()) i['id']! as String,
  ];

  group('the service', () {
    test('refuses a file that lists one service twice, before writing '
        'anything', () async {
      final result = await service().restore(
        _contents([_radarr('a'), _radarr('b'), _radarr('a')]),
      );

      expect(
        (result as Err<RestoreSummary>).error.userMessage,
        allOf(contains('more than once'), contains('Radarr a')),
      );
      expect(await storedIds(), isEmpty);
    });

    test('says how many were applied when a write fails partway', () async {
      final result = await service(failOn: 3).restore(
        _contents([_radarr('a'), _radarr('b'), _radarr('c'), _radarr('d')]),
      );

      expect(
        (result as Err<RestoreSummary>).error.userMessage,
        allOf(
          contains('Restored 2 of 4'),
          contains('Radarr c'),
          contains('Disk full.'),
        ),
      );
      expect(await storedIds(), ['a', 'b'], reason: 'they were written');
    });

    test('passes a first-write failure through unchanged, since nothing was '
        'applied', () async {
      final result = await service(failOn: 1)
          .restore(_contents([_radarr('a'), _radarr('b')]));

      expect((result as Err<RestoreSummary>).error.userMessage, 'Disk full.');
      expect(await storedIds(), isEmpty);
    });
  });

  test('the controller shows instances a failed restore did write, without '
      'a restart', () async {
    final container = ProviderContainer(
      overrides: [
        configStoreProvider.overrideWithValue(config),
        secureStoreProvider.overrideWithValue(secure),
        diagnosticLogStoreProvider.overrideWithValue(
          InMemoryDiagnosticLogStore(),
        ),
        serviceBackupServiceProvider.overrideWithValue(service(failOn: 2)),
      ],
    );
    addTearDown(container.dispose);
    container.listen(serviceBackupControllerProvider, (_, _) {});

    // The UI has already read the (empty) instance list.
    expect(
      (await container.read(instancesProvider.future))
          as Ok<List<ServiceInstance>>,
      isA<Ok<List<ServiceInstance>>>().having((r) => r.value, 'value', []),
    );

    await container
        .read(serviceBackupControllerProvider.notifier)
        .restore(_contents([_radarr('a'), _radarr('b')]));

    final listed = (await container.read(
      instancesProvider.future,
    ) as Ok<List<ServiceInstance>>).value;
    expect(listed.map((i) => i.id), ['a'], reason: 'written before the fail');
    expect(
      container.read(serviceBackupControllerProvider).status!.message,
      contains('Restored 1 of 2'),
    );
  });
}

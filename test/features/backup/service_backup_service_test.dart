import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/features/backup/service_backup_codec.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/storage/fakes.dart';

void main() {
  const passphrase = 'correct horse';
  const radarr = ServiceInstance(
    id: 'r1',
    name: 'Harivin Radarr',
    serviceType: ServiceType.radarr,
    authType: AuthType.apiKey,
    localBaseUrl: 'http://192.168.1.10:7878',
    isDefault: true,
  );
  const kuma = ServiceInstance(
    id: 'k1',
    name: 'Kuma',
    serviceType: ServiceType.uptimeKuma,
    authType: AuthType.usernamePassword,
    remoteBaseUrl: 'http://nas.tail.ts.net:3001',
  );

  late FakeConfigStore config;
  late FakeSecureStore secure;
  late ServiceBackupService service;

  ServiceBackupService build(FakeConfigStore c, FakeSecureStore s) =>
      ServiceBackupService(
        instances: ConfigStoreInstanceRepository(c, s),
        secureStore: s,
        configStore: c,
        codec: const ServiceBackupCodec(iterations: 1000),
        clock: () => DateTime(2026, 9, 30),
      );

  setUp(() async {
    config = FakeConfigStore();
    secure = FakeSecureStore();
    service = build(config, secure);
    final repo = ConfigStoreInstanceRepository(config, secure);
    await repo.add(radarr, credential: const ServiceCredential.apiKey('k'));
    await repo.add(
      kuma,
      credential: const ServiceCredential.usernamePassword(
        username: 'admin',
        password: 'pw',
      ),
    );
    await config.writeHomeSsids(['HomeWifi']);
  });

  Future<String> exportText() async {
    final result = await service.export(passphrase);
    return (result as Ok<BackupExport>).value.fileText;
  }

  test('export names the file by date and counts services', () async {
    final result = await service.export(passphrase);
    final export = (result as Ok<BackupExport>).value;
    expect(export.fileName, 'arrstack-services-2026-09-30.arrbackup');
    expect(export.serviceCount, 2);
    expect(export.fileText, isNot(contains('192.168.1.10')));
  });

  test('export refuses a short passphrase', () async {
    final result = await service.export('short');
    expect(result, isA<Err<BackupExport>>());
  });

  test(
    'restores instances, credentials, and SSIDs onto a fresh device',
    () async {
      final text = await exportText();
      final freshConfig = FakeConfigStore();
      final freshSecure = FakeSecureStore();
      final fresh = build(freshConfig, freshSecure);

      expect((fresh.inspect(text) as Ok<BackupEnvelope>).value.serviceCount, 2);
      final contents =
          (await fresh.decrypt(text, passphrase) as Ok<BackupContents>).value;
      expect(contents.instances.map((i) => i.name), ['Harivin Radarr', 'Kuma']);

      final summary =
          (await fresh.restore(contents) as Ok<RestoreSummary>).value;
      expect(summary.added, 2);
      expect(summary.updated, 0);

      final restored = await ConfigStoreInstanceRepository(
        freshConfig,
        freshSecure,
      ).list();
      expect((restored as Ok<List<ServiceInstance>>).value, [radarr, kuma]);
      expect(
        freshSecure.storedCredentials['k1'],
        const ServiceCredential.usernamePassword(
          username: 'admin',
          password: 'pw',
        ),
      );
      expect(await freshConfig.readHomeSsids(), ['HomeWifi']);
    },
  );

  test(
    'restoring onto the same device replaces rather than duplicates',
    () async {
      final text = await exportText();
      final contents =
          (await service.decrypt(text, passphrase) as Ok<BackupContents>).value;
      final summary =
          (await service.restore(contents) as Ok<RestoreSummary>).value;
      expect(summary.updated, 2);
      expect(summary.added, 0);
      expect(await config.readInstances(), hasLength(2));
      expect(await config.readHomeSsids(), ['HomeWifi']);
    },
  );

  test(
    'a wrong passphrase is a validation error with a clear message',
    () async {
      final text = await exportText();
      final result = await service.decrypt(text, 'not the passphrase');
      expect(
        (result as Err<BackupContents>).error.userMessage,
        contains('Wrong passphrase'),
      );
    },
  );

  test('skips entries this version cannot read', () async {
    const codec = ServiceBackupCodec(iterations: 1000);
    final text = await codec.encode(
      payload: {
        'instances': [
          radarr.toJson(),
          {...radarr.toJson(), 'id': 'x', 'serviceType': 'lidarr'},
          {'garbage': true},
        ],
        'credentials': {'r1': const ServiceCredential.apiKey('k').toJson()},
      },
      passphrase: passphrase,
      serviceCount: 3,
      createdAt: DateTime(2026),
    );
    final contents =
        (await service.decrypt(text, passphrase) as Ok<BackupContents>).value;
    expect(contents.instances, [radarr]);
    expect(contents.skippedCount, 2);
    expect(contents.credentials['r1'], const ServiceCredential.apiKey('k'));
  });

  test('exporting with no services is refused', () async {
    final empty = build(FakeConfigStore(), FakeSecureStore());
    final result = await empty.export(passphrase);
    expect(
      (result as Err<BackupExport>).error.userMessage,
      contains('no services'),
    );
  });
}

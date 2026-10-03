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

class FakeGateway implements BackupFileGateway {
  String? sharedName;
  String? sharedText;
  bool shareCompletes = true;
  String? toPick;

  @override
  Future<bool> share({required String fileName, required String text}) async {
    sharedName = fileName;
    sharedText = text;
    return shareCompletes;
  }

  @override
  Future<String?> pickText() async => toPick;
}

void main() {
  late FakeGateway gateway;
  late ProviderContainer container;

  setUp(() async {
    gateway = FakeGateway();
    final config = FakeConfigStore();
    final secure = FakeSecureStore();
    await ConfigStoreInstanceRepository(config, secure).add(
      const ServiceInstance(
        id: 'r1',
        name: 'Radarr',
        serviceType: ServiceType.radarr,
        authType: AuthType.apiKey,
        localBaseUrl: 'http://10.0.0.2:7878',
      ),
      credential: const ServiceCredential.apiKey('k'),
    );
    container = ProviderContainer(
      overrides: [
        backupFileGatewayProvider.overrideWithValue(gateway),
        diagnosticLogStoreProvider.overrideWithValue(
          InMemoryDiagnosticLogStore(),
        ),
        serviceBackupServiceProvider.overrideWithValue(
          ServiceBackupService(
            instances: ConfigStoreInstanceRepository(config, secure),
            secureStore: secure,
            configStore: config,
            codec: const ServiceBackupCodec(iterations: 1000),
          ),
        ),
      ],
    );
    container.listen(serviceBackupControllerProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  ServiceBackupController controller() =>
      container.read(serviceBackupControllerProvider.notifier);

  test('export shares the file and reports how many services', () async {
    await controller().export('long enough');
    expect(gateway.sharedName, endsWith('.$backupFileExtension'));
    expect(gateway.sharedText, contains(backupFormatId));
    final status = container.read(serviceBackupControllerProvider).status!;
    expect(status.message, 'Saved backup for 1 service.');
    expect(status.isError, isFalse);
  });

  test('a dismissed share sheet reports nothing', () async {
    gateway.shareCompletes = false;
    await controller().export('long enough');
    expect(container.read(serviceBackupControllerProvider).status, isNull);
  });

  test('picking a non-backup file shows an error banner', () async {
    gateway.toPick = '{"hello": 1}';
    expect(await controller().pick(), isNull);
    final status = container.read(serviceBackupControllerProvider).status!;
    expect(status.isError, isTrue);
    expect(status.message, contains("isn't an ArrStack service backup"));
  });

  test('pick → decrypt → restore round trip', () async {
    await controller().export('long enough');
    gateway.toPick = gateway.sharedText;
    final picked = (await controller().pick())!;
    expect(picked.serviceCount, 1);
    final wrong = await controller().decrypt(picked, 'nope nope');
    expect(wrong, isA<Err<BackupContents>>());
    final contents = (await controller().decrypt(
      picked,
      'long enough',
    ) as Ok<BackupContents>).value;
    await controller().restore(contents);
    expect(
      container.read(serviceBackupControllerProvider).status!.message,
      'Restored 1 service.',
    );
  });
}

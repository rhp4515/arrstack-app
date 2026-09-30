import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/features/backup/service_backup_codec.dart';
import 'package:arrstack/features/backup/service_backup_page.dart';
import 'package:arrstack/features/backup/service_backup_providers.dart';
import 'package:arrstack/features/backup/service_backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/storage/fakes.dart';
import 'service_backup_controller_test.dart' show FakeGateway;

void main() {
  late FakeGateway gateway;

  Future<void> pump(WidgetTester tester, {bool withInstance = true}) async {
    gateway = FakeGateway();
    final config = FakeConfigStore();
    final secure = FakeSecureStore();
    if (withInstance) {
      await ConfigStoreInstanceRepository(config, secure).add(
        const ServiceInstance(
          id: 'r1',
          name: 'Movies',
          serviceType: ServiceType.radarr,
          authType: AuthType.apiKey,
          localBaseUrl: 'http://10.0.0.2:7878',
        ),
        credential: const ServiceCredential.apiKey('k'),
      );
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          backupFileGatewayProvider.overrideWithValue(gateway),
          configStoreProvider.overrideWithValue(config),
          secureStoreProvider.overrideWithValue(secure),
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
        child: const MaterialApp(home: ServiceBackupPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Key derivation runs on real time, which the test clock doesn't drive.
  Future<void> settleCrypto(WidgetTester tester) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();
  }

  Future<void> export(WidgetTester tester) async {
    await tester.tap(find.text('Export services'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('backup-passphrase')),
      'long enough',
    );
    await tester.enterText(
      find.byKey(const Key('backup-passphrase-confirm')),
      'long enough',
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Export'));
    await tester.pump();
    await settleCrypto(tester);
  }

  testWidgets('lists saved services as name over type', (tester) async {
    await pump(tester);
    expect(find.text('INSTANCES · 1'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('Radarr'), findsOneWidget);
  });

  testWidgets('with no services it says so and disables export', (
    tester,
  ) async {
    await pump(tester, withInstance: false);
    expect(find.text('No services configured yet.'), findsOneWidget);
    expect(
      tester
          .widget<ButtonStyleButton>(
            find.ancestor(
              of: find.text('Export services'),
              matching: find.bySubtype<ButtonStyleButton>(),
            ),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('a successful export confirms with a snackbar', (tester) async {
    await pump(tester);
    await export(tester);
    expect(find.text('Saved backup for 1 service.'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byType(ErrorCard), findsNothing);
  });

  testWidgets('a failed import shows an error card that can be dismissed', (
    tester,
  ) async {
    await pump(tester);
    gateway.toPick = '{"hello": 1}';
    await tester.tap(find.text('Import services'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorCard), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Dismiss'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorCard), findsNothing);
  });

  testWidgets('import unlocks, confirms the restore, then reports it', (
    tester,
  ) async {
    await pump(tester);
    await export(tester);
    gateway.toPick = gateway.sharedText;
    // Let the export's snackbar expire so the restore's isn't queued.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Import services'));
    await tester.pumpAndSettle();
    expect(find.text('Unlock backup'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('backup-import-passphrase')),
      'long enough',
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Unlock'));
    await tester.pump();
    await settleCrypto(tester);

    expect(find.text('Restore 1 service?'), findsOneWidget);
    expect(find.textContaining('Movies · Radarr'), findsWidgets);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Restore'));
    await tester.pump();
    await settleCrypto(tester);
    expect(find.text('Restored 1 service.'), findsOneWidget);
  });
}

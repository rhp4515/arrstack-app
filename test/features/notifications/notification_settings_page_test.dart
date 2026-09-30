import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/core/storage/storage.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_providers.dart';
import 'package:arrstack/features/notifications/notification_scheduler.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:arrstack/features/notifications/notification_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/storage/fakes.dart';

class FakeScheduler implements NotificationScheduler {
  final List<CheckFrequency> scheduled = [];
  int cancels = 0;

  @override
  Future<void> schedule(CheckFrequency frequency) async =>
      scheduled.add(frequency);

  @override
  Future<void> cancel() async => cancels++;
}

class FakeNotifier implements LocalNotifier {
  bool grant = true;

  @override
  Future<bool> requestPermission() async => grant;

  @override
  Future<void> show(AppNotification notification) async {}
}

void main() {
  late InMemoryAppPreferences prefs;
  late FakeScheduler scheduler;
  late FakeNotifier notifier;
  late FakeConfigStore config;

  setUp(() async {
    prefs = InMemoryAppPreferences();
    scheduler = FakeScheduler();
    notifier = FakeNotifier();
    config = FakeConfigStore();
    await ConfigStoreInstanceRepository(config, FakeSecureStore()).add(
      const ServiceInstance(
        id: 'r1',
        name: 'Radarr',
        serviceType: ServiceType.radarr,
        authType: AuthType.apiKey,
        localBaseUrl: 'http://10.0.0.2:7878',
      ),
    );
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPreferencesProvider.overrideWithValue(prefs),
          notificationSchedulerProvider.overrideWithValue(scheduler),
          localNotificationsProvider.overrideWithValue(notifier),
          configStoreProvider.overrideWithValue(config),
          secureStoreProvider.overrideWithValue(FakeSecureStore()),
          diagnosticLogStoreProvider.overrideWithValue(
            InMemoryDiagnosticLogStore(),
          ),
          // No real services behind these instances in a widget test.
          notificationCheckRunnerProvider.overrideWithValue(() async => 0),
        ],
        child: const MaterialApp(home: NotificationSettingsPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Switch switchFor(WidgetTester tester, String title) => tester.widget<Switch>(
    find.descendant(
      of: find.ancestor(of: find.text(title), matching: find.byType(Row)).first,
      matching: find.byType(Switch),
    ),
  );

  testWidgets('with the master switch off, every source shows off and '
      'disabled', (tester) async {
    await pump(tester);
    for (final title in [
      'Sonarr imports',
      'Radarr imports',
      'Requests and issues',
    ]) {
      final s = switchFor(tester, title);
      expect(s.value, isFalse, reason: title);
      expect(s.onChanged, isNull, reason: title);
    }
  });

  testWidgets('turning on asks permission, schedules, and enables only '
      'configured services', (tester) async {
    await pump(tester);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(scheduler.scheduled, [CheckFrequency.m30]);
    expect(await prefs.readBool(NotificationPreferenceKeys.enabled), isTrue);
    expect(switchFor(tester, 'Radarr imports').value, isTrue);
    expect(switchFor(tester, 'Sonarr imports').onChanged, isNull);
    expect(find.text('Add a Sonarr service to use this'), findsOneWidget);
    expect(find.text('Check now'), findsOneWidget);
  });

  testWidgets('groups the sources under one heading with the schedule '
      'below', (tester) async {
    await pump(tester);
    expect(find.text('SETTINGS'), findsOneWidget);
    expect(find.text('NOTIFY ME ABOUT'), findsOneWidget);
    expect(find.text('SCHEDULE'), findsOneWidget);
    expect(find.text('Check every'), findsOneWidget);
    expect(find.byType(SegmentedButton<CheckFrequency>), findsNothing);
  });

  testWidgets('a denied permission leaves notifications off', (tester) async {
    notifier.grant = false;
    await pump(tester);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(scheduler.scheduled, isEmpty);
    expect(find.textContaining('Notifications are blocked'), findsOneWidget);
    expect(await prefs.readBool(NotificationPreferenceKeys.enabled), isNull);
  });

  testWidgets('changing frequency reschedules while enabled', (tester) async {
    await prefs.writeBool(NotificationPreferenceKeys.enabled, value: true);
    await pump(tester);
    await tester.tap(find.text('30m'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2h').last);
    await tester.pumpAndSettle();
    expect(scheduler.scheduled, [CheckFrequency.h2]);
    expect(
      await prefs.readInt(NotificationPreferenceKeys.frequencyMinutes),
      120,
    );
  });

  testWidgets('turning off cancels the schedule', (tester) async {
    await prefs.writeBool(NotificationPreferenceKeys.enabled, value: true);
    await pump(tester);
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(scheduler.cancels, 1);
    expect(await prefs.readBool(NotificationPreferenceKeys.enabled), isFalse);
  });
}

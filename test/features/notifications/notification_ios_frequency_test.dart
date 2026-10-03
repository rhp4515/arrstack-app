// 'Check every' must apply on iOS too.
//
// workmanager drops `frequency` on iOS: registering submits one app
// refresh request due after `initialDelay`, and each run submits the next
// using a delay AppDelegate fixed at launch — which was a hard-coded 15
// minutes. Every iOS user got 15-minute checks whatever they picked.

import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/notifications/notification_background.dart';
import 'package:arrstack/features/notifications/notification_providers.dart';
import 'package:arrstack/features/notifications/notification_scheduler.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workmanager/workmanager.dart';

class _MockWorkmanager extends Mock implements Workmanager {}

class _Scheduler implements NotificationScheduler {
  final List<CheckFrequency> scheduled = [];

  @override
  Future<void> schedule(CheckFrequency frequency) async =>
      scheduled.add(frequency);

  @override
  Future<void> cancel() async {}
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('scheduling', () {
    late _MockWorkmanager workmanager;

    setUp(() {
      workmanager = _MockWorkmanager();
      when(
        () => workmanager.registerPeriodicTask(
          any(),
          any(),
          frequency: any(named: 'frequency'),
          initialDelay: any(named: 'initialDelay'),
          constraints: any(named: 'constraints'),
          existingWorkPolicy: any(named: 'existingWorkPolicy'),
        ),
      ).thenAnswer((_) async {});
    });

    Future<Duration?> initialDelayFor(CheckFrequency frequency) async {
      await WorkmanagerNotificationScheduler(workmanager).schedule(frequency);
      return verify(
            () => workmanager.registerPeriodicTask(
              notificationCheckTask,
              notificationCheckTask,
              frequency: frequency.interval,
              initialDelay: captureAny(named: 'initialDelay'),
              constraints: any(named: 'constraints'),
              existingWorkPolicy: any(named: 'existingWorkPolicy'),
            ),
          ).captured.single
          as Duration?;
    }

    test('on iOS, the first run waits the chosen frequency — the only '
        'timing iOS takes from a registration', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      expect(
        await initialDelayFor(CheckFrequency.h6),
        const Duration(hours: 6),
      );
    });

    test('on Android, the first run is not delayed: WorkManager applies '
        'the frequency itself', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(await initialDelayFor(CheckFrequency.h6), isNull);
    });
  });

  group('after a background run', () {
    Future<List<CheckFrequency>> resubmitted({required bool enabled}) async {
      final scheduler = _Scheduler();
      final container = ProviderContainer(
        overrides: [
          appPreferencesProvider.overrideWithValue(
            InMemoryAppPreferences({
              NotificationPreferenceKeys.enabled: enabled,
              NotificationPreferenceKeys.frequencyMinutes: 120,
            }),
          ),
          notificationSchedulerProvider.overrideWithValue(scheduler),
        ],
      );
      addTearDown(container.dispose);
      await resubmitBackgroundCheck(container);
      return scheduler.scheduled;
    }

    test('iOS re-submits with the current setting, replacing the delay '
        'fixed at launch', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      expect(await resubmitted(enabled: true), [CheckFrequency.h2]);
    });

    test('nothing is re-submitted once notifications are off', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      expect(await resubmitted(enabled: false), isEmpty);
    });

    test('Android leaves its periodic work alone', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      expect(await resubmitted(enabled: true), isEmpty);
    });
  });
}

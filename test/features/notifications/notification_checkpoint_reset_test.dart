// Turning a source back on must start it fresh.
//
// A checkpoint is "seen up to here" for one source, and it stops moving
// while that source is off. Resuming from it weeks later replays
// everything since as one burst — an unpaged `history/since` that can be
// big enough to time out, and a timeout never advances the checkpoint, so
// that source would never notify again. Each switch's off→on transition
// therefore clears the checkpoints it covers.

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_providers.dart';
import 'package:arrstack/features/notifications/notification_scheduler.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Scheduler implements NotificationScheduler {
  @override
  Future<void> schedule(CheckFrequency frequency) async {}

  @override
  Future<void> cancel() async {}
}

class _Notifier implements LocalNotifier {
  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> show(AppNotification notification) async {}
}

const _radarr = 'notifications.checkpoint.radarr.r1';
const _sonarr = 'notifications.checkpoint.sonarr.s1';
const _seerr = 'notifications.checkpoint.seerr.o1';
const _stale = '2026-06-01T00:00:00Z';

void main() {
  late InMemoryAppPreferences prefs;
  late ProviderContainer container;

  /// Preferences as a previous session left them: every source has a
  /// checkpoint, and the given switches are in the given state.
  Future<NotificationSettingsController> controllerWith({
    required bool enabled,
    bool sonarr = true,
    bool radarr = true,
    bool seerr = true,
  }) async {
    prefs = InMemoryAppPreferences({
      NotificationPreferenceKeys.enabled: enabled,
      NotificationPreferenceKeys.sonarrImports: sonarr,
      NotificationPreferenceKeys.radarrImports: radarr,
      NotificationPreferenceKeys.seerrActivity: seerr,
      _radarr: _stale,
      _sonarr: _stale,
      _seerr: _stale,
      // Not a checkpoint: must survive any reset.
      NotificationPreferenceKeys.lastRun: _stale,
    });
    container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(prefs),
        notificationSchedulerProvider.overrideWithValue(_Scheduler()),
        localNotificationsProvider.overrideWithValue(_Notifier()),
        diagnosticLogStoreProvider.overrideWithValue(
          InMemoryDiagnosticLogStore(),
        ),
        // The establishing run would rewrite checkpoints from real
        // services; there are none here, so the run is a no-op and what
        // remains afterwards is exactly what the reset left.
        notificationCheckRunnerProvider.overrideWithValue(() async => 0),
      ],
    );
    addTearDown(container.dispose);
    await container.read(notificationSettingsControllerProvider.future);
    return container.read(notificationSettingsControllerProvider.notifier);
  }

  Future<Set<String>> checkpoints() async => {
    for (final key in await prefs.keys())
      if (key.startsWith('notifications.checkpoint.')) key,
  };

  test('turning the master switch back on clears every checkpoint', () async {
    final controller = await controllerWith(enabled: false);

    await controller.setEnabled(enabled: true);

    expect(await checkpoints(), isEmpty);
    expect(
      await prefs.readString(NotificationPreferenceKeys.lastRun),
      _stale,
      reason: 'only checkpoints are reset',
    );
  });

  test('turning one source back on clears only that source', () async {
    final controller = await controllerWith(enabled: true, sonarr: false);

    await controller.setSonarrImports(value: true);

    expect(await checkpoints(), {_radarr, _seerr});
  });

  test('each source switch clears its own family', () async {
    final radarrOff = await controllerWith(enabled: true, radarr: false);
    await radarrOff.setRadarrImports(value: true);
    expect(await checkpoints(), {_sonarr, _seerr});

    final seerrOff = await controllerWith(enabled: true, seerr: false);
    await seerrOff.setSeerrActivity(value: true);
    expect(await checkpoints(), {_radarr, _sonarr});
  });

  test('an on→on call leaves checkpoints alone, so nothing that arrived '
      'since the last check is silently skipped', () async {
    final controller = await controllerWith(enabled: true);

    await controller.setSonarrImports(value: true);
    await controller.setEnabled(enabled: true);

    expect(await checkpoints(), {_radarr, _sonarr, _seerr});
  });

  test(
    'turning a source off leaves checkpoints for its turn-on to clear',
    () async {
      final controller = await controllerWith(enabled: true);

      await controller.setSonarrImports(value: false);

      expect(await checkpoints(), {_radarr, _sonarr, _seerr});
    },
  );
}

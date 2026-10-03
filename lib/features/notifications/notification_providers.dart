/// Riverpod wiring for background notifications: the settings the page
/// edits (and keeps the OS schedule in sync with), and the checker built
/// from whichever instances those settings cover.
library;

import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/features/notifications/notification_scheduler.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:arrstack/features/notifications/sources/import_history_sources.dart';
import 'package:arrstack/features/notifications/sources/seerr_activity_source.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';

@Riverpod(keepAlive: true)
LocalNotifier localNotifications(Ref ref) => PluginLocalNotifier();

@Riverpod(keepAlive: true)
NotificationScheduler notificationScheduler(Ref ref) =>
    const WorkmanagerNotificationScheduler();

/// Builds one source per configured instance that the settings enable.
/// An instance whose client can't be built (e.g. a missing credential) is
/// logged and skipped rather than failing the whole check.
Future<List<NotificationSource>> buildNotificationSources(
  Ref ref,
  NotificationSettings settings,
) async {
  final instances = switch (await ref.read(instancesProvider.future)) {
    Ok(:final value) => value,
    Err() => const <ServiceInstance>[],
  };
  final logger = ref.read(diagnosticLoggerProvider);
  final sources = <NotificationSource>[];
  for (final instance in instances) {
    try {
      switch (instance.serviceType) {
        case ServiceType.radarr when settings.radarrImports:
          sources.add(
            RadarrImportSource(
              instanceId: instance.id,
              instanceName: instance.name,
              repository: await ref.read(
                radarrRepositoryProvider(instance.id).future,
              ),
            ),
          );
        case ServiceType.sonarr when settings.sonarrImports:
          sources.add(
            SonarrImportSource(
              instanceId: instance.id,
              instanceName: instance.name,
              repository: await ref.read(
                sonarrRepositoryProvider(instance.id).future,
              ),
            ),
          );
        case ServiceType.seerr when settings.seerrActivity:
          sources.add(
            SeerrActivitySource(
              instanceId: instance.id,
              instanceName: instance.name,
              repository: await ref.read(
                seerrRepositoryProvider(instance.id).future,
              ),
            ),
          );
        default:
          break;
      }
    } on Object catch (error) {
      logger.warn(
        instance.name,
        'Skipped in notification check | ${error is AppError ? error.userMessage : error}',
      );
    }
  }
  return sources;
}

/// Runs one check with the current settings. Used by the background
/// worker, by "Check now", and right after notifications are turned on (to
/// set every source's starting point, so the first background run only
/// reports what's new from then on). Kept alive because callers invoke the
/// returned function after reading it, when an auto-disposed provider's
/// ref could already be gone.
@Riverpod(keepAlive: true)
Future<int> Function() notificationCheckRunner(Ref ref) {
  return () async {
    final prefs = ref.read(appPreferencesProvider);
    final settings = await readNotificationSettings(prefs);
    if (!settings.enabled) return 0;
    final checker = NotificationChecker(
      prefs: prefs,
      notifier: ref.read(localNotificationsProvider),
      logger: ref.read(diagnosticLoggerProvider),
      sources: await buildNotificationSources(ref, settings),
    );
    return checker.run();
  };
}

/// When the last check finished, for the settings page.
@riverpod
Future<DateTime?> notificationLastRun(Ref ref) async {
  final raw = await ref
      .watch(appPreferencesProvider)
      .readString(NotificationPreferenceKeys.lastRun);
  return raw == null ? null : DateTime.tryParse(raw)?.toLocal();
}

enum NotificationEnableResult { changed, permissionDenied, scheduleFailed }

@Riverpod(keepAlive: true)
class NotificationSettingsController extends _$NotificationSettingsController {
  @override
  Future<NotificationSettings> build() =>
      readNotificationSettings(ref.watch(appPreferencesProvider));

  Future<void> _save(NotificationSettings next) async {
    await writeNotificationSettings(ref.read(appPreferencesProvider), next);
    state = AsyncData(next);
  }

  /// The master switch: asks for notification permission on the way on,
  /// and keeps the OS schedule in step either way.
  Future<NotificationEnableResult> setEnabled({required bool enabled}) async {
    final current = await future;
    final logger = ref.read(diagnosticLoggerProvider);
    if (enabled) {
      if (!await ref.read(localNotificationsProvider).requestPermission()) {
        return NotificationEnableResult.permissionDenied;
      }
      try {
        await ref
            .read(notificationSchedulerProvider)
            .schedule(current.frequency);
      } on Object catch (error) {
        logger.error('Notifications', 'Could not schedule checks | $error');
        return NotificationEnableResult.scheduleFailed;
      }
    } else {
      try {
        await ref.read(notificationSchedulerProvider).cancel();
      } on Object catch (error) {
        logger.warn('Notifications', 'Could not cancel checks | $error');
      }
    }
    if (enabled && !current.enabled) {
      // Every source stopped being checked while this was off, so every
      // checkpoint is stale. Cleared on the way on rather than the way off
      // so a switch turned off before this rule existed is covered too.
      await clearNotificationCheckpoints(ref.read(appPreferencesProvider));
    }
    await _save(current.copyWith(enabled: enabled));
    if (enabled) {
      // Establish starting points now; errors are logged by the checker.
      await ref.read(notificationCheckRunnerProvider)();
      ref.invalidate(notificationLastRunProvider);
    }
    return NotificationEnableResult.changed;
  }

  Future<void> setSonarrImports({required bool value}) async {
    final current = await future;
    await _resetIfTurningOn(
      NotificationSourceKind.sonarr,
      wasOn: current.sonarrImports,
      turningOn: value,
    );
    await _save(current.copyWith(sonarrImports: value));
  }

  Future<void> setRadarrImports({required bool value}) async {
    final current = await future;
    await _resetIfTurningOn(
      NotificationSourceKind.radarr,
      wasOn: current.radarrImports,
      turningOn: value,
    );
    await _save(current.copyWith(radarrImports: value));
  }

  Future<void> setSeerrActivity({required bool value}) async {
    final current = await future;
    await _resetIfTurningOn(
      NotificationSourceKind.seerr,
      wasOn: current.seerrActivity,
      turningOn: value,
    );
    await _save(current.copyWith(seerrActivity: value));
  }

  /// Clears a source family's checkpoints on an off→on change only. On an
  /// on→on call it must not: that source has been checked all along, and
  /// clearing would make the next check quietly re-establish instead of
  /// posting whatever arrived since the last one.
  Future<void> _resetIfTurningOn(
    NotificationSourceKind kind, {
    required bool wasOn,
    required bool turningOn,
  }) async {
    if (turningOn && !wasOn) {
      await clearNotificationCheckpoints(
        ref.read(appPreferencesProvider),
        kind: kind,
      );
    }
  }

  Future<void> setFrequency(CheckFrequency frequency) async {
    final current = await future;
    if (current.enabled) {
      try {
        await ref.read(notificationSchedulerProvider).schedule(frequency);
      } on Object catch (error) {
        ref
            .read(diagnosticLoggerProvider)
            .error('Notifications', 'Could not reschedule checks | $error');
      }
    }
    await _save(current.copyWith(frequency: frequency));
  }

  Future<int> checkNow() async {
    final posted = await ref.read(notificationCheckRunnerProvider)();
    ref.invalidate(notificationLastRunProvider);
    return posted;
  }
}

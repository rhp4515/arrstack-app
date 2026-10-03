/// Periodic scheduling of the background notification check through
/// `workmanager` (Android WorkManager; iOS BGTaskScheduler app refresh).
library;

import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

/// The task's unique name — and on iOS its BGTaskScheduler identifier,
/// which must also appear in Info.plist's
/// `BGTaskSchedulerPermittedIdentifiers` and be registered in AppDelegate.
const String notificationCheckTask = 'dev.hraman.arrstack.notifications';

abstract interface class NotificationScheduler {
  Future<void> schedule(CheckFrequency frequency);

  Future<void> cancel();
}

/// Whether scheduling goes through iOS's BGTaskScheduler, where
/// workmanager drops `frequency`: see [WorkmanagerNotificationScheduler].
bool get schedulesWithBackgroundTasks =>
    defaultTargetPlatform == TargetPlatform.iOS;

/// On iOS, workmanager ignores `frequency`. Registering submits one app
/// refresh request, due after `initialDelay`; each run then submits the
/// next, due after the delay AppDelegate gave when the app launched. So
/// [schedule] passes the frequency as the initial delay there, and the
/// background run calls it again with the current setting (replacing the
/// plugin's request), so a change made while the app stays in memory
/// isn't undone by the delay fixed at launch. iOS still treats the delay
/// as a minimum and picks the actual time itself.
class WorkmanagerNotificationScheduler implements NotificationScheduler {
  const WorkmanagerNotificationScheduler([this._workmanager]);

  final Workmanager? _workmanager;

  Workmanager get _scheduler => _workmanager ?? Workmanager();

  @override
  Future<void> schedule(CheckFrequency frequency) {
    return _scheduler.registerPeriodicTask(
      notificationCheckTask,
      notificationCheckTask,
      frequency: frequency.interval,
      // Android runs the first check right away and then every
      // `frequency`; iOS runs only after this, so it carries the frequency.
      initialDelay: schedulesWithBackgroundTasks ? frequency.interval : null,
      // A check can't reach any service offline; don't wake up for nothing.
      constraints: Constraints(networkType: NetworkType.connected),
      // Update keeps the schedule's phase but applies a new frequency;
      // `keep` would silently ignore a frequency change.
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }

  @override
  Future<void> cancel() => _scheduler.cancelByUniqueName(notificationCheckTask);
}

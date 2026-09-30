/// Periodic scheduling of the background notification check through
/// `workmanager` (Android WorkManager; iOS BGTaskScheduler app refresh).
library;

import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:workmanager/workmanager.dart';

/// The task's unique name — and on iOS its BGTaskScheduler identifier,
/// which must also appear in Info.plist's
/// `BGTaskSchedulerPermittedIdentifiers` and be registered in AppDelegate.
const String notificationCheckTask = 'dev.hraman.arrstack.notifications';

abstract interface class NotificationScheduler {
  Future<void> schedule(CheckFrequency frequency);

  Future<void> cancel();
}

class WorkmanagerNotificationScheduler implements NotificationScheduler {
  const WorkmanagerNotificationScheduler();

  @override
  Future<void> schedule(CheckFrequency frequency) {
    return Workmanager().registerPeriodicTask(
      notificationCheckTask,
      notificationCheckTask,
      frequency: frequency.interval,
      // A check can't reach any service offline; don't wake up for nothing.
      constraints: Constraints(networkType: NetworkType.connected),
      // Update keeps the schedule's phase but applies a new frequency;
      // `keep` would silently ignore a frequency change.
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }

  @override
  Future<void> cancel() =>
      Workmanager().cancelByUniqueName(notificationCheckTask);
}

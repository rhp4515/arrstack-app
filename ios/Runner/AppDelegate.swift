import Flutter
import UIKit
import UserNotifications
import workmanager_apple

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Background notification checks (Settings → Notifications). The
    // identifier must match `notificationCheckTask` in Dart and Info.plist's
    // BGTaskSchedulerPermittedIdentifiers; the registrant gives the
    // background engine the same plugins as the app.
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    // The plugin schedules each next run this long after the last, using
    // the value given here for as long as the process lives. It used to be
    // a fixed 15 minutes, so 'Check every' did nothing on iOS. Read the
    // setting instead: SharedPreferencesAsync keeps it in the standard
    // defaults under its Dart key, `NotificationPreferenceKeys
    // .frequencyMinutes` (default 30, as in Dart). Dart also re-submits
    // with the current setting after every run, which covers a change made
    // after this launch.
    let storedMinutes = UserDefaults.standard
      .object(forKey: "notifications.frequencyMinutes") as? NSNumber
    let minutes = max(storedMinutes?.doubleValue ?? 30, 15)
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "dev.hraman.arrstack.notifications",
      earliestBeginInSeconds: NSNumber(value: minutes * 60)
    )
    // Show notifications that arrive while the app is in the foreground.
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

/// Posting notifications on the device, behind an interface so the check
/// logic is testable without the platform plugin.
library;

import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationChannel {
  mediaReady(
    'media_ready',
    'Media ready',
    'New episodes and movies after they are imported',
  ),
  seerrActivity(
    'seerr_activity',
    'Seerr activity',
    'New media requests and reported issues',
  );

  const NotificationChannel(this.id, this.name, this.description);

  final String id;
  final String name;
  final String description;
}

/// One notification to post. [key] identifies it across runs, so posting
/// the same key twice replaces rather than duplicates.
class AppNotification {
  const AppNotification({
    required this.key,
    required this.channel,
    required this.title,
    required this.body,
  });

  final String key;
  final NotificationChannel channel;
  final String title;
  final String body;

  /// A stable 31-bit id for [key] (FNV-1a). `String.hashCode` isn't
  /// guaranteed stable across isolates or app runs, and the worker runs in
  /// a fresh isolate every time.
  int get id {
    var hash = 0x811c9dc5;
    for (final unit in key.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }
}

abstract interface class LocalNotifier {
  /// Asks for permission to post notifications (Android 13+, iOS). True if
  /// granted, or if the platform doesn't ask.
  Future<bool> requestPermission();

  Future<void> show(AppNotification notification);
}

class PluginLocalNotifier implements LocalNotifier {
  PluginLocalNotifier([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested explicitly when the user turns
        // notifications on, not whenever the plugin first loads.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    await _ensureInitialized();
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.requestNotificationsPermission() ?? true;
    }
    if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await ios?.requestPermissions(alert: true, badge: true) ?? false;
    }
    return true;
  }

  @override
  Future<void> show(AppNotification notification) async {
    await _ensureInitialized();
    final channel = notification.channel;
    await _plugin.show(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          styleInformation: BigTextStyleInformation(notification.body),
        ),
        iOS: DarwinNotificationDetails(threadIdentifier: channel.id),
      ),
    );
  }
}

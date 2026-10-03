/// Background notification preferences (Settings → Notifications), stored
/// in [AppPreferences] so the background worker's isolate reads the same
/// values the settings page writes.
library;

import 'package:arrstack/core/storage/app_preferences.dart';

/// How often the background check runs. Android's WorkManager won't run
/// periodic work more often than every 15 minutes, which is why that is the
/// shortest choice.
enum CheckFrequency {
  m15(Duration(minutes: 15), '15m'),
  m30(Duration(minutes: 30), '30m'),
  h1(Duration(hours: 1), '1h'),
  h2(Duration(hours: 2), '2h'),
  h6(Duration(hours: 6), '6h'),
  h12(Duration(hours: 12), '12h');

  const CheckFrequency(this.interval, this.label);

  final Duration interval;
  final String label;

  static CheckFrequency fromMinutes(int? minutes) => values.firstWhere(
    (f) => f.interval.inMinutes == minutes,
    orElse: () => CheckFrequency.m30,
  );
}

class NotificationSettings {
  const NotificationSettings({
    this.enabled = false,
    this.sonarrImports = true,
    this.radarrImports = true,
    this.seerrActivity = true,
    this.frequency = CheckFrequency.m30,
  });

  /// Master switch. The per-source switches keep their own values while
  /// this is off, but the page shows them as off (and disabled) so what's
  /// on screen matches what will actually notify.
  final bool enabled;
  final bool sonarrImports;
  final bool radarrImports;
  final bool seerrActivity;
  final CheckFrequency frequency;

  bool get anySourceOn => sonarrImports || radarrImports || seerrActivity;

  NotificationSettings copyWith({
    bool? enabled,
    bool? sonarrImports,
    bool? radarrImports,
    bool? seerrActivity,
    CheckFrequency? frequency,
  }) => NotificationSettings(
    enabled: enabled ?? this.enabled,
    sonarrImports: sonarrImports ?? this.sonarrImports,
    radarrImports: radarrImports ?? this.radarrImports,
    seerrActivity: seerrActivity ?? this.seerrActivity,
    frequency: frequency ?? this.frequency,
  );

  @override
  bool operator ==(Object other) =>
      other is NotificationSettings &&
      other.enabled == enabled &&
      other.sonarrImports == sonarrImports &&
      other.radarrImports == radarrImports &&
      other.seerrActivity == seerrActivity &&
      other.frequency == frequency;

  @override
  int get hashCode => Object.hash(
    enabled,
    sonarrImports,
    radarrImports,
    seerrActivity,
    frequency,
  );
}

abstract final class NotificationPreferenceKeys {
  static const String enabled = 'notifications.enabled';
  static const String sonarrImports = 'notifications.sonarrImports';
  static const String radarrImports = 'notifications.radarrImports';
  static const String seerrActivity = 'notifications.seerrActivity';
  static const String frequencyMinutes = 'notifications.frequencyMinutes';
  static const String lastRun = 'notifications.lastRun';

  /// Per-source "seen up to here" marker, e.g. the newest history date a
  /// Radarr instance has already been checked for.
  static String checkpoint(String sourceId) =>
      'notifications.checkpoint.$sourceId';

  static const String _checkpointPrefix = 'notifications.checkpoint.';
}

/// The source families, as they appear at the front of a source id
/// (`radarr.<instanceId>`) and so of its checkpoint key.
enum NotificationSourceKind { radarr, sonarr, seerr }

/// Forgets every stored checkpoint for [kind], or for every source.
///
/// A checkpoint only means "seen up to here" while its source is being
/// checked. Once a source is off its checkpoint stops moving, so turning it
/// back on weeks later would resume from that old point and replay
/// everything since as one burst — the opposite of the promise that the
/// first check after turning notifications on only records where things
/// stand. Clearing it makes that first check start fresh again.
Future<void> clearNotificationCheckpoints(
  AppPreferences prefs, {
  NotificationSourceKind? kind,
}) async {
  final prefix =
      NotificationPreferenceKeys._checkpointPrefix +
      (kind == null ? '' : '${kind.name}.');
  for (final key in await prefs.keys()) {
    if (key.startsWith(prefix)) await prefs.remove(key);
  }
}

Future<NotificationSettings> readNotificationSettings(
  AppPreferences prefs,
) async {
  const defaults = NotificationSettings();
  return NotificationSettings(
    enabled:
        await prefs.readBool(NotificationPreferenceKeys.enabled) ??
        defaults.enabled,
    sonarrImports:
        await prefs.readBool(NotificationPreferenceKeys.sonarrImports) ??
        defaults.sonarrImports,
    radarrImports:
        await prefs.readBool(NotificationPreferenceKeys.radarrImports) ??
        defaults.radarrImports,
    seerrActivity:
        await prefs.readBool(NotificationPreferenceKeys.seerrActivity) ??
        defaults.seerrActivity,
    frequency: CheckFrequency.fromMinutes(
      await prefs.readInt(NotificationPreferenceKeys.frequencyMinutes),
    ),
  );
}

Future<void> writeNotificationSettings(
  AppPreferences prefs,
  NotificationSettings settings,
) async {
  await prefs.writeBool(
    NotificationPreferenceKeys.enabled,
    value: settings.enabled,
  );
  await prefs.writeBool(
    NotificationPreferenceKeys.sonarrImports,
    value: settings.sonarrImports,
  );
  await prefs.writeBool(
    NotificationPreferenceKeys.radarrImports,
    value: settings.radarrImports,
  );
  await prefs.writeBool(
    NotificationPreferenceKeys.seerrActivity,
    value: settings.seerrActivity,
  );
  await prefs.writeInt(
    NotificationPreferenceKeys.frequencyMinutes,
    settings.frequency.interval.inMinutes,
  );
}

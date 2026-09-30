/// One background notification check: ask every enabled source what's new
/// since its checkpoint, post notifications, and move the checkpoints
/// forward. Pure logic over [NotificationSource]s, so it's the same code
/// whether the worker or the "Check now" button runs it.
library;

import 'dart:async';

import 'package:arrstack/core/logging/diagnostic_logger.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';

/// What a source found since its last checkpoint.
class SourceCheck {
  const SourceCheck({required this.items, required this.checkpoint});

  /// Newest first.
  final List<SourceItem> items;

  /// Where the next check should start.
  final String checkpoint;
}

/// One new thing: an imported movie, an imported episode, a new request.
class SourceItem {
  const SourceItem({required this.key, required this.title, this.detail});

  /// Unique within the source (e.g. the history record id).
  final String key;

  /// "Dune: Part Two (2024)" / "Severance S02E03".
  final String title;

  /// Optional second line ("Bluray-1080p", "Requested by Asha").
  final String? detail;
}

abstract interface class NotificationSource {
  /// Stable id used for the checkpoint key, e.g. `radarr.<instanceId>`.
  String get id;

  /// The instance name shown in grouped notifications ("Home Radarr").
  String get instanceName;

  NotificationChannel get channel;

  /// Title for a single item ("Movie ready") and for a group of them
  /// ("3 movies ready").
  String singleTitle(SourceItem item);
  String groupTitle(int count);

  /// Everything new after [checkpoint]. With a null checkpoint (the first
  /// check after turning notifications on) a source returns no items and
  /// just establishes where "now" is, so enabling doesn't replay history.
  Future<Result<SourceCheck>> check(String? checkpoint);
}

/// More than this many new items from one source become one summary
/// notification instead of a stack of them.
const int maxIndividualNotifications = 3;

class NotificationChecker {
  NotificationChecker({
    required this._prefs,
    required this._notifier,
    required this._logger,
    required this._sources,
    DateTime Function()? clock,
    this.sourceTimeout = const Duration(seconds: 20),
  }) : _clock = clock ?? DateTime.now;

  final AppPreferences _prefs;
  final LocalNotifier _notifier;
  final DiagnosticLogger _logger;
  final List<NotificationSource> _sources;
  final DateTime Function() _clock;

  /// Per source. iOS gives a background refresh about 30 seconds in all,
  /// so sources run in parallel and a hung one is cut off.
  final Duration sourceTimeout;

  /// Runs every source; returns how many notifications were posted.
  Future<int> run() async {
    final posted = await Future.wait(_sources.map(_runSource));
    await _prefs.writeString(
      NotificationPreferenceKeys.lastRun,
      _clock().toUtc().toIso8601String(),
    );
    return posted.fold<int>(0, (sum, n) => sum + n);
  }

  Future<int> _runSource(NotificationSource source) async {
    final key = NotificationPreferenceKeys.checkpoint(source.id);
    try {
      final previous = await _prefs.readString(key);
      final result = await source.check(previous).timeout(sourceTimeout);
      switch (result) {
        case Err(:final error):
          _logger.warn(
            source.instanceName,
            'Notification check failed | ${describeError(error)}',
          );
          return 0;
        case Ok(:final value):
          final posted = previous == null
              ? 0
              : await _post(source, value.items);
          await _prefs.writeString(key, value.checkpoint);
          return posted;
      }
    } on TimeoutException {
      _logger.warn(
        source.instanceName,
        'Notification check timed out after ${sourceTimeout.inSeconds}s',
      );
      return 0;
    } on Object catch (error) {
      _logger.error(
        source.instanceName,
        'Notification check failed | ${describeError(error)}',
      );
      return 0;
    }
  }

  Future<int> _post(NotificationSource source, List<SourceItem> items) async {
    if (items.isEmpty) return 0;
    if (items.length > maxIndividualNotifications) {
      final shown = items.take(maxIndividualNotifications).map((i) => i.title);
      final more = items.length - maxIndividualNotifications;
      await _notifier.show(
        AppNotification(
          // One summary slot per source, replaced by the next summary.
          key: '${source.id}.summary',
          channel: source.channel,
          title: source.groupTitle(items.length),
          body: '${shown.join(', ')} and $more more · ${source.instanceName}',
        ),
      );
      return 1;
    }
    for (final item in items) {
      final detail = item.detail;
      await _notifier.show(
        AppNotification(
          key: '${source.id}.${item.key}',
          channel: source.channel,
          title: source.singleTitle(item),
          body: detail == null ? item.title : '${item.title}\n$detail',
        ),
      );
    }
    return items.length;
  }
}

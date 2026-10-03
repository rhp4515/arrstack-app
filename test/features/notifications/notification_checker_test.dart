import 'dart:async';

import 'package:arrstack/core/logging/diagnostic_log_store.dart';
import 'package:arrstack/core/logging/diagnostic_logger.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/notifications/local_notifier.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/features/notifications/notification_settings.dart';
import 'package:flutter_test/flutter_test.dart';

class RecordingNotifier implements LocalNotifier {
  final List<AppNotification> shown = [];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> show(AppNotification notification) async =>
      shown.add(notification);
}

class FakeSource implements NotificationSource {
  FakeSource(this.id, this.respond);

  @override
  final String id;

  final Future<Result<SourceCheck>> Function(String? checkpoint) respond;
  final List<String?> seenCheckpoints = [];

  @override
  String get instanceName => 'Home $id';

  @override
  NotificationChannel get channel => NotificationChannel.mediaReady;

  @override
  String singleTitle(SourceItem item) => 'Movie ready';

  @override
  String groupTitle(int count) => '$count movies ready';

  @override
  Future<Result<SourceCheck>> check(String? checkpoint) {
    seenCheckpoints.add(checkpoint);
    return respond(checkpoint);
  }
}

SourceItem item(int n) =>
    SourceItem(key: '$n', title: 'Movie $n', detail: 'HD');

void main() {
  late InMemoryAppPreferences prefs;
  late RecordingNotifier notifier;
  late InMemoryDiagnosticLogStore logs;

  setUp(() {
    prefs = InMemoryAppPreferences();
    notifier = RecordingNotifier();
    logs = InMemoryDiagnosticLogStore();
  });

  NotificationChecker checker(
    List<NotificationSource> sources, {
    Duration timeout = const Duration(seconds: 20),
  }) => NotificationChecker(
    prefs: prefs,
    notifier: notifier,
    logger: DiagnosticLogger(logs),
    sources: sources,
    clock: () => DateTime.utc(2026, 9, 30),
    sourceTimeout: timeout,
  );

  test('the first run only records a checkpoint', () async {
    final source = FakeSource(
      'radarr.a',
      (_) async => Ok(SourceCheck(items: [item(1)], checkpoint: 'c1')),
    );
    expect(await checker([source]).run(), 0);
    expect(notifier.shown, isEmpty);
    expect(
      await prefs.readString(NotificationPreferenceKeys.checkpoint('radarr.a')),
      'c1',
    );
    expect(
      await prefs.readString(NotificationPreferenceKeys.lastRun),
      '2026-09-30T00:00:00.000Z',
    );
  });

  test('later runs post one notification per new item', () async {
    await prefs.writeString(
      NotificationPreferenceKeys.checkpoint('radarr.a'),
      'c1',
    );
    final source = FakeSource(
      'radarr.a',
      (_) async => Ok(SourceCheck(items: [item(2), item(3)], checkpoint: 'c3')),
    );
    expect(await checker([source]).run(), 2);
    expect(source.seenCheckpoints, ['c1']);
    expect(notifier.shown.map((n) => n.title), ['Movie ready', 'Movie ready']);
    expect(notifier.shown.first.body, 'Movie 2\nHD');
    expect(notifier.shown.first.key, 'radarr.a.2');
    expect(
      await prefs.readString(NotificationPreferenceKeys.checkpoint('radarr.a')),
      'c3',
    );
  });

  test('many items from one source collapse into a summary', () async {
    await prefs.writeString(
      NotificationPreferenceKeys.checkpoint('radarr.a'),
      'c',
    );
    final source = FakeSource(
      'radarr.a',
      (_) async => Ok(
        SourceCheck(
          items: [for (var i = 0; i < 5; i++) item(i)],
          checkpoint: 'd',
        ),
      ),
    );
    expect(await checker([source]).run(), 1);
    final summary = notifier.shown.single;
    expect(summary.title, '5 movies ready');
    expect(
      summary.body,
      'Movie 0, Movie 1, Movie 2 and 2 more · Home radarr.a',
    );
  });

  test('a failing source is logged, keeps its checkpoint, and does not '
      'stop the others', () async {
    await prefs.writeString(
      NotificationPreferenceKeys.checkpoint('bad'),
      'old',
    );
    await prefs.writeString(NotificationPreferenceKeys.checkpoint('good'), 'g');
    final bad = FakeSource(
      'bad',
      (_) async => const Err(NetworkError(userMessage: 'Unreachable')),
    );
    final good = FakeSource(
      'good',
      (_) async => Ok(SourceCheck(items: [item(1)], checkpoint: 'g2')),
    );
    expect(await checker([bad, good]).run(), 1);
    expect(
      await prefs.readString(NotificationPreferenceKeys.checkpoint('bad')),
      'old',
    );
    final entry = (await logs.readAll()).single;
    expect(entry.tag, 'Home bad');
    expect(entry.message, contains('Unreachable'));
  });

  test('a hung source is cut off at the timeout', () async {
    final hung = FakeSource(
      'slow',
      (_) => Completer<Result<SourceCheck>>().future,
    );
    expect(
      await checker([hung], timeout: const Duration(milliseconds: 10)).run(),
      0,
    );
    expect((await logs.readAll()).single.message, contains('timed out'));
  });

  test('notification ids are stable and non-negative', () {
    const a = AppNotification(
      key: 'radarr.a.42',
      channel: NotificationChannel.mediaReady,
      title: 't',
      body: 'b',
    );
    const b = AppNotification(
      key: 'radarr.a.42',
      channel: NotificationChannel.seerrActivity,
      title: 'x',
      body: 'y',
    );
    expect(a.id, b.id);
    expect(a.id, isNonNegative);
    expect(
      a.id,
      isNot(
        const AppNotification(
          key: 'radarr.a.43',
          channel: NotificationChannel.mediaReady,
          title: 't',
          body: 'b',
        ).id,
      ),
    );
  });
}

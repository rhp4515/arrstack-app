import 'package:arrstack/features/library/library_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('historyEventLabel', () {
    test('maps the known Radarr/Sonarr event types', () {
      expect(historyEventLabel('grabbed'), 'Grabbed release');
      expect(
        historyEventLabel('downloadFolderImported'),
        'Imported from download folder',
      );
      expect(historyEventLabel('downloadFailed'), 'Download failed');
      expect(historyEventLabel('movieFileDeleted'), 'File deleted');
      expect(historyEventLabel('episodeFileDeleted'), 'File deleted');
      expect(historyEventLabel('movieFileRenamed'), 'File renamed');
      expect(historyEventLabel('episodeFileRenamed'), 'File renamed');
      expect(historyEventLabel('downloadIgnored'), 'Download ignored');
    });

    test('prettifies an unknown event type', () {
      expect(
        historyEventLabel('seriesFolderImported'),
        'Series folder imported',
      );
      expect(historyEventLabel('some_new_event'), 'Some new event');
      expect(historyEventLabel('unknown'), 'Unknown');
      expect(historyEventLabel(''), 'Unknown event');
    });

    test('only downloadFailed counts as a failure', () {
      expect(isFailureEvent('downloadFailed'), isTrue);
      expect(isFailureEvent('grabbed'), isFalse);
    });
  });

  group('formatHistoryDate', () {
    test('formats month, day and 12-hour time in local time', () {
      final date = DateTime(2026, 9, 20, 8, 45);
      expect(
        formatHistoryDate(date, now: DateTime(2026, 9, 30)),
        'September 20 at 8:45 AM',
      );
    });

    test('handles noon and midnight', () {
      final now = DateTime(2026, 9, 30);
      expect(
        formatHistoryDate(DateTime(2026, 1, 1, 12, 5), now: now),
        'January 1 at 12:05 PM',
      );
      expect(
        formatHistoryDate(DateTime(2026, 12, 31, 0, 0), now: now),
        'December 31 at 12:00 AM',
      );
    });

    test('adds the year when it differs from now', () {
      expect(
        formatHistoryDate(DateTime(2025, 3, 4, 21, 7), now: DateTime(2026)),
        'March 4, 2025 at 9:07 PM',
      );
    });

    test('converts a UTC date to local time', () {
      final utc = DateTime.utc(2026, 9, 20, 8, 45);
      final local = utc.toLocal();
      expect(
        formatHistoryDate(utc, now: DateTime(2026, 9, 30)),
        startsWith('September ${local.day} at '),
      );
    });
  });

  group('formatTimeLeft', () {
    test('formats minutes, hours and days', () {
      expect(formatTimeLeft('00:20:31'), '20m left');
      expect(formatTimeLeft('01:20:00'), '1h 20m left');
      expect(formatTimeLeft('03:00:10'), '3h left');
      expect(formatTimeLeft('1.02:03:04'), '1d 2h left');
      expect(formatTimeLeft('2.00:00:00'), '2d left');
      expect(formatTimeLeft('00:00:30'), 'under a minute left');
    });

    test('is null when absent or unparseable', () {
      expect(formatTimeLeft(null), isNull);
      expect(formatTimeLeft(''), isNull);
      expect(formatTimeLeft('soon'), isNull);
    });
  });

  group('queue helpers', () {
    test('queueProgress is the downloaded fraction, clamped', () {
      expect(queueProgress(100, 25), 0.75);
      expect(queueProgress(0, 0), 0);
      expect(queueProgress(100, 150), 0);
    });

    test('queueStatusLabel prettifies or defaults to Queued', () {
      expect(queueStatusLabel('downloading'), 'Downloading');
      expect(
        queueStatusLabel('downloadClientUnavailable'),
        'Download client unavailable',
      );
      expect(queueStatusLabel(null), 'Queued');
    });
  });
}

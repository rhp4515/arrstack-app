import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

SonarrCalendarEpisode _episode(int id, DateTime airDateUtc) =>
    SonarrCalendarEpisode(id: id, airDateUtc: airDateUtc);

void main() {
  group('hasPartialProgress', () {
    SonarrSeries seriesWith({required int have, required int total}) =>
        SonarrSeries(
          id: 1,
          title: 'Test Show',
          statistics: SonarrStatistics(
            episodeFileCount: have,
            totalEpisodeCount: total,
          ),
        );

    test('false when total is 0', () {
      expect(hasPartialProgress(seriesWith(have: 0, total: 0)), isFalse);
    });

    test('false when have is 0 (nothing downloaded)', () {
      expect(hasPartialProgress(seriesWith(have: 0, total: 10)), isFalse);
    });

    test('false when have equals total (fully downloaded)', () {
      expect(hasPartialProgress(seriesWith(have: 10, total: 10)), isFalse);
    });

    test('true when have is between 0 and total', () {
      expect(hasPartialProgress(seriesWith(have: 5, total: 10)), isTrue);
    });
  });

  group('nearestEpisode', () {
    final now = DateTime.utc(2026, 9, 12, 15, 0);

    test('multiple future episodes -> picks the earliest future one', () {
      final farFuture = _episode(1, now.add(const Duration(days: 10)));
      final nearFuture = _episode(2, now.add(const Duration(days: 1)));
      final midFuture = _episode(3, now.add(const Duration(days: 5)));

      final result = nearestEpisode([farFuture, nearFuture, midFuture], now);

      expect(result?.id, 2);
    });

    test('past-only list -> falls back to the most recent past episode', () {
      final oldest = _episode(1, now.subtract(const Duration(days: 10)));
      final mostRecent = _episode(2, now.subtract(const Duration(days: 1)));
      final middle = _episode(3, now.subtract(const Duration(days: 5)));

      final result = nearestEpisode([oldest, mostRecent, middle], now);

      expect(result?.id, 2);
    });

    test('empty list -> returns null', () {
      expect(nearestEpisode(const [], now), isNull);
    });
  });

  group('continueWatchingCaption', () {
    final now = DateTime(2026, 9, 12, 15, 0); // Saturday, 3 PM

    test('today, not yet aired -> hour label', () {
      final date = DateTime(2026, 9, 12, 21, 0); // 9 PM same day
      expect(continueWatchingCaption(date, now), '9 PM');
    });

    test('today, already aired -> "today"', () {
      final date = DateTime(2026, 9, 12, 9, 0); // 9 AM same day, already past
      expect(continueWatchingCaption(date, now), 'today');
    });

    test('tomorrow -> "tomorrow"', () {
      final date = DateTime(2026, 9, 13, 21, 0);
      expect(continueWatchingCaption(date, now), 'tomorrow');
    });

    test('within the next week -> "next <Weekday>"', () {
      final date = DateTime(2026, 9, 18, 21, 0); // following Friday
      expect(continueWatchingCaption(date, now), 'next Friday');
    });

    test('in the past -> relative "aired" label', () {
      final date = DateTime(2026, 9, 10, 21, 0); // 2 days ago
      expect(continueWatchingCaption(date, now), contains('ago'));
    });
  });
}

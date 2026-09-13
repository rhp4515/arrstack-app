import 'package:arrstack/features/library/continue_watching.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

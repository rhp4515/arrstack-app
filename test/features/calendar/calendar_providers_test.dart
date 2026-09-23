// calendarScheduleProvider: where the schedule window ends for movies.
//
// The window is `today` through `today + 60d`, passed to both services as
// the same `end`. Sonarr receives it as a timestamp, so its episodes stop
// at midnight on that day. Radarr movies are filtered by whole day,
// inclusively — so handing that filter `end` itself kept every movie
// released on the final day, leaving a day with movies but none of its
// episodes. These tests pin the two services to the same last day.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

/// Returns a fixed calendar, ignoring the requested range — the point is
/// what the provider keeps from what Radarr sends, and the real endpoint
/// pads its query a day each side, so extra movies are expected.
class _FakeRadarrRepository extends RadarrRepository {
  _FakeRadarrRepository(this._movies) : super(RadarrClient(Dio()));

  final List<RadarrMovie> _movies;

  @override
  Future<Result<List<RadarrMovie>>> listCalendar(
    DateTime start,
    DateTime end,
  ) async => Ok(_movies);
}

/// A movie whose digital release is [day], serialized the way Radarr sends
/// it: a date-only value at UTC midnight.
RadarrMovie _releasedOn(DateTime day, String title) => RadarrMovie(
  id: title.hashCode,
  title: title,
  digitalRelease: DateTime.utc(day.year, day.month, day.day),
);

Future<List<String>> _scheduledTitles(List<RadarrMovie> movies) async {
  final radarr = buildInstance(id: 'radarr-1', serviceType: ServiceType.radarr);
  final container = ProviderContainer(
    overrides: [
      instancesProvider.overrideWith((ref) async => Ok([radarr])),
      radarrRepositoryProvider(radarr.id)
          .overrideWith((ref) async => _FakeRadarrRepository(movies)),
    ],
  );
  addTearDown(container.dispose);

  final result = await container.read(calendarScheduleProvider.future);
  final days = (result as Ok<List<CalendarDay>>).value;
  return [
    for (final day in days)
      for (final entry in day.entries) entry.title,
  ];
}

void main() {
  // Mirrors the provider's own arithmetic: `today` is local midnight, and
  // the window's `end` is today + 60 days.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime dayOffset(int days) =>
      DateTime(today.year, today.month, today.day + days);

  test('keeps a movie released on the last day Sonarr also covers', () async {
    final titles = await _scheduledTitles([
      _releasedOn(dayOffset(59), 'last-covered-day'),
    ]);

    expect(titles, contains('last-covered-day'));
  });

  test('drops a movie released on the window-end day itself, where Sonarr '
      'has stopped — so the final day never shows movies without its '
      'episodes', () async {
    final titles = await _scheduledTitles([
      _releasedOn(dayOffset(60), 'window-end-day'),
    ]);

    expect(titles, isNot(contains('window-end-day')));
  });

  test('keeps a movie released today, the first day of the window', () async {
    final titles = await _scheduledTitles([_releasedOn(today, 'today')]);

    expect(titles, contains('today'));
  });

  test('drops a movie released yesterday, which the padded query can '
      'return but the window does not include', () async {
    final titles = await _scheduledTitles([
      _releasedOn(dayOffset(-1), 'yesterday'),
    ]);

    expect(titles, isNot(contains('yesterday')));
  });
}

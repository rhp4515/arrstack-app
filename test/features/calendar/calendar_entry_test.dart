// Verifies the pure calendar merge/group logic: episodes and movies from
// different services collapse into day buckets, sorted by day and then by
// time within each day. This is the core of the "review my schedule" feature.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry entryAt(DateTime date, {String title = 'x'}) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: title,
);

void main() {
  group('groupEntriesByDay', () {
    test('returns an empty list for no entries', () {
      expect(groupEntriesByDay([]), isEmpty);
    });

    test('buckets entries by calendar day regardless of time', () {
      final days = groupEntriesByDay([
        entryAt(DateTime(2026, 8, 12, 3)),
        entryAt(DateTime(2026, 8, 12, 22)),
        entryAt(DateTime(2026, 8, 14, 5)),
      ]);

      expect(days, hasLength(2));
      expect(days[0].date, DateTime(2026, 8, 12));
      expect(days[0].entries, hasLength(2));
      expect(days[1].date, DateTime(2026, 8, 14));
    });

    test('sorts days ascending and entries within a day by time', () {
      final days = groupEntriesByDay([
        entryAt(DateTime(2026, 8, 14, 5), title: 'later-day'),
        entryAt(DateTime(2026, 8, 12, 4, 38), title: 'ep3'),
        entryAt(DateTime(2026, 8, 12, 3), title: 'ep1'),
        entryAt(DateTime(2026, 8, 12, 3, 49), title: 'ep2'),
      ]);

      expect(days.map((d) => d.date), [
        DateTime(2026, 8, 12),
        DateTime(2026, 8, 14),
      ]);
      expect(
        days[0].entries.map((e) => e.title),
        ['ep1', 'ep2', 'ep3'],
      );
    });
  });

  group('CalendarEntry.fromSonarrEpisode', () {
    test('maps an episode with its embedded series', () {
      final entry = CalendarEntry.fromSonarrEpisode(
        SonarrCalendarEpisode(
          id: 1,
          seriesId: 9,
          seasonNumber: 4,
          episodeNumber: 1,
          title: 'Pilot',
          airDateUtc: DateTime.utc(2026, 8, 12, 7),
          series: const SonarrSeries(
            title: 'Reacher',
            network: 'Prime Video',
          ),
        ),
        instanceId: 'sonarr-1',
      );

      expect(entry, isNotNull);
      expect(entry!.kind, CalendarEntryKind.episode);
      expect(entry.title, 'Reacher');
      expect(entry.subtitle, 'Season 4, Episode 1');
      expect(entry.network, 'Prime Video');
      expect(entry.service, ServiceType.sonarr);
    });

    test('returns null when the episode has no air date', () {
      final entry = CalendarEntry.fromSonarrEpisode(
        const SonarrCalendarEpisode(
          id: 1,
          seriesId: 9,
          seasonNumber: 1,
          episodeNumber: 1,
        ),
        instanceId: 'sonarr-1',
      );
      expect(entry, isNull);
    });
  });

  group('CalendarEntry.fromRadarrMovie', () {
    test('uses the digital release date and a release label', () {
      final entry = CalendarEntry.fromRadarrMovie(
        RadarrMovie(
          title: 'Toy Story 5',
          year: 2026,
          monitored: true,
          status: 'released',
          overview: '',
          sortTitle: 'toy story 5',
          images: const [],
          tmdbId: 1,
          studio: 'Pixar',
          digitalRelease: DateTime.utc(2026, 8, 14, 0),
        ),
        instanceId: 'radarr-1',
      );

      expect(entry, isNotNull);
      expect(entry!.kind, CalendarEntryKind.movie);
      expect(entry.title, 'Toy Story 5');
      expect(entry.subtitle, 'Digital Release');
      expect(entry.network, 'Pixar');
      expect(entry.service, ServiceType.radarr);
    });

    test('returns null when the movie has no release date', () {
      final entry = CalendarEntry.fromRadarrMovie(
        const RadarrMovie(
          title: 'No Date',
          year: 2026,
          monitored: true,
          status: 'announced',
          overview: '',
          sortTitle: 'no date',
          images: [],
          tmdbId: 2,
        ),
        instanceId: 'radarr-1',
      );
      expect(entry, isNull);
    });
  });
}

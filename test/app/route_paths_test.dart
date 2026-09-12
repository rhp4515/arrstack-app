// Release-search deep links carry the episode/movie label as an encoded
// query param so the page can show a subtitle without another fetch.

import 'package:arrstack/app/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('episodeReleaseSearch builds a nested path with an encoded title', () {
    final path = RoutePaths.episodeReleaseSearch(
      'inst',
      12,
      345,
      'S01E01 · Pilot',
    );

    expect(
      path,
      '/library/sonarr/inst/series/12/episode/345/search'
      '?title=S01E01%20%C2%B7%20Pilot',
    );
  });

  test('movieReleaseSearch builds a nested path with an encoded title', () {
    final path = RoutePaths.movieReleaseSearch('inst', 99, 'Dune (2021)');

    expect(path, '/library/radarr/inst/movie/99/search?title=Dune%20(2021)');
  });

  group('Nocturne route map', () {
    test('home replaces dashboard', () {
      expect(RoutePaths.home, '/home');
    });

    test('activity replaces downloads', () {
      expect(RoutePaths.activity, '/activity');
    });

    test('sub-pages nest under /home', () {
      expect(RoutePaths.homeUptime, '/home/uptime');
      expect(RoutePaths.homeIndexers('sonarr-1'), '/home/indexers/sonarr-1');
      expect(RoutePaths.homeSettings, '/home/settings');
      expect(RoutePaths.homeAddInstance, '/home/settings/add');
      expect(RoutePaths.homeEditInstance('id-1'), '/home/settings/id-1/edit');
      expect(RoutePaths.homeDiscover, '/home/discover');
      expect(
        RoutePaths.homeDiscoverDetail(1, 'movie'),
        '/home/discover/detail/1/movie',
      );
      expect(
        RoutePaths.homeDiscoverGenre('movie', 28, 'Action'),
        '/home/discover/genre/movie/28?name=Action',
      );
    });

    test('calendar and subtitles carry over under /activity until Phase 4', () {
      expect(RoutePaths.activityCalendar, '/activity/calendar');
      expect(
        RoutePaths.activitySubtitles('bazarr-1'),
        '/activity/subtitles/bazarr-1',
      );
    });

    test('library paths are unchanged', () {
      expect(RoutePaths.library, '/library');
      expect(
        RoutePaths.movieDetail('radarr-1', 42),
        '/library/radarr/radarr-1/movie/42',
      );
    });
  });
}

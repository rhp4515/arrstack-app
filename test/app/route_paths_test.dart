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
}

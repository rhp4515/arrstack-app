/// Named route path constants for the bottom-nav shell (spec §5 features/).
library;

abstract final class RoutePaths {
  static const String dashboard = '/dashboard';
  static const String library = '/library';
  static const String calendar = '/calendar';
  static const String downloads = '/downloads';
  static const String uptime = '/uptime';
  static const String settings = '/settings';
  static const String addInstance = '/settings/add';
  static String editInstance(String id) => '/settings/$id/edit';

  static String movieDetail(String instanceId, int movieId) =>
      '/library/radarr/$instanceId/movie/$movieId';
  static String addMovie(String instanceId) =>
      '/library/radarr/$instanceId/add';

  static String seriesDetail(String instanceId, int seriesId) =>
      '/library/sonarr/$instanceId/series/$seriesId';
  static String episodeDetail(String instanceId, int seriesId, int episodeId) =>
      '/library/sonarr/$instanceId/series/$seriesId/episode/$episodeId';
  static String addSeries(String instanceId) =>
      '/library/sonarr/$instanceId/add';

  static String subtitles(String instanceId) =>
      '/dashboard/subtitles/$instanceId';
  static String indexers(String instanceId) =>
      '/dashboard/indexers/$instanceId';
  static String discover = '/discover';
  static String discoverDetail(String instanceId, int id, String type) =>
      '/discover/detail/$id/$type';
  static String discoverGenre(
    String instanceId,
    int genreId,
    String mediaType,
    String name,
  ) => '/discover/genre/$mediaType/$genreId?name=${Uri.encodeComponent(name)}';
}

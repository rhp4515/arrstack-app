/// Named route path constants for the bottom-nav shell (spec §5 features/).
library;

abstract final class RoutePaths {
  static const String dashboard = '/dashboard';
  static const String library = '/library';
  static const String downloads = '/downloads';
  static const String uptime = '/uptime';
  static const String settings = '/settings';
  static const String addInstance = '/settings/add';
  static String editInstance(String id) => '/settings/$id/edit';

  static String movieDetail(String instanceId, int movieId) =>
      '/library/radarr/$instanceId/movie/$movieId';
  static String addMovie(String instanceId) => '/library/radarr/$instanceId/add';

  static String seriesDetail(String instanceId, int seriesId) =>
      '/library/sonarr/$instanceId/series/$seriesId';
  static String addSeries(String instanceId) => '/library/sonarr/$instanceId/add';
}

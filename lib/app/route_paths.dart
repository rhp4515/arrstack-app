/// Named route path constants for the bottom-nav shell (spec §5 features/).
///
/// Route map from design_handoff_arrstack_hub/README.md ("Route map").
library;

abstract final class RoutePaths {
  static const String home = '/home';
  static const String library = '/library';
  static const String activity = '/activity';

  /// Diagnostic logs as a full-screen page above the tabs, so a shortcut
  /// (e.g. from Activity) goes back to where it came from. Settings →
  /// Advanced keeps its own [homeSettingsLogs] route.
  static const String logs = '/logs';

  static const String homeUptime = '/home/uptime';
  static String homeIndexers(String instanceId) => '/home/indexers/$instanceId';

  static const String homeSettings = '/home/settings';
  static const String homeAddInstance = '/home/settings/add';
  static String homeEditInstance(String id) => '/home/settings/$id/edit';
  static const String homeSettingsNotifications =
      '/home/settings/notifications';
  static const String homeSettingsAdvanced = '/home/settings/advanced';
  static const String homeSettingsBackup = '/home/settings/advanced/backup';
  static const String homeSettingsLogs = '/home/settings/advanced/logs';

  static String homeEinthusanImport(String instanceId) =>
      '/home/einthusan/$instanceId';

  static const String homeDiscover = '/home/discover';
  static String homeDiscoverDetail(int id, String type) =>
      '/home/discover/detail/$id/$type';
  static String homeDiscoverGenre(String mediaType, int genreId, String name) =>
      '/home/discover/genre/$mediaType/$genreId?name=${Uri.encodeComponent(name)}';

  static const String homeRequests = '/home/requests';

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

  static String episodeReleaseSearch(
    String instanceId,
    int seriesId,
    int episodeId,
    String title,
  ) =>
      '/library/sonarr/$instanceId/series/$seriesId/episode/$episodeId/search'
      '?title=${Uri.encodeComponent(title)}';

  static String movieReleaseSearch(
    String instanceId,
    int movieId,
    String title,
  ) =>
      '/library/radarr/$instanceId/movie/$movieId/search'
      '?title=${Uri.encodeComponent(title)}';
}

/// `go_router` configuration: a [StatefulShellRoute] with one branch per
/// bottom-nav tab (Home, Library, Activity), each rendering its top-level
/// feature page. Sub-pages reached from Home (Uptime, Indexers, Discover,
/// Settings) nest under the Home branch so the tab bar stays visible with
/// Home still marked active — see design_handoff_arrstack_hub/README.md
/// ("Shared shell" → bottom tab bar).
library;

import 'package:arrstack/app/app_shell.dart';
import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/calendar/calendar_page.dart';
import 'package:arrstack/features/discover/discover_detail_page.dart';
import 'package:arrstack/features/discover/discover_page.dart';
import 'package:arrstack/features/discover/genre_results_page.dart';
import 'package:arrstack/features/downloads/downloads_page.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_page.dart';
import 'package:arrstack/features/home/home_page.dart';
import 'package:arrstack/features/indexers/indexers_page.dart';
import 'package:arrstack/features/library/add_movie_page.dart';
import 'package:arrstack/features/library/add_series_page.dart';
import 'package:arrstack/features/library/episode_detail_page.dart';
import 'package:arrstack/features/library/library_page.dart';
import 'package:arrstack/features/library/movie_detail_page.dart';
import 'package:arrstack/features/library/series_detail_page.dart';
import 'package:arrstack/features/onboarding/add_instance_page.dart';
import 'package:arrstack/features/release_search/release_search_page.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:arrstack/features/subtitles/subtitles_page.dart';
import 'package:arrstack/features/uptime/uptime_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        // Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.home,
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: 'uptime',
                  builder: (context, state) => const UptimePage(),
                ),
                GoRoute(
                  path: 'indexers/:instanceId',
                  builder: (context, state) => IndexersPage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
                GoRoute(
                  path: 'einthusan/:instanceId',
                  builder: (context, state) => EinthusanImportPage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
                GoRoute(
                  path: 'discover',
                  builder: (context, state) => const DiscoverPage(),
                  routes: [
                    GoRoute(
                      path: 'detail/:id/:type',
                      builder: (context, state) => DiscoverDetailPage(
                        instanceId: '',
                        id: int.parse(state.pathParameters['id']!),
                        mediaType: state.pathParameters['type']!,
                      ),
                    ),
                    GoRoute(
                      path: 'genre/:type/:genreId',
                      builder: (context, state) => GenreResultsPage(
                        instanceId: '',
                        genreId: int.parse(state.pathParameters['genreId']!),
                        mediaType: state.pathParameters['type']!,
                        genreName: state.uri.queryParameters['name'] ?? 'Genre',
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsPage(),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => const AddInstancePage(),
                    ),
                    GoRoute(
                      path: ':id/edit',
                      builder: (context, state) => AddInstancePage(
                        instanceId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Library
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.library,
              builder: (context, state) => const LibraryPage(),
              routes: [
                GoRoute(
                  path: 'radarr/:instanceId/movie/:movieId',
                  builder: (context, state) => MovieDetailPage(
                    instanceId: state.pathParameters['instanceId']!,
                    movieId: int.parse(state.pathParameters['movieId']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'search',
                      builder: (context, state) => ReleaseSearchPage(
                        service: ServiceType.radarr,
                        instanceId: state.pathParameters['instanceId']!,
                        targetId: int.parse(state.pathParameters['movieId']!),
                        title: state.uri.queryParameters['title'] ?? 'Movie',
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'radarr/:instanceId/add',
                  builder: (context, state) => AddMoviePage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
                GoRoute(
                  path: 'sonarr/:instanceId/series/:seriesId',
                  builder: (context, state) => SeriesDetailPage(
                    instanceId: state.pathParameters['instanceId']!,
                    seriesId: int.parse(state.pathParameters['seriesId']!),
                  ),
                  routes: [
                    GoRoute(
                      path: 'episode/:episodeId',
                      builder: (context, state) => EpisodeDetailPage(
                        instanceId: state.pathParameters['instanceId']!,
                        seriesId: int.parse(state.pathParameters['seriesId']!),
                        episodeId: int.parse(
                          state.pathParameters['episodeId']!,
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: 'search',
                          builder: (context, state) => ReleaseSearchPage(
                            service: ServiceType.sonarr,
                            instanceId: state.pathParameters['instanceId']!,
                            targetId: int.parse(
                              state.pathParameters['episodeId']!,
                            ),
                            title:
                                state.uri.queryParameters['title'] ?? 'Episode',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: 'sonarr/:instanceId/add',
                  builder: (context, state) => AddSeriesPage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Activity — temporarily shows the existing Downloads page; Phase 4
        // replaces this with the lens-based Transfers/Calendar/Wanted page.
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.activity,
              builder: (context, state) => const DownloadsPage(),
              routes: [
                GoRoute(
                  path: 'calendar',
                  builder: (context, state) => const CalendarPage(),
                ),
                GoRoute(
                  path: 'subtitles/:instanceId',
                  builder: (context, state) => SubtitlesPage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

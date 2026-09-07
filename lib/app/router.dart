/// `go_router` configuration: a [StatefulShellRoute] with one branch per
/// bottom-nav tab, each rendering its top-level feature page.
library;

import 'package:arrstack/app/app_shell.dart';
import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/features/calendar/calendar_page.dart';
import 'package:arrstack/features/dashboard/dashboard_page.dart';
import 'package:arrstack/features/discover/discover_detail_page.dart';
import 'package:arrstack/features/discover/discover_page.dart';
import 'package:arrstack/features/downloads/downloads_page.dart';
import 'package:arrstack/features/indexers/indexers_page.dart';
import 'package:arrstack/features/library/add_movie_page.dart';
import 'package:arrstack/features/library/add_series_page.dart';
import 'package:arrstack/features/library/episode_detail_page.dart';
import 'package:arrstack/features/library/library_page.dart';
import 'package:arrstack/features/library/movie_detail_page.dart';
import 'package:arrstack/features/library/series_detail_page.dart';
import 'package:arrstack/features/onboarding/add_instance_page.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:arrstack/features/subtitles/subtitles_page.dart';
import 'package:arrstack/features/uptime/uptime_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.dashboard,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.dashboard,
              builder: (context, state) => const DashboardPage(),
              routes: [
                GoRoute(
                  path: 'subtitles/:instanceId',
                  builder: (context, state) => SubtitlesPage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
                GoRoute(
                  path: 'indexers/:instanceId',
                  builder: (context, state) => IndexersPage(
                    instanceId: state.pathParameters['instanceId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
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
                        episodeId: int.parse(state.pathParameters['episodeId']!),
                      ),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.calendar,
              builder: (context, state) => const CalendarPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.downloads,
              builder: (context, state) => const DownloadsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.uptime,
              builder: (context, state) => const UptimePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.discover,
              builder: (context, state) => const DiscoverPage(),
              routes: [
                GoRoute(
                  path: 'detail/:id/:type',
                  builder: (context, state) => DiscoverDetailPage(
                    instanceId: '', // Logic inside page will use provider if empty
                    id: int.parse(state.pathParameters['id']!),
                    mediaType: state.pathParameters['type']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.settings,
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
  ],
);

/// `go_router` configuration: a [StatefulShellRoute] with one branch per
/// bottom-nav tab, each rendering its top-level feature page.
library;

import 'package:arrstack/app/app_shell.dart';
import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/features/dashboard/dashboard_page.dart';
import 'package:arrstack/features/downloads/downloads_page.dart';
import 'package:arrstack/features/library/library_page.dart';
import 'package:arrstack/features/onboarding/add_instance_page.dart';
import 'package:arrstack/features/settings/settings_page.dart';
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
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.library,
              builder: (context, state) => const LibraryPage(),
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

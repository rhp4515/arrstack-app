import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:arrstack/features/home/widgets/offline_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/fixtures.dart';

void main() {
  testWidgets(
    'shows the error card and omits the LAST KNOWN block when the cache '
    'is empty',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text('Tailscale looks disconnected'), findsOneWidget);
      expect(find.textContaining('LAST KNOWN'), findsNothing);
      expect(find.byType(CachedSummaryRow), findsNothing);
    },
  );

  testWidgets('shows the LAST KNOWN kicker using the oldest cached timestamp', (
    tester,
  ) async {
    final now = DateTime.now();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedServiceSummariesProvider.overrideWith(
            (ref) async => [
              CachedServiceSummary(
                instanceId: 'radarr-1',
                instanceName: 'Home Radarr',
                serviceType: ServiceType.radarr,
                summaryLine: '412 movies',
                lastFetchedAt: now.subtract(const Duration(minutes: 6)),
              ),
              CachedServiceSummary(
                instanceId: 'bazarr-1',
                instanceName: 'Home Bazarr',
                serviceType: ServiceType.bazarr,
                summaryLine: '4 wanted subtitles',
                lastFetchedAt: now.subtract(const Duration(minutes: 2)),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: HomeOfflineState()),
      ),
    );
    await tester.pump();

    expect(find.text('LAST KNOWN · 6 MIN AGO'), findsOneWidget);
    expect(find.byType(CachedSummaryRow), findsNWidgets(2));
  });

  testWidgets(
    'excludes a cached entry for an instance that no longer exists, both '
    'from the rendered rows and the staleness calculation',
    (tester) async {
      final now = DateTime.now();
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([radarr])),
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => [
                CachedServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: 'Home Radarr',
                  serviceType: ServiceType.radarr,
                  summaryLine: '412 movies',
                  lastFetchedAt: now.subtract(const Duration(minutes: 3)),
                ),
                // Orphaned: no longer present in instancesProvider. Its
                // ancient timestamp would otherwise dominate the staleness
                // kicker and it would render as a phantom row.
                CachedServiceSummary(
                  instanceId: 'sonarr-deleted',
                  instanceName: 'Deleted Sonarr',
                  serviceType: ServiceType.sonarr,
                  summaryLine: '99 series',
                  lastFetchedAt: now.subtract(const Duration(days: 30)),
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('LAST KNOWN · 3 MIN AGO'), findsOneWidget);
      expect(find.byType(CachedSummaryRow), findsOneWidget);
      expect(find.text('Home Radarr'), findsOneWidget);
      expect(find.text('Deleted Sonarr'), findsNothing);
    },
  );

  testWidgets(
    'shows neutral copy instead of blaming Tailscale when the failures are '
    'not network errors (e.g. bad credentials)',
    (tester) async {
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => [
                HomeServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: radarr.name,
                  serviceType: ServiceType.radarr,
                  isReachable: false,
                  summaryLine: 'Unreachable',
                  statusLabel: 'Unreachable',
                  lastError: const AuthError(),
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text("Couldn't reach your services"), findsOneWidget);
      expect(find.text('Check settings'), findsOneWidget);
      expect(find.text('Tailscale looks disconnected'), findsNothing);
      expect(find.text('Open Tailscale'), findsNothing);
    },
  );

  testWidgets('still shows the generic Tailscale copy when the timeouts '
      'were not against tailnet addresses', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedServiceSummariesProvider.overrideWith((ref) async => const []),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              const HomeServiceSummary(
                instanceId: 'radarr-1',
                instanceName: 'Home Radarr',
                serviceType: ServiceType.radarr,
                isReachable: false,
                summaryLine: 'Unreachable',
                statusLabel: 'Unreachable',
                lastError: NetworkError(isTimeout: true),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: HomeOfflineState()),
      ),
    );
    await tester.pump();

    expect(find.text('Tailscale looks disconnected'), findsOneWidget);
  });

  testWidgets(
    'calls out unresolvable host names separately from timeouts: nothing '
    'was dialled, so "timed out" would be the wrong advice',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [
                HomeServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: 'Home Radarr',
                  serviceType: ServiceType.radarr,
                  isReachable: false,
                  summaryLine: 'Unreachable',
                  statusLabel: 'Unreachable',
                  lastError: NetworkError(isDnsFailure: true),
                ),
                HomeServiceSummary(
                  instanceId: 'sonarr-1',
                  instanceName: 'Home Sonarr',
                  serviceType: ServiceType.sonarr,
                  isReachable: false,
                  summaryLine: 'Unreachable',
                  statusLabel: 'Unreachable',
                  lastError: NetworkError(isDnsFailure: true),
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text("Can't resolve your services"), findsOneWidget);
      expect(find.text('Tailscale looks disconnected'), findsNothing);
      // Still a Tailscale problem, so the Tailscale action stays.
      expect(find.text('Open Tailscale'), findsOneWidget);
    },
  );

  testWidgets(
    'keeps the timeout copy when only some failures were DNS failures',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [
                HomeServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: 'Home Radarr',
                  serviceType: ServiceType.radarr,
                  isReachable: false,
                  summaryLine: 'Unreachable',
                  statusLabel: 'Unreachable',
                  lastError: NetworkError(isDnsFailure: true),
                ),
                HomeServiceSummary(
                  instanceId: 'sonarr-1',
                  instanceName: 'Home Sonarr',
                  serviceType: ServiceType.sonarr,
                  isReachable: false,
                  summaryLine: 'Unreachable',
                  statusLabel: 'Unreachable',
                  lastError: NetworkError(isTimeout: true),
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text('Tailscale looks disconnected'), findsOneWidget);
    },
  );

  testWidgets('names split tunneling when every timeout was against a tailnet '
      'address: the tunnel is up but not carrying this app', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedServiceSummariesProvider.overrideWith((ref) async => const []),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => const [
              HomeServiceSummary(
                instanceId: 'radarr-1',
                instanceName: 'Home Radarr',
                serviceType: ServiceType.radarr,
                isReachable: false,
                summaryLine: 'Unreachable',
                statusLabel: 'Unreachable',
                lastError: NetworkError(isTimeout: true, isTailnetTarget: true),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: HomeOfflineState()),
      ),
    );
    await tester.pump();

    expect(find.text("Tailscale isn't carrying this app"), findsOneWidget);
    expect(find.textContaining('split tunneling'), findsOneWidget);
    expect(find.text('Tailscale looks disconnected'), findsNothing);
    // Still a Tailscale problem, so the Tailscale action stays.
    expect(find.text('Open Tailscale'), findsOneWidget);
  });

  testWidgets(
    'does not claim a timeout for a connection that failed without one: '
    'a refused connection points at a stopped service, not the tunnel',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [
                HomeServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: 'Home Radarr',
                  serviceType: ServiceType.radarr,
                  isReachable: false,
                  summaryLine: 'Unreachable',
                  statusLabel: 'Unreachable',
                  // Neither a timeout nor a name-lookup failure: the
                  // host answered and refused.
                  lastError: NetworkError(),
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text("Couldn't connect to your services"), findsOneWidget);
      expect(find.text('Tailscale looks disconnected'), findsNothing);
      expect(find.textContaining('timed out'), findsNothing);
      expect(find.text('Check settings'), findsOneWidget);
    },
  );

  testWidgets('keeps the Tailscale copy when a refused connection is mixed '
      'with a real timeout', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedServiceSummariesProvider.overrideWith((ref) async => const []),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => const [
              HomeServiceSummary(
                instanceId: 'radarr-1',
                instanceName: 'Home Radarr',
                serviceType: ServiceType.radarr,
                isReachable: false,
                summaryLine: 'Unreachable',
                statusLabel: 'Unreachable',
                lastError: NetworkError(),
              ),
              HomeServiceSummary(
                instanceId: 'sonarr-1',
                instanceName: 'Home Sonarr',
                serviceType: ServiceType.sonarr,
                isReachable: false,
                summaryLine: 'Unreachable',
                statusLabel: 'Unreachable',
                lastError: NetworkError(isTimeout: true),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: HomeOfflineState()),
      ),
    );
    await tester.pump();

    expect(find.text('Tailscale looks disconnected'), findsOneWidget);
  });

  testWidgets('adds the device top inset to its internal padding, so the gear '
      'button clears a status bar/notch', (tester) async {
    const topInset = 40.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedServiceSummariesProvider.overrideWith((ref) async => const []),
        ],
        child: const MediaQuery(
          data: MediaQueryData(padding: EdgeInsets.only(top: topInset)),
          child: MaterialApp(home: HomeOfflineState()),
        ),
      ),
    );
    await tester.pump();

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(OfflineBand),
            matching: find.byType(Container),
          )
          .first,
    );
    final padding = container.padding! as EdgeInsets;
    expect(padding.top, AppSpacing.space6 + topInset);
  });
}

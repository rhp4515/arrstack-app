import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
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
}

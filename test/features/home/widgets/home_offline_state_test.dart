import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

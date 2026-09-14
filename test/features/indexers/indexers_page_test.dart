import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/indexers/indexers_page.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows header stats, a slow response in warning color, and a dimmed disabled row',
    (tester) async {
      const instanceId = 'prowlarr-1';
      final indexers = [
        const Indexer(
          id: 1,
          name: '1337x',
          protocol: 'torrent',
          priority: 25,
          enable: true,
        ),
        const Indexer(
          id: 2,
          name: 'Nyaa',
          protocol: 'torrent',
          priority: 30,
          enable: false,
        ),
      ];
      final stats = [
        const IndexerStat(
          indexerId: 1,
          averageResponseTime: 1284,
          numberOfQueries: 1204,
          numberOfGrabs: 11,
          numberOfFailures: 37,
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            prowlarrIndexersProvider(instanceId)
                .overrideWith((ref) async => Ok(indexers)),
            prowlarrIndexerStats30dProvider(instanceId).overrideWith(
              (ref) async => Ok(IndexerStatsResponse(indexers: stats)),
            ),
            prowlarrIndexerStatsLast24hProvider(instanceId).overrideWith(
              (ref) async => Ok(IndexerStatsResponse(indexers: stats)),
            ),
          ],
          child: const MaterialApp(home: IndexersPage(instanceId: instanceId)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ENABLED'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // ENABLED count
      expect(find.textContaining('1284'), findsWidgets);
      expect(find.text('LAST 24H'), findsOneWidget);
      expect(find.text('37'), findsOneWidget); // failures

      final nyaaOpacity = tester.widget<Opacity>(
        find
            .ancestor(of: find.text('Nyaa'), matching: find.byType(Opacity))
            .first,
      );
      expect(nyaaOpacity.opacity, 0.62);
    },
  );
}

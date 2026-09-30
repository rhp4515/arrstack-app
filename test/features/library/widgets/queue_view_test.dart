import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/queue_view.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Future<Result<List<RadarrQueueItem>>> Function() queue) =>
    ProviderScope(
      overrides: [
        radarrMoviesProvider('r1').overrideWith(
          (ref) async => const Ok([RadarrMovie(id: 7, title: 'Dune')]),
        ),
        radarrQueueProvider('r1').overrideWith((ref) => queue()),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: LibraryQueueView(type: ServiceType.radarr, instanceId: 'r1'),
        ),
      ),
    );

void main() {
  testWidgets('shows a spinner while loading', (tester) async {
    final pending = Completer<Result<List<RadarrQueueItem>>>();
    await tester.pumpWidget(_host(() => pending.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an empty state when nothing is queued', (tester) async {
    await tester.pumpWidget(_host(() async => const Ok([])));
    await tester.pump();
    await tester.pump();

    expect(find.text('Queue is empty'), findsOneWidget);
  });

  testWidgets('shows the error with Retry', (tester) async {
    await tester.pumpWidget(
      _host(() async => const Err(NetworkError(userMessage: 'Offline'))),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text("Couldn't load the queue"), findsOneWidget);
    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('shows title, status, percent and time left', (tester) async {
    await tester.pumpWidget(
      _host(
        () async => const Ok([
          RadarrQueueItem(
            id: 1,
            movieId: 7,
            title: 'Dune.2021.2160p-GRP',
            status: 'downloading',
            size: 200,
            sizeleft: 50,
            timeleft: '01:05:00',
          ),
        ]),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('QUEUE · 1'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Downloading · 75% · 1h 5m left'), findsOneWidget);
    expect(find.text('Dune.2021.2160p-GRP'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}

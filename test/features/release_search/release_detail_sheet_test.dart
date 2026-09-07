// The detail sheet is the single confirmation step before a grab. Rejected
// releases get a "Force download" button; a failed grab keeps the sheet open
// and shows the error inline; a successful grab dismisses it.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/widgets/release_detail_sheet.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

ReleaseCandidate release({bool rejected = false}) => ReleaseCandidate(
  guid: 'ix-1',
  indexerId: 3,
  indexerName: 'MyIndexer',
  title: 'Show.S01E01.1080p.WEB-DL-GRP',
  sizeBytes: 2000000000,
  protocol: ReleaseProtocol.torrent,
  qualityLabel: 'WEBDL-1080p',
  qualityWeight: 6,
  ageMinutes: 120,
  isRejected: rejected,
  rejections: rejected ? const ['Wrong quality'] : const [],
  downloadAllowed: true,
  seeders: 25,
  leechers: 2,
);

Widget _host(Dio dio, ReleaseCandidate r) => ProviderScope(
  overrides: [
    sonarrRepositoryProvider('i1')
        .overrideWith((ref) async => SonarrRepository(SonarrClient(dio))),
  ],
  child: MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showReleaseDetailSheet(
            context,
            release: r,
            service: ServiceType.sonarr,
            instanceId: 'i1',
          ),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('shows release facts and a Download button', (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    await tester.pumpWidget(_host(dio, release()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('MyIndexer'), findsOneWidget);
    expect(find.text('WEBDL-1080p'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
  });

  testWidgets('rejected release shows reasons and a Force download button', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    await tester.pumpWidget(_host(dio, release(rejected: true)));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('• Wrong quality'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Force download'), findsOneWidget);
  });

  testWidgets('a failed grab keeps the sheet open with an inline error', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(dio: dio).onPost(
      'api/v3/release',
      (s) => s.reply(400, {'message': 'nope'}),
      data: {'guid': 'ix-1', 'indexerId': 3},
    );

    await tester.pumpWidget(_host(dio, release()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Download'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
    // A 400 maps to UnknownError whose default userMessage begins
    // "Something went wrong" (dio_exception_mapper), rendered inline.
    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });

  testWidgets('a successful grab dismisses the sheet', (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(dio: dio).onPost(
      'api/v3/release',
      (s) => s.reply(201, {}),
      data: {'guid': 'ix-1', 'indexerId': 3},
    );

    await tester.pumpWidget(_host(dio, release()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Download'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Download'), findsNothing);
  });
}

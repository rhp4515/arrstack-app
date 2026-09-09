// EinthusanImportPage renders the right step widget for each controller
// state: input, resolving, preview (candidates + empty), running, done
// (with/without a Radarr instance to deep-link to), and error.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_page.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _instanceId = 'i1';

class _FakeSelectedLibraryInstanceId extends SelectedLibraryInstanceId {
  _FakeSelectedLibraryInstanceId(this.value);

  final String? value;

  @override
  Future<String?> build(ServiceType type) async => value;
}

Widget _host(Dio dio, {String? radarrInstanceId = 'r1'}) => ProviderScope(
  overrides: [
    einthusanRepositoryProvider(_instanceId)
        .overrideWith((ref) async => EinthusanRepository(EinthusanClient(dio))),
    selectedLibraryInstanceIdProvider(ServiceType.radarr)
        .overrideWith(() => _FakeSelectedLibraryInstanceId(radarrInstanceId)),
  ],
  child: const MaterialApp(home: EinthusanImportPage(instanceId: _instanceId)),
);

void main() {
  late Dio dio;
  late DioAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
  });

  testWidgets('input step disables submit until a URL is entered', (
    tester,
  ) async {
    await tester.pumpWidget(_host(dio));

    expect(find.text('Import from Einthusan'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);

    await tester.enterText(
      find.byType(TextField),
      'https://einthusan.tv/movie/watch/abc',
    );
    await tester.pump();

    final enabledButton = tester.widget<FilledButton>(
      find.byType(FilledButton),
    );
    expect(enabledButton.onPressed, isNotNull);
  });

  testWidgets('resolving step shows a spinner while the job is created', (
    tester,
  ) async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'resolving',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }, delay: const Duration(seconds: 1)),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );

    await tester.pumpWidget(_host(dio));
    await tester.enterText(
      find.byType(TextField),
      'https://einthusan.tv/movie/watch/abc',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
    // The mocked response is delayed by a second; advance the fake clock
    // (this whole test runs inside flutter_test's internal fake_async zone)
    // instead of pumpAndSettle, which never converges once the resolving
    // step's indeterminate spinner keeps scheduling frames.
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.textContaining('Fetching page and searching TMDB'),
      findsOneWidget,
    );
  });

  testWidgets('preview step lists TMDB candidates and confirms a selection', (
    tester,
  ) async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'awaiting_verification',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        'candidates': [
          {
            'tmdb_id': 42,
            'title': 'Some Movie',
            'year': 2020,
            'tmdb_url': 'https://themoviedb.org/movie/42',
          },
          {
            'tmdb_id': 43,
            'title': 'Another Movie',
            'year': 2021,
            'tmdb_url': 'https://themoviedb.org/movie/43',
          },
        ],
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );
    adapter.onPost(
      'api/v1/jobs/job-1/download',
      (server) => server.reply(200, {
        'id': 'job-1',
        'state': 'downloading',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        'selected_tmdb_id': 43,
      }),
    );
    adapter.onPatch(
      'api/v1/jobs/job-1',
      (server) => server.reply(200, {
        'id': 'job-1',
        'state': 'awaiting_verification',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        'selected_tmdb_id': 43,
      }),
      data: {'tmdb_id': 43},
    );

    await tester.pumpWidget(_host(dio));
    await tester.enterText(
      find.byType(TextField),
      'https://einthusan.tv/movie/watch/abc',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
    await tester.pumpAndSettle();

    expect(find.text('Some Movie'), findsOneWidget);
    expect(find.text('Another Movie'), findsOneWidget);

    final confirmButtonBefore = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Confirm and download'),
    );
    expect(confirmButtonBefore.onPressed, isNull);

    await tester.tap(find.text('Another Movie'));
    await tester.pump();

    final confirmButtonAfter = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Confirm and download'),
    );
    expect(confirmButtonAfter.onPressed, isNotNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Confirm and download'));
    // Not pumpAndSettle: the downloading step's indeterminate spinner
    // animates forever and would never let it converge.
    await tester.pump(Duration.zero);
    await tester.pump(Duration.zero);

    expect(find.text('Downloading…'), findsOneWidget);
  });

  testWidgets(
    'preview step shows an empty state when there are no candidates',
    (tester) async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, {
          'id': 'job-1',
          'state': 'awaiting_verification',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        }),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );

      await tester.pumpWidget(_host(dio));
      await tester.enterText(
        find.byType(TextField),
        'https://einthusan.tv/movie/watch/abc',
      );
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
      await tester.pumpAndSettle();

      expect(find.text('No TMDB matches found'), findsOneWidget);
    },
  );

  testWidgets('done step shows the imported file and a link into Radarr', (
    tester,
  ) async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'done',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        'result': {
          'file': 'Movie.2020.mkv',
          'radarr_movie_id': 12,
          'tmdb_id': 99,
        },
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );

    await tester.pumpWidget(_host(dio));
    await tester.enterText(
      find.byType(TextField),
      'https://einthusan.tv/movie/watch/abc',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
    await tester.pumpAndSettle();

    expect(find.text('Imported successfully'), findsOneWidget);
    expect(find.text('Movie.2020.mkv'), findsOneWidget);
    expect(find.text('View in Radarr library'), findsOneWidget);
  });

  testWidgets(
    'done step hides the Radarr link when there is no default instance',
    (tester) async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, {
          'id': 'job-1',
          'state': 'done',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
          'result': {
            'file': 'Movie.2020.mkv',
            'radarr_movie_id': 12,
            'tmdb_id': 99,
          },
        }),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );

      await tester.pumpWidget(_host(dio, radarrInstanceId: null));
      await tester.enterText(
        find.byType(TextField),
        'https://einthusan.tv/movie/watch/abc',
      );
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
      await tester.pumpAndSettle();

      expect(find.text('Imported successfully'), findsOneWidget);
      expect(find.text('View in Radarr library'), findsNothing);
    },
  );

  testWidgets('error step shows the message and resets on retry', (
    tester,
  ) async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(422, {'message': 'invalid url'}),
      data: {'url': 'not-a-url'},
    );

    await tester.pumpWidget(_host(dio));
    await tester.enterText(find.byType(TextField), 'not-a-url');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
    await tester.pumpAndSettle();

    expect(find.text('Import failed'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Start over'));
    await tester.pumpAndSettle();

    expect(find.text('Import from Einthusan'), findsOneWidget);
  });
}

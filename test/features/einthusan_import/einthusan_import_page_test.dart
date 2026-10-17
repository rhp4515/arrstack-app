// EinthusanImportPage renders the right step widget for each controller
// state: input, resolving, preview (candidates + empty), running, done
// (with/without a Radarr instance to deep-link to), and error; and, under
// the input, the "Recent imports" list of tracked jobs: each state's row,
// opening a job, going back to the list, dismissing, and the unreachable
// notice.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_page.dart';
import 'package:arrstack/features/einthusan_import/einthusan_job_history_store.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _instanceId = 'i1';

class _FakeSelectedLibraryInstanceId extends SelectedLibraryInstanceId {
  _FakeSelectedLibraryInstanceId(this.value);

  final String? value;

  @override
  Future<String?> build(ServiceType type) async => value;
}

List<Override> _overrides(
  Dio dio, {
  String? radarrInstanceId = 'r1',
  EinthusanJobHistoryStore? store,
}) => [
  einthusanRepositoryProvider(_instanceId)
      .overrideWith((ref) async => EinthusanRepository(EinthusanClient(dio))),
  einthusanJobHistoryStoreProvider.overrideWithValue(
    store ?? PreferencesEinthusanJobHistoryStore(InMemoryAppPreferences()),
  ),
  selectedLibraryInstanceIdProvider(ServiceType.radarr)
      .overrideWith(() => _FakeSelectedLibraryInstanceId(radarrInstanceId)),
];

const _page = MaterialApp(home: EinthusanImportPage(instanceId: _instanceId));

Widget _host(
  Dio dio, {
  String? radarrInstanceId = 'r1',
  EinthusanJobHistoryStore? store,
}) => ProviderScope(
  overrides: _overrides(dio, radarrInstanceId: radarrInstanceId, store: store),
  child: _page,
);

EinthusanJobRecord _record(
  String id,
  JobState state, {
  String? title,
  int? year,
  String? file,
  int? radarrMovieId,
  String? errorMessage,
}) => EinthusanJobRecord(
  jobId: id,
  einthusanUrl: 'https://einthusan.tv/movie/watch/$id',
  title: title,
  year: year,
  state: state,
  file: file,
  radarrMovieId: radarrMovieId,
  errorMessage: errorMessage,
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 1),
);

Map<String, dynamic> _liveJob(
  String id,
  String state, {
  Map<String, dynamic>? extra,
}) => {
  'id': id,
  'state': state,
  'einthusan_url': 'https://einthusan.tv/movie/watch/$id',
  ...?extra,
};

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late List<Map<String, dynamic>> serverJobs;
  late bool listingDown;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    serverJobs = [];
    listingDown = false;
    adapter.onGet('api/v1/jobs', (server) {
      server.replyCallback(200, (options) {
        if (listingDown) {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'down',
          );
        }
        return serverJobs;
      });
    });
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

  group('recent imports', () {
    late PreferencesEinthusanJobHistoryStore store;

    setUp(() {
      store = PreferencesEinthusanJobHistoryStore(InMemoryAppPreferences());
    });

    testWidgets('is absent when there are no jobs', (tester) async {
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      expect(find.text('Import from Einthusan'), findsOneWidget);
      expect(find.text('RECENT IMPORTS'), findsNothing);
    });

    testWidgets('lists every state under the input, newest first', (
      tester,
    ) async {
      serverJobs = [
        _liveJob('resolving', 'resolving'),
        _liveJob(
          'verify',
          'awaiting_verification',
          extra: {
            'selected_tmdb_id': 5,
            'candidates': [
              {
                'tmdb_id': 5,
                'title': 'Verify Me',
                'year': 2005,
                'tmdb_url': 'https://themoviedb.org/movie/5',
              },
            ],
          },
        ),
        _liveJob(
          'downloading',
          'downloading',
          extra: {
            'progress': {
              'downloaded_bytes': 42,
              'total_bytes': 100,
              'percent': 42.4,
              'speed_bps': 1.0,
            },
          },
        ),
        _liveJob('importing', 'importing'),
        _liveJob(
          'done',
          'done',
          extra: {
            'result': {
              'file': 'Done.mkv',
              'radarr_movie_id': 12,
              'tmdb_id': 99,
            },
          },
        ),
        _liveJob(
          'failed',
          'error',
          extra: {
            'error': {'code': 'download_failed', 'message': 'Disk is full'},
          },
        ),
      ];
      // Known only from history: it vanished from the downloader.
      await store.write(_instanceId, [
        _record('lost', JobState.downloading, title: 'Lost Film', year: 1999),
      ]);

      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      expect(find.text('Import from Einthusan'), findsOneWidget);
      expect(find.text('RECENT IMPORTS'), findsOneWidget);

      expect(find.text('Resolving'), findsOneWidget);
      expect(find.text('Needs confirmation'), findsOneWidget);
      expect(find.text('Downloading 42%'), findsOneWidget);
      expect(find.text('Importing'), findsOneWidget);
      expect(find.text('Imported'), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
      expect(find.text('Status unknown'), findsOneWidget);

      // Title (+ year) when known, the URL otherwise.
      expect(find.text('Verify Me (2005)'), findsOneWidget);
      expect(find.text('Lost Film (1999)'), findsOneWidget);
      expect(
        find.text('https://einthusan.tv/movie/watch/resolving'),
        findsOneWidget,
      );

      // A progress bar only while downloading.
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, closeTo(0.424, 0.001));

      expect(find.text('Disk is full'), findsOneWidget);
      expect(
        find.text(
          "The downloader restarted, so this job's status is unknown. "
          'Check Radarr.',
        ),
        findsOneWidget,
      );

      // Newest first: the downloader lists oldest first, and rows only the
      // history knows follow the ones the downloader has.
      final order = [
        'https://einthusan.tv/movie/watch/failed',
        'https://einthusan.tv/movie/watch/done',
        'https://einthusan.tv/movie/watch/importing',
        'https://einthusan.tv/movie/watch/downloading',
        'Verify Me (2005)',
        'https://einthusan.tv/movie/watch/resolving',
        'Lost Film (1999)',
      ];
      final tops = [
        for (final label in order) tester.getTopLeft(find.text(label)).dy,
      ];
      expect(tops, orderedEquals([...tops]..sort()));
    });

    testWidgets('only finished and lost rows can be dismissed', (tester) async {
      serverJobs = [
        _liveJob(
          'running',
          'downloading',
          extra: {
            'progress': {
              'downloaded_bytes': 1,
              'total_bytes': 2,
              'percent': 50.0,
              'speed_bps': 1.0,
            },
          },
        ),
        _liveJob('waiting', 'awaiting_verification'),
        _liveJob(
          'finished',
          'done',
          extra: {
            'result': {'file': 'F.mkv', 'radarr_movie_id': 1, 'tmdb_id': 2},
          },
        ),
      ];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Dismiss'), findsOneWidget);
    });

    testWidgets('dismissing a row deletes the job and removes the row', (
      tester,
    ) async {
      serverJobs = [
        _liveJob(
          'failed',
          'error',
          extra: {
            'error': {'code': 'x', 'message': 'Nope'},
          },
        ),
      ];
      var deleted = false;
      adapter.onDelete('api/v1/jobs/failed', (server) {
        deleted = true;
        server.reply(204, <String, dynamic>{});
      });

      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();
      expect(find.text('Nope'), findsOneWidget);

      await tester.tap(find.byTooltip('Dismiss'));
      await tester.pumpAndSettle();

      expect(deleted, isTrue);
      expect(find.text('Nope'), findsNothing);
      expect(find.text('RECENT IMPORTS'), findsNothing);
      expect(await store.read(_instanceId), isEmpty);
    });

    testWidgets('tapping a finished row opens its step, which returns to the '
        'list', (tester) async {
      serverJobs = [
        _liveJob(
          'done',
          'done',
          extra: {
            'result': {
              'file': 'Done.mkv',
              'radarr_movie_id': 12,
              'tmdb_id': 99,
            },
          },
        ),
      ];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      // The row itself offers the Radarr link.
      expect(find.text('View in Radarr library'), findsOneWidget);

      await tester.tap(find.text('Imported'));
      await tester.pumpAndSettle();

      expect(find.text('Imported successfully'), findsOneWidget);
      expect(find.text('Done.mkv'), findsOneWidget);
      expect(find.text('View in Radarr library'), findsOneWidget);
      expect(find.text('RECENT IMPORTS'), findsNothing);

      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Import another movie'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Import from Einthusan'), findsOneWidget);
      expect(find.text('RECENT IMPORTS'), findsOneWidget);
      expect(find.text('Imported'), findsOneWidget);
    });

    testWidgets('the app bar back arrow returns from a job to the list', (
      tester,
    ) async {
      serverJobs = [
        _liveJob(
          'failed',
          'error',
          extra: {
            'error': {'code': 'x', 'message': 'Disk is full'},
          },
        ),
      ];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Failed'));
      await tester.pumpAndSettle();
      expect(find.text('Import failed'), findsOneWidget);
      expect(find.text('Disk is full'), findsOneWidget);
      expect(find.text('RECENT IMPORTS'), findsNothing);

      await tester.tap(find.byTooltip('All imports'));
      await tester.pumpAndSettle();

      expect(find.text('RECENT IMPORTS'), findsOneWidget);
      expect(find.byTooltip('All imports'), findsNothing);
    });

    testWidgets('the system back gesture returns from a job to the list', (
      tester,
    ) async {
      serverJobs = [_liveJob('running', 'importing')];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Importing'));
      await tester.pump();
      expect(find.text('RECENT IMPORTS'), findsNothing);

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.text('RECENT IMPORTS'), findsOneWidget);
    });

    testWidgets('a running job opens as the running step', (tester) async {
      serverJobs = [_liveJob('running', 'importing')];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Importing'));
      await tester.pump();

      expect(find.text('Importing into Radarr…'), findsOneWidget);
    });

    testWidgets('a job awaiting confirmation opens as the preview step', (
      tester,
    ) async {
      serverJobs = [
        _liveJob(
          'verify',
          'awaiting_verification',
          extra: {
            'candidates': [
              {
                'tmdb_id': 5,
                'title': 'Verify Me',
                'year': 2005,
                'tmdb_url': 'https://themoviedb.org/movie/5',
              },
            ],
          },
        ),
      ];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Needs confirmation'));
      await tester.pumpAndSettle();

      expect(find.text('Verify Me'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Confirm and download'),
        findsOneWidget,
      );
    });

    testWidgets('a lost job opens as an explanation of what happened', (
      tester,
    ) async {
      await store.write(_instanceId, [
        _record('lost', JobState.importing, title: 'Lost Film'),
      ]);
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lost Film'));
      await tester.pumpAndSettle();

      expect(find.text('Status unknown'), findsOneWidget);
      expect(find.textContaining('Check Radarr.'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'All imports'));
      await tester.pumpAndSettle();
      expect(find.text('RECENT IMPORTS'), findsOneWidget);
    });

    testWidgets('a finished job from history opens without the downloader', (
      tester,
    ) async {
      await store.write(_instanceId, [
        _record(
          'old',
          JobState.done,
          title: 'Old Film',
          file: 'Old.mkv',
          radarrMovieId: 3,
        ),
      ]);
      listingDown = true;
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      expect(
        find.text("Can't reach the downloader — showing last known status"),
        findsOneWidget,
      );
      expect(find.text('Old Film'), findsOneWidget);
      expect(find.text('Imported'), findsOneWidget);

      await tester.tap(find.text('Old Film'));
      await tester.pumpAndSettle();

      expect(find.text('Imported successfully'), findsOneWidget);
      expect(find.text('Old.mkv'), findsOneWidget);
      expect(find.text('View in Radarr library'), findsOneWidget);
    });

    testWidgets('an unconfirmed job from history waits for the downloader', (
      tester,
    ) async {
      await store.write(_instanceId, [
        _record('pending', JobState.awaitingVerification, title: 'Pending'),
      ]);
      listingDown = true;
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();

      expect(find.text("Can't reach the downloader"), findsOneWidget);
      expect(
        find.widgetWithText(OutlinedButton, 'All imports'),
        findsOneWidget,
      );
    });

    testWidgets('no notice while the downloader answers', (tester) async {
      serverJobs = [_liveJob('a', 'resolving')];
      await tester.pumpWidget(_host(dio, store: store));
      await tester.pumpAndSettle();

      expect(find.textContaining("Can't reach the downloader"), findsNothing);
    });

    testWidgets('a started import is still there after leaving the page', (
      tester,
    ) async {
      adapter.onPost(
        'api/v1/movies',
        (server) =>
            server.reply(201, _liveJob('job-1', 'awaiting_verification')),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );
      final container = ProviderContainer(
        overrides: _overrides(dio, store: store),
      );
      Widget host() =>
          UncontrolledProviderScope(container: container, child: _page);

      await tester.pumpWidget(host());
      await tester.enterText(
        find.byType(TextField),
        'https://einthusan.tv/movie/watch/abc',
      );
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Fetch details'));
      await tester.pumpAndSettle();
      expect(find.text('No TMDB matches found'), findsOneWidget);

      // Leave the page entirely, then come back.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: SizedBox()),
        ),
      );
      serverJobs = [_liveJob('job-1', 'awaiting_verification')];
      await tester.pumpWidget(host());
      await tester.pumpAndSettle();

      // Still on the job's step, not an empty input.
      expect(find.text('No TMDB matches found'), findsOneWidget);

      // Unmount before disposing so nothing is left polling.
      await tester.pumpWidget(const SizedBox());
      container.dispose();
    });
  });
}

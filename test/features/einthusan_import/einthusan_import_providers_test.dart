// EinthusanImportController state machine: submitUrl → resolving → preview,
// candidate selection, confirmDownload → polling → done, cancel, reset, and
// error surfacing at each step (design §"Client state machine"); plus the
// tracked-job list: restoring it from history and the downloader's listing,
// merging the two, polling one listing for every job, opening/dismissing
// jobs, and the unreachable-downloader fallback.

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_providers.dart';
import 'package:arrstack/features/einthusan_import/einthusan_job_history_store.dart';
import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:dio/dio.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _instanceId = 'i1';
const _url = 'https://einthusan.tv/movie/watch/abc';

Map<String, dynamic> _job(
  String id,
  String state, {
  String url = _url,
  Map<String, dynamic>? extra,
}) => {'id': id, 'state': state, 'einthusan_url': url, ...?extra};

Map<String, dynamic> _doneJob(String id) => _job(
  id,
  'done',
  extra: {
    'result': {'file': 'Movie.2020.mkv', 'radarr_movie_id': 12, 'tmdb_id': 99},
  },
);

Map<String, dynamic> _candidate(int id, String title, int year) => {
  'tmdb_id': id,
  'title': title,
  'year': year,
  'tmdb_url': 'https://themoviedb.org/movie/$id',
};

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
  einthusanUrl: _url,
  title: title,
  year: year,
  state: state,
  file: file,
  radarrMovieId: radarrMovieId,
  errorMessage: errorMessage,
  createdAt: DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 1),
);

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late PreferencesEinthusanJobHistoryStore store;

  // What `GET /jobs` answers; tests change it between polls.
  late List<Map<String, dynamic>> serverJobs;
  late bool listingDown;
  late int listCalls;
  Completer<void>? listingGate;

  ProviderContainer newContainer({EinthusanJobHistoryStore? historyStore}) {
    final container = ProviderContainer(
      overrides: [
        einthusanRepositoryProvider(_instanceId).overrideWith(
          (ref) async => EinthusanRepository(EinthusanClient(dio)),
        ),
        einthusanJobHistoryStoreProvider.overrideWithValue(
          historyStore ?? store,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  void stubListing(DioAdapter adapter) {
    adapter.onGet('api/v1/jobs', (server) {
      // Asynchronous so a test can hold a listing back; the snapshot is
      // taken when the request arrives, as a real server's answer would be.
      server.replyCallbackAsync(200, (options) async {
        listCalls++;
        if (listingDown) {
          throw DioException.connectionError(
            requestOptions: options,
            reason: 'down',
          );
        }
        final snapshot = [...serverJobs];
        await listingGate?.future;
        return snapshot;
      });
    });
  }

  EinthusanImportState read(ProviderContainer container) =>
      container.read(einthusanImportControllerProvider(_instanceId));

  EinthusanImportController controllerOf(ProviderContainer container) =>
      container.read(einthusanImportControllerProvider(_instanceId).notifier);

  /// Lets the build-time restore (history read, then listing) finish.
  Future<void> restored(ProviderContainer container) async {
    controllerOf(container);
    await pumpEventQueue();
  }

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    store = PreferencesEinthusanJobHistoryStore(InMemoryAppPreferences());
    serverJobs = [];
    listingDown = false;
    listCalls = 0;
    listingGate = null;
    stubListing(adapter);
  });

  group('submit and confirm', () {
    test('submitUrl tracks a resolving job and makes it active', () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, _job('job-1', 'resolving')),
        data: {'url': _url},
      );

      final container = newContainer();
      await restored(container);
      await controllerOf(container).submitUrl(_url);

      final state = read(container);
      expect(state.activeJobId, 'job-1');
      expect(state.activeJob?.job?.id, 'job-1');
      expect(state.jobs.map((tracked) => tracked.id), ['job-1']);
      expect(state.isSubmitting, isFalse);
      expect(state.lastError, isNull);

      // Remembered for the next launch.
      final saved = await store.read(_instanceId);
      expect(saved.single.jobId, 'job-1');
      expect(saved.single.state, JobState.resolving);
      expect(saved.single.einthusanUrl, _url);
    });

    test('submitUrl puts the new job above the earlier ones', () async {
      await store.write(_instanceId, [_record('old', JobState.done)]);
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, _job('job-1', 'resolving')),
        data: {'url': _url},
      );

      final container = newContainer();
      await restored(container);
      await controllerOf(container).submitUrl(_url);

      expect(read(container).jobs.map((tracked) => tracked.id), [
        'job-1',
        'old',
      ]);
    });

    test('submitUrl surfaces an Err as lastError', () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(422, {'message': 'invalid url'}),
        data: {'url': 'not-a-url'},
      );

      final container = newContainer();
      await restored(container);
      await controllerOf(container).submitUrl('not-a-url');

      final state = read(container);
      expect(state.activeJob, isNull);
      expect(state.jobs, isEmpty);
      expect(state.lastError, isA<AppError>());
      expect(state.isSubmitting, isFalse);
      expect(await store.read(_instanceId), isEmpty);
    });

    test('selectCandidate updates selectedTmdbId locally', () async {
      final container = newContainer();
      await restored(container);

      controllerOf(container).selectCandidate(42);

      expect(read(container).selectedTmdbId, 42);
    });

    test('confirmDownload patches the candidate then starts the download and '
        'remembers the chosen title', () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(
          201,
          _job(
            'job-1',
            'awaiting_verification',
            extra: {
              'selected_tmdb_id': 1,
              'candidates': [
                _candidate(1, 'First Movie', 2019),
                _candidate(99, 'Chosen Movie', 2020),
              ],
            },
          ),
        ),
        data: {'url': _url},
      );
      // The patched job comes back without its candidates.
      adapter.onPatch(
        'api/v1/jobs/job-1',
        (server) => server.reply(
          200,
          _job(
            'job-1',
            'awaiting_verification',
            extra: {'selected_tmdb_id': 99},
          ),
        ),
        data: {'tmdb_id': 99},
      );
      adapter.onPost(
        'api/v1/jobs/job-1/download',
        (server) => server.reply(
          200,
          _job('job-1', 'downloading', extra: {'selected_tmdb_id': 99}),
        ),
      );

      final container = newContainer();
      await restored(container);
      final controller = controllerOf(container);
      await controller.submitUrl(_url);
      controller.selectCandidate(99);
      await controller.confirmDownload();

      final state = read(container);
      expect(state.activeJob?.job?.state, JobState.downloading);
      expect(state.activeJob?.job?.selectedTmdbId, 99);
      expect(state.activeJob?.record.title, 'Chosen Movie');
      expect(state.activeJob?.record.year, 2020);

      final saved = (await store.read(_instanceId)).single;
      expect(saved.state, JobState.downloading);
      expect(saved.title, 'Chosen Movie');
      expect(saved.year, 2020);
    });

    test(
      'confirmDownload skips the patch when the candidate is unchanged',
      () async {
        adapter.onPost(
          'api/v1/movies',
          (server) => server.reply(
            201,
            _job(
              'job-1',
              'awaiting_verification',
              extra: {
                'selected_tmdb_id': 5,
                'candidates': [_candidate(5, 'Five', 2005)],
              },
            ),
          ),
          data: {'url': _url},
        );
        adapter.onPost(
          'api/v1/jobs/job-1/download',
          (server) => server.reply(
            200,
            _job('job-1', 'downloading', extra: {'selected_tmdb_id': 5}),
          ),
        );

        final container = newContainer();
        await restored(container);
        await controllerOf(container).submitUrl(_url);
        await controllerOf(container).confirmDownload();

        final state = read(container);
        expect(state.activeJob?.job?.state, JobState.downloading);
        expect(state.activeJob?.record.title, 'Five');
      },
    );

    test(
      'confirmDownload surfaces a patch Err without losing the job',
      () async {
        adapter.onPost(
          'api/v1/movies',
          (server) => server.reply(201, _job('job-1', 'awaiting_verification')),
          data: {'url': _url},
        );
        adapter.onPatch(
          'api/v1/jobs/job-1',
          (server) => server.reply(400, {'message': 'bad candidate'}),
          data: {'tmdb_id': 7},
        );

        final container = newContainer();
        await restored(container);
        final controller = controllerOf(container);
        await controller.submitUrl(_url);
        controller.selectCandidate(7);
        await controller.confirmDownload();

        final state = read(container);
        expect(state.lastError, isA<AppError>());
        expect(state.activeJob?.id, 'job-1');
        expect(state.isSubmitting, isFalse);
      },
    );
  });

  group('leaving a job', () {
    test('cancel deletes the job and removes it from the list', () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, _job('job-1', 'resolving')),
        data: {'url': _url},
      );
      var deleted = false;
      adapter.onDelete('api/v1/jobs/job-1', (server) {
        deleted = true;
        server.reply(204, <String, dynamic>{});
      });

      final container = newContainer();
      await restored(container);
      final controller = controllerOf(container);
      await controller.submitUrl(_url);
      await controller.cancel();

      final state = read(container);
      expect(deleted, isTrue);
      expect(state.activeJobId, isNull);
      expect(state.jobs, isEmpty);
      expect(state.lastError, isNull);
      expect(await store.read(_instanceId), isEmpty);
    });

    test('reset returns to the input step but keeps the job listed', () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, _job('job-1', 'awaiting_verification')),
        data: {'url': _url},
      );

      final container = newContainer();
      await restored(container);
      final controller = controllerOf(container);
      await controller.submitUrl(_url);
      controller.selectCandidate(3);
      controller.reset();

      final state = read(container);
      expect(state.selectedTmdbId, isNull);
      expect(state.activeJobId, isNull);
      expect(state.lastError, isNull);
      expect(state.jobs.map((tracked) => tracked.id), ['job-1']);
      expect((await store.read(_instanceId)).single.jobId, 'job-1');
    });

    test('openJob shows a listed job and ignores an unknown id', () async {
      await store.write(_instanceId, [_record('old', JobState.done)]);

      final container = newContainer();
      await restored(container);
      final controller = controllerOf(container);

      controller.openJob('missing');
      expect(read(container).activeJobId, isNull);

      controller.selectCandidate(4);
      controller.openJob('old');
      expect(read(container).activeJobId, 'old');
      expect(read(container).selectedTmdbId, isNull);

      controller.reset();
      expect(read(container).activeJobId, isNull);
    });

    test('dismiss deletes on the server and forgets the job', () async {
      await store.write(_instanceId, [
        _record('old', JobState.error, errorMessage: 'nope'),
        _record('keep', JobState.done),
      ]);
      serverJobs = [_job('old', 'error'), _doneJob('keep')];
      var deleted = false;
      adapter.onDelete('api/v1/jobs/old', (server) {
        deleted = true;
        server.reply(204, <String, dynamic>{});
      });

      final container = newContainer();
      await restored(container);
      final controller = controllerOf(container);
      controller.openJob('old');
      await controller.dismiss('old');

      final state = read(container);
      expect(deleted, isTrue);
      expect(state.jobs.map((tracked) => tracked.id), ['keep']);
      expect(state.activeJobId, isNull);
      expect((await store.read(_instanceId)).map((record) => record.jobId), [
        'keep',
      ]);
    });

    test('dismiss ignores a server failure (job already forgotten)', () async {
      await store.write(_instanceId, [_record('gone', JobState.downloading)]);
      adapter.onDelete(
        'api/v1/jobs/gone',
        (server) => server.reply(404, {'code': 'job_not_found'}),
      );

      final container = newContainer();
      await restored(container);
      expect(read(container).jobs.single.isLost, isTrue);
      await controllerOf(container).dismiss('gone');

      expect(read(container).jobs, isEmpty);
      expect(await store.read(_instanceId), isEmpty);
    });

    test('a dismissed job the server still lists does not come back', () async {
      serverJobs = [_doneJob('stuck')];
      // The downloader fails to delete it.
      adapter.onDelete(
        'api/v1/jobs/stuck',
        (server) => server.reply(500, {'message': 'boom'}),
      );

      final container = newContainer();
      await restored(container);
      expect(read(container).jobs.single.id, 'stuck');
      await controllerOf(container).dismiss('stuck');
      await pumpEventQueue();

      expect(read(container).jobs, isEmpty);
    });
  });

  group('restoring', () {
    test('adds the downloader\'s jobs newest first, titled from the selected '
        'candidate', () async {
      serverJobs = [
        _job('oldest', 'downloading', url: 'https://einthusan.tv/movie/a'),
        _job(
          'newest',
          'awaiting_verification',
          url: 'https://einthusan.tv/movie/b',
          extra: {
            'selected_tmdb_id': 8,
            'candidates': [_candidate(8, 'Eight', 2008)],
          },
        ),
      ];

      final container = newContainer();
      await restored(container);

      final state = read(container);
      expect(state.jobs.map((tracked) => tracked.id), ['newest', 'oldest']);
      expect(state.jobs.first.record.title, 'Eight');
      expect(state.jobs.first.record.year, 2008);
      expect(state.jobs.last.record.title, isNull);
      expect(
        state.jobs.last.record.einthusanUrl,
        'https://einthusan.tv/movie/a',
      );
      expect(state.jobs.every((tracked) => tracked.job != null), isTrue);
      expect(state.activeJobId, isNull);
      expect(state.serverUnreachable, isFalse);

      // The discovered jobs are remembered too.
      expect((await store.read(_instanceId)).map((record) => record.jobId), [
        'newest',
        'oldest',
      ]);
    });

    test('merges history with the listing: the server wins, a vanished '
        'in-progress job is lost, a vanished finished job is kept', () async {
      await store.write(_instanceId, [
        _record('lost', JobState.downloading, title: 'Lost Movie', year: 2001),
        _record(
          'finished',
          JobState.done,
          title: 'Finished Movie',
          file: 'Finished.mkv',
          radarrMovieId: 7,
        ),
        _record('moved-on', JobState.downloading, title: 'Moving'),
      ]);
      serverJobs = [_doneJob('moved-on')];

      final container = newContainer();
      await restored(container);

      final byId = {
        for (final tracked in read(container).jobs) tracked.id: tracked,
      };
      expect(read(container).jobs.map((tracked) => tracked.id), [
        'lost',
        'finished',
        'moved-on',
      ]);

      expect(byId['lost']!.isLost, isTrue);
      expect(byId['lost']!.job, isNull);
      expect(byId['lost']!.record.title, 'Lost Movie');

      expect(byId['finished']!.isLost, isFalse);
      expect(byId['finished']!.state, JobState.done);
      expect(byId['finished']!.file, 'Finished.mkv');
      expect(byId['finished']!.radarrMovieId, 7);

      expect(byId['moved-on']!.isLost, isFalse);
      expect(byId['moved-on']!.state, JobState.done);
      expect(byId['moved-on']!.record.title, 'Moving');
      expect(byId['moved-on']!.file, 'Movie.2020.mkv');

      // The server's outcome is saved over the stale record.
      final saved = {
        for (final record in await store.read(_instanceId))
          record.jobId: record,
      };
      expect(saved['moved-on']!.state, JobState.done);
      expect(saved['moved-on']!.radarrMovieId, 12);
      expect(saved['moved-on']!.title, 'Moving');
      // "Lost" is derived, not stored: the record still says in progress.
      expect(saved['lost']!.state, JobState.downloading);
    });

    test('a listing failure keeps the cached jobs and flags the downloader '
        'as unreachable', () async {
      await store.write(_instanceId, [
        _record('done-1', JobState.done, file: 'A.mkv', radarrMovieId: 1),
        _record('running', JobState.downloading),
      ]);
      listingDown = true;

      final container = newContainer();
      await restored(container);

      final state = read(container);
      expect(state.serverUnreachable, isTrue);
      expect(state.jobs.map((tracked) => tracked.id), ['done-1', 'running']);
      expect(state.jobs.any((tracked) => tracked.isLost), isFalse);
      expect(state.jobs.every((tracked) => tracked.job == null), isTrue);
    });

    test(
      'a corrupt history reads as empty and the listing still applies',
      () async {
        final preferences = InMemoryAppPreferences({
          'einthusan.jobs.$_instanceId': '{not json',
        });
        store = PreferencesEinthusanJobHistoryStore(preferences);
        serverJobs = [_doneJob('a')];

        final container = newContainer();
        await restored(container);

        expect(read(container).jobs.map((tracked) => tracked.id), ['a']);
      },
    );

    test('keeps its state when nothing is listening to it', () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, _doneJob('job-1')),
        data: {'url': _url},
      );

      final container = newContainer();
      final subscription = container.listen(
        einthusanImportControllerProvider(_instanceId),
        (_, _) {},
      );
      await pumpEventQueue();
      await controllerOf(container).submitUrl(_url);
      subscription.close();
      await pumpEventQueue();

      // Leaving the page must not drop the job.
      expect(read(container).jobs.single.id, 'job-1');
      expect(read(container).activeJobId, 'job-1');
    });

    test(
      'a job submitted while a listing is in flight is not marked lost',
      () async {
        listingGate = Completer<void>();
        adapter.onPost(
          'api/v1/movies',
          (server) => server.reply(201, _job('job-1', 'resolving')),
          data: {'url': _url},
        );

        final container = newContainer();
        await restored(container); // Listing now waiting on the gate.
        expect(listCalls, 1);
        await controllerOf(container).submitUrl(_url);
        listingGate!.complete(); // The (empty) answer predates the job.
        await pumpEventQueue();

        final tracked = read(container).jobs.single;
        expect(tracked.id, 'job-1');
        expect(tracked.isLost, isFalse);
        expect(tracked.job?.state, JobState.resolving);
      },
    );
  });

  group('polling', () {
    test('lists every job in one request and stops once all are '
        'terminal', () {
      fakeAsync((async) {
        adapter.onPost(
          'api/v1/movies',
          (server) => server.reply(201, _job('job-1', 'downloading')),
          data: {'url': _url},
        );

        final container = newContainer();
        controllerOf(container);
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 10));
        expect(listCalls, 1); // The restore listing.

        unawaited(controllerOf(container).submitUrl(_url));
        async.elapse(const Duration(milliseconds: 10));
        expect(read(container).activeJob?.state, JobState.downloading);

        // First poll: still downloading.
        serverJobs = [_job('job-1', 'downloading')];
        async.elapse(const Duration(seconds: 2));
        expect(listCalls, 2);
        expect(read(container).activeJob?.state, JobState.downloading);

        // Second poll: done.
        serverJobs = [_doneJob('job-1')];
        async.elapse(const Duration(seconds: 2));
        expect(listCalls, 3);
        final tracked = read(container).activeJob!;
        expect(tracked.state, JobState.done);
        expect(tracked.job?.result?.radarrMovieId, 12);

        // Nothing left to wait for: no more polls.
        async.elapse(const Duration(seconds: 10));
        expect(listCalls, 3);
      });
    });

    test('polls for several jobs with a single request each time', () {
      fakeAsync((async) {
        serverJobs = [
          _job('a', 'downloading', url: 'https://einthusan.tv/movie/a'),
          _job('b', 'importing', url: 'https://einthusan.tv/movie/b'),
        ];
        final container = newContainer();
        controllerOf(container);
        async.elapse(const Duration(milliseconds: 10));
        expect(listCalls, 1);

        serverJobs = [_doneJob('a'), _job('b', 'importing')];
        async.elapse(const Duration(seconds: 2));
        expect(listCalls, 2);
        expect(read(container).jobs.map((tracked) => tracked.state), [
          JobState.importing,
          JobState.done,
        ]);

        // One job is still running, so polling carries on.
        serverJobs = [_doneJob('a'), _doneJob('b')];
        async.elapse(const Duration(seconds: 2));
        expect(listCalls, 3);
        async.elapse(const Duration(seconds: 10));
        expect(listCalls, 3);
      });
    });

    test('does not poll when nothing is in progress', () {
      fakeAsync((async) {
        serverJobs = [_doneJob('a')];
        final container = newContainer();
        controllerOf(container);
        async.elapse(const Duration(seconds: 10));

        expect(listCalls, 1);
      });
    });

    test('progress ticks update the job without rewriting the history', () {
      fakeAsync((async) {
        final writes = <List<EinthusanJobRecord>>[];
        serverJobs = [_job('a', 'downloading')];
        final spied = newContainer(historyStore: _SpyStore(store, writes.add));

        controllerOf(spied);
        async.elapse(const Duration(milliseconds: 10));
        expect(writes, hasLength(1)); // Discovered on restore.

        for (var percent = 10; percent <= 50; percent += 10) {
          serverJobs = [
            _job(
              'a',
              'downloading',
              extra: {
                'progress': {
                  'downloaded_bytes': percent,
                  'total_bytes': 100,
                  'percent': percent.toDouble(),
                  'speed_bps': 1.0,
                },
              },
            ),
          ];
          async.elapse(const Duration(seconds: 2));
        }
        expect(read(spied).jobs.single.job?.progress?.percent, 50);
        expect(writes, hasLength(1));

        // A state transition is written.
        serverJobs = [_job('a', 'importing')];
        async.elapse(const Duration(seconds: 2));
        expect(writes, hasLength(2));
        expect(writes.last.single.state, JobState.importing);
      });
    });

    test('a job that disappears from the listing is marked lost and polling '
        'stops', () {
      fakeAsync((async) {
        serverJobs = [_job('a', 'downloading')];
        final container = newContainer();
        controllerOf(container);
        async.elapse(const Duration(milliseconds: 10));
        expect(read(container).jobs.single.isLost, isFalse);

        // The downloader restarted.
        serverJobs = [];
        async.elapse(const Duration(seconds: 2));
        final tracked = read(container).jobs.single;
        expect(tracked.isLost, isTrue);
        expect(tracked.record.state, JobState.downloading);
        expect(listCalls, 2);

        async.elapse(const Duration(seconds: 10));
        expect(listCalls, 2);
      });
    });

    test('a failed poll flags the downloader and polling recovers', () {
      fakeAsync((async) {
        serverJobs = [_job('a', 'downloading')];
        final container = newContainer();
        controllerOf(container);
        async.elapse(const Duration(milliseconds: 10));
        expect(read(container).serverUnreachable, isFalse);

        listingDown = true;
        async.elapse(const Duration(seconds: 2));
        expect(read(container).serverUnreachable, isTrue);
        expect(read(container).jobs.single.isLost, isFalse);

        // Still polling, so it recovers by itself.
        listingDown = false;
        serverJobs = [_doneJob('a')];
        async.elapse(const Duration(seconds: 2));
        expect(read(container).serverUnreachable, isFalse);
        expect(read(container).jobs.single.state, JobState.done);
      });
    });

    test('the timer is cancelled when the container is disposed', () {
      fakeAsync((async) {
        serverJobs = [_job('a', 'downloading')];
        final container = newContainer();
        controllerOf(container);
        async.elapse(const Duration(milliseconds: 10));
        final calls = listCalls;

        container.dispose();
        async.elapse(const Duration(seconds: 10));

        expect(listCalls, calls);
      });
    });

    test('confirming restarts polling after it had stopped', () {
      fakeAsync((async) {
        adapter.onPost(
          'api/v1/movies',
          (server) => server.reply(201, _job('job-1', 'awaiting_verification')),
          data: {'url': _url},
        );
        adapter.onPost(
          'api/v1/jobs/job-1/download',
          (server) => server.reply(200, _job('job-1', 'downloading')),
        );

        final container = newContainer();
        controllerOf(container);
        async.elapse(const Duration(milliseconds: 10));
        unawaited(controllerOf(container).submitUrl(_url));
        async.elapse(const Duration(milliseconds: 10));
        serverJobs = [_job('job-1', 'awaiting_verification')];

        // Awaiting verification is still pending, so it polls.
        async.elapse(const Duration(seconds: 2));
        final before = listCalls;
        expect(before, greaterThan(1));

        unawaited(controllerOf(container).confirmDownload());
        async.elapse(const Duration(milliseconds: 10));
        serverJobs = [_job('job-1', 'downloading')];
        async.elapse(const Duration(seconds: 2));
        expect(listCalls, greaterThan(before));
        expect(read(container).activeJob?.state, JobState.downloading);
      });
    });
  });

  test('the list is capped at the history limit, oldest dropped', () async {
    await store.write(_instanceId, [
      for (var i = 0; i < einthusanJobHistoryLimit; i++)
        _record('job-$i', JobState.done),
    ]);
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, _job('fresh', 'resolving')),
      data: {'url': _url},
    );
    serverJobs = [
      for (var i = 0; i < einthusanJobHistoryLimit; i++) _doneJob('job-$i'),
    ];

    final container = newContainer();
    await restored(container);
    await controllerOf(container).submitUrl(_url);

    final state = read(container);
    expect(state.jobs, hasLength(einthusanJobHistoryLimit));
    expect(state.jobs.first.id, 'fresh');
    expect(state.jobs.any((tracked) => tracked.id == 'job-24'), isFalse);
    final saved = await store.read(_instanceId);
    expect(saved, hasLength(einthusanJobHistoryLimit));
    expect(saved.first.jobId, 'fresh');
  });
}

/// A store that reports each write to [onWrite] and otherwise defers to
/// [inner].
class _SpyStore implements EinthusanJobHistoryStore {
  _SpyStore(this.inner, this.onWrite);

  final EinthusanJobHistoryStore inner;
  final void Function(List<EinthusanJobRecord>) onWrite;

  @override
  Future<List<EinthusanJobRecord>> read(String instanceId) =>
      inner.read(instanceId);

  @override
  Future<void> write(String instanceId, List<EinthusanJobRecord> records) {
    onWrite(records);
    return inner.write(instanceId, records);
  }
}

// EinthusanImportController state machine: submitUrl → resolving → preview,
// candidate selection, confirmDownload → polling → done, cancel, reset, and
// error surfacing at each step (design §"Client state machine").

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_providers.dart';
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

ProviderContainer _container(Dio dio) {
  final container = ProviderContainer(
    overrides: [
      einthusanRepositoryProvider(
        _instanceId,
      ).overrideWith((ref) async => EinthusanRepository(EinthusanClient(dio))),
    ],
  );
  addTearDown(container.dispose);
  // Keep the autoDispose controller alive across the awaits in each test —
  // otherwise it's torn down as soon as `.notifier` is read without a
  // listener, and later `state = ...` calls hit a disposed Ref.
  container.listen(einthusanImportControllerProvider(_instanceId), (_, _) {});
  return container;
}

void main() {
  late Dio dio;
  late DioAdapter adapter;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
  });

  test('submitUrl moves to a resolving job on success', () async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'resolving',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );

    final container = _container(dio);
    final controller = container.read(
      einthusanImportControllerProvider(_instanceId).notifier,
    );

    await controller.submitUrl('https://einthusan.tv/movie/watch/abc');

    final state = container.read(
      einthusanImportControllerProvider(_instanceId),
    );
    expect(state.job?.id, 'job-1');
    expect(state.isSubmitting, isFalse);
    expect(state.lastError, isNull);
  });

  test('submitUrl surfaces an Err as lastError', () async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(422, {'message': 'invalid url'}),
      data: {'url': 'not-a-url'},
    );

    final container = _container(dio);
    final controller = container.read(
      einthusanImportControllerProvider(_instanceId).notifier,
    );

    await controller.submitUrl('not-a-url');

    final state = container.read(
      einthusanImportControllerProvider(_instanceId),
    );
    expect(state.job, isNull);
    expect(state.lastError, isA<AppError>());
    expect(state.isSubmitting, isFalse);
  });

  test('selectCandidate updates selectedTmdbId locally', () async {
    final container = _container(dio);
    final controller = container.read(
      einthusanImportControllerProvider(_instanceId).notifier,
    );

    controller.selectCandidate(42);

    final state = container.read(
      einthusanImportControllerProvider(_instanceId),
    );
    expect(state.selectedTmdbId, 42);
  });

  test(
    'confirmDownload patches the candidate then starts the download',
    () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, {
          'id': 'job-1',
          'state': 'awaiting_verification',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
          'selected_tmdb_id': 1,
        }),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );
      adapter.onPatch(
        'api/v1/jobs/job-1',
        (server) => server.reply(200, {
          'id': 'job-1',
          'state': 'awaiting_verification',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
          'selected_tmdb_id': 99,
        }),
        data: {'tmdb_id': 99},
      );
      adapter.onPost(
        'api/v1/jobs/job-1/download',
        (server) => server.reply(200, {
          'id': 'job-1',
          'state': 'downloading',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
          'selected_tmdb_id': 99,
        }),
      );

      final container = _container(dio);
      final controller = container.read(
        einthusanImportControllerProvider(_instanceId).notifier,
      );

      await controller.submitUrl('https://einthusan.tv/movie/watch/abc');
      controller.selectCandidate(99);
      await controller.confirmDownload();

      final state = container.read(
        einthusanImportControllerProvider(_instanceId),
      );
      expect(state.job?.state, JobState.downloading);
      expect(state.job?.selectedTmdbId, 99);
    },
  );

  test(
    'confirmDownload skips the patch when the candidate is unchanged',
    () async {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, {
          'id': 'job-1',
          'state': 'awaiting_verification',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
          'selected_tmdb_id': 5,
        }),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );
      adapter.onPost(
        'api/v1/jobs/job-1/download',
        (server) => server.reply(200, {
          'id': 'job-1',
          'state': 'downloading',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
          'selected_tmdb_id': 5,
        }),
      );

      final container = _container(dio);
      final controller = container.read(
        einthusanImportControllerProvider(_instanceId).notifier,
      );

      await controller.submitUrl('https://einthusan.tv/movie/watch/abc');
      await controller.confirmDownload();

      final state = container.read(
        einthusanImportControllerProvider(_instanceId),
      );
      expect(state.job?.state, JobState.downloading);
    },
  );

  test('confirmDownload surfaces a patch Err without losing the job', () async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'awaiting_verification',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );
    adapter.onPatch(
      'api/v1/jobs/job-1',
      (server) => server.reply(400, {'message': 'bad candidate'}),
      data: {'tmdb_id': 7},
    );

    final container = _container(dio);
    final controller = container.read(
      einthusanImportControllerProvider(_instanceId).notifier,
    );

    await controller.submitUrl('https://einthusan.tv/movie/watch/abc');
    controller.selectCandidate(7);
    await controller.confirmDownload();

    final state = container.read(
      einthusanImportControllerProvider(_instanceId),
    );
    expect(state.lastError, isA<AppError>());
    expect(state.job?.id, 'job-1');
  });

  test('cancel deletes the job and resets to the input step', () async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'resolving',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );
    adapter.onDelete(
      'api/v1/jobs/job-1',
      (server) => server.reply(204, <String, dynamic>{}),
    );

    final container = _container(dio);
    final controller = container.read(
      einthusanImportControllerProvider(_instanceId).notifier,
    );

    await controller.submitUrl('https://einthusan.tv/movie/watch/abc');
    await controller.cancel();

    final state = container.read(
      einthusanImportControllerProvider(_instanceId),
    );
    expect(state.job, isNull);
    expect(state.lastError, isNull);
  });

  test('reset clears state without calling the server', () async {
    final container = _container(dio);
    final controller = container.read(
      einthusanImportControllerProvider(_instanceId).notifier,
    );

    controller.selectCandidate(3);
    controller.reset();

    final state = container.read(
      einthusanImportControllerProvider(_instanceId),
    );
    expect(state.selectedTmdbId, isNull);
    expect(state.job, isNull);
  });

  test('polling stops once the job reaches a terminal state', () {
    fakeAsync((async) {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, {
          'id': 'job-1',
          'state': 'downloading',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        }),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );
      var pollCount = 0;
      adapter.onGet('api/v1/jobs/job-1', (server) {
        // `replyCallback`'s data function is evaluated per matched request
        // (unlike `reply`, which fixes its response body at registration
        // time) — needed here since the response changes across polls.
        server.replyCallback(200, (options) {
          pollCount++;
          final state = pollCount >= 2 ? 'done' : 'downloading';
          return {
            'id': 'job-1',
            'state': state,
            'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
            if (state == 'done')
              'result': {
                'file': 'Movie.2020.mkv',
                'radarr_movie_id': 12,
                'tmdb_id': 99,
              },
          };
        });
      });

      final container = _container(dio);
      final controller = container.read(
        einthusanImportControllerProvider(_instanceId).notifier,
      );

      unawaited(controller.submitUrl('https://einthusan.tv/movie/watch/abc'));
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 5));

      final state = container.read(
        einthusanImportControllerProvider(_instanceId),
      );
      expect(pollCount, 2);
      expect(state.job?.state, JobState.done);
      expect(state.job?.result?.radarrMovieId, 12);

      // Timer should be cancelled now that the job is done — no more polls.
      async.elapse(const Duration(seconds: 4));
      expect(pollCount, 2);
    });
  });

  test('a poll Err stops the timer and surfaces the error', () {
    fakeAsync((async) {
      adapter.onPost(
        'api/v1/movies',
        (server) => server.reply(201, {
          'id': 'job-1',
          'state': 'downloading',
          'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        }),
        data: {'url': 'https://einthusan.tv/movie/watch/abc'},
      );
      adapter.onGet(
        'api/v1/jobs/job-1',
        (server) => server.reply(500, {'message': 'boom'}),
      );

      final container = _container(dio);
      final controller = container.read(
        einthusanImportControllerProvider(_instanceId).notifier,
      );

      unawaited(controller.submitUrl('https://einthusan.tv/movie/watch/abc'));
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 2));

      final state = container.read(
        einthusanImportControllerProvider(_instanceId),
      );
      expect(state.lastError, isA<AppError>());
    });
  });
}

// EinthusanClient endpoint calls: testConnection hits the health endpoint,
// createJob/getJob/patchJob/startDownload/deleteJob map requests and
// responses per docs/superpowers/specs/2026-09-08-einthusan-import-design.md.

import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late EinthusanClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = EinthusanClient(dio);
  });

  test('testConnection returns an Ok identity on a healthy response', () async {
    adapter.onGet('api/v1/health', (server) => server.reply(200, {}));

    final result = await client.testConnection();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.instanceName, 'Einthusan Downloader');
  });

  test('testConnection maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v1/health',
      (server) => server.reply(503, {'message': 'down'}),
    );

    final result = await client.testConnection();

    expect(result.isErr, isTrue);
  });

  test('createJob posts the url and parses the job', () async {
    RequestOptions? captured;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'resolving',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );

    final result = await client.createJob(
      'https://einthusan.tv/movie/watch/abc',
    );

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.id, 'job-1');
    expect(captured!.data, {'url': 'https://einthusan.tv/movie/watch/abc'});
  });

  test('createJob maps a 4xx to an Err', () async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(422, {'message': 'invalid url'}),
      data: {'url': 'not-a-url'},
    );

    final result = await client.createJob('not-a-url');

    expect(result.isErr, isTrue);
  });

  test('getJob fetches by id and parses the job', () async {
    adapter.onGet(
      'api/v1/jobs/job-1',
      (server) => server.reply(200, {
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
        ],
      }),
    );

    final result = await client.getJob('job-1');

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.candidates.single.tmdbId, 42);
  });

  test('getJob maps a 404 to an Err', () async {
    adapter.onGet(
      'api/v1/jobs/missing',
      (server) => server.reply(404, {'message': 'not found'}),
    );

    final result = await client.getJob('missing');

    expect(result.isErr, isTrue);
  });

  test('patchJob sends tmdb_id and parses the updated job', () async {
    RequestOptions? captured;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
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

    final result = await client.patchJob(jobId: 'job-1', tmdbId: 99);

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.selectedTmdbId, 99);
    expect(captured!.data, {'tmdb_id': 99});
  });

  test('patchJob maps a 4xx to an Err', () async {
    adapter.onPatch(
      'api/v1/jobs/job-1',
      (server) => server.reply(400, {'message': 'bad candidate'}),
      data: {'tmdb_id': -1},
    );

    final result = await client.patchJob(jobId: 'job-1', tmdbId: -1);

    expect(result.isErr, isTrue);
  });

  test('startDownload posts and parses the job in downloading state', () async {
    adapter.onPost(
      'api/v1/jobs/job-1/download',
      (server) => server.reply(200, {
        'id': 'job-1',
        'state': 'downloading',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
    );

    final result = await client.startDownload('job-1');

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.state.name, 'downloading');
  });

  test('startDownload maps a 5xx to an Err', () async {
    adapter.onPost(
      'api/v1/jobs/job-1/download',
      (server) => server.reply(500, {'message': 'boom'}),
    );

    final result = await client.startDownload('job-1');

    expect(result.isErr, isTrue);
  });

  test('deleteJob deletes by id', () async {
    adapter.onDelete(
      'api/v1/jobs/job-1',
      (server) => server.reply(204, <String, dynamic>{}),
    );

    final result = await client.deleteJob('job-1');

    expect(result.isOk, isTrue);
  });

  test('deleteJob maps a 4xx to an Err', () async {
    adapter.onDelete(
      'api/v1/jobs/missing',
      (server) => server.reply(404, {'message': 'not found'}),
    );

    final result = await client.deleteJob('missing');

    expect(result.isErr, isTrue);
  });
}

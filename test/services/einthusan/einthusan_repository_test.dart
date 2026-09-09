// EinthusanRepository is a thin passthrough over EinthusanClient — every
// method just forwards to the client and returns its Result.

import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late EinthusanRepository repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = EinthusanRepository(EinthusanClient(dio));
  });

  test('createJob delegates to the client', () async {
    adapter.onPost(
      'api/v1/movies',
      (server) => server.reply(201, {
        'id': 'job-1',
        'state': 'resolving',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
      data: {'url': 'https://einthusan.tv/movie/watch/abc'},
    );

    final result = await repo.createJob('https://einthusan.tv/movie/watch/abc');

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.id, 'job-1');
  });

  test('getJob delegates to the client', () async {
    adapter.onGet(
      'api/v1/jobs/job-1',
      (server) => server.reply(200, {
        'id': 'job-1',
        'state': 'downloading',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
    );

    final result = await repo.getJob('job-1');

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.state.name, 'downloading');
  });

  test('patchJob delegates to the client', () async {
    adapter.onPatch(
      'api/v1/jobs/job-1',
      (server) => server.reply(200, {
        'id': 'job-1',
        'state': 'awaiting_verification',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
        'selected_tmdb_id': 7,
      }),
      data: {'tmdb_id': 7},
    );

    final result = await repo.patchJob(jobId: 'job-1', tmdbId: 7);

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.selectedTmdbId, 7);
  });

  test('startDownload delegates to the client', () async {
    adapter.onPost(
      'api/v1/jobs/job-1/download',
      (server) => server.reply(200, {
        'id': 'job-1',
        'state': 'downloading',
        'einthusan_url': 'https://einthusan.tv/movie/watch/abc',
      }),
    );

    final result = await repo.startDownload('job-1');

    expect(result.isOk, isTrue);
  });

  test('deleteJob delegates to the client', () async {
    adapter.onDelete(
      'api/v1/jobs/job-1',
      (server) => server.reply(204, <String, dynamic>{}),
    );

    final result = await repo.deleteJob('job-1');

    expect(result.isOk, isTrue);
  });

  test('propagates an Err from the client', () async {
    adapter.onGet(
      'api/v1/jobs/missing',
      (server) => server.reply(404, {'message': 'not found'}),
    );

    final result = await repo.getJob('missing');

    expect(result.isErr, isTrue);
  });
}

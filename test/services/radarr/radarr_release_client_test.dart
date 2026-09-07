// RadarrClient interactive-search calls: searchMovieReleases skips a malformed
// entry; grabRelease posts exactly {guid, indexerId}.

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late RadarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = RadarrClient(dio);
  });

  test(
    'searchMovieReleases parses releases and skips a malformed entry',
    () async {
      RequestOptions? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );
      adapter.onGet(
        'api/v3/release',
        (server) => server.reply(200, [
          {
            'guid': 'ix-1',
            'title': 'Movie.2024.1080p.WEB-DL-GRP',
            'size': 1000,
            'indexerId': 2,
            'indexer': 'ix',
            'seeders': 10,
            'protocol': 'torrent',
            'rejections': [],
          },
          'not a map',
          {
            'guid': 'ix-2',
            'title': 'Movie.2024.2160p.BluRay-GRP',
            'size': 2000,
            'indexerId': 2,
            'protocol': 'torrent',
            'rejections': ['Quality not wanted'],
          },
        ]),
        queryParameters: {'movieId': 55},
      );

      final result = await client.searchMovieReleases(55);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.map((r) => r.guid), ['ix-1', 'ix-2']);
      expect(captured!.receiveTimeout, const Duration(seconds: 90));
    },
  );

  test('searchMovieReleases maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(503, {'message': 'down'}),
      queryParameters: {'movieId': 55},
    );
    final result = await client.searchMovieReleases(55);
    expect(result.isErr, isTrue);
    expect(result.errorOrNull, isA<AppError>());
  });

  test('grabRelease posts exactly {guid, indexerId}', () async {
    RequestOptions? captured;
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(201, {'guid': 'ix-1'}),
      data: {'guid': 'ix-1', 'indexerId': 2},
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    final result = await client.grabRelease(guid: 'ix-1', indexerId: 2);

    expect(result.isOk, isTrue);
    expect(captured!.data, {'guid': 'ix-1', 'indexerId': 2});
  });

  test('grabRelease maps a 4xx to an Err', () async {
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(400, {'message': 'bad'}),
      data: {'guid': 'bad', 'indexerId': 1},
    );
    final result = await client.grabRelease(guid: 'bad', indexerId: 1);
    expect(result.isErr, isTrue);
  });
}

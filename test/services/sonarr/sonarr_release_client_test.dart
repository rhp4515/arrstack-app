// SonarrClient interactive-search calls. searchEpisodeReleases must survive
// a malformed release in the array (skip it, keep the rest) the same way
// getSeries does; grabRelease must POST exactly {guid, indexerId}.

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = SonarrClient(dio);
  });

  test(
    'searchEpisodeReleases parses releases and skips a malformed entry',
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
            'title': 'Good.Release-GRP',
            'size': 1000,
            'indexerId': 2,
            'indexer': 'ix',
            'seeders': 10,
            'protocol': 'torrent',
            'rejections': [],
          },
          'not a map', // forces the per-element guard to skip
          {
            'guid': 'ix-2',
            'title': 'Another.Release-GRP',
            'size': 2000,
            'indexerId': 2,
            'protocol': 'usenet',
            'rejections': ['Unknown quality'],
          },
        ]),
        queryParameters: {'episodeId': 55},
      );

      final result = await client.searchEpisodeReleases(55);

      expect(result.isOk, isTrue);
      final list = result.valueOrNull!;
      expect(list.map((r) => r.guid), ['ix-1', 'ix-2']);
      expect(list.first.seeders, 10);
      expect(list.last.rejections, ['Unknown quality']);
      expect(captured!.receiveTimeout, const Duration(seconds: 90));
    },
  );

  test('searchEpisodeReleases maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(503, {'message': 'indexers unavailable'}),
      queryParameters: {'episodeId': 55},
    );

    final result = await client.searchEpisodeReleases(55);

    expect(result.isErr, isTrue);
    expect(result.errorOrNull, isA<AppError>());
  });

  test(
    'grabRelease posts exactly {guid, indexerId} and maps 201 to Ok',
    () async {
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
      expect(captured!.queryParameters, isEmpty);
    },
  );

  test('grabRelease maps a 4xx to an Err', () async {
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(400, {'message': 'unknown release'}),
      data: {'guid': 'bad', 'indexerId': 1},
    );

    final result = await client.grabRelease(guid: 'bad', indexerId: 1);

    expect(result.isErr, isTrue);
  });
}

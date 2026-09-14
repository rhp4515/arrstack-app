import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SeerrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = SeerrClient(dio);
  });

  test('getRadarrService parses profiles and rootFolders', () async {
    adapter.onGet(
      'api/v1/service/radarr/3',
      (server) => server.reply(200, {
        'profiles': [
          {'id': 6, 'name': 'HD-1080p'},
        ],
        'rootFolders': [
          {'path': '/data/media/movies', 'freeSpace': 100, 'totalSpace': 200},
        ],
      }),
    );

    final result = await client.getRadarrService(3);

    expect(result.isOk, isTrue);
  });

  test('getSonarrService requests the service-detail endpoint', () async {
    adapter.onGet(
      'api/v1/service/sonarr/5',
      (server) => server.reply(200, {'profiles': [], 'rootFolders': []}),
    );

    final result = await client.getSonarrService(5);

    expect(result.isOk, isTrue);
  });

  test('approveRequest POSTs to the approve endpoint', () async {
    adapter.onPost(
      'api/v1/request/42/approve',
      (server) => server.reply(200, {'id': 42, 'status': 2}),
    );

    final result = await client.approveRequest(42);

    expect(result.isOk, isTrue);
  });

  test('declineRequest POSTs to the decline endpoint', () async {
    adapter.onPost(
      'api/v1/request/42/decline',
      (server) => server.reply(200, {'id': 42, 'status': 3}),
    );

    final result = await client.declineRequest(42);

    expect(result.isOk, isTrue);
  });

  test(
    'request omits serverId/profileId/rootFolder from the body when null',
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
      adapter.onPost(
        'api/v1/request',
        (server) => server.reply(200, {'id': 1, 'status': 1}),
        data: {'mediaType': 'movie', 'mediaId': 100},
      );

      await client.request(100, 'movie');

      expect(captured!.data, {'mediaType': 'movie', 'mediaId': 100});
    },
  );

  test('request includes serverId/profileId/rootFolder when given', () async {
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
      'api/v1/request',
      (server) => server.reply(200, {'id': 1, 'status': 1}),
      data: {
        'mediaType': 'movie',
        'mediaId': 100,
        'serverId': 0,
        'profileId': 6,
        'rootFolder': '/data/media/movies',
      },
    );

    await client.request(
      100,
      'movie',
      serverId: 0,
      profileId: 6,
      rootFolder: '/data/media/movies',
    );

    expect(captured!.data, {
      'mediaType': 'movie',
      'mediaId': 100,
      'serverId': 0,
      'profileId': 6,
      'rootFolder': '/data/media/movies',
    });
  });
}

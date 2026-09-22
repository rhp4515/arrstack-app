import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
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

  test('getRadarrServices parses the server list with isDefault', () async {
    adapter.onGet(
      'api/v1/service/radarr',
      (server) => server.reply(200, [
        {'id': 0, 'isDefault': false},
        {'id': 2, 'isDefault': true},
      ]),
    );

    final result = await client.getRadarrServices();

    expect(result.isOk, isTrue);
    final services = (result as Ok).value as List<SeerrServiceSummary>;
    expect(services, hasLength(2));
    expect(services[0].id, 0);
    expect(services[0].isDefault, isFalse);
    expect(services[1].id, 2);
    expect(services[1].isDefault, isTrue);
  });

  test('getSonarrServices requests the no-id service-list endpoint', () async {
    adapter.onGet(
      'api/v1/service/sonarr',
      (server) => server.reply(200, [
        {'id': 1, 'isDefault': true},
      ]),
    );

    final result = await client.getSonarrServices();

    expect(result.isOk, isTrue);
    final services = (result as Ok).value as List<SeerrServiceSummary>;
    expect(services, hasLength(1));
    expect(services.single.id, 1);
    expect(services.single.isDefault, isTrue);
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

  test('testConnection reads the version from an authenticated endpoint, '
      'not the public status one', () async {
    // `/api/v1/status` is marked `security: []` and tagged `public` in
    // Overseerr's own spec — it answers with no key at all, so a test
    // against it passed for a wrong or empty API key.
    adapter.onGet(
      'api/v1/settings/about',
      (server) => server.reply(200, {'version': '1.33.2'}),
    );

    final result = await client.testConnection();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull?.version, '1.33.2');
  });

  test('testConnection fails on a rejected API key, rather than passing on '
      'a public endpoint', () async {
    adapter.onGet(
      'api/v1/settings/about',
      (server) => server.reply(403, {'message': 'Forbidden'}),
    );

    final result = await client.testConnection();

    expect(result.isErr, isTrue);
    expect(result.errorOrNull, isA<AuthError>());
  });

  test('testConnection maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v1/settings/about',
      (server) => server.reply(500, {'message': 'boom'}),
    );

    final result = await client.testConnection();

    expect(result.isErr, isTrue);
  });
}

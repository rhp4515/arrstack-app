// QbitClient torrent-control calls against qBittorrent 5.0+.

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/services/qbittorrent/qbit_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late QbitClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = QbitClient(dio);
  });

  test('login parses SID cookie and sets session state', () async {
    adapter.onPost(
      'api/v2/auth/login',
      (server) => server.reply(
        200,
        'Ok.',
        headers: {
          'set-cookie': ['SID=test_sid_value; path=/; HttpOnly'],
        },
      ),
      data: Matchers.any,
    );

    final result = await client.login('admin', 'password');

    expect(result.isOk, isTrue);
    expect(client.hasSession, isTrue);
  });

  test('login returning Fails. returns AuthError', () async {
    adapter.onPost(
      'api/v2/auth/login',
      (server) => server.reply(200, 'Fails.'),
      data: Matchers.any,
    );

    final result = await client.login('admin', 'wrong_password');

    expect(result.isErr, isTrue);
    expect(result.errorOrNull, isA<AuthError>());
    expect(client.hasSession, isFalse);
  });

  test('stopTorrents posts to torrents/stop with hashes in the body', () async {
    RequestOptions? captured;
    adapter.onPost(
      'api/v2/torrents/stop',
      (server) => server.reply(200, ''),
      data: Matchers.any,
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    final result = await client.stopTorrents(['hash1', 'hash2']);

    expect(result.isOk, isTrue);
    expect(captured!.queryParameters, isEmpty);
    expect(captured!.data, {'hashes': 'hash1|hash2'});
  });

  test(
    'getMainData parses categories from a map keyed by category name',
    () async {
      adapter.onGet(
        'api/v2/sync/maindata',
        (server) => server.reply(200, {
          'server_state': {
            'dl_info_speed': 0,
            'dl_info_data': 0,
            'up_info_speed': 0,
            'up_info_data': 0,
            'dl_rate_limit': 0,
            'up_rate_limit': 0,
            'dht_nodes': 0,
            'connection_status': 'connected',
          },
          'torrents': <String, dynamic>{},
          'categories': {
            'Movies': {'name': 'Movies', 'savePath': '/data/movies'},
            'TV': {'name': 'TV', 'savePath': '/data/tv'},
          },
        }),
      );

      final result = await client.getMainData();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull!.categories.toSet(), {'Movies', 'TV'});
    },
  );

  test(
    'startTorrents posts to torrents/start with hashes in the body',
    () async {
      RequestOptions? captured;
      adapter.onPost(
        'api/v2/torrents/start',
        (server) => server.reply(200, ''),
        data: Matchers.any,
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.next(options);
          },
        ),
      );

      final result = await client.startTorrents(['hash1']);

      expect(result.isOk, isTrue);
      expect(captured!.queryParameters, isEmpty);
      expect(captured!.data, {'hashes': 'hash1'});
    },
  );

  test('deleteTorrents posts hashes and deleteFiles in the body, not the query string', () async {
    RequestOptions? captured;
    adapter.onPost(
      'api/v2/torrents/delete',
      (server) => server.reply(200, ''),
      data: Matchers.any,
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    final result = await client.deleteTorrents(['hash1'], deleteFiles: true);

    expect(result.isOk, isTrue);
    expect(captured!.queryParameters, isEmpty);
    expect(captured!.data, {'hashes': 'hash1', 'deleteFiles': true});
  });

  test(
    'getTorrentFiles queries torrents/files by hash and parses files',
    () async {
      adapter.onGet(
        'api/v2/torrents/files',
        (server) => server.reply(200, [
          {
            'index': 0,
            'name': 'Movie.2024/Movie.2024.1080p.mkv.exe',
            'size': 2048,
            'progress': 0.5,
            'priority': 1,
            'is_seed': false,
            'piece_range': [0, 1],
            'availability': 1.0,
          },
          {'name': 'Movie.2024/sample.mkv', 'size': 10, 'priority': 0},
        ]),
        queryParameters: {'hash': 'abc'},
      );

      final result = await client.getTorrentFiles('abc');

      expect(result.isOk, isTrue);
      final files = result.valueOrNull!;
      expect(files, hasLength(2));
      expect(files.first.name, 'Movie.2024/Movie.2024.1080p.mkv.exe');
      expect(files.first.size, 2048);
      expect(files.first.progress, 0.5);
      expect(files.last.progress, 0.0);
      expect(files.last.priority, 0);
    },
  );
}

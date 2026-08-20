// QbitClient torrent-control calls against qBittorrent 5.0+.
//
// Two breaking changes verified here:
// - `torrents/pause` and `torrents/resume` were hard-renamed to
//   `torrents/stop` and `torrents/start` in qBittorrent 5.0 (the old paths
//   404 on 5.0+, they are not aliased).
// - State-changing endpoints read `hashes`/`deleteFiles` from the POST body,
//   not the query string; sending them as queryParameters yields a 400
//   because the server sees `hashes` as missing.

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

  test('startTorrents posts to torrents/start with hashes in the body', () async {
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
  });

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
}

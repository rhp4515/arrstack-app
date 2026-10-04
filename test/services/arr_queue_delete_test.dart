// Removing a queue item with blocklisting is how Radarr/Sonarr are told to
// never grab a release again, so the flags must reach the API as query
// parameters on DELETE api/v3/queue/{id}.

import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late List<RequestOptions> captured;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    captured = [];
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured.add(options);
          handler.next(options);
        },
      ),
    );
  });

  test('Radarr deleteQueueItem sends removeFromClient and blocklist', () async {
    adapter.onDelete('api/v3/queue/7', (server) => server.reply(200, ''));

    final result = await RadarrClient(dio)
        .deleteQueueItem(7, removeFromClient: true, blocklist: true);

    expect(result.isOk, isTrue);
    expect(captured.single.method, 'DELETE');
    expect(captured.single.queryParameters, {
      'removeFromClient': true,
      'blocklist': true,
    });
  });

  test('Sonarr deleteQueueItem sends removeFromClient and blocklist', () async {
    adapter.onDelete('api/v3/queue/11', (server) => server.reply(200, ''));

    final result = await SonarrClient(dio)
        .deleteQueueItem(11, removeFromClient: false, blocklist: true);

    expect(result.isOk, isTrue);
    expect(captured.single.queryParameters, {
      'removeFromClient': false,
      'blocklist': true,
    });
  });

  test('the queue is requested in one big page and keeps downloadId', () async {
    adapter.onGet(
      'api/v3/queue',
      (server) => server.reply(200, {
        'records': [
          {'id': 1, 'downloadId': 'ABCDEF', 'title': 'x'},
        ],
      }),
      queryParameters: {'pageSize': 1000},
    );

    final result = await RadarrClient(dio).getQueue();

    expect(result.valueOrNull!.single.downloadId, 'ABCDEF');
    expect(captured.single.queryParameters['pageSize'], 1000);
  });
}

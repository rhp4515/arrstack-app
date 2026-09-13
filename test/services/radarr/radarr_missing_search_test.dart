import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late RadarrRepository repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = RadarrRepository(RadarrClient(dio));
  });

  test(
    'searchMovies posts a MoviesSearch command with the given IDs',
    () async {
      adapter.onPost(
        'api/v3/command',
        (server) => server.reply(201, <String, dynamic>{}),
        data: {
          'name': 'MoviesSearch',
          'movieIds': [1, 2, 3],
        },
      );

      final result = await repo.searchMovies([1, 2, 3]);

      expect(result.isOk, isTrue);
    },
  );

  test('searchMovies propagates an Err from the client', () async {
    adapter.onPost(
      'api/v3/command',
      (server) => server.reply(500, {'message': 'boom'}),
      data: {
        'name': 'MoviesSearch',
        'movieIds': [1],
      },
    );

    final result = await repo.searchMovies([1]);

    expect(result.isErr, isTrue);
  });
}

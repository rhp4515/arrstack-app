// ProwlarrClient.testConnection.
//
// The regression this guards: Prowlarr had no branch in the Add/Edit
// connection-test switch, so it fell through to a stub that returned
// `Success: v1.0.0-stub` without contacting anything — a test that could
// not fail, on an instance that might not exist.

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/prowlarr/client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late ProwlarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://10.0.0.1:9696/'));
    adapter = DioAdapter(dio: dio);
    client = ProwlarrClient(dio);
  });

  test('reports the version the server actually returned', () async {
    adapter.onGet(
      'api/v1/system/status',
      (server) => server.reply(200, {
        'instanceName': 'Prowlarr',
        'version': '1.37.0.5076',
      }),
    );

    final result = await client.testConnection();

    expect(result, isA<Ok<ServiceIdentity>>());
    final identity = (result as Ok<ServiceIdentity>).value;
    expect(identity.version, '1.37.0.5076');
    expect(identity.instanceName, 'Prowlarr');
    // The exact string the stub used to return whatever was at the far end.
    expect(identity.version, isNot('1.0.0-stub'));
  });

  test(
    'falls back to a sensible name when the server omits instanceName',
    () async {
      adapter.onGet(
        'api/v1/system/status',
        (server) => server.reply(200, {'version': '1.37.0.5076'}),
      );

      final result = await client.testConnection();

      expect((result as Ok<ServiceIdentity>).value.instanceName, 'Prowlarr');
    },
  );

  test('fails on a bad API key instead of passing', () async {
    adapter.onGet(
      'api/v1/system/status',
      (server) => server.reply(401, {'message': 'Unauthorized'}),
    );

    final result = await client.testConnection();

    expect(result, isA<Err<ServiceIdentity>>());
    expect((result as Err<ServiceIdentity>).error, isA<AuthError>());
  });

  test('fails when the server cannot be reached instead of passing', () async {
    adapter.onGet(
      'api/v1/system/status',
      (server) => server.throws(
        503,
        DioException(
          requestOptions: RequestOptions(path: 'api/v1/system/status'),
          type: DioExceptionType.connectionTimeout,
        ),
      ),
    );

    final result = await client.testConnection();

    expect(result, isA<Err<ServiceIdentity>>());
    expect((result as Err<ServiceIdentity>).error, isA<NetworkError>());
  });
}

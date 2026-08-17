// DioFactory: builds a Dio with explicit timeouts, the resolved baseUrl,
// and the standard interceptor stack (error mapping + redacted logging).

import 'package:arrstack/core/network/network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the given baseUrl, normalizing only a trailing slash', () {
    const factory = DioFactory();

    // The factory appends a single trailing slash so Dio joins relative paths
    // like `api/v3/series` correctly; it never derives the host/port itself.
    expect(
      factory.create(baseUrl: 'http://192.168.1.10:7878').options.baseUrl,
      'http://192.168.1.10:7878/',
    );
    expect(
      factory.create(baseUrl: 'http://192.168.1.10:7878/').options.baseUrl,
      'http://192.168.1.10:7878/',
    );
  });

  test('sets explicit (non-default) timeouts', () {
    const factory = DioFactory(
      connectTimeout: Duration(seconds: 3),
      receiveTimeout: Duration(seconds: 7),
      sendTimeout: Duration(seconds: 9),
    );

    final dio = factory.create(baseUrl: 'http://example.test');

    expect(dio.options.connectTimeout, const Duration(seconds: 3));
    expect(dio.options.receiveTimeout, const Duration(seconds: 7));
    expect(dio.options.sendTimeout, const Duration(seconds: 9));
  });

  test('always includes the error-mapping and redacting-log interceptors', () {
    const factory = DioFactory();

    final dio = factory.create(baseUrl: 'http://example.test');

    expect(dio.interceptors.whereType<ErrorMappingInterceptor>(), isNotEmpty);
    expect(dio.interceptors.whereType<RedactingLogInterceptor>(), isNotEmpty);
  });

  test('adds the ApiKeyInterceptor only when one is supplied', () {
    const factory = DioFactory();

    final withoutKey = factory.create(baseUrl: 'http://example.test');
    expect(withoutKey.interceptors.whereType<ApiKeyInterceptor>(), isEmpty);

    final withKey = factory.create(
      baseUrl: 'http://example.test',
      apiKeyInterceptor: ApiKeyInterceptor(lookupApiKey: () async => 'k'),
    );
    expect(withKey.interceptors.whereType<ApiKeyInterceptor>(), isNotEmpty);
  });
}

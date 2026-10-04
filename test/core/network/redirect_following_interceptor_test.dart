import 'dart:convert';
import 'dart:typed_data';

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/dio_call.dart';
import 'package:arrstack/core/network/dio_factory.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Answers each request from [respond] and records what it was sent.
class _ScriptedAdapter implements HttpClientAdapter {
  _ScriptedAdapter(this.respond);

  final ResponseBody Function(RequestOptions options) respond;
  final List<RequestOptions> seen = [];
  final List<String> bodies = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    bodies.add(
      requestStream == null
          ? ''
          : utf8.decode(await requestStream.expand((c) => c).toList()),
    );
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _redirect(int status, String location) => ResponseBody.fromString(
  '',
  status,
  headers: {
    'location': [location],
  },
);

ResponseBody _ok() => ResponseBody.fromString(
  '{"id":1}',
  200,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  Dio build(_ScriptedAdapter adapter, {String base = 'http://nas.test:8989'}) {
    final dio = const DioFactory().create(baseUrl: base);
    dio.httpClientAdapter = adapter;
    return dio;
  }

  test('follows a 307 on POST to the same host, resending the body', () async {
    final adapter = _ScriptedAdapter(
      (o) => o.uri.scheme == 'http'
          ? _redirect(307, 'https://nas.test/api/v3/series')
          : _ok(),
    );
    final dio = build(adapter);

    final result = await dioCall(
      () => dio.post('api/v3/series', data: {'title': 'Lanterns'}),
      map: (data) => data,
    );

    expect(result.isOk, isTrue);
    expect(adapter.seen, hasLength(2));
    expect(adapter.seen.last.method, 'POST');
    expect(adapter.seen.last.uri.toString(), 'https://nas.test/api/v3/series');
    expect(adapter.bodies.last, '{"title":"Lanterns"}');
  });

  test('follows a 308 and resolves a relative Location', () async {
    final adapter = _ScriptedAdapter(
      (o) => o.uri.path == '/sonarr/api/v3/series'
          ? _ok()
          : _redirect(308, '/sonarr/api/v3/series'),
    );
    final dio = build(adapter);

    final result = await dioCall(
      () => dio.post('api/v3/series', data: {}),
      map: (data) => data,
    );

    expect(result.isOk, isTrue);
    expect(adapter.seen.last.uri.host, 'nas.test');
    expect(adapter.seen.last.uri.path, '/sonarr/api/v3/series');
  });

  test('never follows a redirect to another host', () async {
    final adapter = _ScriptedAdapter(
      (_) => _redirect(307, 'https://elsewhere.test/api/v3/series'),
    );
    final dio = build(adapter);

    final result = await dioCall(
      () => dio.post('api/v3/series', data: {}),
      map: (data) => data,
    );

    expect(adapter.seen, hasLength(1));
    expect(result.errorOrNull, isA<UnknownError>());
    expect(result.errorOrNull!.statusCode, 307);
    expect(result.errorOrNull!.userMessage, contains('redirected'));
  });

  test('refuses to downgrade https to http', () async {
    final adapter = _ScriptedAdapter(
      (_) => _redirect(307, 'http://nas.test/api/v3/series'),
    );
    final dio = build(adapter, base: 'https://nas.test');

    final result = await dioCall(
      () => dio.post('api/v3/series', data: {}),
      map: (data) => data,
    );

    expect(adapter.seen, hasLength(1));
    expect(result.isErr, isTrue);
  });

  test('gives up after a few hops instead of looping', () async {
    final adapter = _ScriptedAdapter((o) => _redirect(307, '${o.uri}x'));
    final dio = build(adapter);

    final result = await dioCall(
      () => dio.post('api/v3/series', data: {}),
      map: (data) => data,
    );

    expect(adapter.seen, hasLength(4)); // the original + 3 hops
    expect(result.isErr, isTrue);
  });

  test('leaves GET redirects to the HTTP client', () async {
    final adapter = _ScriptedAdapter(
      (_) => _redirect(307, 'https://nas.test/api/v3/series'),
    );
    final dio = build(adapter);

    final result = await dioCall(
      () => dio.get('api/v3/series'),
      map: (data) => data,
    );

    expect(adapter.seen, hasLength(1));
    expect(result.isErr, isTrue);
  });
}

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/notifications/notification_checker.dart';
import 'package:arrstack/features/notifications/sources/seerr_activity_source.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late DioAdapter adapter;
  late SeerrActivitySource source;

  const page = {'page': 1, 'pages': 1, 'results': 2, 'pageSize': 20};

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test/'));
    adapter = DioAdapter(dio: dio);
    source = SeerrActivitySource(
      instanceId: 'i1',
      instanceName: 'Harivin Seerr',
      repository: SeerrRepository(SeerrClient(dio)),
    );
    adapter
      ..onGet(
        'api/v1/request',
        (server) => server.reply(200, {
          'pageInfo': page,
          'results': [
            {
              'id': 12,
              'status': 1,
              'media': {'id': 1, 'tmdbId': 550, 'mediaType': 'movie'},
              'requestedBy': {'displayName': 'Asha'},
            },
            {
              'id': 11,
              'status': 2,
              'media': {'id': 2, 'tmdbId': 1399, 'mediaType': 'tv'},
            },
          ],
        }),
        queryParameters: {
          'filter': 'all',
          'sort': 'added',
          'take': 20,
          'skip': 0,
        },
      )
      ..onGet(
        'api/v1/issue',
        (server) => server.reply(200, {
          'pageInfo': page,
          'results': [
            {
              'id': 5,
              'issueType': 2,
              'media': {'id': 2, 'tmdbId': 1399, 'mediaType': 'tv'},
              'createdBy': {'displayName': 'Ravi'},
            },
          ],
        }),
        queryParameters: {
          'filter': 'all',
          'sort': 'added',
          'take': 20,
          'skip': 0,
        },
      )
      ..onGet(
        'api/v1/movie/550',
        (server) => server.reply(200, {
          'id': 550,
          'title': 'Fight Club',
          'releaseDate': '1999-10-15',
        }),
      )
      ..onGet('api/v1/tv/1399', (server) => server.reply(500, {}));
  });

  test('the first check only records the newest ids', () async {
    final check = (await source.check(null) as Ok<SourceCheck>).value;
    expect(check.items, isEmpty);
    expect(check.checkpoint, 'r:12;i:5');
  });

  test('reports requests and issues newer than the checkpoint', () async {
    final check = (await source.check('r:11;i:4') as Ok<SourceCheck>).value;
    expect(check.checkpoint, 'r:12;i:5');
    expect(check.items.map((i) => i.key), ['request.12', 'issue.5']);
    expect(check.items[0].title, 'Fight Club (1999)');
    expect(check.items[0].detail, 'Requested by Asha');
    expect(source.singleTitle(check.items[0]), 'New request');
    // A failed title lookup falls back rather than dropping the item.
    expect(check.items[1].title, 'Issue #5');
    expect(check.items[1].detail, 'Audio issue reported by Ravi');
    expect(source.singleTitle(check.items[1]), 'New issue reported');
  });

  test('nothing new means no items and an unchanged checkpoint', () async {
    final check = (await source.check('r:12;i:5') as Ok<SourceCheck>).value;
    expect(check.items, isEmpty);
    expect(check.checkpoint, 'r:12;i:5');
  });

  test('a failed request list fails the check', () async {
    adapter.onGet(
      'api/v1/request',
      (server) => server.reply(401, {}),
      queryParameters: {
        'filter': 'all',
        'sort': 'added',
        'take': 20,
        'skip': 0,
      },
    );
    expect(await source.check('r:1;i:1'), isA<Err<SourceCheck>>());
  });
}

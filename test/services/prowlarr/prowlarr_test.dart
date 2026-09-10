import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prowlarr Models', () {
    test('Indexer.fromJson parses indexer correctly', () {
      final json = {
        'id': 1,
        'name': '1337x',
        'protocol': 'torrent',
        'priority': 25,
        'enable': true,
      };

      final indexer = Indexer.fromJson(json);

      expect(indexer.id, 1);
      expect(indexer.name, '1337x');
      expect(indexer.protocol, 'torrent');
      expect(indexer.priority, 25);
      expect(indexer.enable, isTrue);
    });

    test('IndexerStat.fromJson parses stats correctly', () {
      final json = {
        'indexerId': 1,
        'indexerName': '1337x',
        'averageResponseTime': 1234,
        'numberOfQueries': 500,
        'numberOfGrabs': 10,
        'numberOfFailures': 2,
      };

      final stat = IndexerStat.fromJson(json);

      expect(stat.indexerId, 1);
      expect(stat.indexerName, '1337x');
      expect(stat.averageResponseTime, 1234);
      expect(stat.numberOfQueries, 500);
      expect(stat.numberOfGrabs, 10);
      expect(stat.numberOfFailures, 2);
    });

    test('IndexerStatsResponse.fromJson parses list of stats correctly', () {
      final json = {
        'indexers': [
          {
            'indexerId': 1,
            'indexerName': '1337x',
            'averageResponseTime': 1234,
            'numberOfQueries': 500,
            'numberOfGrabs': 10,
            'numberOfFailures': 2,
          },
        ],
      };

      final response = IndexerStatsResponse.fromJson(json);

      expect(response.indexers.length, 1);
      expect(response.indexers.first.indexerName, '1337x');
    });
  });
}

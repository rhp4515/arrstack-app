// SonarrRelease parsing against a realistic /api/v3/release payload:
// torrent releases carry seeders/leechers; rejections may be plain strings
// (Sonarr v3) or {reason,type} objects (newer Sonarr). Both must land as
// List<String> so the UI can show them.

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> releaseJson() => {
    'guid': 'MyIndexer-98765',
    'title': 'Show.S01E01.1080p.WEB-DL.x264-GRP',
    'size': 2147483648,
    'indexerId': 3,
    'indexer': 'MyIndexer',
    'seeders': 42,
    'leechers': 3,
    'protocol': 'torrent',
    'quality': {
      'quality': {'id': 9, 'name': 'WEBDL-1080p', 'resolution': 1080},
      'revision': {'version': 1, 'real': 0},
    },
    'qualityWeight': 6,
    'ageMinutes': 342.6,
    'rejected': true,
    'rejections': ['Not a preferred protocol', 'Unknown quality'],
    'downloadAllowed': true,
    'releaseGroup': 'GRP',
    'customFormatScore': 0,
  };

  group('SonarrRelease.fromJson', () {
    test('parses a torrent release with seeders and quality', () {
      final r = SonarrRelease.fromJson(releaseJson());

      expect(r.guid, 'MyIndexer-98765');
      expect(r.title, 'Show.S01E01.1080p.WEB-DL.x264-GRP');
      expect(r.size, 2147483648);
      expect(r.indexerId, 3);
      expect(r.indexer, 'MyIndexer');
      expect(r.seeders, 42);
      expect(r.leechers, 3);
      expect(r.protocol, 'torrent');
      expect(r.quality?.quality?.name, 'WEBDL-1080p');
      expect(r.qualityWeight, 6);
      expect(r.ageMinutes, 342.6);
      expect(r.rejected, isTrue);
      expect(r.rejections, ['Not a preferred protocol', 'Unknown quality']);
      expect(r.downloadAllowed, isTrue);
      expect(r.releaseGroup, 'GRP');
    });

    test('normalises object-shaped rejections to a list of reason strings', () {
      final json = releaseJson()
        ..['rejections'] = [
          {'reason': 'Wrong quality', 'type': 'permanent'},
          {'reason': 'Release rejected by list', 'type': 'temporary'},
        ];

      final r = SonarrRelease.fromJson(json);

      expect(r.rejections, ['Wrong quality', 'Release rejected by list']);
    });

    test('applies defaults for a usenet release missing torrent fields', () {
      final json = <String, dynamic>{
        'guid': 'g',
        'title': 't',
        'size': 100,
        'indexerId': 1,
        'protocol': 'usenet',
      };

      final r = SonarrRelease.fromJson(json);

      expect(r.seeders, isNull);
      expect(r.leechers, isNull);
      expect(r.rejected, isFalse);
      expect(r.rejections, isEmpty);
      expect(r.downloadAllowed, isTrue);
    });
  });
}

// ReleaseCandidate flattens a SonarrRelease/RadarrRelease into the view-model
// the shared release_search UI renders. Protocol strings map to an enum,
// missing seeders means "peers unknown" (peersKey -1, sorts last), and a
// missing quality name falls back to an em dash.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReleaseCandidate.fromSonarr', () {
    test('maps a fully populated torrent release', () {
      final c = ReleaseCandidate.fromSonarr(
        const SonarrRelease(
          guid: 'g1',
          title: 'Show.S01E01.1080p.WEB-DL-GRP',
          size: 2000,
          indexerId: 7,
          indexer: 'MyIndexer',
          seeders: 30,
          leechers: 2,
          protocol: 'torrent',
          quality: SonarrQualityInfo(
            quality: SonarrQuality(name: 'WEBDL-1080p'),
          ),
          qualityWeight: 6,
          ageMinutes: 610.9,
          rejected: false,
          rejections: [],
          releaseGroup: 'GRP',
          downloadAllowed: true,
          customFormatScore: 15,
        ),
      );

      expect(c.guid, 'g1');
      expect(c.indexerId, 7);
      expect(c.indexerName, 'MyIndexer');
      expect(c.sizeBytes, 2000);
      expect(c.protocol, ReleaseProtocol.torrent);
      expect(c.qualityLabel, 'WEBDL-1080p');
      expect(c.qualityWeight, 6);
      expect(c.ageMinutes, 611); // rounded
      expect(c.seeders, 30);
      expect(c.peersKey, 30);
      expect(c.isRejected, isFalse);
      expect(c.releaseGroup, 'GRP');
      expect(c.customFormatScore, 15);
    });

    test('usenet release: protocol enum, null seeders, peersKey -1', () {
      final c = ReleaseCandidate.fromSonarr(
        const SonarrRelease(
          guid: 'g2',
          title: 't',
          size: 1,
          indexerId: 1,
          protocol: 'usenet',
          rejected: true,
          rejections: ['Unknown quality'],
          downloadAllowed: false,
        ),
      );

      expect(c.protocol, ReleaseProtocol.usenet);
      expect(c.seeders, isNull);
      expect(c.peersKey, -1);
      expect(c.qualityLabel, '—');
      expect(c.qualityWeight, 0);
      expect(c.ageMinutes, 0);
      expect(c.indexerName, 'Unknown indexer');
      expect(c.isRejected, isTrue);
      expect(c.rejections, ['Unknown quality']);
      expect(c.downloadAllowed, isFalse);
    });

    test('unrecognised protocol string maps to ReleaseProtocol.unknown', () {
      final c = ReleaseCandidate.fromSonarr(
        const SonarrRelease(
          guid: 'g',
          title: 't',
          indexerId: 1,
          protocol: null,
        ),
      );
      expect(c.protocol, ReleaseProtocol.unknown);
    });
  });

  group('ReleaseCandidate.fromRadarr', () {
    test('maps a Radarr movie release', () {
      final c = ReleaseCandidate.fromRadarr(
        const RadarrRelease(
          guid: 'm1',
          title: 'Movie.2024.2160p.BluRay-GRP',
          size: 50000,
          indexerId: 2,
          indexer: 'RadarrIndexer',
          seeders: 8,
          leechers: 1,
          protocol: 'torrent',
          quality: RadarrQualityInfo(
            quality: RadarrQuality(name: 'Bluray-2160p'),
          ),
          qualityWeight: 20,
          ageMinutes: 45,
        ),
      );

      expect(c.protocol, ReleaseProtocol.torrent);
      expect(c.qualityLabel, 'Bluray-2160p');
      expect(c.qualityWeight, 20);
      expect(c.ageMinutes, 45);
      expect(c.peersKey, 8);
    });
  });
}

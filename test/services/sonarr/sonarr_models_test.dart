// SonarrSeries parsing against a realistic /api/v3/series payload. The Sonarr
// API returns `runtime` as an int (minutes) and `tags` as int IDs — a model
// that types these as String/List<String> throws TypeError on every series,
// which the client swallows into an empty library (the "no TV shows" bug).

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Trimmed but representative of a real Sonarr v3 series object.
  Map<String, dynamic> seriesJson() => {
    'id': 7,
    'title': 'Severance',
    'sortTitle': 'severance',
    'status': 'continuing',
    'overview': 'Mark leads a team...',
    'year': 2022,
    'runtime': 55, // int minutes — NOT a String
    'tvdbId': 371980,
    'seriesType': 'standard',
    'monitored': true,
    'genres': ['Drama', 'Sci-Fi'],
    'tags': [1, 3], // int tag IDs — NOT strings
    'images': [
      {
        'coverType': 'poster',
        'url': '/MediaCover/7/poster.jpg?lastWrite=638',
        'remoteUrl': 'https://artworks.thetvdb.com/banners/poster.jpg',
      },
    ],
    'seasons': [
      {'seasonNumber': 1, 'monitored': true},
    ],
  };

  group('SonarrSeries.fromJson', () {
    test('parses a series whose runtime is an int and tags are int IDs', () {
      final series = SonarrSeries.fromJson(seriesJson());

      expect(series.title, 'Severance');
      expect(series.runtime, 55);
      expect(series.tags, [1, 3]);
      expect(series.year, 2022);
    });

    test('exposes the remote poster URL for display', () {
      final series = SonarrSeries.fromJson(seriesJson());

      // Prefer the auth-free CDN URL so posters load regardless of the
      // server's authentication mode.
      expect(
        series.posterUrl,
        'https://artworks.thetvdb.com/banners/poster.jpg',
      );
    });
  });

  group('SonarrEpisodeFile.fromJson', () {
    test('parses releaseGroup and mediaInfo', () {
      final file = SonarrEpisodeFile.fromJson({
        'id': 1,
        'relativePath': 'Severance/Season 02/S02E05.mkv',
        'size': 3100000000,
        'releaseGroup': 'FLUX',
        'quality': {
          'quality': {'name': 'WEBDL-1080p'},
        },
        'mediaInfo': {
          'videoCodec': 'h264',
          'audioCodec': 'DDP',
          'audioChannels': 5.1,
        },
      });

      expect(file.releaseGroup, 'FLUX');
      expect(file.mediaInfo?.videoCodec, 'h264');
      expect(file.mediaInfo?.audioCodec, 'DDP');
      expect(file.mediaInfo?.audioChannels, 5.1);
    });

    test('tolerates a missing mediaInfo/releaseGroup', () {
      final file = SonarrEpisodeFile.fromJson({'id': 1, 'size': 0});
      expect(file.releaseGroup, isNull);
      expect(file.mediaInfo, isNull);
    });
  });
}

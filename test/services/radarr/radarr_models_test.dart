import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadarrMovieFile.fromJson', () {
    test('parses releaseGroup and mediaInfo', () {
      final file = RadarrMovieFile.fromJson({
        'id': 1,
        'relativePath': 'Movies/Dune Part Two (2024)/Dune.Part.Two.mkv',
        'size': 54200000000,
        'releaseGroup': 'TERMiNAL',
        'quality': {
          'quality': {'name': 'Bluray-2160p'},
        },
        'mediaInfo': {
          'videoCodec': 'x265',
          'audioCodec': 'TrueHD Atmos',
          'audioChannels': 7.1,
          'resolution': '2160p',
          'videoDynamicRangeType': 'HDR10',
        },
      });

      expect(file.releaseGroup, 'TERMiNAL');
      expect(file.mediaInfo?.videoCodec, 'x265');
      expect(file.mediaInfo?.audioCodec, 'TrueHD Atmos');
      expect(file.mediaInfo?.audioChannels, 7.1);
      expect(file.mediaInfo?.resolution, '2160p');
      expect(file.mediaInfo?.videoDynamicRangeType, 'HDR10');
    });

    test('tolerates a missing mediaInfo/releaseGroup', () {
      final file = RadarrMovieFile.fromJson({'id': 1, 'size': 0});
      expect(file.releaseGroup, isNull);
      expect(file.mediaInfo, isNull);
    });
  });
}

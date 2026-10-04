import 'package:arrstack/features/activity/models/torrent_file_risk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fileExtension', () {
    test('reads the last segment only, lower-cased', () {
      expect(fileExtension('Movie.2024/Movie.2024.1080p.MKV'), 'mkv');
      expect(fileExtension(r'Show.S01\Setup.EXE'), 'exe');
      expect(fileExtension('Show.S01/README'), '');
      expect(fileExtension('.hidden'), '');
      expect(fileExtension('trailing.'), '');
    });
  });

  group('torrentFileRisk', () {
    test('flags executables, including a disguised double extension', () {
      expect(
        torrentFileRisk('Movie.2024.1080p.mkv.exe'),
        TorrentFileRisk.executable,
      );
      expect(torrentFileRisk('Release/Codec.scr'), TorrentFileRisk.executable);
      expect(
        torrentFileRisk('Release/Play Movie.lnk'),
        TorrentFileRisk.executable,
      );
      expect(
        torrentFileRisk('Release/install.msi'),
        TorrentFileRisk.executable,
      );
    });

    test('flags disc images', () {
      expect(torrentFileRisk('Movie.2024.ISO'), TorrentFileRisk.diskImage);
      expect(torrentFileRisk('Release/disc.img'), TorrentFileRisk.diskImage);
    });

    test('leaves normal release contents alone', () {
      for (final name in [
        'Movie.2024.1080p.mkv',
        'Movie.2024/Sample/sample.mp4',
        'Movie.2024/Subs/English.srt',
        'Movie.2024/movie.nfo',
        'Movie.2024/movie.r00',
        'Movie.2024.exe.mkv',
      ]) {
        expect(torrentFileRisk(name), TorrentFileRisk.none, reason: name);
      }
    });
  });

  test('flaggedExtensions lists distinct extensions, executables first', () {
    expect(
      flaggedExtensions([
        'R/disc.iso',
        'R/movie.mkv',
        'R/setup.exe',
        'R/other.EXE',
        'R/codec.scr',
      ]),
      ['.exe', '.scr', '.iso'],
    );
    expect(flaggedExtensions(['R/movie.mkv', 'R/subs.srt']), isEmpty);
  });
}

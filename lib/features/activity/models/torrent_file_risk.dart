/// Flags files inside a torrent that a movie or TV release shouldn't
/// contain. Fake releases grabbed by Radarr/Sonarr often carry an
/// executable (`Movie.2024.1080p.mkv.exe`, `.scr`, `.lnk`) or a disc image
/// in place of the video.
library;

/// How suspicious one file in a torrent is.
enum TorrentFileRisk {
  /// Video, subtitles, NFOs, samples and the like.
  none,

  /// Programs and scripts that run when opened. A media release has no
  /// business including one; treat the torrent as malware.
  executable,

  /// Disc and disk images (`.iso`, `.img`, …). Sonarr/Radarr can't import
  /// them, and fake releases use them to hide an installer.
  diskImage,
}

const _executableExtensions = {
  'apk',
  'app',
  'bat',
  'cmd',
  'com',
  'cpl',
  'dll',
  'exe',
  'hta',
  'jar',
  'js',
  'jse',
  'lnk',
  'msi',
  'msp',
  'pif',
  'ps1',
  'reg',
  'run',
  'scr',
  'sh',
  'vbe',
  'vbs',
  'wsf',
  'wsh',
};

const _diskImageExtensions = {'dmg', 'img', 'iso', 'vhd', 'vhdx'};

/// The lower-cased extension of [path]'s file name, without the dot, or
/// `''` when it has none. Only the last path segment counts, so a dot in a
/// folder name (`Show.S01/episode`) is ignored.
String fileExtension(String path) {
  final name = path.split(RegExp(r'[/\\]')).last;
  final dot = name.lastIndexOf('.');
  if (dot <= 0 || dot == name.length - 1) return '';
  return name.substring(dot + 1).trim().toLowerCase();
}

TorrentFileRisk torrentFileRisk(String path) {
  final ext = fileExtension(path);
  if (_executableExtensions.contains(ext)) return TorrentFileRisk.executable;
  if (_diskImageExtensions.contains(ext)) return TorrentFileRisk.diskImage;
  return TorrentFileRisk.none;
}

/// The distinct flagged extensions among [paths], executables first, each
/// with its leading dot (e.g. `['.exe', '.iso']`). Empty when nothing is
/// flagged.
List<String> flaggedExtensions(Iterable<String> paths) {
  final executables = <String>{};
  final images = <String>{};
  for (final path in paths) {
    switch (torrentFileRisk(path)) {
      case TorrentFileRisk.executable:
        executables.add('.${fileExtension(path)}');
      case TorrentFileRisk.diskImage:
        images.add('.${fileExtension(path)}');
      case TorrentFileRisk.none:
        break;
    }
  }
  return [...executables, ...images];
}

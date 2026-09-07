/// Flattened, service-agnostic view of one interactive-search release. The
/// shared release_search UI renders only this type; `SonarrRepository` /
/// `RadarrRepository` map their raw releases into it.
library;

import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:meta/meta.dart';

/// Download protocol of a release. `unknown` covers a null or unexpected
/// `protocol` value from the API.
enum ReleaseProtocol { torrent, usenet, unknown }

@immutable
class ReleaseCandidate {
  const ReleaseCandidate({
    required this.guid,
    required this.indexerId,
    required this.indexerName,
    required this.title,
    required this.sizeBytes,
    required this.protocol,
    required this.qualityLabel,
    required this.qualityWeight,
    required this.ageMinutes,
    required this.isRejected,
    required this.rejections,
    required this.downloadAllowed,
    this.seeders,
    this.leechers,
    this.releaseGroup,
    this.customFormatScore,
  });

  final String guid;
  final int indexerId;
  final String indexerName;
  final String title;
  final int sizeBytes;
  final ReleaseProtocol protocol;

  /// e.g. `WEBDL-1080p`, or `—` when the API omitted a quality name.
  final String qualityLabel;

  /// Sonarr/Radarr `qualityWeight`; `0` when unknown. Sort key for Quality.
  final int qualityWeight;

  /// Release age in whole minutes; `0` when unknown. Sort key for Age.
  final int ageMinutes;

  final bool isRejected;
  final List<String> rejections;
  final bool downloadAllowed;
  final int? seeders;
  final int? leechers;
  final String? releaseGroup;
  final int? customFormatScore;

  /// Sort key for Peers (high→low): seeders, or `-1` when unknown so
  /// usenet / seeder-less releases sink to the bottom.
  int get peersKey => seeders ?? -1;

  factory ReleaseCandidate.fromSonarr(SonarrRelease r) => ReleaseCandidate(
    guid: r.guid,
    indexerId: r.indexerId,
    indexerName: (r.indexer == null || r.indexer!.isEmpty)
        ? 'Unknown indexer'
        : r.indexer!,
    title: r.title,
    sizeBytes: r.size,
    protocol: _protocol(r.protocol),
    qualityLabel: r.quality?.quality?.name ?? '—',
    qualityWeight: r.qualityWeight ?? 0,
    ageMinutes: (r.ageMinutes ?? 0).round(),
    isRejected: r.rejected,
    rejections: r.rejections,
    downloadAllowed: r.downloadAllowed,
    seeders: r.seeders,
    leechers: r.leechers,
    releaseGroup: r.releaseGroup,
    customFormatScore: r.customFormatScore,
  );

  factory ReleaseCandidate.fromRadarr(RadarrRelease r) => ReleaseCandidate(
    guid: r.guid,
    indexerId: r.indexerId,
    indexerName: (r.indexer == null || r.indexer!.isEmpty)
        ? 'Unknown indexer'
        : r.indexer!,
    title: r.title,
    sizeBytes: r.size,
    protocol: _protocol(r.protocol),
    qualityLabel: r.quality?.quality?.name ?? '—',
    qualityWeight: r.qualityWeight ?? 0,
    ageMinutes: (r.ageMinutes ?? 0).round(),
    isRejected: r.rejected,
    rejections: r.rejections,
    downloadAllowed: r.downloadAllowed,
    seeders: r.seeders,
    leechers: r.leechers,
    releaseGroup: r.releaseGroup,
    customFormatScore: r.customFormatScore,
  );

  static ReleaseProtocol _protocol(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'torrent':
        return ReleaseProtocol.torrent;
      case 'usenet':
        return ReleaseProtocol.usenet;
      default:
        return ReleaseProtocol.unknown;
    }
  }
}

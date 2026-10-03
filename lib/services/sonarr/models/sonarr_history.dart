/// Models for Sonarr's history feed (`GET /api/v3/history` and
/// `GET /api/v3/history/since`).
///
/// Parsed defensively: every field except [SonarrHistoryRecord.date] is
/// optional, and an embedded series, episode or quality block that doesn't
/// match the expected shape is dropped (null) rather than failing the whole
/// record.
library;

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sonarr_history.freezed.dart';
part 'sonarr_history.g.dart';

/// One event in Sonarr's history (a grab, an import, a failure, ...).
@freezed
abstract class SonarrHistoryRecord with _$SonarrHistoryRecord {
  const factory SonarrHistoryRecord({
    @Default(0) int id,
    int? seriesId,
    int? episodeId,

    /// Raw Sonarr event type, e.g. `grabbed`, `downloadFolderImported`,
    /// `downloadFailed`, `episodeFileDeleted`, `episodeFileRenamed`,
    /// `downloadIgnored`.
    @Default('unknown') String eventType,

    /// When the event happened (UTC as sent by Sonarr).
    required DateTime date,

    /// The release name the event concerns.
    String? sourceTitle,
    String? downloadId,
    @JsonKey(fromJson: _qualityFromJson) SonarrQualityInfo? quality,

    /// The series, present when requested with `includeSeries=true`.
    @JsonKey(fromJson: _seriesFromJson) SonarrHistorySeries? series,

    /// The episode, present when requested with `includeEpisode=true`.
    @JsonKey(fromJson: _episodeFromJson) SonarrHistoryEpisode? episode,
  }) = _SonarrHistoryRecord;

  factory SonarrHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$SonarrHistoryRecordFromJson(json);
}

/// The slice of a series that history rows need: title, year and poster.
@freezed
abstract class SonarrHistorySeries with _$SonarrHistorySeries {
  const factory SonarrHistorySeries({
    int? id,
    String? title,
    int? year,
    @JsonKey(fromJson: _imagesFromJson) List<SonarrImage>? images,
  }) = _SonarrHistorySeries;

  factory SonarrHistorySeries.fromJson(Map<String, dynamic> json) =>
      _$SonarrHistorySeriesFromJson(json);
}

/// The slice of an episode that history rows need.
@freezed
abstract class SonarrHistoryEpisode with _$SonarrHistoryEpisode {
  const factory SonarrHistoryEpisode({
    int? id,
    int? seasonNumber,
    int? episodeNumber,
    String? title,
  }) = _SonarrHistoryEpisode;

  factory SonarrHistoryEpisode.fromJson(Map<String, dynamic> json) =>
      _$SonarrHistoryEpisodeFromJson(json);
}

extension SonarrHistoryRecordX on SonarrHistoryRecord {
  /// Quality name of the release, e.g. "WEBDL-1080p".
  String? get qualityName => quality?.quality?.name;

  /// The embedded series' title, when included.
  String? get seriesTitle => series?.title;

  int? get seasonNumber => episode?.seasonNumber;

  int? get episodeNumber => episode?.episodeNumber;

  /// The embedded episode's title, when included.
  String? get episodeTitle => episode?.title;

  /// "S01E05", or null when the episode numbers weren't included.
  String? get episodeCode {
    final s = episode?.seasonNumber;
    final e = episode?.episodeNumber;
    if (s == null || e == null) return null;
    return 'S${s.toString().padLeft(2, '0')}E${e.toString().padLeft(2, '0')}';
  }

  /// "Severance S02E05", falling back to the release name, then
  /// "Unknown episode".
  String get displayTitle {
    final title = series?.title;
    if (title != null && title.isNotEmpty) {
      final code = episodeCode;
      return code == null ? title : '$title $code';
    }
    final source = sourceTitle;
    if (source != null && source.isNotEmpty) return source;
    return 'Unknown episode';
  }

  /// Poster of the embedded series, remote CDN URL preferred.
  String? get posterUrl {
    final imgs = series?.images;
    if (imgs == null || imgs.isEmpty) return null;
    final poster = imgs.firstWhere(
      (i) => i.coverType == 'poster',
      orElse: () => imgs.first,
    );
    final remote = poster.remoteUrl;
    if (remote != null && remote.isNotEmpty) return remote;
    final url = poster.url;
    return url != null && url.isNotEmpty ? url : null;
  }
}

SonarrQualityInfo? _qualityFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return SonarrQualityInfo.fromJson(json);
  } on Object {
    return null;
  }
}

SonarrHistorySeries? _seriesFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return SonarrHistorySeries.fromJson(json);
  } on Object {
    return null;
  }
}

SonarrHistoryEpisode? _episodeFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return SonarrHistoryEpisode.fromJson(json);
  } on Object {
    return null;
  }
}

List<SonarrImage>? _imagesFromJson(Object? json) {
  if (json is! List) return null;
  final images = <SonarrImage>[];
  for (final item in json) {
    if (item is! Map<String, dynamic>) continue;
    try {
      images.add(SonarrImage.fromJson(item));
    } on Object {
      continue;
    }
  }
  return images;
}

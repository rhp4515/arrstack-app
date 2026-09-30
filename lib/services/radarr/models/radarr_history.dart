/// Models for Radarr's history feed (`GET /api/v3/history` and
/// `GET /api/v3/history/since`).
///
/// Parsed defensively: every field except [RadarrHistoryRecord.date] is
/// optional, and an embedded movie or quality block that doesn't match the
/// expected shape is dropped (null) rather than failing the whole record.
library;

import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'radarr_history.freezed.dart';
part 'radarr_history.g.dart';

/// One event in Radarr's history (a grab, an import, a failure, ...).
@freezed
abstract class RadarrHistoryRecord with _$RadarrHistoryRecord {
  const factory RadarrHistoryRecord({
    @Default(0) int id,
    int? movieId,

    /// Raw Radarr event type, e.g. `grabbed`, `downloadFolderImported`,
    /// `downloadFailed`, `movieFileDeleted`, `movieFileRenamed`,
    /// `downloadIgnored`.
    @Default('unknown') String eventType,

    /// When the event happened (UTC as sent by Radarr).
    required DateTime date,

    /// The release name the event concerns.
    String? sourceTitle,
    String? downloadId,
    @JsonKey(fromJson: _qualityFromJson) RadarrQualityInfo? quality,

    /// The movie, present when requested with `includeMovie=true`.
    @JsonKey(fromJson: _movieFromJson) RadarrHistoryMovie? movie,
  }) = _RadarrHistoryRecord;

  factory RadarrHistoryRecord.fromJson(Map<String, dynamic> json) =>
      _$RadarrHistoryRecordFromJson(json);
}

/// The slice of a movie that history rows need: enough for a title, year and
/// poster. Kept separate from [RadarrMovie] so a partial embedded movie can
/// never fail a history record.
@freezed
abstract class RadarrHistoryMovie with _$RadarrHistoryMovie {
  const factory RadarrHistoryMovie({
    int? id,
    String? title,
    int? year,
    @JsonKey(fromJson: _imagesFromJson) List<RadarrImage>? images,
  }) = _RadarrHistoryMovie;

  factory RadarrHistoryMovie.fromJson(Map<String, dynamic> json) =>
      _$RadarrHistoryMovieFromJson(json);
}

extension RadarrHistoryRecordX on RadarrHistoryRecord {
  /// Quality name of the release, e.g. "Bluray-1080p".
  String? get qualityName => quality?.quality?.name;

  /// The embedded movie's title, when included.
  String? get movieTitle => movie?.title;

  /// The embedded movie's year, when included.
  int? get movieYear => movie?.year;

  /// "Dune (2021)", falling back to the release name, then "Unknown movie".
  String get displayTitle {
    final title = movie?.title;
    if (title != null && title.isNotEmpty) {
      final year = movie?.year;
      return year == null || year == 0 ? title : '$title ($year)';
    }
    final source = sourceTitle;
    if (source != null && source.isNotEmpty) return source;
    return 'Unknown movie';
  }

  /// Poster of the embedded movie, remote CDN URL preferred.
  String? get posterUrl {
    final imgs = movie?.images;
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

RadarrQualityInfo? _qualityFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return RadarrQualityInfo.fromJson(json);
  } on Object {
    return null;
  }
}

RadarrHistoryMovie? _movieFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return RadarrHistoryMovie.fromJson(json);
  } on Object {
    return null;
  }
}

List<RadarrImage>? _imagesFromJson(Object? json) {
  if (json is! List) return null;
  final images = <RadarrImage>[];
  for (final item in json) {
    if (item is! Map<String, dynamic>) continue;
    try {
      images.add(RadarrImage.fromJson(item));
    } on Object {
      continue;
    }
  }
  return images;
}

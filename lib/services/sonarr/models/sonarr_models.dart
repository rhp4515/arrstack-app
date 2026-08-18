/// Models for the Sonarr API (v3).
///
/// These models follow the schema of the Sonarr API and are used for library
/// browsing and adding new series.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sonarr_models.freezed.dart';
part 'sonarr_models.g.dart';

/// One series in the Sonarr library or a lookup result.
@freezed
abstract class SonarrSeries with _$SonarrSeries {
  const factory SonarrSeries({
    /// Unique ID in the Sonarr database (null for lookup results).
    int? id,
    required String title,
    String? sortTitle,
    String? status,
    String? overview,
    List<SonarrImage>? images,
    List<SonarrSeason>? seasons,
    int? year,
    String? path,
    String? rootFolderPath,
    int? qualityProfileId,
    @Default(true) bool monitored,
    @Default(false) bool useSceneNumbering,
    // Sonarr returns runtime as an int (minutes), not a string.
    int? runtime,
    @Default(0) int tvdbId,
    int? tvMazeId,
    @Default('program') String seriesType,
    String? cleanTitle,
    String? titleSlug,
    String? imdbId,
    String? network,
    String? certification,
    DateTime? firstAired,
    SonarrRatings? ratings,
    DateTime? added,
    List<String>? genres,
    // Tags are stored as int IDs in Sonarr.
    List<int>? tags,
    SonarrStatistics? statistics,
    SonarrAddOptions? addOptions,
  }) = _SonarrSeries;

  factory SonarrSeries.fromJson(Map<String, dynamic> json) =>
      _$SonarrSeriesFromJson(json);
}

@freezed
abstract class SonarrAddOptions with _$SonarrAddOptions {
  const factory SonarrAddOptions({
    @Default('all') String monitor,
    @Default(false) bool searchForMissingEpisodes,
  }) = _SonarrAddOptions;

  factory SonarrAddOptions.fromJson(Map<String, dynamic> json) =>
      _$SonarrAddOptionsFromJson(json);
}

extension SonarrSeriesX on SonarrSeries {
  /// Downloaded-vs-total episode count, e.g. "30/296". Falls back to "0/0"
  /// when statistics are absent so the row still renders a stable label.
  String get episodeProgressLabel {
    final stats = statistics;
    final have = stats?.episodeFileCount ?? 0;
    final total = stats?.totalEpisodeCount ?? stats?.episodeCount ?? 0;
    return '$have/$total';
  }

  String? get posterUrl {
    final imgs = images;
    if (imgs == null || imgs.isEmpty) return null;
    final image = imgs.firstWhere(
      (i) => i.coverType == 'poster',
      orElse: () => imgs.firstWhere(
        (i) => i.coverType == 'fanart',
        orElse: () => imgs.first,
      ),
    );
    // Prefer the auth-free remote (TVDB) CDN URL so posters load regardless of
    // the server's authentication mode; fall back to the internal path (which
    // the image provider will sign with an API key) only when it's absent.
    final remote = image.remoteUrl;
    if (remote != null && remote.isNotEmpty) return remote;
    return (image.url != null && image.url!.isNotEmpty) ? image.url : null;
  }
}

/// Artwork for a series.
@freezed
abstract class SonarrImage with _$SonarrImage {
  const factory SonarrImage({
    String? coverType,
    String? url,
    String? remoteUrl,
  }) = _SonarrImage;

  factory SonarrImage.fromJson(Map<String, dynamic> json) =>
      _$SonarrImageFromJson(json);
}

/// A season within a series.
@freezed
abstract class SonarrSeason with _$SonarrSeason {
  const factory SonarrSeason({
    int? seasonNumber,
    @Default(true) bool monitored,
    SonarrStatistics? statistics,
  }) = _SonarrSeason;

  factory SonarrSeason.fromJson(Map<String, dynamic> json) =>
      _$SonarrSeasonFromJson(json);
}

/// Statistics for a series or season.
@freezed
abstract class SonarrStatistics with _$SonarrStatistics {
  const factory SonarrStatistics({
    int? seasonCount,
    int? episodeFileCount,
    int? episodeCount,
    int? totalEpisodeCount,
    int? sizeOnDisk,
    double? percentOfEpisodes,
  }) = _SonarrStatistics;

  factory SonarrStatistics.fromJson(Map<String, dynamic> json) =>
      _$SonarrStatisticsFromJson(json);
}

/// An episode in Sonarr.
@freezed
abstract class SonarrEpisode with _$SonarrEpisode {
  const factory SonarrEpisode({
    required int id,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
    required String title,
    String? overview,
    required bool hasFile,
    required bool monitored,
    DateTime? airDateUtc,
    int? runtime,
    int? episodeFileId,
    SonarrEpisodeFile? episodeFile,
    int? absoluteEpisodeNumber,
    int? sceneEpisodeNumber,
    int? sceneSeasonNumber,
    @Default(false) bool unverifiedSceneNumbering,
  }) = _SonarrEpisode;

  factory SonarrEpisode.fromJson(Map<String, dynamic> json) =>
      _$SonarrEpisodeFromJson(json);
}

extension SonarrEpisodeX on SonarrEpisode {
  /// "S01E01" style code for display.
  String get episodeCode =>
      'S${seasonNumber.toString().padLeft(2, '0')}'
      'E${episodeNumber.toString().padLeft(2, '0')}';

  /// Quality name of the downloaded file (e.g. "Bluray-1080p"), if present.
  String? get qualityName => episodeFile?.quality?.quality.name;
}

/// The downloaded file for an episode, with its quality and technical info.
@freezed
abstract class SonarrEpisodeFile with _$SonarrEpisodeFile {
  const factory SonarrEpisodeFile({
    required int id,
    String? relativePath,
    @Default(0) int size,
    DateTime? dateAdded,
    SonarrQualityInfo? quality,
  }) = _SonarrEpisodeFile;

  factory SonarrEpisodeFile.fromJson(Map<String, dynamic> json) =>
      _$SonarrEpisodeFileFromJson(json);
}

/// Quality wrapper matching Sonarr's `quality: { quality: { name } }` shape.
@freezed
abstract class SonarrQualityInfo with _$SonarrQualityInfo {
  const factory SonarrQualityInfo({required SonarrQuality quality}) =
      _SonarrQualityInfo;

  factory SonarrQualityInfo.fromJson(Map<String, dynamic> json) =>
      _$SonarrQualityInfoFromJson(json);
}

@freezed
abstract class SonarrQuality with _$SonarrQuality {
  const factory SonarrQuality({required int id, required String name}) =
      _SonarrQuality;

  factory SonarrQuality.fromJson(Map<String, dynamic> json) =>
      _$SonarrQualityFromJson(json);
}

/// Aggregate rating for a series (Sonarr returns a single value/votes pair).
@freezed
abstract class SonarrRatings with _$SonarrRatings {
  const factory SonarrRatings({
    @Default(0) int votes,
    @Default(0) double value,
  }) = _SonarrRatings;

  factory SonarrRatings.fromJson(Map<String, dynamic> json) =>
      _$SonarrRatingsFromJson(json);
}

/// One entry from Sonarr's `/api/v3/calendar` feed: a scheduled episode with
/// its parent series embedded (when requested with `includeSeries=true`).
@freezed
abstract class SonarrCalendarEpisode with _$SonarrCalendarEpisode {
  const factory SonarrCalendarEpisode({
    required int id,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
    String? title,
    DateTime? airDateUtc,
    @Default(false) bool hasFile,
    @Default(true) bool monitored,
    SonarrSeries? series,
  }) = _SonarrCalendarEpisode;

  factory SonarrCalendarEpisode.fromJson(Map<String, dynamic> json) =>
      _$SonarrCalendarEpisodeFromJson(json);
}

/// A quality profile (e.g. "Any", "HD-1080p").
@freezed
abstract class SonarrQualityProfile with _$SonarrQualityProfile {
  const factory SonarrQualityProfile({required int id, required String name}) =
      _SonarrQualityProfile;

  factory SonarrQualityProfile.fromJson(Map<String, dynamic> json) =>
      _$SonarrQualityProfileFromJson(json);
}

/// A root folder (e.g. "/tv").
@freezed
abstract class SonarrRootFolder with _$SonarrRootFolder {
  const factory SonarrRootFolder({
    required int id,
    required String path,
    required int freeSpace,
  }) = _SonarrRootFolder;

  factory SonarrRootFolder.fromJson(Map<String, dynamic> json) =>
      _$SonarrRootFolderFromJson(json);
}

@freezed
abstract class SonarrQueueItem with _$SonarrQueueItem {
  const factory SonarrQueueItem({
    required int id,
    int? seriesId,
    int? episodeId,
    String? status,
    @Default(0) int size,
    @Default(0) int sizeleft,
    String? title,
    String? timeleft,
    DateTime? estimatedCompletionTime,
  }) = _SonarrQueueItem;

  factory SonarrQueueItem.fromJson(Map<String, dynamic> json) =>
      _$SonarrQueueItemFromJson(json);
}

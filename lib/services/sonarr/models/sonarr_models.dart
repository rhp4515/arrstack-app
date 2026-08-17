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
    required String sortTitle,
    required String status,
    required String overview,
    required List<SonarrImage> images,
    required List<SonarrSeason> seasons,
    required int year,
    String? path,
    String? rootFolderPath,
    int? qualityProfileId,
    required bool monitored,
    @Default(false) bool useSceneNumbering,
    String? runtime,
    required int tvdbId,
    int? tvMazeId,
    required String seriesType,
    String? cleanTitle,
    String? titleSlug,
    DateTime? added,
    @Default([]) List<String> genres,
    @Default([]) List<String> tags,
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
  String? get posterUrl {
    if (images.isEmpty) return null;
    final image = images.firstWhere(
      (i) => i.coverType == 'poster',
      orElse: () => images.firstWhere(
        (i) => i.coverType == 'fanart',
        orElse: () => images.first,
      ),
    );
    return (image.url.isNotEmpty) ? image.url : image.remoteUrl;
  }
}

/// Artwork for a series.
@freezed
abstract class SonarrImage with _$SonarrImage {
  const factory SonarrImage({
    required String coverType,
    required String url,
    String? remoteUrl,
  }) = _SonarrImage;

  factory SonarrImage.fromJson(Map<String, dynamic> json) =>
      _$SonarrImageFromJson(json);
}

/// A season within a series.
@freezed
abstract class SonarrSeason with _$SonarrSeason {
  const factory SonarrSeason({
    required int seasonNumber,
    required bool monitored,
    SonarrStatistics? statistics,
  }) = _SonarrSeason;

  factory SonarrSeason.fromJson(Map<String, dynamic> json) =>
      _$SonarrSeasonFromJson(json);
}

/// Statistics for a series or season.
@freezed
abstract class SonarrStatistics with _$SonarrStatistics {
  const factory SonarrStatistics({
    required int seasonCount,
    required int episodeFileCount,
    required int episodeCount,
    required int totalEpisodeCount,
    required int sizeOnDisk,
    required double percentOfEpisodes,
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
    int? absoluteEpisodeNumber,
    int? sceneEpisodeNumber,
    int? sceneSeasonNumber,
    required bool unverifiedSceneNumbering,
  }) = _SonarrEpisode;

  factory SonarrEpisode.fromJson(Map<String, dynamic> json) =>
      _$SonarrEpisodeFromJson(json);
}

/// A quality profile (e.g. "Any", "HD-1080p").
@freezed
abstract class SonarrQualityProfile with _$SonarrQualityProfile {
  const factory SonarrQualityProfile({
    required int id,
    required String name,
  }) = _SonarrQualityProfile;

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

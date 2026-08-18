/// Models for the Radarr API (v3).
///
/// These models follow the schema of the Radarr API and are used for both
/// library browsing and adding new movies.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'radarr_models.freezed.dart';
part 'radarr_models.g.dart';

/// One movie in the Radarr library or a lookup result.
@freezed
abstract class RadarrMovie with _$RadarrMovie {
  const factory RadarrMovie({
    /// Unique ID in the Radarr database (null for lookup results).
    int? id,
    required String title,
    required int year,
    required bool monitored,
    required String status,
    required String overview,
    required String sortTitle,
    DateTime? added,
    required List<RadarrImage> images,
    int? qualityProfileId,
    String? rootFolderPath,
    String? path,
    RadarrMovieFile? movieFile,
    required int tmdbId,
    String? imdbId,
    String? titleSlug,
    String? studio,
    String? certification,
    int? runtime,
    @Default([]) List<String> genres,
    RadarrRatings? ratings,
    DateTime? inCinemas,
    DateTime? physicalRelease,
    DateTime? digitalRelease,
    @Default(false) bool hasFile,
    @Default(0) int sizeOnDisk,
  }) = _RadarrMovie;

  factory RadarrMovie.fromJson(Map<String, dynamic> json) =>
      _$RadarrMovieFromJson(json);
}

extension RadarrMovieX on RadarrMovie {
  /// Human-readable quality of the downloaded file (e.g. "Bluray-1080p"),
  /// or null when the movie has no file yet.
  String? get displayQuality => movieFile?.quality.quality.name;

  /// Best single rating (0–10) to surface, preferring TMDB then IMDb.
  double? get displayRating => ratings?.tmdb?.value ?? ratings?.imdb?.value;

  /// The most relevant release date for scheduling: digital, then physical,
  /// then theatrical. Used by the Calendar to place the movie on a day.
  DateTime? get calendarDate => digitalRelease ?? physicalRelease ?? inCinemas;

  /// The kind of release [calendarDate] refers to, for a subtitle label.
  String? get calendarReleaseLabel {
    if (digitalRelease != null) return 'Digital Release';
    if (physicalRelease != null) return 'Physical Release';
    if (inCinemas != null) return 'In Cinemas';
    return null;
  }

  String? get posterUrl {
    if (images.isEmpty) return null;
    final image = images.firstWhere(
      (i) => i.coverType == 'poster',
      orElse: () => images.firstWhere(
        (i) => i.coverType == 'fanart',
        orElse: () => images.first,
      ),
    );
    // Prefer the auth-free remote (TMDB) CDN URL so posters load regardless of
    // the server's authentication mode; fall back to the internal path (which
    // the image provider will sign with an API key) only when it's absent.
    final remote = image.remoteUrl;
    if (remote != null && remote.isNotEmpty) return remote;
    return image.url.isNotEmpty ? image.url : null;
  }
}

/// Artwork for a movie.
@freezed
abstract class RadarrImage with _$RadarrImage {
  const factory RadarrImage({
    required String coverType,
    required String url,
    String? remoteUrl,
  }) = _RadarrImage;

  factory RadarrImage.fromJson(Map<String, dynamic> json) =>
      _$RadarrImageFromJson(json);
}

/// Information about the downloaded file for a movie.
@freezed
abstract class RadarrMovieFile with _$RadarrMovieFile {
  const factory RadarrMovieFile({
    required int id,
    required String relativePath,
    required int size,
    required DateTime dateAdded,
    required RadarrQualityInfo quality,
  }) = _RadarrMovieFile;

  factory RadarrMovieFile.fromJson(Map<String, dynamic> json) =>
      _$RadarrMovieFileFromJson(json);
}

/// Quality info for a file or profile.
@freezed
abstract class RadarrQualityInfo with _$RadarrQualityInfo {
  const factory RadarrQualityInfo({required RadarrQuality quality}) =
      _RadarrQualityInfo;

  factory RadarrQualityInfo.fromJson(Map<String, dynamic> json) =>
      _$RadarrQualityInfoFromJson(json);
}

@freezed
abstract class RadarrQuality with _$RadarrQuality {
  const factory RadarrQuality({required int id, required String name}) =
      _RadarrQuality;

  factory RadarrQuality.fromJson(Map<String, dynamic> json) =>
      _$RadarrQualityFromJson(json);
}

/// Aggregate ratings for a movie from various providers.
@freezed
abstract class RadarrRatings with _$RadarrRatings {
  const factory RadarrRatings({
    RadarrRatingValue? imdb,
    RadarrRatingValue? tmdb,
    RadarrRatingValue? rottenTomatoes,
  }) = _RadarrRatings;

  factory RadarrRatings.fromJson(Map<String, dynamic> json) =>
      _$RadarrRatingsFromJson(json);
}

/// A single rating source's value and vote count.
@freezed
abstract class RadarrRatingValue with _$RadarrRatingValue {
  const factory RadarrRatingValue({
    @Default(0) int votes,
    @Default(0) double value,
  }) = _RadarrRatingValue;

  factory RadarrRatingValue.fromJson(Map<String, dynamic> json) =>
      _$RadarrRatingValueFromJson(json);
}

/// A quality profile (e.g. "Any", "HD-1080p").
@freezed
abstract class RadarrQualityProfile with _$RadarrQualityProfile {
  const factory RadarrQualityProfile({required int id, required String name}) =
      _RadarrQualityProfile;

  factory RadarrQualityProfile.fromJson(Map<String, dynamic> json) =>
      _$RadarrQualityProfileFromJson(json);
}

/// A root folder (e.g. "/movies").
@freezed
abstract class RadarrRootFolder with _$RadarrRootFolder {
  const factory RadarrRootFolder({
    required int id,
    required String path,
    required int freeSpace,
  }) = _RadarrRootFolder;

  factory RadarrRootFolder.fromJson(Map<String, dynamic> json) =>
      _$RadarrRootFolderFromJson(json);
}

/// An item in the Radarr download queue.
@freezed
abstract class RadarrQueueItem with _$RadarrQueueItem {
  const factory RadarrQueueItem({
    required int id,
    int? movieId,
    String? status,
    @Default(0) int size,
    @Default(0) int sizeleft,
    String? title,
    String? timeleft,
    DateTime? estimatedCompletionTime,
  }) = _RadarrQueueItem;

  factory RadarrQueueItem.fromJson(Map<String, dynamic> json) =>
      _$RadarrQueueItemFromJson(json);
}

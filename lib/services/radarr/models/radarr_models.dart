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
    @Default('Unknown') String title,
    int? year,
    @Default(true) bool monitored,
    String? status,
    String? overview,
    String? sortTitle,
    DateTime? added,
    List<RadarrImage>? images,
    int? qualityProfileId,
    String? rootFolderPath,
    String? path,
    RadarrMovieFile? movieFile,
    int? tmdbId,
    String? imdbId,
    String? titleSlug,
    String? studio,
    String? certification,
    int? runtime,
    List<String>? genres,
    RadarrRatings? ratings,
    @Default('announced') String minimumAvailability,
    DateTime? inCinemas,
    DateTime? physicalRelease,
    DateTime? digitalRelease,
    @Default(false) bool hasFile,
    @Default(0) int sizeOnDisk,
    RadarrAddOptions? addOptions,
  }) = _RadarrMovie;

  factory RadarrMovie.fromJson(Map<String, dynamic> json) =>
      _$RadarrMovieFromJson(json);
}

@freezed
abstract class RadarrAddOptions with _$RadarrAddOptions {
  const factory RadarrAddOptions({
    @Default(false) bool searchForMovie,
    @Default('movieOnly') String monitor,
  }) = _RadarrAddOptions;

  factory RadarrAddOptions.fromJson(Map<String, dynamic> json) =>
      _$RadarrAddOptionsFromJson(json);
}

extension RadarrMovieX on RadarrMovie {
  /// Human-readable quality of the downloaded file (e.g. "Bluray-1080p"),
  /// or null when the movie has no file yet.
  String? get displayQuality => movieFile?.quality?.quality?.name;

  /// Best single rating (0–10) to surface, preferring TMDB then IMDb.
  double? get displayRating => ratings?.tmdb?.value ?? ratings?.imdb?.value;

  /// The most relevant release date for scheduling: digital, then physical,
  /// then theatrical. Used by the Calendar to place the movie on a day.
  DateTime? get calendarDate => digitalRelease ?? physicalRelease ?? inCinemas;

  /// The release to place on a calendar spanning the local days [start]
  /// through [end] (inclusive): the first of digital, physical, then
  /// theatrical whose day falls inside the window, with a label naming it.
  ///
  /// Radarr's calendar endpoint returns a movie when *any* of its release
  /// dates is in range, so the fixed-priority [calendarDate] can land far
  /// outside the requested window (a past digital release shown for a movie
  /// that matched on an upcoming physical one). Null when none fall inside.
  ({DateTime day, String label})? calendarReleaseWithin(
    DateTime start,
    DateTime end,
  ) {
    final first = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    for (final (date, label) in [
      (digitalRelease, 'Digital Release'),
      (physicalRelease, 'Physical Release'),
      (inCinemas, 'In Cinemas'),
    ]) {
      if (date == null) continue;
      final day = radarrReleaseDay(date);
      if (!day.isBefore(first) && !day.isAfter(last)) {
        return (day: day, label: label);
      }
    }
    return null;
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
    // Prefer the auth-free remote (TMDB) CDN URL so posters load regardless of
    // the server's authentication mode; fall back to the internal path (which
    // the image provider will sign with an API key) only when it's absent.
    final remote = image.remoteUrl;
    if (remote != null && remote.isNotEmpty) return remote;
    return (image.url != null && image.url!.isNotEmpty) ? image.url : null;
  }
}

/// The local calendar day of a Radarr release date. Radarr stores release
/// dates as date-only values serialized as UTC midnight, so the day is read
/// in UTC — converting to local time would move it to the previous evening
/// anywhere west of UTC.
DateTime radarrReleaseDay(DateTime date) {
  final utc = date.toUtc();
  return DateTime(utc.year, utc.month, utc.day);
}

/// Artwork for a movie.
@freezed
abstract class RadarrImage with _$RadarrImage {
  const factory RadarrImage({
    String? coverType,
    String? url,
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
    String? relativePath,
    int? size,
    DateTime? dateAdded,
    RadarrQualityInfo? quality,
    String? releaseGroup,
    RadarrMediaInfo? mediaInfo,
  }) = _RadarrMovieFile;

  factory RadarrMovieFile.fromJson(Map<String, dynamic> json) =>
      _$RadarrMovieFileFromJson(json);
}

/// Technical media details Radarr extracts from the file (spec 2g "FILE").
@freezed
abstract class RadarrMediaInfo with _$RadarrMediaInfo {
  const factory RadarrMediaInfo({
    String? videoCodec,
    String? audioCodec,
    double? audioChannels,
    String? resolution,
    String? videoDynamicRangeType,
  }) = _RadarrMediaInfo;

  factory RadarrMediaInfo.fromJson(Map<String, dynamic> json) =>
      _$RadarrMediaInfoFromJson(json);
}

/// Quality wrapper matching Radarr's `quality: { quality: { name } }` shape.
@freezed
abstract class RadarrQualityInfo with _$RadarrQualityInfo {
  const factory RadarrQualityInfo({RadarrQuality? quality}) =
      _RadarrQualityInfo;

  factory RadarrQualityInfo.fromJson(Map<String, dynamic> json) =>
      _$RadarrQualityInfoFromJson(json);
}

@freezed
abstract class RadarrQuality with _$RadarrQuality {
  const factory RadarrQuality({int? id, String? name}) = _RadarrQuality;

  factory RadarrQuality.fromJson(Map<String, dynamic> json) =>
      _$RadarrQualityFromJson(json);
}

/// One release from Radarr's interactive search (`GET /api/v3/release?movieId=`).
@freezed
abstract class RadarrRelease with _$RadarrRelease {
  const factory RadarrRelease({
    @Default('') String guid,
    @Default('') String title,
    @Default(0) int size,
    @Default(0) int indexerId,
    String? indexer,
    int? seeders,
    int? leechers,
    String? protocol,
    RadarrQualityInfo? quality,
    int? qualityWeight,
    num? ageMinutes,
    @Default(false) bool rejected,
    @JsonKey(fromJson: _rejectionsFromJson)
    @Default(<String>[])
    List<String> rejections,
    String? releaseGroup,
    @Default(true) bool downloadAllowed,
    int? customFormatScore,
  }) = _RadarrRelease;

  factory RadarrRelease.fromJson(Map<String, dynamic> json) =>
      _$RadarrReleaseFromJson(json);
}

/// Radarr v3 returns `rejections` as `List<String>`; newer Radarr returns
/// `[{reason, type}]`. Normalise both to a list of reason strings.
List<String> _rejectionsFromJson(dynamic raw) {
  if (raw is! List) {
    return const [];
  }
  return raw.map((e) {
    if (e is String) {
      return e;
    }
    if (e is Map) {
      return (e['reason'] ?? e).toString();
    }
    return e.toString();
  }).toList();
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
  const factory RadarrQualityProfile({required int id, String? name}) =
      _RadarrQualityProfile;

  factory RadarrQualityProfile.fromJson(Map<String, dynamic> json) =>
      _$RadarrQualityProfileFromJson(json);
}

/// A root folder (e.g. "/movies").
@freezed
abstract class RadarrRootFolder with _$RadarrRootFolder {
  const factory RadarrRootFolder({
    required int id,
    String? path,
    int? freeSpace,
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

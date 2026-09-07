import 'package:freezed_annotation/freezed_annotation.dart';

part 'seerr_models.freezed.dart';
part 'seerr_models.g.dart';

@freezed
abstract class SeerrResult with _$SeerrResult {
  const factory SeerrResult({
    required int id,
    @Default('movie') String mediaType,
    String? title,
    String? name,
    String? posterPath,
    String? backdropPath,
    String? overview,
    String? releaseDate,
    String? firstAirDate,
    double? voteAverage,
    SeerrMediaInfo? mediaInfo,
  }) = _SeerrResult;

  factory SeerrResult.fromJson(Map<String, dynamic> json) =>
      _$SeerrResultFromJson(json);
}

/// Mirrors Overseerr/Jellyseerr's `MediaInfo.status`, i.e. the `MediaStatus`
/// enum from `server/constants/media.ts`. NOT the same enum as
/// [SeerrRequest.status] (`MediaRequestStatus`) — a media item can be
/// AVAILABLE while its originating request is separately COMPLETED.
abstract final class SeerrMediaStatus {
  static const int unknown = 1;
  static const int pending = 2;
  static const int processing = 3;
  static const int partiallyAvailable = 4;
  static const int available = 5;
  static const int deleted = 6;
}

/// Mirrors `MediaRequestStatus` from `server/constants/media.ts`.
abstract final class SeerrRequestStatus {
  static const int pending = 1;
  static const int approved = 2;
  static const int declined = 3;
  static const int failed = 4;
  static const int completed = 5;
}

@freezed
abstract class SeerrMediaInfo with _$SeerrMediaInfo {
  const factory SeerrMediaInfo({
    required int id,
    int? tmdbId,
    int? tvdbId,
    @Default(SeerrMediaStatus.unknown) int status,
    @Default([]) List<SeerrRequest> requests,
  }) = _SeerrMediaInfo;

  factory SeerrMediaInfo.fromJson(Map<String, dynamic> json) =>
      _$SeerrMediaInfoFromJson(json);
}

/// A single request, as returned nested under `MediaInfo.requests` or as a
/// row from `GET /request`. The latter enriches `media` with only the
/// identifiers Overseerr stores server-side (id, tmdbId, mediaType, status) —
/// poster/title/year are NOT included and must be fetched separately via
/// `SeerrRepository.getMovieDetail`/`getTvDetail`, matching how Overseerr's
/// own web UI resolves each request card.
@freezed
abstract class SeerrRequest with _$SeerrRequest {
  const factory SeerrRequest({
    required int id,
    @Default(SeerrRequestStatus.pending) int status,
    SeerrRequestMedia? media,
    SeerrRequestUser? requestedBy,
    @Default([]) List<SeerrRequestSeason> seasons,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SeerrRequest;

  factory SeerrRequest.fromJson(Map<String, dynamic> json) =>
      _$SeerrRequestFromJson(json);
}

@freezed
abstract class SeerrRequestMedia with _$SeerrRequestMedia {
  const factory SeerrRequestMedia({
    required int id,
    int? tmdbId,
    @Default('movie') String mediaType,
    @Default(SeerrMediaStatus.unknown) int status,
  }) = _SeerrRequestMedia;

  factory SeerrRequestMedia.fromJson(Map<String, dynamic> json) =>
      _$SeerrRequestMediaFromJson(json);
}

@freezed
abstract class SeerrRequestUser with _$SeerrRequestUser {
  const factory SeerrRequestUser({String? displayName, String? email}) =
      _SeerrRequestUser;

  factory SeerrRequestUser.fromJson(Map<String, dynamic> json) =>
      _$SeerrRequestUserFromJson(json);
}

@freezed
abstract class SeerrRequestSeason with _$SeerrRequestSeason {
  const factory SeerrRequestSeason({
    required int id,
    required int seasonNumber,
    @Default(SeerrRequestStatus.pending) int status,
  }) = _SeerrRequestSeason;

  factory SeerrRequestSeason.fromJson(Map<String, dynamic> json) =>
      _$SeerrRequestSeasonFromJson(json);
}

@freezed
abstract class SeerrPageInfo with _$SeerrPageInfo {
  const factory SeerrPageInfo({
    @Default(1) int page,
    @Default(1) int pages,
    @Default(0) int results,
    @Default(20) int pageSize,
  }) = _SeerrPageInfo;

  factory SeerrPageInfo.fromJson(Map<String, dynamic> json) =>
      _$SeerrPageInfoFromJson(json);
}

@freezed
abstract class SeerrRequestsResponse with _$SeerrRequestsResponse {
  const factory SeerrRequestsResponse({
    required SeerrPageInfo pageInfo,
    @Default([]) List<SeerrRequest> results,
  }) = _SeerrRequestsResponse;

  factory SeerrRequestsResponse.fromJson(Map<String, dynamic> json) =>
      _$SeerrRequestsResponseFromJson(json);
}

@freezed
abstract class SeerrDiscoveryResponse with _$SeerrDiscoveryResponse {
  const factory SeerrDiscoveryResponse({
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(0) int totalResults,
    @Default([]) List<SeerrResult> results,
  }) = _SeerrDiscoveryResponse;

  factory SeerrDiscoveryResponse.fromJson(Map<String, dynamic> json) =>
      _$SeerrDiscoveryResponseFromJson(json);
}

@freezed
abstract class SeerrGenre with _$SeerrGenre {
  const factory SeerrGenre({required int id, required String name}) =
      _SeerrGenre;

  factory SeerrGenre.fromJson(Map<String, dynamic> json) =>
      _$SeerrGenreFromJson(json);
}

extension SeerrResultX on SeerrResult {
  String? get displayTitle => title ?? name;
  String? get displayDate => releaseDate ?? firstAirDate;

  String? get displayYear {
    final date = displayDate;
    if (date == null || date.length < 4) return null;
    return date.substring(0, 4);
  }

  String? get posterUrl {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2$posterPath';
  }
}

extension SeerrRequestMediaX on SeerrRequestMedia {
  String get tmdbUrl {
    final path = mediaType == 'tv' ? 'tv' : 'movie';
    return 'https://www.themoviedb.org/$path/$tmdbId';
  }
}

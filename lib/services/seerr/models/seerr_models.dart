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

@freezed
abstract class SeerrMediaInfo with _$SeerrMediaInfo {
  const factory SeerrMediaInfo({
    required int id,
    int? tmdbId,
    int? tvdbId,
    @Default(1) int status, // 1 = PENDING, 2 = APPROVED, 3 = DECLINED, 4 = PROCESSING, 5 = PARTIALLY_AVAILABLE, 6 = AVAILABLE
    @Default([]) List<SeerrRequest> requests,
  }) = _SeerrMediaInfo;

  factory SeerrMediaInfo.fromJson(Map<String, dynamic> json) =>
      _$SeerrMediaInfoFromJson(json);
}

@freezed
abstract class SeerrRequest with _$SeerrRequest {
  const factory SeerrRequest({
    required int id,
    @Default(1) int status,
    @Default(1) int mediaType, // 1 = MOVIE, 2 = TV
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SeerrRequest;

  factory SeerrRequest.fromJson(Map<String, dynamic> json) =>
      _$SeerrRequestFromJson(json);
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

extension SeerrResultX on SeerrResult {
  String? get displayTitle => title ?? name;
  String? get displayDate => releaseDate ?? firstAirDate;
  
  String? get posterUrl {
    if (posterPath == null) return null;
    return 'https://image.tmdb.org/t/p/w600_and_h900_bestv2$posterPath';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seerr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeerrResult _$SeerrResultFromJson(Map<String, dynamic> json) => _SeerrResult(
  id: (json['id'] as num).toInt(),
  mediaType: json['mediaType'] as String? ?? 'movie',
  title: json['title'] as String?,
  name: json['name'] as String?,
  posterPath: json['posterPath'] as String?,
  backdropPath: json['backdropPath'] as String?,
  overview: json['overview'] as String?,
  releaseDate: json['releaseDate'] as String?,
  firstAirDate: json['firstAirDate'] as String?,
  voteAverage: (json['voteAverage'] as num?)?.toDouble(),
  mediaInfo: json['mediaInfo'] == null
      ? null
      : SeerrMediaInfo.fromJson(json['mediaInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SeerrResultToJson(_SeerrResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mediaType': instance.mediaType,
      'title': instance.title,
      'name': instance.name,
      'posterPath': instance.posterPath,
      'backdropPath': instance.backdropPath,
      'overview': instance.overview,
      'releaseDate': instance.releaseDate,
      'firstAirDate': instance.firstAirDate,
      'voteAverage': instance.voteAverage,
      'mediaInfo': instance.mediaInfo,
    };

_SeerrMediaInfo _$SeerrMediaInfoFromJson(Map<String, dynamic> json) =>
    _SeerrMediaInfo(
      id: (json['id'] as num).toInt(),
      tmdbId: (json['tmdbId'] as num?)?.toInt(),
      tvdbId: (json['tvdbId'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt() ?? SeerrMediaStatus.unknown,
      requests:
          (json['requests'] as List<dynamic>?)
              ?.map((e) => SeerrRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SeerrMediaInfoToJson(_SeerrMediaInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tmdbId': instance.tmdbId,
      'tvdbId': instance.tvdbId,
      'status': instance.status,
      'requests': instance.requests,
    };

_SeerrRequest _$SeerrRequestFromJson(
  Map<String, dynamic> json,
) => _SeerrRequest(
  id: (json['id'] as num).toInt(),
  status: (json['status'] as num?)?.toInt() ?? SeerrRequestStatus.pending,
  media: json['media'] == null
      ? null
      : SeerrRequestMedia.fromJson(json['media'] as Map<String, dynamic>),
  requestedBy: json['requestedBy'] == null
      ? null
      : SeerrRequestUser.fromJson(json['requestedBy'] as Map<String, dynamic>),
  seasons:
      (json['seasons'] as List<dynamic>?)
          ?.map((e) => SeerrRequestSeason.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SeerrRequestToJson(_SeerrRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'media': instance.media,
      'requestedBy': instance.requestedBy,
      'seasons': instance.seasons,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_SeerrRequestMedia _$SeerrRequestMediaFromJson(Map<String, dynamic> json) =>
    _SeerrRequestMedia(
      id: (json['id'] as num).toInt(),
      tmdbId: (json['tmdbId'] as num?)?.toInt(),
      mediaType: json['mediaType'] as String? ?? 'movie',
      status: (json['status'] as num?)?.toInt() ?? SeerrMediaStatus.unknown,
    );

Map<String, dynamic> _$SeerrRequestMediaToJson(_SeerrRequestMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tmdbId': instance.tmdbId,
      'mediaType': instance.mediaType,
      'status': instance.status,
    };

_SeerrRequestUser _$SeerrRequestUserFromJson(Map<String, dynamic> json) =>
    _SeerrRequestUser(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$SeerrRequestUserToJson(_SeerrRequestUser instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
    };

_SeerrRequestSeason _$SeerrRequestSeasonFromJson(Map<String, dynamic> json) =>
    _SeerrRequestSeason(
      id: (json['id'] as num).toInt(),
      seasonNumber: (json['seasonNumber'] as num).toInt(),
      status: (json['status'] as num?)?.toInt() ?? SeerrRequestStatus.pending,
    );

Map<String, dynamic> _$SeerrRequestSeasonToJson(_SeerrRequestSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonNumber': instance.seasonNumber,
      'status': instance.status,
    };

_SeerrPageInfo _$SeerrPageInfoFromJson(Map<String, dynamic> json) =>
    _SeerrPageInfo(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pages: (json['pages'] as num?)?.toInt() ?? 1,
      results: (json['results'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$SeerrPageInfoToJson(_SeerrPageInfo instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pages': instance.pages,
      'results': instance.results,
      'pageSize': instance.pageSize,
    };

_SeerrRequestsResponse _$SeerrRequestsResponseFromJson(
  Map<String, dynamic> json,
) => _SeerrRequestsResponse(
  pageInfo: SeerrPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => SeerrRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SeerrRequestsResponseToJson(
  _SeerrRequestsResponse instance,
) => <String, dynamic>{
  'pageInfo': instance.pageInfo,
  'results': instance.results,
};

_SeerrDiscoveryResponse _$SeerrDiscoveryResponseFromJson(
  Map<String, dynamic> json,
) => _SeerrDiscoveryResponse(
  page: (json['page'] as num?)?.toInt() ?? 1,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
  totalResults: (json['totalResults'] as num?)?.toInt() ?? 0,
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => SeerrResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SeerrDiscoveryResponseToJson(
  _SeerrDiscoveryResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'totalPages': instance.totalPages,
  'totalResults': instance.totalResults,
  'results': instance.results,
};

_SeerrGenre _$SeerrGenreFromJson(Map<String, dynamic> json) =>
    _SeerrGenre(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$SeerrGenreToJson(_SeerrGenre instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

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
      status: (json['status'] as num?)?.toInt() ?? 1,
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

_SeerrRequest _$SeerrRequestFromJson(Map<String, dynamic> json) =>
    _SeerrRequest(
      id: (json['id'] as num).toInt(),
      status: (json['status'] as num?)?.toInt() ?? 1,
      mediaType: (json['mediaType'] as num?)?.toInt() ?? 1,
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
      'mediaType': instance.mediaType,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radarr_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RadarrHistoryRecord _$RadarrHistoryRecordFromJson(Map<String, dynamic> json) =>
    _RadarrHistoryRecord(
      id: (json['id'] as num?)?.toInt() ?? 0,
      movieId: (json['movieId'] as num?)?.toInt(),
      eventType: json['eventType'] as String? ?? 'unknown',
      date: DateTime.parse(json['date'] as String),
      sourceTitle: json['sourceTitle'] as String?,
      downloadId: json['downloadId'] as String?,
      quality: _qualityFromJson(json['quality']),
      movie: _movieFromJson(json['movie']),
    );

Map<String, dynamic> _$RadarrHistoryRecordToJson(
  _RadarrHistoryRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'movieId': instance.movieId,
  'eventType': instance.eventType,
  'date': instance.date.toIso8601String(),
  'sourceTitle': instance.sourceTitle,
  'downloadId': instance.downloadId,
  'quality': instance.quality,
  'movie': instance.movie,
};

_RadarrHistoryMovie _$RadarrHistoryMovieFromJson(Map<String, dynamic> json) =>
    _RadarrHistoryMovie(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      year: (json['year'] as num?)?.toInt(),
      images: _imagesFromJson(json['images']),
    );

Map<String, dynamic> _$RadarrHistoryMovieToJson(_RadarrHistoryMovie instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'images': instance.images,
    };

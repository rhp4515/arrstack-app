// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonarr_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SonarrHistoryRecord _$SonarrHistoryRecordFromJson(Map<String, dynamic> json) =>
    _SonarrHistoryRecord(
      id: (json['id'] as num?)?.toInt() ?? 0,
      seriesId: (json['seriesId'] as num?)?.toInt(),
      episodeId: (json['episodeId'] as num?)?.toInt(),
      eventType: json['eventType'] as String? ?? 'unknown',
      date: DateTime.parse(json['date'] as String),
      sourceTitle: json['sourceTitle'] as String?,
      downloadId: json['downloadId'] as String?,
      quality: _qualityFromJson(json['quality']),
      series: _seriesFromJson(json['series']),
      episode: _episodeFromJson(json['episode']),
    );

Map<String, dynamic> _$SonarrHistoryRecordToJson(
  _SonarrHistoryRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'seriesId': instance.seriesId,
  'episodeId': instance.episodeId,
  'eventType': instance.eventType,
  'date': instance.date.toIso8601String(),
  'sourceTitle': instance.sourceTitle,
  'downloadId': instance.downloadId,
  'quality': instance.quality,
  'series': instance.series,
  'episode': instance.episode,
};

_SonarrHistorySeries _$SonarrHistorySeriesFromJson(Map<String, dynamic> json) =>
    _SonarrHistorySeries(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      year: (json['year'] as num?)?.toInt(),
      images: _imagesFromJson(json['images']),
    );

Map<String, dynamic> _$SonarrHistorySeriesToJson(
  _SonarrHistorySeries instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'year': instance.year,
  'images': instance.images,
};

_SonarrHistoryEpisode _$SonarrHistoryEpisodeFromJson(
  Map<String, dynamic> json,
) => _SonarrHistoryEpisode(
  id: (json['id'] as num?)?.toInt(),
  seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
  episodeNumber: (json['episodeNumber'] as num?)?.toInt(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$SonarrHistoryEpisodeToJson(
  _SonarrHistoryEpisode instance,
) => <String, dynamic>{
  'id': instance.id,
  'seasonNumber': instance.seasonNumber,
  'episodeNumber': instance.episodeNumber,
  'title': instance.title,
};

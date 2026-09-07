// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazarr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BazarrWantedSubtitle _$BazarrWantedSubtitleFromJson(
  Map<String, dynamic> json,
) => _BazarrWantedSubtitle(
  title: json['title'] as String,
  type: json['type'] as String? ?? 'episode',
  seriesTitle: json['seriesTitle'] as String?,
  seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
  episodeNumber: (json['episodeNumber'] as num?)?.toInt(),
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  path: json['path'] as String? ?? '',
  radarrId: (json['radarrId'] as num?)?.toInt(),
  sonarrId: (json['sonarrId'] as num?)?.toInt(),
  episodeId: (json['episode_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$BazarrWantedSubtitleToJson(
  _BazarrWantedSubtitle instance,
) => <String, dynamic>{
  'title': instance.title,
  'type': instance.type,
  'seriesTitle': instance.seriesTitle,
  'seasonNumber': instance.seasonNumber,
  'episodeNumber': instance.episodeNumber,
  'languages': instance.languages,
  'path': instance.path,
  'radarrId': instance.radarrId,
  'sonarrId': instance.sonarrId,
  'episode_id': instance.episodeId,
};

_BazarrSystemStatus _$BazarrSystemStatusFromJson(Map<String, dynamic> json) =>
    _BazarrSystemStatus(
      version: json['version'] as String? ?? '',
      branch: json['branch'] as String? ?? '',
      appName: json['app_name'] as String? ?? 'Bazarr',
    );

Map<String, dynamic> _$BazarrSystemStatusToJson(_BazarrSystemStatus instance) =>
    <String, dynamic>{
      'version': instance.version,
      'branch': instance.branch,
      'app_name': instance.appName,
    };

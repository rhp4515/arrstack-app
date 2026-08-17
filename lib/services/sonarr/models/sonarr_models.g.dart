// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonarr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SonarrSeries _$SonarrSeriesFromJson(
  Map<String, dynamic> json,
) => _SonarrSeries(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  sortTitle: json['sortTitle'] as String,
  status: json['status'] as String,
  overview: json['overview'] as String,
  images: (json['images'] as List<dynamic>)
      .map((e) => SonarrImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  seasons: (json['seasons'] as List<dynamic>)
      .map((e) => SonarrSeason.fromJson(e as Map<String, dynamic>))
      .toList(),
  year: (json['year'] as num).toInt(),
  path: json['path'] as String?,
  rootFolderPath: json['rootFolderPath'] as String?,
  qualityProfileId: (json['qualityProfileId'] as num?)?.toInt(),
  monitored: json['monitored'] as bool,
  useSceneNumbering: json['useSceneNumbering'] as bool? ?? false,
  runtime: json['runtime'] as String?,
  tvdbId: (json['tvdbId'] as num).toInt(),
  tvMazeId: (json['tvMazeId'] as num?)?.toInt(),
  seriesType: json['seriesType'] as String,
  cleanTitle: json['cleanTitle'] as String?,
  titleSlug: json['titleSlug'] as String?,
  added: json['added'] == null ? null : DateTime.parse(json['added'] as String),
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  statistics: json['statistics'] == null
      ? null
      : SonarrStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
  addOptions: json['addOptions'] == null
      ? null
      : SonarrAddOptions.fromJson(json['addOptions'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SonarrSeriesToJson(_SonarrSeries instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sortTitle': instance.sortTitle,
      'status': instance.status,
      'overview': instance.overview,
      'images': instance.images,
      'seasons': instance.seasons,
      'year': instance.year,
      'path': instance.path,
      'rootFolderPath': instance.rootFolderPath,
      'qualityProfileId': instance.qualityProfileId,
      'monitored': instance.monitored,
      'useSceneNumbering': instance.useSceneNumbering,
      'runtime': instance.runtime,
      'tvdbId': instance.tvdbId,
      'tvMazeId': instance.tvMazeId,
      'seriesType': instance.seriesType,
      'cleanTitle': instance.cleanTitle,
      'titleSlug': instance.titleSlug,
      'added': instance.added?.toIso8601String(),
      'genres': instance.genres,
      'tags': instance.tags,
      'statistics': instance.statistics,
      'addOptions': instance.addOptions,
    };

_SonarrAddOptions _$SonarrAddOptionsFromJson(Map<String, dynamic> json) =>
    _SonarrAddOptions(
      monitor: json['monitor'] as String? ?? 'all',
      searchForMissingEpisodes:
          json['searchForMissingEpisodes'] as bool? ?? false,
    );

Map<String, dynamic> _$SonarrAddOptionsToJson(_SonarrAddOptions instance) =>
    <String, dynamic>{
      'monitor': instance.monitor,
      'searchForMissingEpisodes': instance.searchForMissingEpisodes,
    };

_SonarrImage _$SonarrImageFromJson(Map<String, dynamic> json) => _SonarrImage(
  coverType: json['coverType'] as String,
  url: json['url'] as String,
  remoteUrl: json['remoteUrl'] as String?,
);

Map<String, dynamic> _$SonarrImageToJson(_SonarrImage instance) =>
    <String, dynamic>{
      'coverType': instance.coverType,
      'url': instance.url,
      'remoteUrl': instance.remoteUrl,
    };

_SonarrSeason _$SonarrSeasonFromJson(Map<String, dynamic> json) =>
    _SonarrSeason(
      seasonNumber: (json['seasonNumber'] as num).toInt(),
      monitored: json['monitored'] as bool,
      statistics: json['statistics'] == null
          ? null
          : SonarrStatistics.fromJson(
              json['statistics'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SonarrSeasonToJson(_SonarrSeason instance) =>
    <String, dynamic>{
      'seasonNumber': instance.seasonNumber,
      'monitored': instance.monitored,
      'statistics': instance.statistics,
    };

_SonarrStatistics _$SonarrStatisticsFromJson(Map<String, dynamic> json) =>
    _SonarrStatistics(
      seasonCount: (json['seasonCount'] as num).toInt(),
      episodeFileCount: (json['episodeFileCount'] as num).toInt(),
      episodeCount: (json['episodeCount'] as num).toInt(),
      totalEpisodeCount: (json['totalEpisodeCount'] as num).toInt(),
      sizeOnDisk: (json['sizeOnDisk'] as num).toInt(),
      percentOfEpisodes: (json['percentOfEpisodes'] as num).toDouble(),
    );

Map<String, dynamic> _$SonarrStatisticsToJson(_SonarrStatistics instance) =>
    <String, dynamic>{
      'seasonCount': instance.seasonCount,
      'episodeFileCount': instance.episodeFileCount,
      'episodeCount': instance.episodeCount,
      'totalEpisodeCount': instance.totalEpisodeCount,
      'sizeOnDisk': instance.sizeOnDisk,
      'percentOfEpisodes': instance.percentOfEpisodes,
    };

_SonarrEpisode _$SonarrEpisodeFromJson(Map<String, dynamic> json) =>
    _SonarrEpisode(
      id: (json['id'] as num).toInt(),
      seriesId: (json['seriesId'] as num).toInt(),
      seasonNumber: (json['seasonNumber'] as num).toInt(),
      episodeNumber: (json['episodeNumber'] as num).toInt(),
      title: json['title'] as String,
      overview: json['overview'] as String?,
      hasFile: json['hasFile'] as bool,
      monitored: json['monitored'] as bool,
      absoluteEpisodeNumber: (json['absoluteEpisodeNumber'] as num?)?.toInt(),
      sceneEpisodeNumber: (json['sceneEpisodeNumber'] as num?)?.toInt(),
      sceneSeasonNumber: (json['sceneSeasonNumber'] as num?)?.toInt(),
      unverifiedSceneNumbering: json['unverifiedSceneNumbering'] as bool,
    );

Map<String, dynamic> _$SonarrEpisodeToJson(_SonarrEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seriesId': instance.seriesId,
      'seasonNumber': instance.seasonNumber,
      'episodeNumber': instance.episodeNumber,
      'title': instance.title,
      'overview': instance.overview,
      'hasFile': instance.hasFile,
      'monitored': instance.monitored,
      'absoluteEpisodeNumber': instance.absoluteEpisodeNumber,
      'sceneEpisodeNumber': instance.sceneEpisodeNumber,
      'sceneSeasonNumber': instance.sceneSeasonNumber,
      'unverifiedSceneNumbering': instance.unverifiedSceneNumbering,
    };

_SonarrQualityProfile _$SonarrQualityProfileFromJson(
  Map<String, dynamic> json,
) => _SonarrQualityProfile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$SonarrQualityProfileToJson(
  _SonarrQualityProfile instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_SonarrRootFolder _$SonarrRootFolderFromJson(Map<String, dynamic> json) =>
    _SonarrRootFolder(
      id: (json['id'] as num).toInt(),
      path: json['path'] as String,
      freeSpace: (json['freeSpace'] as num).toInt(),
    );

Map<String, dynamic> _$SonarrRootFolderToJson(_SonarrRootFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'freeSpace': instance.freeSpace,
    };

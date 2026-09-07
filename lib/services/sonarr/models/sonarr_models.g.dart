// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonarr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SonarrSeries _$SonarrSeriesFromJson(
  Map<String, dynamic> json,
) => _SonarrSeries(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String? ?? 'Unknown',
  sortTitle: json['sortTitle'] as String?,
  status: json['status'] as String?,
  overview: json['overview'] as String?,
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => SonarrImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  seasons: (json['seasons'] as List<dynamic>?)
      ?.map((e) => SonarrSeason.fromJson(e as Map<String, dynamic>))
      .toList(),
  year: (json['year'] as num?)?.toInt(),
  path: json['path'] as String?,
  rootFolderPath: json['rootFolderPath'] as String?,
  qualityProfileId: (json['qualityProfileId'] as num?)?.toInt(),
  monitored: json['monitored'] as bool? ?? true,
  useSceneNumbering: json['useSceneNumbering'] as bool? ?? false,
  runtime: (json['runtime'] as num?)?.toInt(),
  tvdbId: (json['tvdbId'] as num?)?.toInt(),
  tvMazeId: (json['tvMazeId'] as num?)?.toInt(),
  seriesType: json['seriesType'] as String? ?? 'program',
  cleanTitle: json['cleanTitle'] as String?,
  titleSlug: json['titleSlug'] as String?,
  imdbId: json['imdbId'] as String?,
  network: json['network'] as String?,
  certification: json['certification'] as String?,
  firstAired: json['firstAired'] == null
      ? null
      : DateTime.parse(json['firstAired'] as String),
  ratings: json['ratings'] == null
      ? null
      : SonarrRatings.fromJson(json['ratings'] as Map<String, dynamic>),
  added: json['added'] == null ? null : DateTime.parse(json['added'] as String),
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
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
      'imdbId': instance.imdbId,
      'network': instance.network,
      'certification': instance.certification,
      'firstAired': instance.firstAired?.toIso8601String(),
      'ratings': instance.ratings,
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
  coverType: json['coverType'] as String?,
  url: json['url'] as String?,
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
      seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
      monitored: json['monitored'] as bool? ?? true,
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
      seasonCount: (json['seasonCount'] as num?)?.toInt(),
      episodeFileCount: (json['episodeFileCount'] as num?)?.toInt(),
      episodeCount: (json['episodeCount'] as num?)?.toInt(),
      totalEpisodeCount: (json['totalEpisodeCount'] as num?)?.toInt(),
      sizeOnDisk: (json['sizeOnDisk'] as num?)?.toInt(),
      percentOfEpisodes: (json['percentOfEpisodes'] as num?)?.toDouble(),
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

_SonarrEpisode _$SonarrEpisodeFromJson(
  Map<String, dynamic> json,
) => _SonarrEpisode(
  id: (json['id'] as num).toInt(),
  seriesId: (json['seriesId'] as num?)?.toInt(),
  seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
  episodeNumber: (json['episodeNumber'] as num?)?.toInt(),
  title: json['title'] as String?,
  overview: json['overview'] as String?,
  hasFile: json['hasFile'] as bool? ?? false,
  monitored: json['monitored'] as bool? ?? true,
  airDateUtc: json['airDateUtc'] == null
      ? null
      : DateTime.parse(json['airDateUtc'] as String),
  runtime: (json['runtime'] as num?)?.toInt(),
  episodeFileId: (json['episodeFileId'] as num?)?.toInt(),
  episodeFile: json['episodeFile'] == null
      ? null
      : SonarrEpisodeFile.fromJson(json['episodeFile'] as Map<String, dynamic>),
  absoluteEpisodeNumber: (json['absoluteEpisodeNumber'] as num?)?.toInt(),
  sceneEpisodeNumber: (json['sceneEpisodeNumber'] as num?)?.toInt(),
  sceneSeasonNumber: (json['sceneSeasonNumber'] as num?)?.toInt(),
  unverifiedSceneNumbering: json['unverifiedSceneNumbering'] as bool? ?? false,
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
      'airDateUtc': instance.airDateUtc?.toIso8601String(),
      'runtime': instance.runtime,
      'episodeFileId': instance.episodeFileId,
      'episodeFile': instance.episodeFile,
      'absoluteEpisodeNumber': instance.absoluteEpisodeNumber,
      'sceneEpisodeNumber': instance.sceneEpisodeNumber,
      'sceneSeasonNumber': instance.sceneSeasonNumber,
      'unverifiedSceneNumbering': instance.unverifiedSceneNumbering,
    };

_SonarrEpisodeFile _$SonarrEpisodeFileFromJson(Map<String, dynamic> json) =>
    _SonarrEpisodeFile(
      id: (json['id'] as num).toInt(),
      relativePath: json['relativePath'] as String?,
      size: (json['size'] as num?)?.toInt() ?? 0,
      dateAdded: json['dateAdded'] == null
          ? null
          : DateTime.parse(json['dateAdded'] as String),
      quality: json['quality'] == null
          ? null
          : SonarrQualityInfo.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SonarrEpisodeFileToJson(_SonarrEpisodeFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relativePath': instance.relativePath,
      'size': instance.size,
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'quality': instance.quality,
    };

_SonarrQualityInfo _$SonarrQualityInfoFromJson(Map<String, dynamic> json) =>
    _SonarrQualityInfo(
      quality: json['quality'] == null
          ? null
          : SonarrQuality.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SonarrQualityInfoToJson(_SonarrQualityInfo instance) =>
    <String, dynamic>{'quality': instance.quality};

_SonarrQuality _$SonarrQualityFromJson(Map<String, dynamic> json) =>
    _SonarrQuality(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SonarrQualityToJson(_SonarrQuality instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_SonarrRelease _$SonarrReleaseFromJson(Map<String, dynamic> json) =>
    _SonarrRelease(
      guid: json['guid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      indexerId: (json['indexerId'] as num?)?.toInt() ?? 0,
      indexer: json['indexer'] as String?,
      seeders: (json['seeders'] as num?)?.toInt(),
      leechers: (json['leechers'] as num?)?.toInt(),
      protocol: json['protocol'] as String?,
      quality: json['quality'] == null
          ? null
          : SonarrQualityInfo.fromJson(json['quality'] as Map<String, dynamic>),
      qualityWeight: (json['qualityWeight'] as num?)?.toInt(),
      ageMinutes: json['ageMinutes'] as num?,
      rejected: json['rejected'] as bool? ?? false,
      rejections: json['rejections'] == null
          ? const <String>[]
          : _rejectionsFromJson(json['rejections']),
      releaseGroup: json['releaseGroup'] as String?,
      downloadAllowed: json['downloadAllowed'] as bool? ?? true,
      customFormatScore: (json['customFormatScore'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SonarrReleaseToJson(_SonarrRelease instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'title': instance.title,
      'size': instance.size,
      'indexerId': instance.indexerId,
      'indexer': instance.indexer,
      'seeders': instance.seeders,
      'leechers': instance.leechers,
      'protocol': instance.protocol,
      'quality': instance.quality,
      'qualityWeight': instance.qualityWeight,
      'ageMinutes': instance.ageMinutes,
      'rejected': instance.rejected,
      'rejections': instance.rejections,
      'releaseGroup': instance.releaseGroup,
      'downloadAllowed': instance.downloadAllowed,
      'customFormatScore': instance.customFormatScore,
    };

_SonarrRatings _$SonarrRatingsFromJson(Map<String, dynamic> json) =>
    _SonarrRatings(
      votes: (json['votes'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$SonarrRatingsToJson(_SonarrRatings instance) =>
    <String, dynamic>{'votes': instance.votes, 'value': instance.value};

_SonarrCalendarEpisode _$SonarrCalendarEpisodeFromJson(
  Map<String, dynamic> json,
) => _SonarrCalendarEpisode(
  id: (json['id'] as num).toInt(),
  seriesId: (json['seriesId'] as num?)?.toInt(),
  seasonNumber: (json['seasonNumber'] as num?)?.toInt(),
  episodeNumber: (json['episodeNumber'] as num?)?.toInt(),
  title: json['title'] as String?,
  airDateUtc: json['airDateUtc'] == null
      ? null
      : DateTime.parse(json['airDateUtc'] as String),
  hasFile: json['hasFile'] as bool? ?? false,
  monitored: json['monitored'] as bool? ?? true,
  series: json['series'] == null
      ? null
      : SonarrSeries.fromJson(json['series'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SonarrCalendarEpisodeToJson(
  _SonarrCalendarEpisode instance,
) => <String, dynamic>{
  'id': instance.id,
  'seriesId': instance.seriesId,
  'seasonNumber': instance.seasonNumber,
  'episodeNumber': instance.episodeNumber,
  'title': instance.title,
  'airDateUtc': instance.airDateUtc?.toIso8601String(),
  'hasFile': instance.hasFile,
  'monitored': instance.monitored,
  'series': instance.series,
};

_SonarrQualityProfile _$SonarrQualityProfileFromJson(
  Map<String, dynamic> json,
) => _SonarrQualityProfile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$SonarrQualityProfileToJson(
  _SonarrQualityProfile instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_SonarrRootFolder _$SonarrRootFolderFromJson(Map<String, dynamic> json) =>
    _SonarrRootFolder(
      id: (json['id'] as num).toInt(),
      path: json['path'] as String?,
      freeSpace: (json['freeSpace'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SonarrRootFolderToJson(_SonarrRootFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'freeSpace': instance.freeSpace,
    };

_SonarrQueueItem _$SonarrQueueItemFromJson(Map<String, dynamic> json) =>
    _SonarrQueueItem(
      id: (json['id'] as num).toInt(),
      seriesId: (json['seriesId'] as num?)?.toInt(),
      episodeId: (json['episodeId'] as num?)?.toInt(),
      status: json['status'] as String?,
      size: (json['size'] as num?)?.toInt() ?? 0,
      sizeleft: (json['sizeleft'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      timeleft: json['timeleft'] as String?,
      estimatedCompletionTime: json['estimatedCompletionTime'] == null
          ? null
          : DateTime.parse(json['estimatedCompletionTime'] as String),
    );

Map<String, dynamic> _$SonarrQueueItemToJson(_SonarrQueueItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seriesId': instance.seriesId,
      'episodeId': instance.episodeId,
      'status': instance.status,
      'size': instance.size,
      'sizeleft': instance.sizeleft,
      'title': instance.title,
      'timeleft': instance.timeleft,
      'estimatedCompletionTime': instance.estimatedCompletionTime
          ?.toIso8601String(),
    };

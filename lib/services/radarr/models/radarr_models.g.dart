// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radarr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RadarrMovie _$RadarrMovieFromJson(Map<String, dynamic> json) => _RadarrMovie(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  year: (json['year'] as num).toInt(),
  monitored: json['monitored'] as bool,
  status: json['status'] as String,
  overview: json['overview'] as String,
  sortTitle: json['sortTitle'] as String,
  added: json['added'] == null ? null : DateTime.parse(json['added'] as String),
  images: (json['images'] as List<dynamic>)
      .map((e) => RadarrImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  qualityProfileId: (json['qualityProfileId'] as num?)?.toInt(),
  rootFolderPath: json['rootFolderPath'] as String?,
  path: json['path'] as String?,
  movieFile: json['movieFile'] == null
      ? null
      : RadarrMovieFile.fromJson(json['movieFile'] as Map<String, dynamic>),
  tmdbId: (json['tmdbId'] as num).toInt(),
  titleSlug: json['titleSlug'] as String?,
  hasFile: json['hasFile'] as bool? ?? false,
  sizeOnDisk: (json['sizeOnDisk'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RadarrMovieToJson(_RadarrMovie instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'year': instance.year,
      'monitored': instance.monitored,
      'status': instance.status,
      'overview': instance.overview,
      'sortTitle': instance.sortTitle,
      'added': instance.added?.toIso8601String(),
      'images': instance.images,
      'qualityProfileId': instance.qualityProfileId,
      'rootFolderPath': instance.rootFolderPath,
      'path': instance.path,
      'movieFile': instance.movieFile,
      'tmdbId': instance.tmdbId,
      'titleSlug': instance.titleSlug,
      'hasFile': instance.hasFile,
      'sizeOnDisk': instance.sizeOnDisk,
    };

_RadarrImage _$RadarrImageFromJson(Map<String, dynamic> json) => _RadarrImage(
  coverType: json['coverType'] as String,
  url: json['url'] as String,
  remoteUrl: json['remoteUrl'] as String?,
);

Map<String, dynamic> _$RadarrImageToJson(_RadarrImage instance) =>
    <String, dynamic>{
      'coverType': instance.coverType,
      'url': instance.url,
      'remoteUrl': instance.remoteUrl,
    };

_RadarrMovieFile _$RadarrMovieFileFromJson(Map<String, dynamic> json) =>
    _RadarrMovieFile(
      id: (json['id'] as num).toInt(),
      relativePath: json['relativePath'] as String,
      size: (json['size'] as num).toInt(),
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      quality: RadarrQualityInfo.fromJson(
        json['quality'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$RadarrMovieFileToJson(_RadarrMovieFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relativePath': instance.relativePath,
      'size': instance.size,
      'dateAdded': instance.dateAdded.toIso8601String(),
      'quality': instance.quality,
    };

_RadarrQualityInfo _$RadarrQualityInfoFromJson(Map<String, dynamic> json) =>
    _RadarrQualityInfo(
      quality: RadarrQuality.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RadarrQualityInfoToJson(_RadarrQualityInfo instance) =>
    <String, dynamic>{'quality': instance.quality};

_RadarrQuality _$RadarrQualityFromJson(Map<String, dynamic> json) =>
    _RadarrQuality(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$RadarrQualityToJson(_RadarrQuality instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_RadarrQualityProfile _$RadarrQualityProfileFromJson(
  Map<String, dynamic> json,
) => _RadarrQualityProfile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
);

Map<String, dynamic> _$RadarrQualityProfileToJson(
  _RadarrQualityProfile instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_RadarrRootFolder _$RadarrRootFolderFromJson(Map<String, dynamic> json) =>
    _RadarrRootFolder(
      id: (json['id'] as num).toInt(),
      path: json['path'] as String,
      freeSpace: (json['freeSpace'] as num).toInt(),
    );

Map<String, dynamic> _$RadarrRootFolderToJson(_RadarrRootFolder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'freeSpace': instance.freeSpace,
    };

_RadarrQueueItem _$RadarrQueueItemFromJson(Map<String, dynamic> json) =>
    _RadarrQueueItem(
      id: (json['id'] as num).toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      status: json['status'] as String?,
      size: (json['size'] as num?)?.toInt() ?? 0,
      sizeleft: (json['sizeleft'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      timeleft: json['timeleft'] as String?,
      estimatedCompletionTime: json['estimatedCompletionTime'] == null
          ? null
          : DateTime.parse(json['estimatedCompletionTime'] as String),
    );

Map<String, dynamic> _$RadarrQueueItemToJson(_RadarrQueueItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'movieId': instance.movieId,
      'status': instance.status,
      'size': instance.size,
      'sizeleft': instance.sizeleft,
      'title': instance.title,
      'timeleft': instance.timeleft,
      'estimatedCompletionTime': instance.estimatedCompletionTime
          ?.toIso8601String(),
    };

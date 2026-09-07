// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radarr_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RadarrMovie _$RadarrMovieFromJson(Map<String, dynamic> json) => _RadarrMovie(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String? ?? 'Unknown',
  year: (json['year'] as num?)?.toInt(),
  monitored: json['monitored'] as bool? ?? true,
  status: json['status'] as String?,
  overview: json['overview'] as String?,
  sortTitle: json['sortTitle'] as String?,
  added: json['added'] == null ? null : DateTime.parse(json['added'] as String),
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => RadarrImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  qualityProfileId: (json['qualityProfileId'] as num?)?.toInt(),
  rootFolderPath: json['rootFolderPath'] as String?,
  path: json['path'] as String?,
  movieFile: json['movieFile'] == null
      ? null
      : RadarrMovieFile.fromJson(json['movieFile'] as Map<String, dynamic>),
  tmdbId: (json['tmdbId'] as num?)?.toInt(),
  imdbId: json['imdbId'] as String?,
  titleSlug: json['titleSlug'] as String?,
  studio: json['studio'] as String?,
  certification: json['certification'] as String?,
  runtime: (json['runtime'] as num?)?.toInt(),
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  ratings: json['ratings'] == null
      ? null
      : RadarrRatings.fromJson(json['ratings'] as Map<String, dynamic>),
  minimumAvailability: json['minimumAvailability'] as String? ?? 'announced',
  inCinemas: json['inCinemas'] == null
      ? null
      : DateTime.parse(json['inCinemas'] as String),
  physicalRelease: json['physicalRelease'] == null
      ? null
      : DateTime.parse(json['physicalRelease'] as String),
  digitalRelease: json['digitalRelease'] == null
      ? null
      : DateTime.parse(json['digitalRelease'] as String),
  hasFile: json['hasFile'] as bool? ?? false,
  sizeOnDisk: (json['sizeOnDisk'] as num?)?.toInt() ?? 0,
  addOptions: json['addOptions'] == null
      ? null
      : RadarrAddOptions.fromJson(json['addOptions'] as Map<String, dynamic>),
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
      'imdbId': instance.imdbId,
      'titleSlug': instance.titleSlug,
      'studio': instance.studio,
      'certification': instance.certification,
      'runtime': instance.runtime,
      'genres': instance.genres,
      'ratings': instance.ratings,
      'minimumAvailability': instance.minimumAvailability,
      'inCinemas': instance.inCinemas?.toIso8601String(),
      'physicalRelease': instance.physicalRelease?.toIso8601String(),
      'digitalRelease': instance.digitalRelease?.toIso8601String(),
      'hasFile': instance.hasFile,
      'sizeOnDisk': instance.sizeOnDisk,
      'addOptions': instance.addOptions,
    };

_RadarrAddOptions _$RadarrAddOptionsFromJson(Map<String, dynamic> json) =>
    _RadarrAddOptions(
      searchForMovie: json['searchForMovie'] as bool? ?? false,
      monitor: json['monitor'] as String? ?? 'movieOnly',
    );

Map<String, dynamic> _$RadarrAddOptionsToJson(_RadarrAddOptions instance) =>
    <String, dynamic>{
      'searchForMovie': instance.searchForMovie,
      'monitor': instance.monitor,
    };

_RadarrImage _$RadarrImageFromJson(Map<String, dynamic> json) => _RadarrImage(
  coverType: json['coverType'] as String?,
  url: json['url'] as String?,
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
      relativePath: json['relativePath'] as String?,
      size: (json['size'] as num?)?.toInt(),
      dateAdded: json['dateAdded'] == null
          ? null
          : DateTime.parse(json['dateAdded'] as String),
      quality: json['quality'] == null
          ? null
          : RadarrQualityInfo.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RadarrMovieFileToJson(_RadarrMovieFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relativePath': instance.relativePath,
      'size': instance.size,
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'quality': instance.quality,
    };

_RadarrQualityInfo _$RadarrQualityInfoFromJson(Map<String, dynamic> json) =>
    _RadarrQualityInfo(
      quality: json['quality'] == null
          ? null
          : RadarrQuality.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RadarrQualityInfoToJson(_RadarrQualityInfo instance) =>
    <String, dynamic>{'quality': instance.quality};

_RadarrQuality _$RadarrQualityFromJson(Map<String, dynamic> json) =>
    _RadarrQuality(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$RadarrQualityToJson(_RadarrQuality instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_RadarrRelease _$RadarrReleaseFromJson(Map<String, dynamic> json) =>
    _RadarrRelease(
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
          : RadarrQualityInfo.fromJson(json['quality'] as Map<String, dynamic>),
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

Map<String, dynamic> _$RadarrReleaseToJson(_RadarrRelease instance) =>
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

_RadarrRatings _$RadarrRatingsFromJson(Map<String, dynamic> json) =>
    _RadarrRatings(
      imdb: json['imdb'] == null
          ? null
          : RadarrRatingValue.fromJson(json['imdb'] as Map<String, dynamic>),
      tmdb: json['tmdb'] == null
          ? null
          : RadarrRatingValue.fromJson(json['tmdb'] as Map<String, dynamic>),
      rottenTomatoes: json['rottenTomatoes'] == null
          ? null
          : RadarrRatingValue.fromJson(
              json['rottenTomatoes'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RadarrRatingsToJson(_RadarrRatings instance) =>
    <String, dynamic>{
      'imdb': instance.imdb,
      'tmdb': instance.tmdb,
      'rottenTomatoes': instance.rottenTomatoes,
    };

_RadarrRatingValue _$RadarrRatingValueFromJson(Map<String, dynamic> json) =>
    _RadarrRatingValue(
      votes: (json['votes'] as num?)?.toInt() ?? 0,
      value: (json['value'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$RadarrRatingValueToJson(_RadarrRatingValue instance) =>
    <String, dynamic>{'votes': instance.votes, 'value': instance.value};

_RadarrQualityProfile _$RadarrQualityProfileFromJson(
  Map<String, dynamic> json,
) => _RadarrQualityProfile(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$RadarrQualityProfileToJson(
  _RadarrQualityProfile instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_RadarrRootFolder _$RadarrRootFolderFromJson(Map<String, dynamic> json) =>
    _RadarrRootFolder(
      id: (json['id'] as num).toInt(),
      path: json['path'] as String?,
      freeSpace: (json['freeSpace'] as num?)?.toInt(),
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

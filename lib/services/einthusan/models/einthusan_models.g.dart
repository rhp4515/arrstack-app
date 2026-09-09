// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'einthusan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EinthusanJob _$EinthusanJobFromJson(Map<String, dynamic> json) =>
    _EinthusanJob(
      id: json['id'] as String,
      state: $enumDecode(_$JobStateEnumMap, json['state']),
      einthusanUrl: json['einthusan_url'] as String,
      candidates:
          (json['candidates'] as List<dynamic>?)
              ?.map((e) => TmdbCandidate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedTmdbId: (json['selected_tmdb_id'] as num?)?.toInt(),
      progress: json['progress'] == null
          ? null
          : JobProgress.fromJson(json['progress'] as Map<String, dynamic>),
      result: json['result'] == null
          ? null
          : JobResult.fromJson(json['result'] as Map<String, dynamic>),
      error: json['error'] == null
          ? null
          : JobErrorInfo.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EinthusanJobToJson(_EinthusanJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$JobStateEnumMap[instance.state]!,
      'einthusan_url': instance.einthusanUrl,
      'candidates': instance.candidates,
      'selected_tmdb_id': instance.selectedTmdbId,
      'progress': instance.progress,
      'result': instance.result,
      'error': instance.error,
    };

const _$JobStateEnumMap = {
  JobState.resolving: 'resolving',
  JobState.resolveFailed: 'resolve_failed',
  JobState.awaitingVerification: 'awaiting_verification',
  JobState.downloading: 'downloading',
  JobState.importing: 'importing',
  JobState.done: 'done',
  JobState.error: 'error',
};

_TmdbCandidate _$TmdbCandidateFromJson(Map<String, dynamic> json) =>
    _TmdbCandidate(
      tmdbId: (json['tmdb_id'] as num).toInt(),
      title: json['title'] as String,
      year: (json['year'] as num).toInt(),
      tmdbUrl: json['tmdb_url'] as String,
      posterUrl: json['poster_url'] as String?,
    );

Map<String, dynamic> _$TmdbCandidateToJson(_TmdbCandidate instance) =>
    <String, dynamic>{
      'tmdb_id': instance.tmdbId,
      'title': instance.title,
      'year': instance.year,
      'tmdb_url': instance.tmdbUrl,
      'poster_url': instance.posterUrl,
    };

_JobProgress _$JobProgressFromJson(Map<String, dynamic> json) => _JobProgress(
  downloadedBytes: (json['downloaded_bytes'] as num).toInt(),
  totalBytes: (json['total_bytes'] as num).toInt(),
  percent: (json['percent'] as num).toDouble(),
  speedBps: (json['speed_bps'] as num).toDouble(),
  etaSeconds: (json['eta_seconds'] as num?)?.toDouble(),
);

Map<String, dynamic> _$JobProgressToJson(_JobProgress instance) =>
    <String, dynamic>{
      'downloaded_bytes': instance.downloadedBytes,
      'total_bytes': instance.totalBytes,
      'percent': instance.percent,
      'speed_bps': instance.speedBps,
      'eta_seconds': instance.etaSeconds,
    };

_JobResult _$JobResultFromJson(Map<String, dynamic> json) => _JobResult(
  file: json['file'] as String,
  radarrMovieId: (json['radarr_movie_id'] as num).toInt(),
  tmdbId: (json['tmdb_id'] as num).toInt(),
);

Map<String, dynamic> _$JobResultToJson(_JobResult instance) =>
    <String, dynamic>{
      'file': instance.file,
      'radarr_movie_id': instance.radarrMovieId,
      'tmdb_id': instance.tmdbId,
    };

_JobErrorInfo _$JobErrorInfoFromJson(Map<String, dynamic> json) =>
    _JobErrorInfo(
      code: json['code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$JobErrorInfoToJson(_JobErrorInfo instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

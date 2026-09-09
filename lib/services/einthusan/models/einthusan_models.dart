/// Models for the einthusan-downloader API (`docs/openapi.json` in
/// `einthusan-downloader`). See spec §"Upstream API (reference)".
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'einthusan_models.freezed.dart';
part 'einthusan_models.g.dart';

/// A job's lifecycle state, matching `JobOut.state` exactly.
enum JobState {
  @JsonValue('resolving')
  resolving,
  @JsonValue('resolve_failed')
  resolveFailed,
  @JsonValue('awaiting_verification')
  awaitingVerification,
  @JsonValue('downloading')
  downloading,
  @JsonValue('importing')
  importing,
  @JsonValue('done')
  done,
  @JsonValue('error')
  error,
}

extension JobStateX on JobState {
  /// No further polling will change this job's outcome.
  bool get isTerminal =>
      this == JobState.done ||
      this == JobState.error ||
      this == JobState.resolveFailed;

  /// A download/import is actively in progress.
  bool get isRunning =>
      this == JobState.downloading || this == JobState.importing;
}

/// One import job, as returned by `POST /movies`, `GET/PATCH /jobs/{id}`,
/// and `POST /jobs/{id}/download`.
@freezed
abstract class EinthusanJob with _$EinthusanJob {
  const factory EinthusanJob({
    required String id,
    required JobState state,
    @JsonKey(name: 'einthusan_url') required String einthusanUrl,
    @Default([]) List<TmdbCandidate> candidates,
    @JsonKey(name: 'selected_tmdb_id') int? selectedTmdbId,
    JobProgress? progress,
    JobResult? result,
    JobErrorInfo? error,
  }) = _EinthusanJob;

  factory EinthusanJob.fromJson(Map<String, dynamic> json) =>
      _$EinthusanJobFromJson(json);
}

/// One TMDB candidate offered for verification (`awaiting_verification`).
@freezed
abstract class TmdbCandidate with _$TmdbCandidate {
  const factory TmdbCandidate({
    @JsonKey(name: 'tmdb_id') required int tmdbId,
    required String title,
    required int year,
    @JsonKey(name: 'tmdb_url') required String tmdbUrl,
    @JsonKey(name: 'poster_url') String? posterUrl,
  }) = _TmdbCandidate;

  factory TmdbCandidate.fromJson(Map<String, dynamic> json) =>
      _$TmdbCandidateFromJson(json);
}

/// Download progress, populated only while `state` is `downloading` or
/// `importing`.
@freezed
abstract class JobProgress with _$JobProgress {
  const factory JobProgress({
    @JsonKey(name: 'downloaded_bytes') required int downloadedBytes,
    @JsonKey(name: 'total_bytes') required int totalBytes,
    required double percent,
    @JsonKey(name: 'speed_bps') required double speedBps,
    @JsonKey(name: 'eta_seconds') double? etaSeconds,
  }) = _JobProgress;

  factory JobProgress.fromJson(Map<String, dynamic> json) =>
      _$JobProgressFromJson(json);
}

/// The outcome of a successfully completed (`done`) job.
@freezed
abstract class JobResult with _$JobResult {
  const factory JobResult({
    required String file,
    @JsonKey(name: 'radarr_movie_id') required int radarrMovieId,
    @JsonKey(name: 'tmdb_id') required int tmdbId,
  }) = _JobResult;

  factory JobResult.fromJson(Map<String, dynamic> json) =>
      _$JobResultFromJson(json);
}

/// A job-reported failure (`state == error` or `resolve_failed`). Distinct
/// from transport-level [AppError]s, which come from `guardDioCall` instead.
@freezed
abstract class JobErrorInfo with _$JobErrorInfo {
  const factory JobErrorInfo({required String code, required String message}) =
      _JobErrorInfo;

  factory JobErrorInfo.fromJson(Map<String, dynamic> json) =>
      _$JobErrorInfoFromJson(json);
}

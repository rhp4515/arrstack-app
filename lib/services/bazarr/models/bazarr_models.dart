/// Models for the Bazarr API.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bazarr_models.freezed.dart';
part 'bazarr_models.g.dart';

/// Represents a missing subtitle for a movie or episode.
@freezed
abstract class BazarrWantedSubtitle with _$BazarrWantedSubtitle {
  const factory BazarrWantedSubtitle({
    required String title,
    @Default('episode') String type, // 'movie' or 'episode'
    String? seriesTitle,
    int? seasonNumber,
    int? episodeNumber,
    @Default([]) List<String> languages,
    required String path,
    @JsonKey(name: 'radarrId') int? radarrId,
    @JsonKey(name: 'sonarrId') int? sonarrId,
    @JsonKey(name: 'episode_id') int? episodeId,
  }) = _BazarrWantedSubtitle;

  factory BazarrWantedSubtitle.fromJson(Map<String, dynamic> json) =>
      _$BazarrWantedSubtitleFromJson(json);
}

/// System status information from Bazarr.
@freezed
abstract class BazarrSystemStatus with _$BazarrSystemStatus {
  const factory BazarrSystemStatus({
    required String version,
    required String branch,
    @JsonKey(name: 'app_name') @Default('Bazarr') String appName,
  }) = _BazarrSystemStatus;

  factory BazarrSystemStatus.fromJson(Map<String, dynamic> json) =>
      _$BazarrSystemStatusFromJson(json);
}

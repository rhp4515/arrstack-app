/// Models for the qBittorrent Web API (v2).
///
/// These models follow the schema of the qBittorrent API and are used for
/// download management.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'qbit_models.freezed.dart';
part 'qbit_models.g.dart';

/// One torrent in the qBittorrent list.
@freezed
abstract class QbitTorrent with _$QbitTorrent {
  const factory QbitTorrent({
    required String hash,
    required String name,
    required int size,
    required double progress,
    required int dlspeed,
    required int upspeed,
    required int priority,
    @JsonKey(name: 'num_seeds') required int numSeeds,
    @JsonKey(name: 'num_leechs') required int numLeechs,
    @JsonKey(name: 'num_incomplete') required int numIncomplete,
    required double ratio,
    required int eta,
    required String state,
    @Default('') String tracker,
    @JsonKey(name: 'added_on') required int addedOn,
    @JsonKey(name: 'completion_on') required int completionOn,
    required String category,
    required String tags,
    @JsonKey(name: 'save_path') required String savePath,
    @JsonKey(name: 'time_active') required int timeActive,
    @JsonKey(name: 'last_activity') required int lastActivity,
  }) = _QbitTorrent;

  factory QbitTorrent.fromJson(Map<String, dynamic> json) =>
      _$QbitTorrentFromJson(json);
}

/// Global server state and aggregate transfer statistics.
@freezed
abstract class QbitMainData with _$QbitMainData {
  const factory QbitMainData({
    @JsonKey(name: 'server_state') required QbitServerState serverState,
    @Default({}) Map<String, QbitTorrent> torrents,
    @Default([]) List<String> categories,
  }) = _QbitMainData;

  factory QbitMainData.fromJson(Map<String, dynamic> json) =>
      _$QbitMainDataFromJson(json);
}

@freezed
abstract class QbitServerState with _$QbitServerState {
  const factory QbitServerState({
    @JsonKey(name: 'dl_info_speed') required int dlInfoSpeed,
    @JsonKey(name: 'dl_info_data') required int dlInfoData,
    @JsonKey(name: 'up_info_speed') required int upInfoSpeed,
    @JsonKey(name: 'up_info_data') required int upInfoData,
    @JsonKey(name: 'dl_rate_limit') required int dlRateLimit,
    @JsonKey(name: 'up_rate_limit') required int upRateLimit,
    @JsonKey(name: 'dht_nodes') required int dhtNodes,
    @JsonKey(name: 'connection_status') required String connectionStatus,
  }) = _QbitServerState;

  factory QbitServerState.fromJson(Map<String, dynamic> json) =>
      _$QbitServerStateFromJson(json);
}

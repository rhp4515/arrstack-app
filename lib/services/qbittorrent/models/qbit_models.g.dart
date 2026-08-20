// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qbit_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QbitTorrent _$QbitTorrentFromJson(Map<String, dynamic> json) => _QbitTorrent(
  hash: json['hash'] as String,
  name: json['name'] as String,
  size: (json['size'] as num).toInt(),
  progress: (json['progress'] as num).toDouble(),
  dlspeed: (json['dlspeed'] as num).toInt(),
  upspeed: (json['upspeed'] as num).toInt(),
  priority: (json['priority'] as num).toInt(),
  numSeeds: (json['num_seeds'] as num).toInt(),
  numLeechs: (json['num_leechs'] as num).toInt(),
  numIncomplete: (json['num_incomplete'] as num).toInt(),
  ratio: (json['ratio'] as num).toDouble(),
  eta: (json['eta'] as num).toInt(),
  state: json['state'] as String,
  tracker: json['tracker'] as String? ?? '',
  addedOn: (json['added_on'] as num).toInt(),
  completionOn: (json['completion_on'] as num).toInt(),
  category: json['category'] as String,
  tags: json['tags'] as String,
  savePath: json['save_path'] as String,
  timeActive: (json['time_active'] as num).toInt(),
  lastActivity: (json['last_activity'] as num).toInt(),
);

Map<String, dynamic> _$QbitTorrentToJson(_QbitTorrent instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'name': instance.name,
      'size': instance.size,
      'progress': instance.progress,
      'dlspeed': instance.dlspeed,
      'upspeed': instance.upspeed,
      'priority': instance.priority,
      'num_seeds': instance.numSeeds,
      'num_leechs': instance.numLeechs,
      'num_incomplete': instance.numIncomplete,
      'ratio': instance.ratio,
      'eta': instance.eta,
      'state': instance.state,
      'tracker': instance.tracker,
      'added_on': instance.addedOn,
      'completion_on': instance.completionOn,
      'category': instance.category,
      'tags': instance.tags,
      'save_path': instance.savePath,
      'time_active': instance.timeActive,
      'last_activity': instance.lastActivity,
    };

_QbitMainData _$QbitMainDataFromJson(Map<String, dynamic> json) =>
    _QbitMainData(
      serverState: QbitServerState.fromJson(
        json['server_state'] as Map<String, dynamic>,
      ),
      torrents:
          (json['torrents'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, QbitTorrent.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QbitMainDataToJson(_QbitMainData instance) =>
    <String, dynamic>{
      'server_state': instance.serverState,
      'torrents': instance.torrents,
      'categories': instance.categories,
    };

_QbitServerState _$QbitServerStateFromJson(Map<String, dynamic> json) =>
    _QbitServerState(
      dlInfoSpeed: (json['dl_info_speed'] as num).toInt(),
      dlInfoData: (json['dl_info_data'] as num).toInt(),
      upInfoSpeed: (json['up_info_speed'] as num).toInt(),
      upInfoData: (json['up_info_data'] as num).toInt(),
      dlRateLimit: (json['dl_rate_limit'] as num).toInt(),
      upRateLimit: (json['up_rate_limit'] as num).toInt(),
      dhtNodes: (json['dht_nodes'] as num).toInt(),
      connectionStatus: json['connection_status'] as String,
    );

Map<String, dynamic> _$QbitServerStateToJson(_QbitServerState instance) =>
    <String, dynamic>{
      'dl_info_speed': instance.dlInfoSpeed,
      'dl_info_data': instance.dlInfoData,
      'up_info_speed': instance.upInfoSpeed,
      'up_info_data': instance.upInfoData,
      'dl_rate_limit': instance.dlRateLimit,
      'up_rate_limit': instance.upRateLimit,
      'dht_nodes': instance.dhtNodes,
      'connection_status': instance.connectionStatus,
    };

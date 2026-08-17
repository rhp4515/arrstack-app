// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuma_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KumaMonitor _$KumaMonitorFromJson(Map<String, dynamic> json) => _KumaMonitor(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  url: json['url'] as String?,
  active: json['active'] as bool,
  interval: (json['interval'] as num).toInt(),
  status: (json['status'] as num?)?.toInt() ?? 1,
  uptime: (json['uptime'] as num?)?.toDouble() ?? 0,
  weight: (json['weight'] as num?)?.toInt() ?? 0,
  heartbeats:
      (json['heartbeats'] as List<dynamic>?)
          ?.map((e) => KumaHeartbeat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$KumaMonitorToJson(_KumaMonitor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
      'active': instance.active,
      'interval': instance.interval,
      'status': instance.status,
      'uptime': instance.uptime,
      'weight': instance.weight,
      'heartbeats': instance.heartbeats,
    };

_KumaHeartbeat _$KumaHeartbeatFromJson(Map<String, dynamic> json) =>
    _KumaHeartbeat(
      monitorId: (json['monitorID'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      time: DateTime.parse(json['time'] as String),
      msg: json['msg'] as String?,
      ping: (json['ping'] as num).toInt(),
      important: json['important'] as bool,
    );

Map<String, dynamic> _$KumaHeartbeatToJson(_KumaHeartbeat instance) =>
    <String, dynamic>{
      'monitorID': instance.monitorId,
      'status': instance.status,
      'time': instance.time.toIso8601String(),
      'msg': instance.msg,
      'ping': instance.ping,
      'important': instance.important,
    };

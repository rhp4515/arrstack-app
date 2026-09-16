// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_service_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CachedServiceSummary _$CachedServiceSummaryFromJson(
  Map<String, dynamic> json,
) => _CachedServiceSummary(
  instanceId: json['instanceId'] as String,
  instanceName: json['instanceName'] as String,
  serviceType: $enumDecode(_$ServiceTypeEnumMap, json['serviceType']),
  summaryLine: json['summaryLine'] as String,
  lastFetchedAt: DateTime.parse(json['lastFetchedAt'] as String),
);

Map<String, dynamic> _$CachedServiceSummaryToJson(
  _CachedServiceSummary instance,
) => <String, dynamic>{
  'instanceId': instance.instanceId,
  'instanceName': instance.instanceName,
  'serviceType': _$ServiceTypeEnumMap[instance.serviceType]!,
  'summaryLine': instance.summaryLine,
  'lastFetchedAt': instance.lastFetchedAt.toIso8601String(),
};

const _$ServiceTypeEnumMap = {
  ServiceType.sonarr: 'sonarr',
  ServiceType.radarr: 'radarr',
  ServiceType.bazarr: 'bazarr',
  ServiceType.prowlarr: 'prowlarr',
  ServiceType.qbittorrent: 'qbittorrent',
  ServiceType.uptimeKuma: 'uptimeKuma',
  ServiceType.seerr: 'seerr',
  ServiceType.einthusan: 'einthusan',
};

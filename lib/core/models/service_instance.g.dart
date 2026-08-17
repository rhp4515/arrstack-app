// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceInstance _$ServiceInstanceFromJson(Map<String, dynamic> json) =>
    _ServiceInstance(
      id: json['id'] as String,
      name: json['name'] as String,
      serviceType: $enumDecode(_$ServiceTypeEnumMap, json['serviceType']),
      authType: $enumDecode(_$AuthTypeEnumMap, json['authType']),
      localBaseUrl: json['localBaseUrl'] as String?,
      remoteBaseUrl: json['remoteBaseUrl'] as String?,
      homeSsidsOverride: (json['homeSsidsOverride'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      endpointMode:
          $enumDecodeNullable(_$EndpointModeEnumMap, json['endpointMode']) ??
          EndpointMode.auto,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$ServiceInstanceToJson(_ServiceInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serviceType': _$ServiceTypeEnumMap[instance.serviceType]!,
      'authType': _$AuthTypeEnumMap[instance.authType]!,
      'localBaseUrl': instance.localBaseUrl,
      'remoteBaseUrl': instance.remoteBaseUrl,
      'homeSsidsOverride': instance.homeSsidsOverride,
      'endpointMode': _$EndpointModeEnumMap[instance.endpointMode]!,
      'isDefault': instance.isDefault,
    };

const _$ServiceTypeEnumMap = {
  ServiceType.sonarr: 'sonarr',
  ServiceType.radarr: 'radarr',
  ServiceType.bazarr: 'bazarr',
  ServiceType.prowlarr: 'prowlarr',
  ServiceType.qbittorrent: 'qbittorrent',
  ServiceType.uptimeKuma: 'uptimeKuma',
  ServiceType.seerr: 'seerr',
};

const _$AuthTypeEnumMap = {
  AuthType.apiKey: 'apiKey',
  AuthType.usernamePassword: 'usernamePassword',
};

const _$EndpointModeEnumMap = {
  EndpointMode.auto: 'auto',
  EndpointMode.forceLocal: 'forceLocal',
  EndpointMode.forceRemote: 'forceRemote',
};

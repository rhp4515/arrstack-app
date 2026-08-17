// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceIdentity _$ServiceIdentityFromJson(Map<String, dynamic> json) =>
    _ServiceIdentity(
      instanceName: json['instanceName'] as String,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$ServiceIdentityToJson(_ServiceIdentity instance) =>
    <String, dynamic>{
      'instanceName': instance.instanceName,
      'version': instance.version,
    };

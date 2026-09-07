// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indexer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Indexer _$IndexerFromJson(Map<String, dynamic> json) => _Indexer(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String? ?? '',
  protocol: json['protocol'] as String? ?? '',
  priority: (json['priority'] as num?)?.toInt() ?? 25,
  enable: json['enable'] as bool? ?? true,
  status: json['status'] as String?,
);

Map<String, dynamic> _$IndexerToJson(_Indexer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'protocol': instance.protocol,
  'priority': instance.priority,
  'enable': instance.enable,
  'status': instance.status,
};

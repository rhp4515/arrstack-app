// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indexer_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IndexerStat _$IndexerStatFromJson(Map<String, dynamic> json) => _IndexerStat(
  indexerId: (json['indexerId'] as num).toInt(),
  indexerName: json['indexerName'] as String? ?? '',
  averageResponseTime: (json['averageResponseTime'] as num?)?.toInt() ?? 0,
  numberOfQueries: (json['numberOfQueries'] as num?)?.toInt() ?? 0,
  numberOfGrabs: (json['numberOfGrabs'] as num?)?.toInt() ?? 0,
  numberOfFailures: (json['numberOfFailures'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$IndexerStatToJson(_IndexerStat instance) =>
    <String, dynamic>{
      'indexerId': instance.indexerId,
      'indexerName': instance.indexerName,
      'averageResponseTime': instance.averageResponseTime,
      'numberOfQueries': instance.numberOfQueries,
      'numberOfGrabs': instance.numberOfGrabs,
      'numberOfFailures': instance.numberOfFailures,
    };

_IndexerStatsResponse _$IndexerStatsResponseFromJson(
  Map<String, dynamic> json,
) => _IndexerStatsResponse(
  indexers:
      (json['indexers'] as List<dynamic>?)
          ?.map((e) => IndexerStat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$IndexerStatsResponseToJson(
  _IndexerStatsResponse instance,
) => <String, dynamic>{'indexers': instance.indexers};

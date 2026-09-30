// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LogEntry _$LogEntryFromJson(Map<String, dynamic> json) => _LogEntry(
  time: DateTime.parse(json['time'] as String),
  level: $enumDecode(_$LogLevelEnumMap, json['level']),
  tag: json['tag'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$LogEntryToJson(_LogEntry instance) => <String, dynamic>{
  'time': instance.time.toIso8601String(),
  'level': _$LogLevelEnumMap[instance.level]!,
  'tag': instance.tag,
  'message': instance.message,
};

const _$LogLevelEnumMap = {
  LogLevel.info: 'info',
  LogLevel.warn: 'warn',
  LogLevel.error: 'error',
};

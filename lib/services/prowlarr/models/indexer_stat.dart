import 'package:freezed_annotation/freezed_annotation.dart';

part 'indexer_stat.freezed.dart';
part 'indexer_stat.g.dart';

@freezed
abstract class IndexerStat with _$IndexerStat {
  const factory IndexerStat({
    required int indexerId,
    @Default('') String indexerName,
    @Default(0) int averageResponseTime,
    @Default(0) int numberOfQueries,
    @Default(0) int numberOfGrabs,
    @Default(0) int numberOfFailures,
  }) = _IndexerStat;

  factory IndexerStat.fromJson(Map<String, dynamic> json) => _$IndexerStatFromJson(json);
}

@freezed
abstract class IndexerStatsResponse with _$IndexerStatsResponse {
  const factory IndexerStatsResponse({
    @Default([]) List<IndexerStat> indexers,
  }) = _IndexerStatsResponse;

  factory IndexerStatsResponse.fromJson(Map<String, dynamic> json) => _$IndexerStatsResponseFromJson(json);
}

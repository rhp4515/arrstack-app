import 'package:freezed_annotation/freezed_annotation.dart';

part 'indexer.freezed.dart';
part 'indexer.g.dart';

@freezed
abstract class Indexer with _$Indexer {
  const factory Indexer({
    required int id,
    @Default('') String name,
    @Default('') String protocol,
    @Default(25) int priority,
    @Default(true) bool enable,
    String? status,
  }) = _Indexer;

  factory Indexer.fromJson(Map<String, dynamic> json) => _$IndexerFromJson(json);
}

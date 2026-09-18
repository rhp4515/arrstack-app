/// One service's last-successful Home summary, persisted with its own
/// fetch timestamp — the data the offline layout (README §3f) falls back
/// to when nothing is currently reachable.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cached_service_summary.freezed.dart';
part 'cached_service_summary.g.dart';

@freezed
abstract class CachedServiceSummary with _$CachedServiceSummary {
  const factory CachedServiceSummary({
    required String instanceId,
    required String instanceName,
    required ServiceType serviceType,
    required String summaryLine,
    required DateTime lastFetchedAt,
  }) = _CachedServiceSummary;

  factory CachedServiceSummary.fromJson(Map<String, dynamic> json) =>
      _$CachedServiceSummaryFromJson(json);
}

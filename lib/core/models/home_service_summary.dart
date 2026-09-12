/// One service's tile data on the Home hub: name row + tabular summary row
/// (Phase 3 design §Provider plan).
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_service_summary.freezed.dart';

@freezed
abstract class HomeServiceSummary with _$HomeServiceSummary {
  const factory HomeServiceSummary({
    required String instanceId,
    required String instanceName,
    required ServiceType serviceType,
    required bool isReachable,
    required String summaryLine,
    String? statusLabel,
  }) = _HomeServiceSummary;
}

/// One service's tile data on the Home hub: name row + tabular summary row
/// (Phase 3 design §Provider plan).
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
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

    /// The classified failure behind an unreachable summary, when known —
    /// null when reachable, or when the failure came from an unclassified
    /// exception (a repository-construction error, for example). Lets the
    /// offline layout distinguish a genuine network outage from bad
    /// credentials or a server error, instead of always blaming
    /// connectivity (README §3f offline card).
    AppError? lastError,
  }) = _HomeServiceSummary;
}

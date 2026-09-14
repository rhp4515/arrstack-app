/// "Right now" card data for the default qBittorrent instance (Phase 3
/// design §Provider plan). Null upstream (not this type) when no
/// qBittorrent instance is configured.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'right_now_summary.freezed.dart';

@freezed
abstract class RightNowSummary with _$RightNowSummary {
  const factory RightNowSummary({
    required int downloadSpeed,
    required int uploadSpeed,
    required int downloadingCount,
    required int seedingCount,
    int? etaToNextFinishSeconds,
    required double downloadingFraction,
    required double pausedOrStalledFraction,
    required double queuedFraction,
  }) = _RightNowSummary;
}

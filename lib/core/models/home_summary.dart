/// Aggregate Home-band data: hero numeral/caption plus up to two status
/// lines, derived from `homeServiceSummariesProvider` (Phase 3 design
/// §Provider plan).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_summary.freezed.dart';

@freezed
abstract class HomeStatusLine with _$HomeStatusLine {
  const factory HomeStatusLine({
    required String label,
    required bool isWarning,
  }) = _HomeStatusLine;
}

@freezed
abstract class HomeSummary with _$HomeSummary {
  const factory HomeSummary({
    required int healthy,
    required int total,
    required List<HomeStatusLine> statusLines,
  }) = _HomeSummary;
}

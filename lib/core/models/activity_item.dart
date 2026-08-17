/// Unified model for active downloads and tasks across services.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_item.freezed.dart';

@freezed
abstract class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required String title,
    required ServiceType serviceType,
    required String instanceId,
    required double progress,
    required int speed, // Bytes per second
    required String status,
    String? posterUrl,
  }) = _ActivityItem;
}

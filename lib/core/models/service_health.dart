/// Model for a service's health and headline status on the dashboard.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_health.freezed.dart';

@freezed
abstract class ServiceHealth with _$ServiceHealth {
  const factory ServiceHealth({
    required String instanceId,
    required String instanceName,
    required ServiceType serviceType,
    required bool isReachable,
    required String headlineStat,
    required Color statusColor,
  }) = _ServiceHealth;
}

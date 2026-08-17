/// Models for the Uptime Kuma Socket.io API.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'kuma_models.freezed.dart';
part 'kuma_models.g.dart';

/// One monitor in Uptime Kuma.
@freezed
abstract class KumaMonitor with _$KumaMonitor {
  const factory KumaMonitor({
    required int id,
    required String name,
    required String type,
    String? url,
    required bool active,
    required int interval,
    @Default(1) int status, // 0: Down, 1: Up, 2: Pending, 3: Maintenance
    @Default(0) double uptime,
    @Default(0) int weight,
    @Default([]) List<KumaHeartbeat> heartbeats,
  }) = _KumaMonitor;

  factory KumaMonitor.fromJson(Map<String, dynamic> json) =>
      _$KumaMonitorFromJson(json);
}

/// A single heartbeat event for a monitor.
@freezed
abstract class KumaHeartbeat with _$KumaHeartbeat {
  const factory KumaHeartbeat({
    @JsonKey(name: 'monitorID') required int monitorId,
    required int status,
    required DateTime time,
    String? msg,
    required int ping,
    required bool important,
  }) = _KumaHeartbeat;

  factory KumaHeartbeat.fromJson(Map<String, dynamic> json) =>
      _$KumaHeartbeatFromJson(json);
}

/// Helper extension for Kuma status logic.
extension KumaStatusX on int {
  bool get isUp => this == 1;
  bool get isDown => this == 0;
  bool get isPending => this == 2;
  bool get isMaintenance => this == 3;

  String get statusLabel => switch (this) {
    0 => 'Down',
    1 => 'Up',
    2 => 'Pending',
    3 => 'Maintenance',
    _ => 'Unknown',
  };
}

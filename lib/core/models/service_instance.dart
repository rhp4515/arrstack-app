/// A configured service (e.g. "Home Radarr") and its non-secret metadata.
///
/// The API key / username+password for this instance is **never** stored
/// here — it lives only in `SecureStore`, keyed by [ServiceInstance.id].
library;

import 'package:arrstack/core/models/auth_type.dart';
import 'package:arrstack/core/models/endpoint_mode.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_instance.freezed.dart';
part 'service_instance.g.dart';

/// One configured instance of a [ServiceType] (spec §5, §6a).
@freezed
abstract class ServiceInstance with _$ServiceInstance {
  const factory ServiceInstance({
    required String id,
    required String name,
    required ServiceType serviceType,
    required AuthType authType,

    /// LAN URL, e.g. `http://192.168.1.10:7878`.
    String? localBaseUrl,

    /// Tailscale MagicDNS URL, e.g. `http://nas.tailnet-xxxx.ts.net:7878`.
    String? remoteBaseUrl,

    /// Per-instance override of the app-level home SSID list. When null,
    /// [EndpointResolver] falls back to the app-level list.
    List<String>? homeSsidsOverride,
    @Default(EndpointMode.auto) EndpointMode endpointMode,
    @Default(false) bool isDefault,
  }) = _ServiceInstance;

  factory ServiceInstance.fromJson(Map<String, dynamic> json) =>
      _$ServiceInstanceFromJson(json);
}

/// Validates a [ServiceInstance] at the storage boundary (spec §5): at
/// least one of the local/remote URLs must be present, and any URL that is
/// present must parse with a scheme and host.
Result<ServiceInstance> validateServiceInstance(ServiceInstance instance) {
  if (instance.id.trim().isEmpty) {
    return const Err(
      ValidationError(userMessage: 'Instance id cannot be empty.'),
    );
  }
  if (instance.name.trim().isEmpty) {
    return const Err(
      ValidationError(userMessage: 'Instance name cannot be empty.'),
    );
  }

  final hasLocal = _hasValue(instance.localBaseUrl);
  final hasRemote = _hasValue(instance.remoteBaseUrl);
  if (!hasLocal && !hasRemote) {
    return const Err(
      ValidationError(userMessage: 'Enter at least one local or remote URL.'),
    );
  }
  if (hasLocal && !_isValidUrl(instance.localBaseUrl)) {
    return const Err(
      ValidationError(userMessage: 'The local URL is not valid.'),
    );
  }
  if (hasRemote && !_isValidUrl(instance.remoteBaseUrl)) {
    return const Err(
      ValidationError(userMessage: 'The remote URL is not valid.'),
    );
  }

  return Ok(instance);
}

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

bool _isValidUrl(String? value) {
  if (!_hasValue(value)) return false;
  final uri = Uri.tryParse(value!.trim());
  return uri != null && uri.hasScheme && uri.host.isNotEmpty;
}

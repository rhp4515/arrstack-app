// Shared test fixtures for core/ unit tests.

import 'package:arrstack/core/models/models.dart';

ServiceInstance buildInstance({
  String id = 'radarr-1',
  String name = 'Home Radarr',
  ServiceType serviceType = ServiceType.radarr,
  AuthType authType = AuthType.apiKey,
  String? localBaseUrl = 'http://192.168.1.10:7878',
  String? remoteBaseUrl = 'http://nas.tailnet-xxxx.ts.net:7878',
  List<String>? homeSsidsOverride,
  EndpointMode endpointMode = EndpointMode.auto,
  bool isDefault = false,
}) {
  return ServiceInstance(
    id: id,
    name: name,
    serviceType: serviceType,
    authType: authType,
    localBaseUrl: localBaseUrl,
    remoteBaseUrl: remoteBaseUrl,
    homeSsidsOverride: homeSsidsOverride,
    endpointMode: endpointMode,
    isDefault: isDefault,
  );
}

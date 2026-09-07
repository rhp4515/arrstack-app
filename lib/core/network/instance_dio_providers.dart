/// Providers that wire up [EndpointResolver], [InstanceRepository], and
/// [SecureStore] into a ready-to-use [Dio] instance for any service (spec
/// §6a, §11).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'instance_dio_providers.g.dart';

/// Session-level override for an instance's [EndpointMode] (spec §6a).
/// Resets when the app process is killed.
@Riverpod(keepAlive: true)
class EndpointSessionOverride extends _$EndpointSessionOverride {
  @override
  Map<String, EndpointMode?> build() => const {};

  void update(String instanceId, EndpointMode? mode) {
    state = {...state, instanceId: mode};
  }
}

/// The credential for a service instance, read from [SecureStore].
@riverpod
Future<ServiceCredential?> serviceCredential(Ref ref, String instanceId) {
  return ref.watch(secureStoreProvider).readCredential(instanceId);
}

/// Resolves the current base URL for [instanceId] based on SSID/connectivity.
@riverpod
Future<Result<EndpointResolution>> resolvedEndpoint(
  Ref ref,
  String instanceId,
) async {
  final instanceResult = await ref.watch(
    serviceInstanceProvider(instanceId).future,
  );
  if (instanceResult is Err<ServiceInstance>) return Err(instanceResult.error);
  final instance = (instanceResult as Ok<ServiceInstance>).value;

  final ssidsResult = await ref.watch(homeSsidsProvider.future);
  if (ssidsResult is Err<List<String>>) return Err(ssidsResult.error);
  final appHomeSsids = (ssidsResult as Ok<List<String>>).value;

  // currentSsid is a Stream; .future completion ensures we have the current
  // state from the connectivity/SSID sources.
  final currentSsid = await ref.watch(currentSsidProvider.future);
  final resolver = ref.watch(endpointResolverProvider);

  // Apply session override if present.
  final sessionOverride = ref.watch(
    endpointSessionOverrideProvider,
  )[instanceId];
  final effectiveInstance = sessionOverride != null
      ? instance.copyWith(endpointMode: sessionOverride)
      : instance;

  return resolver.resolve(
    instance: effectiveInstance,
    appHomeSsids: appHomeSsids,
    currentSsid: currentSsid,
  );
}

/// Provides a [Dio] instance for [instanceId], configured with the correct
/// [EndpointResolution.baseUrl] and auth interceptors (spec §11).
@riverpod
Future<Result<Dio>> dioForInstance(Ref ref, String instanceId) async {
  final resolutionResult = await ref.watch(
    resolvedEndpointProvider(instanceId).future,
  );
  if (resolutionResult is Err<EndpointResolution>) {
    return Err(resolutionResult.error);
  }
  final resolution = (resolutionResult as Ok<EndpointResolution>).value;

  final instanceResult = await ref.watch(
    serviceInstanceProvider(instanceId).future,
  );
  if (instanceResult is Err<ServiceInstance>) return Err(instanceResult.error);
  final instance = (instanceResult as Ok<ServiceInstance>).value;

  final credential = await ref.watch(
    serviceCredentialProvider(instanceId).future,
  );

  // Build the ApiKeyInterceptor only if the service uses API keys via X-Api-Key.
  // Cookie-based (qBittorrent) or Socket (Uptime Kuma) auth services
  // handle their own auth interceptors or flows in their modules.
  final isXApiKeyService =
      instance.serviceType != ServiceType.qbittorrent &&
      instance.serviceType != ServiceType.uptimeKuma;

  final apiKeyInterceptor = isXApiKeyService && credential is ApiKeyCredential
      ? ApiKeyInterceptor(lookupApiKey: () async => credential.apiKey)
      : null;

  return Ok(
    const DioFactory().create(
      baseUrl: resolution.baseUrl,
      apiKeyInterceptor: apiKeyInterceptor,
    ),
  );
}

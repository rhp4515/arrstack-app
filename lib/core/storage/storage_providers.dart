/// Riverpod wiring for storage: [ConfigStore], [SecureStore], the
/// [InstanceRepository], and the current instance list (spec §5).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/config_store.dart';
import 'package:arrstack/core/storage/instance_repository.dart';
import 'package:arrstack/core/storage/secure_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_providers.g.dart';

@Riverpod(keepAlive: true)
ConfigStore configStore(Ref ref) => SharedPreferencesConfigStore();

@Riverpod(keepAlive: true)
SecureStore secureStore(Ref ref) => const FlutterSecureCredentialStore();

@Riverpod(keepAlive: true)
InstanceRepository instanceRepository(Ref ref) => ConfigStoreInstanceRepository(
  ref.watch(configStoreProvider),
  ref.watch(secureStoreProvider),
);

/// The configured service instances. Exposes the [Result] directly rather
/// than throwing, so UI decides how to render a storage failure.
@riverpod
Future<Result<List<ServiceInstance>>> instances(Ref ref) {
  final repository = ref.watch(instanceRepositoryProvider);
  return repository.list();
}

/// App-level "home" WiFi SSIDs used by `EndpointResolver` when an instance
/// has no per-instance override (spec §6a). Consumed by the settings screen
/// (Phase 3) and the per-instance Dio composition (Phase 4).
@riverpod
Future<List<String>> homeSsids(Ref ref) {
  return ref.watch(configStoreProvider).readHomeSsids();
}

/// The default [EndpointMode] applied to newly created instances (spec §6a).
@riverpod
Future<EndpointMode> defaultEndpointMode(Ref ref) {
  return ref.watch(configStoreProvider).readDefaultEndpointMode();
}

/// Riverpod wiring for storage: [ConfigStore], [SecureStore], the
/// [InstanceRepository], and the current instance list (spec §5).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/config_store.dart';
import 'package:arrstack/core/storage/instance_repository.dart';
import 'package:arrstack/core/storage/secure_store.dart';
import 'package:json_annotation/json_annotation.dart';
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
@Riverpod(keepAlive: true)
Future<Result<List<ServiceInstance>>> instances(Ref ref) {
  final repository = ref.watch(instanceRepositoryProvider);
  return repository.list();
}

/// Watches a single [ServiceInstance] by id.
@riverpod
Future<Result<ServiceInstance>> serviceInstance(Ref ref, String id) {
  final repository = ref.watch(instanceRepositoryProvider);
  return repository.getById(id);
}

/// App-level "home" WiFi SSIDs used by `EndpointResolver` when an instance
/// has no per-instance override (spec §6a). Consumed by the settings screen
/// (Phase 3) and the per-instance Dio composition (Phase 4).
@Riverpod(keepAlive: true)
Future<Result<List<String>>> homeSsids(Ref ref) async {
  try {
    final ssids = await ref.watch(configStoreProvider).readHomeSsids();
    return Ok(List.unmodifiable(ssids));
  } catch (error) {
    return Err(
      StorageError(cause: error, userMessage: 'Failed to read home SSIDs.'),
    );
  }
}

/// The default [EndpointMode] applied to newly created instances (spec §6a).
@Riverpod(keepAlive: true)
Future<Result<EndpointMode>> defaultEndpointMode(Ref ref) async {
  try {
    final mode = await ref.watch(configStoreProvider).readDefaultEndpointMode();
    return Ok(mode);
  } catch (error) {
    return Err(
      StorageError(
        cause: error,
        userMessage: 'Failed to read default endpoint mode.',
      ),
    );
  }
}

/// Each service's last-successful summary, read back for Home's offline
/// layout (README §3f `lastKnown`). A corrupt individual entry is skipped
/// rather than discarding the whole cache — these are independent
/// per-service records, unlike the all-or-nothing instance list.
@Riverpod(keepAlive: true)
Future<List<CachedServiceSummary>> cachedServiceSummaries(Ref ref) async {
  final raw = await ref.watch(configStoreProvider).readCachedSummaries();
  final summaries = <CachedServiceSummary>[];
  for (final json in raw) {
    try {
      summaries.add(CachedServiceSummary.fromJson(json));
    } on FormatException {
      continue;
    } on CheckedFromJsonException {
      continue;
    } on TypeError {
      continue;
    } on ArgumentError {
      continue;
    }
  }
  return List.unmodifiable(summaries);
}

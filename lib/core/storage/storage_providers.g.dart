// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(configStore)
final configStoreProvider = ConfigStoreProvider._();

final class ConfigStoreProvider
    extends $FunctionalProvider<ConfigStore, ConfigStore, ConfigStore>
    with $Provider<ConfigStore> {
  ConfigStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configStoreHash();

  @$internal
  @override
  $ProviderElement<ConfigStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConfigStore create(Ref ref) {
    return configStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfigStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfigStore>(value),
    );
  }
}

String _$configStoreHash() => r'77bf4d613c39c2d304541986a32753ccc49efc36';

@ProviderFor(secureStore)
final secureStoreProvider = SecureStoreProvider._();

final class SecureStoreProvider
    extends $FunctionalProvider<SecureStore, SecureStore, SecureStore>
    with $Provider<SecureStore> {
  SecureStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStoreHash();

  @$internal
  @override
  $ProviderElement<SecureStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureStore create(Ref ref) {
    return secureStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStore>(value),
    );
  }
}

String _$secureStoreHash() => r'f8ae26f769396a4b9e9d2d9a77d16fdba2bed3b0';

@ProviderFor(instanceRepository)
final instanceRepositoryProvider = InstanceRepositoryProvider._();

final class InstanceRepositoryProvider
    extends
        $FunctionalProvider<
          InstanceRepository,
          InstanceRepository,
          InstanceRepository
        >
    with $Provider<InstanceRepository> {
  InstanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instanceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instanceRepositoryHash();

  @$internal
  @override
  $ProviderElement<InstanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InstanceRepository create(Ref ref) {
    return instanceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstanceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstanceRepository>(value),
    );
  }
}

String _$instanceRepositoryHash() =>
    r'610e22e6525ae8792e94e777e7cdabf4d76df858';

/// The configured service instances. Exposes the [Result] directly rather
/// than throwing, so UI decides how to render a storage failure.

@ProviderFor(instances)
final instancesProvider = InstancesProvider._();

/// The configured service instances. Exposes the [Result] directly rather
/// than throwing, so UI decides how to render a storage failure.

final class InstancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<ServiceInstance>>>,
          Result<List<ServiceInstance>>,
          FutureOr<Result<List<ServiceInstance>>>
        >
    with
        $FutureModifier<Result<List<ServiceInstance>>>,
        $FutureProvider<Result<List<ServiceInstance>>> {
  /// The configured service instances. Exposes the [Result] directly rather
  /// than throwing, so UI decides how to render a storage failure.
  InstancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instancesHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<ServiceInstance>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<ServiceInstance>>> create(Ref ref) {
    return instances(ref);
  }
}

String _$instancesHash() => r'5b381b81053b624960740fe63ecaba58565f6dae';

/// App-level "home" WiFi SSIDs used by `EndpointResolver` when an instance
/// has no per-instance override (spec §6a). Consumed by the settings screen
/// (Phase 3) and the per-instance Dio composition (Phase 4).

@ProviderFor(homeSsids)
final homeSsidsProvider = HomeSsidsProvider._();

/// App-level "home" WiFi SSIDs used by `EndpointResolver` when an instance
/// has no per-instance override (spec §6a). Consumed by the settings screen
/// (Phase 3) and the per-instance Dio composition (Phase 4).

final class HomeSsidsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// App-level "home" WiFi SSIDs used by `EndpointResolver` when an instance
  /// has no per-instance override (spec §6a). Consumed by the settings screen
  /// (Phase 3) and the per-instance Dio composition (Phase 4).
  HomeSsidsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSsidsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSsidsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return homeSsids(ref);
  }
}

String _$homeSsidsHash() => r'a561c0b1d116daca314ad3526c0875abb563047a';

/// The default [EndpointMode] applied to newly created instances (spec §6a).

@ProviderFor(defaultEndpointMode)
final defaultEndpointModeProvider = DefaultEndpointModeProvider._();

/// The default [EndpointMode] applied to newly created instances (spec §6a).

final class DefaultEndpointModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<EndpointMode>,
          EndpointMode,
          FutureOr<EndpointMode>
        >
    with $FutureModifier<EndpointMode>, $FutureProvider<EndpointMode> {
  /// The default [EndpointMode] applied to newly created instances (spec §6a).
  DefaultEndpointModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultEndpointModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultEndpointModeHash();

  @$internal
  @override
  $FutureProviderElement<EndpointMode> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EndpointMode> create(Ref ref) {
    return defaultEndpointMode(ref);
  }
}

String _$defaultEndpointModeHash() =>
    r'6415948f80a2843e4fe2c9256df12eb5ac41e159';

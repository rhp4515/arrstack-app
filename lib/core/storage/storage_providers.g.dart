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
        isAutoDispose: false,
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

String _$instancesHash() => r'9c0aab9ce0dd02470f991040a189e15d7ad0a60f';

/// Watches a single [ServiceInstance] by id.

@ProviderFor(serviceInstance)
final serviceInstanceProvider = ServiceInstanceFamily._();

/// Watches a single [ServiceInstance] by id.

final class ServiceInstanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<ServiceInstance>>,
          Result<ServiceInstance>,
          FutureOr<Result<ServiceInstance>>
        >
    with
        $FutureModifier<Result<ServiceInstance>>,
        $FutureProvider<Result<ServiceInstance>> {
  /// Watches a single [ServiceInstance] by id.
  ServiceInstanceProvider._({
    required ServiceInstanceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceInstanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceInstanceHash();

  @override
  String toString() {
    return r'serviceInstanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<ServiceInstance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<ServiceInstance>> create(Ref ref) {
    final argument = this.argument as String;
    return serviceInstance(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceInstanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceInstanceHash() => r'85f5fdf60ba25811465da75fb5469be4f7eb8ba6';

/// Watches a single [ServiceInstance] by id.

final class ServiceInstanceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<ServiceInstance>>, String> {
  ServiceInstanceFamily._()
    : super(
        retry: null,
        name: r'serviceInstanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches a single [ServiceInstance] by id.

  ServiceInstanceProvider call(String id) =>
      ServiceInstanceProvider._(argument: id, from: this);

  @override
  String toString() => r'serviceInstanceProvider';
}

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
          AsyncValue<Result<List<String>>>,
          Result<List<String>>,
          FutureOr<Result<List<String>>>
        >
    with
        $FutureModifier<Result<List<String>>>,
        $FutureProvider<Result<List<String>>> {
  /// App-level "home" WiFi SSIDs used by `EndpointResolver` when an instance
  /// has no per-instance override (spec §6a). Consumed by the settings screen
  /// (Phase 3) and the per-instance Dio composition (Phase 4).
  HomeSsidsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSsidsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSsidsHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<String>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<String>>> create(Ref ref) {
    return homeSsids(ref);
  }
}

String _$homeSsidsHash() => r'f1d6eb26edb31d1310db4e37795afbe8c406bd1e';

/// The default [EndpointMode] applied to newly created instances (spec §6a).

@ProviderFor(defaultEndpointMode)
final defaultEndpointModeProvider = DefaultEndpointModeProvider._();

/// The default [EndpointMode] applied to newly created instances (spec §6a).

final class DefaultEndpointModeProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<EndpointMode>>,
          Result<EndpointMode>,
          FutureOr<Result<EndpointMode>>
        >
    with
        $FutureModifier<Result<EndpointMode>>,
        $FutureProvider<Result<EndpointMode>> {
  /// The default [EndpointMode] applied to newly created instances (spec §6a).
  DefaultEndpointModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultEndpointModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultEndpointModeHash();

  @$internal
  @override
  $FutureProviderElement<Result<EndpointMode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<EndpointMode>> create(Ref ref) {
    return defaultEndpointMode(ref);
  }
}

String _$defaultEndpointModeHash() =>
    r'6c922d279c796d08e7a91c7c4ca645a075fb4886';

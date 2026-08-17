// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_dio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Session-level override for an instance's [EndpointMode] (spec §6a).
/// Resets when the app process is killed.

@ProviderFor(EndpointSessionOverride)
final endpointSessionOverrideProvider = EndpointSessionOverrideProvider._();

/// Session-level override for an instance's [EndpointMode] (spec §6a).
/// Resets when the app process is killed.
final class EndpointSessionOverrideProvider
    extends
        $NotifierProvider<EndpointSessionOverride, Map<String, EndpointMode?>> {
  /// Session-level override for an instance's [EndpointMode] (spec §6a).
  /// Resets when the app process is killed.
  EndpointSessionOverrideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endpointSessionOverrideProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endpointSessionOverrideHash();

  @$internal
  @override
  EndpointSessionOverride create() => EndpointSessionOverride();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, EndpointMode?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, EndpointMode?>>(value),
    );
  }
}

String _$endpointSessionOverrideHash() =>
    r'd11d621538d2fb0e70c0fe8d3dfeed7462366ae2';

/// Session-level override for an instance's [EndpointMode] (spec §6a).
/// Resets when the app process is killed.

abstract class _$EndpointSessionOverride
    extends $Notifier<Map<String, EndpointMode?>> {
  Map<String, EndpointMode?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, EndpointMode?>, Map<String, EndpointMode?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, EndpointMode?>,
                Map<String, EndpointMode?>
              >,
              Map<String, EndpointMode?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The credential for a service instance, read from [SecureStore].

@ProviderFor(serviceCredential)
final serviceCredentialProvider = ServiceCredentialFamily._();

/// The credential for a service instance, read from [SecureStore].

final class ServiceCredentialProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceCredential?>,
          ServiceCredential?,
          FutureOr<ServiceCredential?>
        >
    with
        $FutureModifier<ServiceCredential?>,
        $FutureProvider<ServiceCredential?> {
  /// The credential for a service instance, read from [SecureStore].
  ServiceCredentialProvider._({
    required ServiceCredentialFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'serviceCredentialProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceCredentialHash();

  @override
  String toString() {
    return r'serviceCredentialProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceCredential?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceCredential?> create(Ref ref) {
    final argument = this.argument as String;
    return serviceCredential(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceCredentialProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceCredentialHash() => r'506ef0357f5d5c9d85efef2251a977d45be739eb';

/// The credential for a service instance, read from [SecureStore].

final class ServiceCredentialFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceCredential?>, String> {
  ServiceCredentialFamily._()
    : super(
        retry: null,
        name: r'serviceCredentialProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The credential for a service instance, read from [SecureStore].

  ServiceCredentialProvider call(String instanceId) =>
      ServiceCredentialProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'serviceCredentialProvider';
}

/// Resolves the current base URL for [instanceId] based on SSID/connectivity.

@ProviderFor(resolvedEndpoint)
final resolvedEndpointProvider = ResolvedEndpointFamily._();

/// Resolves the current base URL for [instanceId] based on SSID/connectivity.

final class ResolvedEndpointProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<EndpointResolution>>,
          Result<EndpointResolution>,
          FutureOr<Result<EndpointResolution>>
        >
    with
        $FutureModifier<Result<EndpointResolution>>,
        $FutureProvider<Result<EndpointResolution>> {
  /// Resolves the current base URL for [instanceId] based on SSID/connectivity.
  ResolvedEndpointProvider._({
    required ResolvedEndpointFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'resolvedEndpointProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$resolvedEndpointHash();

  @override
  String toString() {
    return r'resolvedEndpointProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<EndpointResolution>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<EndpointResolution>> create(Ref ref) {
    final argument = this.argument as String;
    return resolvedEndpoint(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ResolvedEndpointProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$resolvedEndpointHash() => r'fe6cd2f3f204aca52840304f10f972d29fcfda67';

/// Resolves the current base URL for [instanceId] based on SSID/connectivity.

final class ResolvedEndpointFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<EndpointResolution>>,
          String
        > {
  ResolvedEndpointFamily._()
    : super(
        retry: null,
        name: r'resolvedEndpointProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves the current base URL for [instanceId] based on SSID/connectivity.

  ResolvedEndpointProvider call(String instanceId) =>
      ResolvedEndpointProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'resolvedEndpointProvider';
}

/// Provides a [Dio] instance for [instanceId], configured with the correct
/// [EndpointResolution.baseUrl] and auth interceptors (spec §11).

@ProviderFor(dioForInstance)
final dioForInstanceProvider = DioForInstanceFamily._();

/// Provides a [Dio] instance for [instanceId], configured with the correct
/// [EndpointResolution.baseUrl] and auth interceptors (spec §11).

final class DioForInstanceProvider
    extends $FunctionalProvider<AsyncValue<Dio>, Dio, FutureOr<Dio>>
    with $FutureModifier<Dio>, $FutureProvider<Dio> {
  /// Provides a [Dio] instance for [instanceId], configured with the correct
  /// [EndpointResolution.baseUrl] and auth interceptors (spec §11).
  DioForInstanceProvider._({
    required DioForInstanceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dioForInstanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dioForInstanceHash();

  @override
  String toString() {
    return r'dioForInstanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Dio> create(Ref ref) {
    final argument = this.argument as String;
    return dioForInstance(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DioForInstanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dioForInstanceHash() => r'0c620283c2cde7489e4917364f9702fa3242ac30';

/// Provides a [Dio] instance for [instanceId], configured with the correct
/// [EndpointResolution.baseUrl] and auth interceptors (spec §11).

final class DioForInstanceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Dio>, String> {
  DioForInstanceFamily._()
    : super(
        retry: null,
        name: r'dioForInstanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a [Dio] instance for [instanceId], configured with the correct
  /// [EndpointResolution.baseUrl] and auth interceptors (spec §11).

  DioForInstanceProvider call(String instanceId) =>
      DioForInstanceProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'dioForInstanceProvider';
}

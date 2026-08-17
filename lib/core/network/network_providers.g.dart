// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ssidSource)
final ssidSourceProvider = SsidSourceProvider._();

final class SsidSourceProvider
    extends $FunctionalProvider<SsidSource, SsidSource, SsidSource>
    with $Provider<SsidSource> {
  SsidSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ssidSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ssidSourceHash();

  @$internal
  @override
  $ProviderElement<SsidSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SsidSource create(Ref ref) {
    return ssidSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SsidSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SsidSource>(value),
    );
  }
}

String _$ssidSourceHash() => r'f457368f6f0787e53bb532388cd465a94aa489ca';

@ProviderFor(connectivitySource)
final connectivitySourceProvider = ConnectivitySourceProvider._();

final class ConnectivitySourceProvider
    extends
        $FunctionalProvider<
          ConnectivitySource,
          ConnectivitySource,
          ConnectivitySource
        >
    with $Provider<ConnectivitySource> {
  ConnectivitySourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivitySourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivitySourceHash();

  @$internal
  @override
  $ProviderElement<ConnectivitySource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConnectivitySource create(Ref ref) {
    return connectivitySource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectivitySource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectivitySource>(value),
    );
  }
}

String _$connectivitySourceHash() =>
    r'5077e41e3ff04c4723dab7b4954f95369632a94f';

@ProviderFor(endpointResolver)
final endpointResolverProvider = EndpointResolverProvider._();

final class EndpointResolverProvider
    extends
        $FunctionalProvider<
          EndpointResolver,
          EndpointResolver,
          EndpointResolver
        >
    with $Provider<EndpointResolver> {
  EndpointResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endpointResolverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endpointResolverHash();

  @$internal
  @override
  $ProviderElement<EndpointResolver> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EndpointResolver create(Ref ref) {
    return endpointResolver(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EndpointResolver value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EndpointResolver>(value),
    );
  }
}

String _$endpointResolverHash() => r'7fda54e1a30d54f47b52b5f97581d7ad1fd368c0';

/// The currently connected WiFi SSID (or null if unavailable), re-read
/// every time connectivity changes so `EndpointResolver`-driven baseUrls
/// stay current (spec §6a step 4).

@ProviderFor(currentSsid)
final currentSsidProvider = CurrentSsidProvider._();

/// The currently connected WiFi SSID (or null if unavailable), re-read
/// every time connectivity changes so `EndpointResolver`-driven baseUrls
/// stay current (spec §6a step 4).

final class CurrentSsidProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  /// The currently connected WiFi SSID (or null if unavailable), re-read
  /// every time connectivity changes so `EndpointResolver`-driven baseUrls
  /// stay current (spec §6a step 4).
  CurrentSsidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSsidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSsidHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return currentSsid(ref);
  }
}

String _$currentSsidHash() => r'0ef6e073a44eb1aedc53e266e970d000608ee0ef';

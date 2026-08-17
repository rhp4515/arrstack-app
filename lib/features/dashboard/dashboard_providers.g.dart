// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stackHealth)
final stackHealthProvider = StackHealthProvider._();

final class StackHealthProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServiceHealth>>,
          List<ServiceHealth>,
          FutureOr<List<ServiceHealth>>
        >
    with
        $FutureModifier<List<ServiceHealth>>,
        $FutureProvider<List<ServiceHealth>> {
  StackHealthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackHealthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackHealthHash();

  @$internal
  @override
  $FutureProviderElement<List<ServiceHealth>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ServiceHealth>> create(Ref ref) {
    return stackHealth(ref);
  }
}

String _$stackHealthHash() => r'48d3161da7ba49e4cb3a1cd16a62475ea22712c4';

@ProviderFor(stackActivity)
final stackActivityProvider = StackActivityProvider._();

final class StackActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityItem>>,
          List<ActivityItem>,
          FutureOr<List<ActivityItem>>
        >
    with
        $FutureModifier<List<ActivityItem>>,
        $FutureProvider<List<ActivityItem>> {
  StackActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackActivityHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivityItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivityItem>> create(Ref ref) {
    return stackActivity(ref);
  }
}

String _$stackActivityHash() => r'cba1f14c942134000269d942f5b344e14aedbfa7';

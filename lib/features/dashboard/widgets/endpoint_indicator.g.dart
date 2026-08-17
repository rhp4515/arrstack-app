// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_indicator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Finds a "primary" instance to show the indicator for on the Dashboard.

@ProviderFor(primaryDashboardInstance)
final primaryDashboardInstanceProvider = PrimaryDashboardInstanceProvider._();

/// Finds a "primary" instance to show the indicator for on the Dashboard.

final class PrimaryDashboardInstanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceInstance?>,
          ServiceInstance?,
          FutureOr<ServiceInstance?>
        >
    with $FutureModifier<ServiceInstance?>, $FutureProvider<ServiceInstance?> {
  /// Finds a "primary" instance to show the indicator for on the Dashboard.
  PrimaryDashboardInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'primaryDashboardInstanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$primaryDashboardInstanceHash();

  @$internal
  @override
  $FutureProviderElement<ServiceInstance?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceInstance?> create(Ref ref) {
    return primaryDashboardInstance(ref);
  }
}

String _$primaryDashboardInstanceHash() =>
    r'9eed1c2ec150b30912cf99e7f42558602093ea42';

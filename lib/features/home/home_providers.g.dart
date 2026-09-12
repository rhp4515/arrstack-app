// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Finds a "primary" instance to show the endpoint chip for on Home.
/// Moved verbatim from the deleted `endpoint_indicator.dart`.

@ProviderFor(primaryDashboardInstance)
final primaryDashboardInstanceProvider = PrimaryDashboardInstanceProvider._();

/// Finds a "primary" instance to show the endpoint chip for on Home.
/// Moved verbatim from the deleted `endpoint_indicator.dart`.

final class PrimaryDashboardInstanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceInstance?>,
          ServiceInstance?,
          FutureOr<ServiceInstance?>
        >
    with $FutureModifier<ServiceInstance?>, $FutureProvider<ServiceInstance?> {
  /// Finds a "primary" instance to show the endpoint chip for on Home.
  /// Moved verbatim from the deleted `endpoint_indicator.dart`.
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

@ProviderFor(homeServiceSummaries)
final homeServiceSummariesProvider = HomeServiceSummariesProvider._();

final class HomeServiceSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HomeServiceSummary>>,
          List<HomeServiceSummary>,
          FutureOr<List<HomeServiceSummary>>
        >
    with
        $FutureModifier<List<HomeServiceSummary>>,
        $FutureProvider<List<HomeServiceSummary>> {
  HomeServiceSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeServiceSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeServiceSummariesHash();

  @$internal
  @override
  $FutureProviderElement<List<HomeServiceSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HomeServiceSummary>> create(Ref ref) {
    return homeServiceSummaries(ref);
  }
}

String _$homeServiceSummariesHash() =>
    r'637b4246c530a59caf485262a06e80a37c5a02e7';

@ProviderFor(homeSummary)
final homeSummaryProvider = HomeSummaryProvider._();

final class HomeSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeSummary>,
          HomeSummary,
          FutureOr<HomeSummary>
        >
    with $FutureModifier<HomeSummary>, $FutureProvider<HomeSummary> {
  HomeSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSummaryHash();

  @$internal
  @override
  $FutureProviderElement<HomeSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeSummary> create(Ref ref) {
    return homeSummary(ref);
  }
}

String _$homeSummaryHash() => r'd611a9866bf844a41f56f2ddd828167c5a7de3d8';

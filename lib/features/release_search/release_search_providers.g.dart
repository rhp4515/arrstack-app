// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs an interactive search for [targetId] (an episode id for Sonarr, a
/// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
/// is an explicit, expensive action; refetch with `ref.invalidate`.

@ProviderFor(releaseSearchResults)
final releaseSearchResultsProvider = ReleaseSearchResultsFamily._();

/// Runs an interactive search for [targetId] (an episode id for Sonarr, a
/// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
/// is an explicit, expensive action; refetch with `ref.invalidate`.

final class ReleaseSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<ReleaseCandidate>>>,
          Result<List<ReleaseCandidate>>,
          FutureOr<Result<List<ReleaseCandidate>>>
        >
    with
        $FutureModifier<Result<List<ReleaseCandidate>>>,
        $FutureProvider<Result<List<ReleaseCandidate>>> {
  /// Runs an interactive search for [targetId] (an episode id for Sonarr, a
  /// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
  /// is an explicit, expensive action; refetch with `ref.invalidate`.
  ReleaseSearchResultsProvider._({
    required ReleaseSearchResultsFamily super.from,
    required ({ServiceType service, String instanceId, int targetId})
    super.argument,
  }) : super(
         retry: null,
         name: r'releaseSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$releaseSearchResultsHash();

  @override
  String toString() {
    return r'releaseSearchResultsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<ReleaseCandidate>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<ReleaseCandidate>>> create(Ref ref) {
    final argument =
        this.argument
            as ({ServiceType service, String instanceId, int targetId});
    return releaseSearchResults(
      ref,
      service: argument.service,
      instanceId: argument.instanceId,
      targetId: argument.targetId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReleaseSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$releaseSearchResultsHash() =>
    r'8430e5696514795678ddc54753fa3499c878dcf5';

/// Runs an interactive search for [targetId] (an episode id for Sonarr, a
/// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
/// is an explicit, expensive action; refetch with `ref.invalidate`.

final class ReleaseSearchResultsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<ReleaseCandidate>>>,
          ({ServiceType service, String instanceId, int targetId})
        > {
  ReleaseSearchResultsFamily._()
    : super(
        retry: null,
        name: r'releaseSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Runs an interactive search for [targetId] (an episode id for Sonarr, a
  /// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
  /// is an explicit, expensive action; refetch with `ref.invalidate`.

  ReleaseSearchResultsProvider call({
    required ServiceType service,
    required String instanceId,
    required int targetId,
  }) => ReleaseSearchResultsProvider._(
    argument: (service: service, instanceId: instanceId, targetId: targetId),
    from: this,
  );

  @override
  String toString() => r'releaseSearchResultsProvider';
}

/// The active sort for the results list. Defaults to [ReleaseSort.peers].

@ProviderFor(ReleaseSortController)
final releaseSortControllerProvider = ReleaseSortControllerProvider._();

/// The active sort for the results list. Defaults to [ReleaseSort.peers].
final class ReleaseSortControllerProvider
    extends $NotifierProvider<ReleaseSortController, ReleaseSort> {
  /// The active sort for the results list. Defaults to [ReleaseSort.peers].
  ReleaseSortControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'releaseSortControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$releaseSortControllerHash();

  @$internal
  @override
  ReleaseSortController create() => ReleaseSortController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReleaseSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReleaseSort>(value),
    );
  }
}

String _$releaseSortControllerHash() =>
    r'c97bd2b634076d2eab6917288e5d8e0e8981e025';

/// The active sort for the results list. Defaults to [ReleaseSort.peers].

abstract class _$ReleaseSortController extends $Notifier<ReleaseSort> {
  ReleaseSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReleaseSort, ReleaseSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReleaseSort, ReleaseSort>,
              ReleaseSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

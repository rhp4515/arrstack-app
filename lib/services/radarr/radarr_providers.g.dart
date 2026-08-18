// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radarr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(radarrRepository)
final radarrRepositoryProvider = RadarrRepositoryFamily._();

final class RadarrRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<RadarrRepository>,
          RadarrRepository,
          FutureOr<RadarrRepository>
        >
    with $FutureModifier<RadarrRepository>, $FutureProvider<RadarrRepository> {
  RadarrRepositoryProvider._({
    required RadarrRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'radarrRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrRepositoryHash();

  @override
  String toString() {
    return r'radarrRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RadarrRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RadarrRepository> create(Ref ref) {
    final argument = this.argument as String;
    return radarrRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrRepositoryHash() => r'931627d897c981d0b01acba6af413424f6b49e7c';

final class RadarrRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RadarrRepository>, String> {
  RadarrRepositoryFamily._()
    : super(
        retry: null,
        name: r'radarrRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RadarrRepositoryProvider call(String instanceId) =>
      RadarrRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'radarrRepositoryProvider';
}

@ProviderFor(radarrMovies)
final radarrMoviesProvider = RadarrMoviesFamily._();

final class RadarrMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<RadarrMovie>>>,
          Result<List<RadarrMovie>>,
          FutureOr<Result<List<RadarrMovie>>>
        >
    with
        $FutureModifier<Result<List<RadarrMovie>>>,
        $FutureProvider<Result<List<RadarrMovie>>> {
  RadarrMoviesProvider._({
    required RadarrMoviesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'radarrMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrMoviesHash();

  @override
  String toString() {
    return r'radarrMoviesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<RadarrMovie>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<RadarrMovie>>> create(Ref ref) {
    final argument = this.argument as String;
    return radarrMovies(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrMoviesHash() => r'81ff8af66f02f6868410e73b959011dc3dbcb014';

final class RadarrMoviesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<RadarrMovie>>>, String> {
  RadarrMoviesFamily._()
    : super(
        retry: null,
        name: r'radarrMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RadarrMoviesProvider call(String instanceId) =>
      RadarrMoviesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'radarrMoviesProvider';
}

@ProviderFor(radarrMovie)
final radarrMovieProvider = RadarrMovieFamily._();

final class RadarrMovieProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<RadarrMovie>>,
          Result<RadarrMovie>,
          FutureOr<Result<RadarrMovie>>
        >
    with
        $FutureModifier<Result<RadarrMovie>>,
        $FutureProvider<Result<RadarrMovie>> {
  RadarrMovieProvider._({
    required RadarrMovieFamily super.from,
    required ({String instanceId, int movieId}) super.argument,
  }) : super(
         retry: null,
         name: r'radarrMovieProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrMovieHash();

  @override
  String toString() {
    return r'radarrMovieProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<RadarrMovie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<RadarrMovie>> create(Ref ref) {
    final argument = this.argument as ({String instanceId, int movieId});
    return radarrMovie(
      ref,
      instanceId: argument.instanceId,
      movieId: argument.movieId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrMovieProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrMovieHash() => r'c80cff7f117ea04bb4d3eb7d4cc4f2781f40bb78';

final class RadarrMovieFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<RadarrMovie>>,
          ({String instanceId, int movieId})
        > {
  RadarrMovieFamily._()
    : super(
        retry: null,
        name: r'radarrMovieProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RadarrMovieProvider call({
    required String instanceId,
    required int movieId,
  }) => RadarrMovieProvider._(
    argument: (instanceId: instanceId, movieId: movieId),
    from: this,
  );

  @override
  String toString() => r'radarrMovieProvider';
}

/// Resolves a relative Radarr image URL to a full URL using the instance's
/// current base URL and API key (via query param, as Radarr's image proxy
/// requires it).

@ProviderFor(radarrFullImageUrl)
final radarrFullImageUrlProvider = RadarrFullImageUrlFamily._();

/// Resolves a relative Radarr image URL to a full URL using the instance's
/// current base URL and API key (via query param, as Radarr's image proxy
/// requires it).

final class RadarrFullImageUrlProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Resolves a relative Radarr image URL to a full URL using the instance's
  /// current base URL and API key (via query param, as Radarr's image proxy
  /// requires it).
  RadarrFullImageUrlProvider._({
    required RadarrFullImageUrlFamily super.from,
    required ({String instanceId, String relativeUrl}) super.argument,
  }) : super(
         retry: null,
         name: r'radarrFullImageUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrFullImageUrlHash();

  @override
  String toString() {
    return r'radarrFullImageUrlProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as ({String instanceId, String relativeUrl});
    return radarrFullImageUrl(
      ref,
      instanceId: argument.instanceId,
      relativeUrl: argument.relativeUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrFullImageUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrFullImageUrlHash() =>
    r'10d48bc2538526ec2527de6a75b4958811b5a653';

/// Resolves a relative Radarr image URL to a full URL using the instance's
/// current base URL and API key (via query param, as Radarr's image proxy
/// requires it).

final class RadarrFullImageUrlFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String?>,
          ({String instanceId, String relativeUrl})
        > {
  RadarrFullImageUrlFamily._()
    : super(
        retry: null,
        name: r'radarrFullImageUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves a relative Radarr image URL to a full URL using the instance's
  /// current base URL and API key (via query param, as Radarr's image proxy
  /// requires it).

  RadarrFullImageUrlProvider call({
    required String instanceId,
    required String relativeUrl,
  }) => RadarrFullImageUrlProvider._(
    argument: (instanceId: instanceId, relativeUrl: relativeUrl),
    from: this,
  );

  @override
  String toString() => r'radarrFullImageUrlProvider';
}

@ProviderFor(radarrQualityProfiles)
final radarrQualityProfilesProvider = RadarrQualityProfilesFamily._();

final class RadarrQualityProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<RadarrQualityProfile>>>,
          Result<List<RadarrQualityProfile>>,
          FutureOr<Result<List<RadarrQualityProfile>>>
        >
    with
        $FutureModifier<Result<List<RadarrQualityProfile>>>,
        $FutureProvider<Result<List<RadarrQualityProfile>>> {
  RadarrQualityProfilesProvider._({
    required RadarrQualityProfilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'radarrQualityProfilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrQualityProfilesHash();

  @override
  String toString() {
    return r'radarrQualityProfilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<RadarrQualityProfile>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<RadarrQualityProfile>>> create(Ref ref) {
    final argument = this.argument as String;
    return radarrQualityProfiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrQualityProfilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrQualityProfilesHash() =>
    r'009e07c6e518fe01650f34cfdef523b1b18c0754';

final class RadarrQualityProfilesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<RadarrQualityProfile>>>,
          String
        > {
  RadarrQualityProfilesFamily._()
    : super(
        retry: null,
        name: r'radarrQualityProfilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RadarrQualityProfilesProvider call(String instanceId) =>
      RadarrQualityProfilesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'radarrQualityProfilesProvider';
}

@ProviderFor(radarrRootFolders)
final radarrRootFoldersProvider = RadarrRootFoldersFamily._();

final class RadarrRootFoldersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<RadarrRootFolder>>>,
          Result<List<RadarrRootFolder>>,
          FutureOr<Result<List<RadarrRootFolder>>>
        >
    with
        $FutureModifier<Result<List<RadarrRootFolder>>>,
        $FutureProvider<Result<List<RadarrRootFolder>>> {
  RadarrRootFoldersProvider._({
    required RadarrRootFoldersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'radarrRootFoldersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrRootFoldersHash();

  @override
  String toString() {
    return r'radarrRootFoldersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<RadarrRootFolder>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<RadarrRootFolder>>> create(Ref ref) {
    final argument = this.argument as String;
    return radarrRootFolders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrRootFoldersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrRootFoldersHash() => r'9f0f504489f73a507324badb4f1a20cb9411464e';

final class RadarrRootFoldersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<RadarrRootFolder>>>,
          String
        > {
  RadarrRootFoldersFamily._()
    : super(
        retry: null,
        name: r'radarrRootFoldersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RadarrRootFoldersProvider call(String instanceId) =>
      RadarrRootFoldersProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'radarrRootFoldersProvider';
}

@ProviderFor(radarrQueue)
final radarrQueueProvider = RadarrQueueFamily._();

final class RadarrQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<RadarrQueueItem>>>,
          Result<List<RadarrQueueItem>>,
          FutureOr<Result<List<RadarrQueueItem>>>
        >
    with
        $FutureModifier<Result<List<RadarrQueueItem>>>,
        $FutureProvider<Result<List<RadarrQueueItem>>> {
  RadarrQueueProvider._({
    required RadarrQueueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'radarrQueueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrQueueHash();

  @override
  String toString() {
    return r'radarrQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<RadarrQueueItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<RadarrQueueItem>>> create(Ref ref) {
    final argument = this.argument as String;
    return radarrQueue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrQueueHash() => r'626c77990a7f747d27400dd6953368ab2207e1be';

final class RadarrQueueFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<RadarrQueueItem>>>,
          String
        > {
  RadarrQueueFamily._()
    : super(
        retry: null,
        name: r'radarrQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RadarrQueueProvider call(String instanceId) =>
      RadarrQueueProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'radarrQueueProvider';
}

/// Search results for a lookup term.

@ProviderFor(radarrLookup)
final radarrLookupProvider = RadarrLookupFamily._();

/// Search results for a lookup term.

final class RadarrLookupProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<RadarrMovie>>>,
          Result<List<RadarrMovie>>,
          FutureOr<Result<List<RadarrMovie>>>
        >
    with
        $FutureModifier<Result<List<RadarrMovie>>>,
        $FutureProvider<Result<List<RadarrMovie>>> {
  /// Search results for a lookup term.
  RadarrLookupProvider._({
    required RadarrLookupFamily super.from,
    required ({String instanceId, String term}) super.argument,
  }) : super(
         retry: null,
         name: r'radarrLookupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$radarrLookupHash();

  @override
  String toString() {
    return r'radarrLookupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<RadarrMovie>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<RadarrMovie>>> create(Ref ref) {
    final argument = this.argument as ({String instanceId, String term});
    return radarrLookup(
      ref,
      instanceId: argument.instanceId,
      term: argument.term,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RadarrLookupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$radarrLookupHash() => r'dd30cbaf518b32c8afe4145d6748a1890500a976';

/// Search results for a lookup term.

final class RadarrLookupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<RadarrMovie>>>,
          ({String instanceId, String term})
        > {
  RadarrLookupFamily._()
    : super(
        retry: null,
        name: r'radarrLookupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Search results for a lookup term.

  RadarrLookupProvider call({
    required String instanceId,
    required String term,
  }) => RadarrLookupProvider._(
    argument: (instanceId: instanceId, term: term),
    from: this,
  );

  @override
  String toString() => r'radarrLookupProvider';
}

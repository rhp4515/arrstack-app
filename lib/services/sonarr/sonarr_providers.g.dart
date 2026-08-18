// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonarr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sonarrRepository)
final sonarrRepositoryProvider = SonarrRepositoryFamily._();

final class SonarrRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SonarrRepository>,
          SonarrRepository,
          FutureOr<SonarrRepository>
        >
    with $FutureModifier<SonarrRepository>, $FutureProvider<SonarrRepository> {
  SonarrRepositoryProvider._({
    required SonarrRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sonarrRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrRepositoryHash();

  @override
  String toString() {
    return r'sonarrRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SonarrRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SonarrRepository> create(Ref ref) {
    final argument = this.argument as String;
    return sonarrRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrRepositoryHash() => r'e6fa8dca68655a889ad85c3813d4b7c9afa086d8';

final class SonarrRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SonarrRepository>, String> {
  SonarrRepositoryFamily._()
    : super(
        retry: null,
        name: r'sonarrRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrRepositoryProvider call(String instanceId) =>
      SonarrRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'sonarrRepositoryProvider';
}

@ProviderFor(sonarrSeries)
final sonarrSeriesProvider = SonarrSeriesFamily._();

final class SonarrSeriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SonarrSeries>>>,
          Result<List<SonarrSeries>>,
          FutureOr<Result<List<SonarrSeries>>>
        >
    with
        $FutureModifier<Result<List<SonarrSeries>>>,
        $FutureProvider<Result<List<SonarrSeries>>> {
  SonarrSeriesProvider._({
    required SonarrSeriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sonarrSeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrSeriesHash();

  @override
  String toString() {
    return r'sonarrSeriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SonarrSeries>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SonarrSeries>>> create(Ref ref) {
    final argument = this.argument as String;
    return sonarrSeries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrSeriesHash() => r'f6e1e95b55b074f4d1b740743e7bcf13355ce8b8';

final class SonarrSeriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SonarrSeries>>>,
          String
        > {
  SonarrSeriesFamily._()
    : super(
        retry: null,
        name: r'sonarrSeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrSeriesProvider call(String instanceId) =>
      SonarrSeriesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'sonarrSeriesProvider';
}

@ProviderFor(sonarrSingleSeries)
final sonarrSingleSeriesProvider = SonarrSingleSeriesFamily._();

final class SonarrSingleSeriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SonarrSeries>>,
          Result<SonarrSeries>,
          FutureOr<Result<SonarrSeries>>
        >
    with
        $FutureModifier<Result<SonarrSeries>>,
        $FutureProvider<Result<SonarrSeries>> {
  SonarrSingleSeriesProvider._({
    required SonarrSingleSeriesFamily super.from,
    required ({String instanceId, int seriesId}) super.argument,
  }) : super(
         retry: null,
         name: r'sonarrSingleSeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrSingleSeriesHash();

  @override
  String toString() {
    return r'sonarrSingleSeriesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<SonarrSeries>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SonarrSeries>> create(Ref ref) {
    final argument = this.argument as ({String instanceId, int seriesId});
    return sonarrSingleSeries(
      ref,
      instanceId: argument.instanceId,
      seriesId: argument.seriesId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrSingleSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrSingleSeriesHash() =>
    r'7b3d7e103c247c6ad1fabfa5ae8aab04c63a7137';

final class SonarrSingleSeriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SonarrSeries>>,
          ({String instanceId, int seriesId})
        > {
  SonarrSingleSeriesFamily._()
    : super(
        retry: null,
        name: r'sonarrSingleSeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrSingleSeriesProvider call({
    required String instanceId,
    required int seriesId,
  }) => SonarrSingleSeriesProvider._(
    argument: (instanceId: instanceId, seriesId: seriesId),
    from: this,
  );

  @override
  String toString() => r'sonarrSingleSeriesProvider';
}

@ProviderFor(sonarrEpisodes)
final sonarrEpisodesProvider = SonarrEpisodesFamily._();

final class SonarrEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SonarrEpisode>>>,
          Result<List<SonarrEpisode>>,
          FutureOr<Result<List<SonarrEpisode>>>
        >
    with
        $FutureModifier<Result<List<SonarrEpisode>>>,
        $FutureProvider<Result<List<SonarrEpisode>>> {
  SonarrEpisodesProvider._({
    required SonarrEpisodesFamily super.from,
    required ({String instanceId, int seriesId}) super.argument,
  }) : super(
         retry: null,
         name: r'sonarrEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrEpisodesHash();

  @override
  String toString() {
    return r'sonarrEpisodesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SonarrEpisode>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SonarrEpisode>>> create(Ref ref) {
    final argument = this.argument as ({String instanceId, int seriesId});
    return sonarrEpisodes(
      ref,
      instanceId: argument.instanceId,
      seriesId: argument.seriesId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrEpisodesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrEpisodesHash() => r'4c2d451c15164fbd37f7f86ba6fb2b221e69a3ff';

final class SonarrEpisodesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SonarrEpisode>>>,
          ({String instanceId, int seriesId})
        > {
  SonarrEpisodesFamily._()
    : super(
        retry: null,
        name: r'sonarrEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrEpisodesProvider call({
    required String instanceId,
    required int seriesId,
  }) => SonarrEpisodesProvider._(
    argument: (instanceId: instanceId, seriesId: seriesId),
    from: this,
  );

  @override
  String toString() => r'sonarrEpisodesProvider';
}

@ProviderFor(sonarrQualityProfiles)
final sonarrQualityProfilesProvider = SonarrQualityProfilesFamily._();

final class SonarrQualityProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SonarrQualityProfile>>>,
          Result<List<SonarrQualityProfile>>,
          FutureOr<Result<List<SonarrQualityProfile>>>
        >
    with
        $FutureModifier<Result<List<SonarrQualityProfile>>>,
        $FutureProvider<Result<List<SonarrQualityProfile>>> {
  SonarrQualityProfilesProvider._({
    required SonarrQualityProfilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sonarrQualityProfilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrQualityProfilesHash();

  @override
  String toString() {
    return r'sonarrQualityProfilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SonarrQualityProfile>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SonarrQualityProfile>>> create(Ref ref) {
    final argument = this.argument as String;
    return sonarrQualityProfiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrQualityProfilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrQualityProfilesHash() =>
    r'db0bbd696b31b705d5974f50dd18d1e87e2114e8';

final class SonarrQualityProfilesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SonarrQualityProfile>>>,
          String
        > {
  SonarrQualityProfilesFamily._()
    : super(
        retry: null,
        name: r'sonarrQualityProfilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrQualityProfilesProvider call(String instanceId) =>
      SonarrQualityProfilesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'sonarrQualityProfilesProvider';
}

@ProviderFor(sonarrRootFolders)
final sonarrRootFoldersProvider = SonarrRootFoldersFamily._();

final class SonarrRootFoldersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SonarrRootFolder>>>,
          Result<List<SonarrRootFolder>>,
          FutureOr<Result<List<SonarrRootFolder>>>
        >
    with
        $FutureModifier<Result<List<SonarrRootFolder>>>,
        $FutureProvider<Result<List<SonarrRootFolder>>> {
  SonarrRootFoldersProvider._({
    required SonarrRootFoldersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sonarrRootFoldersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrRootFoldersHash();

  @override
  String toString() {
    return r'sonarrRootFoldersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SonarrRootFolder>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SonarrRootFolder>>> create(Ref ref) {
    final argument = this.argument as String;
    return sonarrRootFolders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrRootFoldersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrRootFoldersHash() => r'356a93613359fbded23c55d8e61f3ff60a534b20';

final class SonarrRootFoldersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SonarrRootFolder>>>,
          String
        > {
  SonarrRootFoldersFamily._()
    : super(
        retry: null,
        name: r'sonarrRootFoldersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrRootFoldersProvider call(String instanceId) =>
      SonarrRootFoldersProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'sonarrRootFoldersProvider';
}

@ProviderFor(sonarrQueue)
final sonarrQueueProvider = SonarrQueueFamily._();

final class SonarrQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SonarrQueueItem>>>,
          Result<List<SonarrQueueItem>>,
          FutureOr<Result<List<SonarrQueueItem>>>
        >
    with
        $FutureModifier<Result<List<SonarrQueueItem>>>,
        $FutureProvider<Result<List<SonarrQueueItem>>> {
  SonarrQueueProvider._({
    required SonarrQueueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sonarrQueueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrQueueHash();

  @override
  String toString() {
    return r'sonarrQueueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SonarrQueueItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SonarrQueueItem>>> create(Ref ref) {
    final argument = this.argument as String;
    return sonarrQueue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrQueueHash() => r'172e3818a68681fd560a1646dc6451f4382b1c62';

final class SonarrQueueFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SonarrQueueItem>>>,
          String
        > {
  SonarrQueueFamily._()
    : super(
        retry: null,
        name: r'sonarrQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SonarrQueueProvider call(String instanceId) =>
      SonarrQueueProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'sonarrQueueProvider';
}

/// Search results for a lookup term.

@ProviderFor(sonarrLookup)
final sonarrLookupProvider = SonarrLookupFamily._();

/// Search results for a lookup term.

final class SonarrLookupProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SonarrSeries>>>,
          Result<List<SonarrSeries>>,
          FutureOr<Result<List<SonarrSeries>>>
        >
    with
        $FutureModifier<Result<List<SonarrSeries>>>,
        $FutureProvider<Result<List<SonarrSeries>>> {
  /// Search results for a lookup term.
  SonarrLookupProvider._({
    required SonarrLookupFamily super.from,
    required ({String instanceId, String term}) super.argument,
  }) : super(
         retry: null,
         name: r'sonarrLookupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrLookupHash();

  @override
  String toString() {
    return r'sonarrLookupProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SonarrSeries>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SonarrSeries>>> create(Ref ref) {
    final argument = this.argument as ({String instanceId, String term});
    return sonarrLookup(
      ref,
      instanceId: argument.instanceId,
      term: argument.term,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrLookupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrLookupHash() => r'4f6b2b16f84eb89c485ae10a9490da1e65c79a68';

/// Search results for a lookup term.

final class SonarrLookupFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SonarrSeries>>>,
          ({String instanceId, String term})
        > {
  SonarrLookupFamily._()
    : super(
        retry: null,
        name: r'sonarrLookupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Search results for a lookup term.

  SonarrLookupProvider call({
    required String instanceId,
    required String term,
  }) => SonarrLookupProvider._(
    argument: (instanceId: instanceId, term: term),
    from: this,
  );

  @override
  String toString() => r'sonarrLookupProvider';
}

/// Resolves a relative Sonarr image URL to a full URL.

@ProviderFor(sonarrFullImageUrl)
final sonarrFullImageUrlProvider = SonarrFullImageUrlFamily._();

/// Resolves a relative Sonarr image URL to a full URL.

final class SonarrFullImageUrlProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Resolves a relative Sonarr image URL to a full URL.
  SonarrFullImageUrlProvider._({
    required SonarrFullImageUrlFamily super.from,
    required ({String instanceId, String relativeUrl}) super.argument,
  }) : super(
         retry: null,
         name: r'sonarrFullImageUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sonarrFullImageUrlHash();

  @override
  String toString() {
    return r'sonarrFullImageUrlProvider'
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
    return sonarrFullImageUrl(
      ref,
      instanceId: argument.instanceId,
      relativeUrl: argument.relativeUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SonarrFullImageUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sonarrFullImageUrlHash() =>
    r'ebdb39afca089eeb883da2e9dec95693cad474ed';

/// Resolves a relative Sonarr image URL to a full URL.

final class SonarrFullImageUrlFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String?>,
          ({String instanceId, String relativeUrl})
        > {
  SonarrFullImageUrlFamily._()
    : super(
        retry: null,
        name: r'sonarrFullImageUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Resolves a relative Sonarr image URL to a full URL.

  SonarrFullImageUrlProvider call({
    required String instanceId,
    required String relativeUrl,
  }) => SonarrFullImageUrlProvider._(
    argument: (instanceId: instanceId, relativeUrl: relativeUrl),
    from: this,
  );

  @override
  String toString() => r'sonarrFullImageUrlProvider';
}

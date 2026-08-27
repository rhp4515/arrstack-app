// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seerr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(seerrRepository)
final seerrRepositoryProvider = SeerrRepositoryFamily._();

final class SeerrRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<SeerrRepository>,
          SeerrRepository,
          FutureOr<SeerrRepository>
        >
    with $FutureModifier<SeerrRepository>, $FutureProvider<SeerrRepository> {
  SeerrRepositoryProvider._({
    required SeerrRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrRepositoryHash();

  @override
  String toString() {
    return r'seerrRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SeerrRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SeerrRepository> create(Ref ref) {
    final argument = this.argument as String;
    return seerrRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrRepositoryHash() => r'dcf3d7a5777b2a4c2d05350942d104846483166e';

final class SeerrRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SeerrRepository>, String> {
  SeerrRepositoryFamily._()
    : super(
        retry: null,
        name: r'seerrRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrRepositoryProvider call(String instanceId) =>
      SeerrRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrRepositoryProvider';
}

@ProviderFor(seerrDiscoverMovies)
final seerrDiscoverMoviesProvider = SeerrDiscoverMoviesFamily._();

final class SeerrDiscoverMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrDiscoverMoviesProvider._({
    required SeerrDiscoverMoviesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrDiscoverMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrDiscoverMoviesHash();

  @override
  String toString() {
    return r'seerrDiscoverMoviesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SeerrResult>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SeerrResult>>> create(Ref ref) {
    final argument = this.argument as String;
    return seerrDiscoverMovies(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrDiscoverMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrDiscoverMoviesHash() =>
    r'4ee78788a6320d312acc7b4523633fc2bd36e1f4';

final class SeerrDiscoverMoviesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<SeerrResult>>>, String> {
  SeerrDiscoverMoviesFamily._()
    : super(
        retry: null,
        name: r'seerrDiscoverMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrDiscoverMoviesProvider call(String instanceId) =>
      SeerrDiscoverMoviesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrDiscoverMoviesProvider';
}

@ProviderFor(seerrDiscoverTv)
final seerrDiscoverTvProvider = SeerrDiscoverTvFamily._();

final class SeerrDiscoverTvProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrDiscoverTvProvider._({
    required SeerrDiscoverTvFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrDiscoverTvProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrDiscoverTvHash();

  @override
  String toString() {
    return r'seerrDiscoverTvProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SeerrResult>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SeerrResult>>> create(Ref ref) {
    final argument = this.argument as String;
    return seerrDiscoverTv(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrDiscoverTvProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrDiscoverTvHash() => r'cb0940de17491420bf0c9edd22bf5b35df57a895';

final class SeerrDiscoverTvFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<SeerrResult>>>, String> {
  SeerrDiscoverTvFamily._()
    : super(
        retry: null,
        name: r'seerrDiscoverTvProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrDiscoverTvProvider call(String instanceId) =>
      SeerrDiscoverTvProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrDiscoverTvProvider';
}

@ProviderFor(seerrSearch)
final seerrSearchProvider = SeerrSearchFamily._();

final class SeerrSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrSearchProvider._({
    required SeerrSearchFamily super.from,
    required ({String instanceId, String query}) super.argument,
  }) : super(
         retry: null,
         name: r'seerrSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrSearchHash();

  @override
  String toString() {
    return r'seerrSearchProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SeerrResult>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SeerrResult>>> create(Ref ref) {
    final argument = this.argument as ({String instanceId, String query});
    return seerrSearch(
      ref,
      instanceId: argument.instanceId,
      query: argument.query,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrSearchHash() => r'88b55a7ef127173929f2ac4a38b09c5d4500115c';

final class SeerrSearchFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SeerrResult>>>,
          ({String instanceId, String query})
        > {
  SeerrSearchFamily._()
    : super(
        retry: null,
        name: r'seerrSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrSearchProvider call({
    required String instanceId,
    required String query,
  }) => SeerrSearchProvider._(
    argument: (instanceId: instanceId, query: query),
    from: this,
  );

  @override
  String toString() => r'seerrSearchProvider';
}

@ProviderFor(seerrDetail)
final seerrDetailProvider = SeerrDetailFamily._();

final class SeerrDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SeerrResult>>,
          Result<SeerrResult>,
          FutureOr<Result<SeerrResult>>
        >
    with
        $FutureModifier<Result<SeerrResult>>,
        $FutureProvider<Result<SeerrResult>> {
  SeerrDetailProvider._({
    required SeerrDetailFamily super.from,
    required ({String instanceId, int id, String mediaType}) super.argument,
  }) : super(
         retry: null,
         name: r'seerrDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrDetailHash();

  @override
  String toString() {
    return r'seerrDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<SeerrResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SeerrResult>> create(Ref ref) {
    final argument =
        this.argument as ({String instanceId, int id, String mediaType});
    return seerrDetail(
      ref,
      instanceId: argument.instanceId,
      id: argument.id,
      mediaType: argument.mediaType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrDetailHash() => r'ed23c9abbb70df0c78c4e265819194352c7a5b3a';

final class SeerrDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SeerrResult>>,
          ({String instanceId, int id, String mediaType})
        > {
  SeerrDetailFamily._()
    : super(
        retry: null,
        name: r'seerrDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrDetailProvider call({
    required String instanceId,
    required int id,
    required String mediaType,
  }) => SeerrDetailProvider._(
    argument: (instanceId: instanceId, id: id, mediaType: mediaType),
    from: this,
  );

  @override
  String toString() => r'seerrDetailProvider';
}

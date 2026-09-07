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

@ProviderFor(seerrTrending)
final seerrTrendingProvider = SeerrTrendingFamily._();

final class SeerrTrendingProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrTrendingProvider._({
    required SeerrTrendingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrTrendingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrTrendingHash();

  @override
  String toString() {
    return r'seerrTrendingProvider'
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
    return seerrTrending(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrTrendingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrTrendingHash() => r'8ae80163ed75f2c02aaec6cc20c71f15b0a5fe15';

final class SeerrTrendingFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<SeerrResult>>>, String> {
  SeerrTrendingFamily._()
    : super(
        retry: null,
        name: r'seerrTrendingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrTrendingProvider call(String instanceId) =>
      SeerrTrendingProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrTrendingProvider';
}

@ProviderFor(seerrUpcomingMovies)
final seerrUpcomingMoviesProvider = SeerrUpcomingMoviesFamily._();

final class SeerrUpcomingMoviesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrUpcomingMoviesProvider._({
    required SeerrUpcomingMoviesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrUpcomingMoviesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrUpcomingMoviesHash();

  @override
  String toString() {
    return r'seerrUpcomingMoviesProvider'
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
    return seerrUpcomingMovies(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrUpcomingMoviesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrUpcomingMoviesHash() =>
    r'6d76358a1e7b9c04780099e6b0f4beedcc6c1a0a';

final class SeerrUpcomingMoviesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<SeerrResult>>>, String> {
  SeerrUpcomingMoviesFamily._()
    : super(
        retry: null,
        name: r'seerrUpcomingMoviesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrUpcomingMoviesProvider call(String instanceId) =>
      SeerrUpcomingMoviesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrUpcomingMoviesProvider';
}

@ProviderFor(seerrUpcomingTv)
final seerrUpcomingTvProvider = SeerrUpcomingTvFamily._();

final class SeerrUpcomingTvProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrUpcomingTvProvider._({
    required SeerrUpcomingTvFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrUpcomingTvProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrUpcomingTvHash();

  @override
  String toString() {
    return r'seerrUpcomingTvProvider'
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
    return seerrUpcomingTv(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrUpcomingTvProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrUpcomingTvHash() => r'9525b1651b90f79ca16d6f0e840e83c4b6b5fa8f';

final class SeerrUpcomingTvFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<SeerrResult>>>, String> {
  SeerrUpcomingTvFamily._()
    : super(
        retry: null,
        name: r'seerrUpcomingTvProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrUpcomingTvProvider call(String instanceId) =>
      SeerrUpcomingTvProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrUpcomingTvProvider';
}

@ProviderFor(seerrMoviesByGenre)
final seerrMoviesByGenreProvider = SeerrMoviesByGenreFamily._();

final class SeerrMoviesByGenreProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrMoviesByGenreProvider._({
    required SeerrMoviesByGenreFamily super.from,
    required ({String instanceId, int genreId}) super.argument,
  }) : super(
         retry: null,
         name: r'seerrMoviesByGenreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrMoviesByGenreHash();

  @override
  String toString() {
    return r'seerrMoviesByGenreProvider'
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
    final argument = this.argument as ({String instanceId, int genreId});
    return seerrMoviesByGenre(
      ref,
      instanceId: argument.instanceId,
      genreId: argument.genreId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrMoviesByGenreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrMoviesByGenreHash() =>
    r'90ca80ee9191976e8d75fb36b0a8cc242e7b0360';

final class SeerrMoviesByGenreFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SeerrResult>>>,
          ({String instanceId, int genreId})
        > {
  SeerrMoviesByGenreFamily._()
    : super(
        retry: null,
        name: r'seerrMoviesByGenreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrMoviesByGenreProvider call({
    required String instanceId,
    required int genreId,
  }) => SeerrMoviesByGenreProvider._(
    argument: (instanceId: instanceId, genreId: genreId),
    from: this,
  );

  @override
  String toString() => r'seerrMoviesByGenreProvider';
}

@ProviderFor(seerrTvByGenre)
final seerrTvByGenreProvider = SeerrTvByGenreFamily._();

final class SeerrTvByGenreProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrResult>>>,
          Result<List<SeerrResult>>,
          FutureOr<Result<List<SeerrResult>>>
        >
    with
        $FutureModifier<Result<List<SeerrResult>>>,
        $FutureProvider<Result<List<SeerrResult>>> {
  SeerrTvByGenreProvider._({
    required SeerrTvByGenreFamily super.from,
    required ({String instanceId, int genreId}) super.argument,
  }) : super(
         retry: null,
         name: r'seerrTvByGenreProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrTvByGenreHash();

  @override
  String toString() {
    return r'seerrTvByGenreProvider'
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
    final argument = this.argument as ({String instanceId, int genreId});
    return seerrTvByGenre(
      ref,
      instanceId: argument.instanceId,
      genreId: argument.genreId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrTvByGenreProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrTvByGenreHash() => r'58d4f93580d8f83790d17b864738ac5f40785b8a';

final class SeerrTvByGenreFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<SeerrResult>>>,
          ({String instanceId, int genreId})
        > {
  SeerrTvByGenreFamily._()
    : super(
        retry: null,
        name: r'seerrTvByGenreProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrTvByGenreProvider call({
    required String instanceId,
    required int genreId,
  }) => SeerrTvByGenreProvider._(
    argument: (instanceId: instanceId, genreId: genreId),
    from: this,
  );

  @override
  String toString() => r'seerrTvByGenreProvider';
}

@ProviderFor(seerrMovieGenres)
final seerrMovieGenresProvider = SeerrMovieGenresFamily._();

final class SeerrMovieGenresProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrGenre>>>,
          Result<List<SeerrGenre>>,
          FutureOr<Result<List<SeerrGenre>>>
        >
    with
        $FutureModifier<Result<List<SeerrGenre>>>,
        $FutureProvider<Result<List<SeerrGenre>>> {
  SeerrMovieGenresProvider._({
    required SeerrMovieGenresFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrMovieGenresProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrMovieGenresHash();

  @override
  String toString() {
    return r'seerrMovieGenresProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SeerrGenre>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SeerrGenre>>> create(Ref ref) {
    final argument = this.argument as String;
    return seerrMovieGenres(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrMovieGenresProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrMovieGenresHash() => r'1e5d42b954657ae9d9eba5c0b0cf518bc9d1d1b7';

final class SeerrMovieGenresFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<List<SeerrGenre>>>, String> {
  SeerrMovieGenresFamily._()
    : super(
        retry: null,
        name: r'seerrMovieGenresProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrMovieGenresProvider call(String instanceId) =>
      SeerrMovieGenresProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrMovieGenresProvider';
}

@ProviderFor(seerrTvGenres)
final seerrTvGenresProvider = SeerrTvGenresFamily._();

final class SeerrTvGenresProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<SeerrGenre>>>,
          Result<List<SeerrGenre>>,
          FutureOr<Result<List<SeerrGenre>>>
        >
    with
        $FutureModifier<Result<List<SeerrGenre>>>,
        $FutureProvider<Result<List<SeerrGenre>>> {
  SeerrTvGenresProvider._({
    required SeerrTvGenresFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seerrTvGenresProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrTvGenresHash();

  @override
  String toString() {
    return r'seerrTvGenresProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<SeerrGenre>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<SeerrGenre>>> create(Ref ref) {
    final argument = this.argument as String;
    return seerrTvGenres(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrTvGenresProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrTvGenresHash() => r'483ed8e7f3def3ea4ac35852bbd6275084456fd1';

final class SeerrTvGenresFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<List<SeerrGenre>>>, String> {
  SeerrTvGenresFamily._()
    : super(
        retry: null,
        name: r'seerrTvGenresProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeerrTvGenresProvider call(String instanceId) =>
      SeerrTvGenresProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'seerrTvGenresProvider';
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

/// `filter`: pending | approved | declined | all. `sort`: added | modified.

@ProviderFor(seerrRequests)
final seerrRequestsProvider = SeerrRequestsFamily._();

/// `filter`: pending | approved | declined | all. `sort`: added | modified.

final class SeerrRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<SeerrRequestsResponse>>,
          Result<SeerrRequestsResponse>,
          FutureOr<Result<SeerrRequestsResponse>>
        >
    with
        $FutureModifier<Result<SeerrRequestsResponse>>,
        $FutureProvider<Result<SeerrRequestsResponse>> {
  /// `filter`: pending | approved | declined | all. `sort`: added | modified.
  SeerrRequestsProvider._({
    required SeerrRequestsFamily super.from,
    required ({String instanceId, String filter, String sort}) super.argument,
  }) : super(
         retry: null,
         name: r'seerrRequestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seerrRequestsHash();

  @override
  String toString() {
    return r'seerrRequestsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<SeerrRequestsResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<SeerrRequestsResponse>> create(Ref ref) {
    final argument =
        this.argument as ({String instanceId, String filter, String sort});
    return seerrRequests(
      ref,
      instanceId: argument.instanceId,
      filter: argument.filter,
      sort: argument.sort,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeerrRequestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seerrRequestsHash() => r'd036608b104d94395a5eb1caa942b03d79113d07';

/// `filter`: pending | approved | declined | all. `sort`: added | modified.

final class SeerrRequestsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<SeerrRequestsResponse>>,
          ({String instanceId, String filter, String sort})
        > {
  SeerrRequestsFamily._()
    : super(
        retry: null,
        name: r'seerrRequestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// `filter`: pending | approved | declined | all. `sort`: added | modified.

  SeerrRequestsProvider call({
    required String instanceId,
    required String filter,
    required String sort,
  }) => SeerrRequestsProvider._(
    argument: (instanceId: instanceId, filter: filter, sort: sort),
    from: this,
  );

  @override
  String toString() => r'seerrRequestsProvider';
}

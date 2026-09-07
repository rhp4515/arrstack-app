// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prowlarrClient)
final prowlarrClientProvider = ProwlarrClientFamily._();

final class ProwlarrClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProwlarrClient>,
          ProwlarrClient,
          FutureOr<ProwlarrClient>
        >
    with $FutureModifier<ProwlarrClient>, $FutureProvider<ProwlarrClient> {
  ProwlarrClientProvider._({
    required ProwlarrClientFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'prowlarrClientProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prowlarrClientHash();

  @override
  String toString() {
    return r'prowlarrClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProwlarrClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProwlarrClient> create(Ref ref) {
    final argument = this.argument as String;
    return prowlarrClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProwlarrClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prowlarrClientHash() => r'5abd9d06b4736c5e1b774306c3ee14c1fea841ec';

final class ProwlarrClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProwlarrClient>, String> {
  ProwlarrClientFamily._()
    : super(
        retry: null,
        name: r'prowlarrClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProwlarrClientProvider call(String instanceId) =>
      ProwlarrClientProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'prowlarrClientProvider';
}

@ProviderFor(prowlarrRepository)
final prowlarrRepositoryProvider = ProwlarrRepositoryFamily._();

final class ProwlarrRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProwlarrRepository>,
          ProwlarrRepository,
          FutureOr<ProwlarrRepository>
        >
    with
        $FutureModifier<ProwlarrRepository>,
        $FutureProvider<ProwlarrRepository> {
  ProwlarrRepositoryProvider._({
    required ProwlarrRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'prowlarrRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prowlarrRepositoryHash();

  @override
  String toString() {
    return r'prowlarrRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProwlarrRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProwlarrRepository> create(Ref ref) {
    final argument = this.argument as String;
    return prowlarrRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProwlarrRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prowlarrRepositoryHash() =>
    r'f7ef93ff3f85e2dc21f3bebe27c5981977879505';

final class ProwlarrRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProwlarrRepository>, String> {
  ProwlarrRepositoryFamily._()
    : super(
        retry: null,
        name: r'prowlarrRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProwlarrRepositoryProvider call(String instanceId) =>
      ProwlarrRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'prowlarrRepositoryProvider';
}

@ProviderFor(prowlarrIndexers)
final prowlarrIndexersProvider = ProwlarrIndexersFamily._();

final class ProwlarrIndexersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<Indexer>>>,
          Result<List<Indexer>>,
          FutureOr<Result<List<Indexer>>>
        >
    with
        $FutureModifier<Result<List<Indexer>>>,
        $FutureProvider<Result<List<Indexer>>> {
  ProwlarrIndexersProvider._({
    required ProwlarrIndexersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'prowlarrIndexersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prowlarrIndexersHash();

  @override
  String toString() {
    return r'prowlarrIndexersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<Indexer>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<Indexer>>> create(Ref ref) {
    final argument = this.argument as String;
    return prowlarrIndexers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProwlarrIndexersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prowlarrIndexersHash() => r'0f9239d6c3f5b5022bc3aed75a40b1a0071c68cc';

final class ProwlarrIndexersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<List<Indexer>>>, String> {
  ProwlarrIndexersFamily._()
    : super(
        retry: null,
        name: r'prowlarrIndexersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProwlarrIndexersProvider call(String instanceId) =>
      ProwlarrIndexersProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'prowlarrIndexersProvider';
}

@ProviderFor(prowlarrIndexerStats)
final prowlarrIndexerStatsProvider = ProwlarrIndexerStatsFamily._();

final class ProwlarrIndexerStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<IndexerStatsResponse>>,
          Result<IndexerStatsResponse>,
          FutureOr<Result<IndexerStatsResponse>>
        >
    with
        $FutureModifier<Result<IndexerStatsResponse>>,
        $FutureProvider<Result<IndexerStatsResponse>> {
  ProwlarrIndexerStatsProvider._({
    required ProwlarrIndexerStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'prowlarrIndexerStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prowlarrIndexerStatsHash();

  @override
  String toString() {
    return r'prowlarrIndexerStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<IndexerStatsResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<IndexerStatsResponse>> create(Ref ref) {
    final argument = this.argument as String;
    return prowlarrIndexerStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProwlarrIndexerStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prowlarrIndexerStatsHash() =>
    r'a24f402a3b22ab3d793ec2bc065ddaf3885c9d24';

final class ProwlarrIndexerStatsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<IndexerStatsResponse>>,
          String
        > {
  ProwlarrIndexerStatsFamily._()
    : super(
        retry: null,
        name: r'prowlarrIndexerStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProwlarrIndexerStatsProvider call(String instanceId) =>
      ProwlarrIndexerStatsProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'prowlarrIndexerStatsProvider';
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qbit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(qbitClient)
final qbitClientProvider = QbitClientFamily._();

final class QbitClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<QbitClient>,
          QbitClient,
          FutureOr<QbitClient>
        >
    with $FutureModifier<QbitClient>, $FutureProvider<QbitClient> {
  QbitClientProvider._({
    required QbitClientFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'qbitClientProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$qbitClientHash();

  @override
  String toString() {
    return r'qbitClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<QbitClient> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<QbitClient> create(Ref ref) {
    final argument = this.argument as String;
    return qbitClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QbitClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$qbitClientHash() => r'518c5c3d7255b10cb9aaa05b64bacccdd4c077d0';

final class QbitClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<QbitClient>, String> {
  QbitClientFamily._()
    : super(
        retry: null,
        name: r'qbitClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  QbitClientProvider call(String instanceId) =>
      QbitClientProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'qbitClientProvider';
}

@ProviderFor(qbitRepository)
final qbitRepositoryProvider = QbitRepositoryFamily._();

final class QbitRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<QbitRepository>,
          QbitRepository,
          FutureOr<QbitRepository>
        >
    with $FutureModifier<QbitRepository>, $FutureProvider<QbitRepository> {
  QbitRepositoryProvider._({
    required QbitRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'qbitRepositoryProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$qbitRepositoryHash();

  @override
  String toString() {
    return r'qbitRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<QbitRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<QbitRepository> create(Ref ref) {
    final argument = this.argument as String;
    return qbitRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QbitRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$qbitRepositoryHash() => r'1ab6512774b51259dbd7bfa4b48af8f5d6a15748';

final class QbitRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<QbitRepository>, String> {
  QbitRepositoryFamily._()
    : super(
        retry: null,
        name: r'qbitRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  QbitRepositoryProvider call(String instanceId) =>
      QbitRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'qbitRepositoryProvider';
}

@ProviderFor(qbitTorrents)
final qbitTorrentsProvider = QbitTorrentsFamily._();

final class QbitTorrentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<QbitTorrent>>>,
          Result<List<QbitTorrent>>,
          FutureOr<Result<List<QbitTorrent>>>
        >
    with
        $FutureModifier<Result<List<QbitTorrent>>>,
        $FutureProvider<Result<List<QbitTorrent>>> {
  QbitTorrentsProvider._({
    required QbitTorrentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'qbitTorrentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$qbitTorrentsHash();

  @override
  String toString() {
    return r'qbitTorrentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<QbitTorrent>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<QbitTorrent>>> create(Ref ref) {
    final argument = this.argument as String;
    return qbitTorrents(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QbitTorrentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$qbitTorrentsHash() => r'5acea877940ebb125a6f290cadc36f4f923d5d39';

final class QbitTorrentsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Result<List<QbitTorrent>>>, String> {
  QbitTorrentsFamily._()
    : super(
        retry: null,
        name: r'qbitTorrentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QbitTorrentsProvider call(String instanceId) =>
      QbitTorrentsProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'qbitTorrentsProvider';
}

@ProviderFor(qbitMainData)
final qbitMainDataProvider = QbitMainDataFamily._();

final class QbitMainDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<QbitMainData>>,
          Result<QbitMainData>,
          FutureOr<Result<QbitMainData>>
        >
    with
        $FutureModifier<Result<QbitMainData>>,
        $FutureProvider<Result<QbitMainData>> {
  QbitMainDataProvider._({
    required QbitMainDataFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'qbitMainDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$qbitMainDataHash();

  @override
  String toString() {
    return r'qbitMainDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<QbitMainData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<QbitMainData>> create(Ref ref) {
    final argument = this.argument as String;
    return qbitMainData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QbitMainDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$qbitMainDataHash() => r'94252ccaceaca5bfbb837cdc053ce71589b810d9';

final class QbitMainDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Result<QbitMainData>>, String> {
  QbitMainDataFamily._()
    : super(
        retry: null,
        name: r'qbitMainDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QbitMainDataProvider call(String instanceId) =>
      QbitMainDataProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'qbitMainDataProvider';
}

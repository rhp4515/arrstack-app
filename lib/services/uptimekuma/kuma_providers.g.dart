// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kuma_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(kumaClient)
final kumaClientProvider = KumaClientFamily._();

final class KumaClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<KumaClient>,
          KumaClient,
          FutureOr<KumaClient>
        >
    with $FutureModifier<KumaClient>, $FutureProvider<KumaClient> {
  KumaClientProvider._({
    required KumaClientFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'kumaClientProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kumaClientHash();

  @override
  String toString() {
    return r'kumaClientProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<KumaClient> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<KumaClient> create(Ref ref) {
    final argument = this.argument as String;
    return kumaClient(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KumaClientProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kumaClientHash() => r'cfe724713a3bdf6645d88a0dec61e8dbdaf12ba8';

final class KumaClientFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<KumaClient>, String> {
  KumaClientFamily._()
    : super(
        retry: null,
        name: r'kumaClientProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  KumaClientProvider call(String instanceId) =>
      KumaClientProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'kumaClientProvider';
}

@ProviderFor(kumaRepository)
final kumaRepositoryProvider = KumaRepositoryFamily._();

final class KumaRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<KumaRepository>,
          KumaRepository,
          FutureOr<KumaRepository>
        >
    with $FutureModifier<KumaRepository>, $FutureProvider<KumaRepository> {
  KumaRepositoryProvider._({
    required KumaRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'kumaRepositoryProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kumaRepositoryHash();

  @override
  String toString() {
    return r'kumaRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<KumaRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<KumaRepository> create(Ref ref) {
    final argument = this.argument as String;
    return kumaRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KumaRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kumaRepositoryHash() => r'afba8b636fee19a7851785c5da90ab6e72d0ffd4';

final class KumaRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<KumaRepository>, String> {
  KumaRepositoryFamily._()
    : super(
        retry: null,
        name: r'kumaRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  KumaRepositoryProvider call(String instanceId) =>
      KumaRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'kumaRepositoryProvider';
}

/// The live state of all monitors for a Kuma instance.

@ProviderFor(KumaMonitors)
final kumaMonitorsProvider = KumaMonitorsFamily._();

/// The live state of all monitors for a Kuma instance.
final class KumaMonitorsProvider
    extends $StreamNotifierProvider<KumaMonitors, Result<List<KumaMonitor>>> {
  /// The live state of all monitors for a Kuma instance.
  KumaMonitorsProvider._({
    required KumaMonitorsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'kumaMonitorsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$kumaMonitorsHash();

  @override
  String toString() {
    return r'kumaMonitorsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  KumaMonitors create() => KumaMonitors();

  @override
  bool operator ==(Object other) {
    return other is KumaMonitorsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$kumaMonitorsHash() => r'b0f77cef871ecb13e5910fbcb33ed6c5da567c22';

/// The live state of all monitors for a Kuma instance.

final class KumaMonitorsFamily extends $Family
    with
        $ClassFamilyOverride<
          KumaMonitors,
          AsyncValue<Result<List<KumaMonitor>>>,
          Result<List<KumaMonitor>>,
          Stream<Result<List<KumaMonitor>>>,
          String
        > {
  KumaMonitorsFamily._()
    : super(
        retry: null,
        name: r'kumaMonitorsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The live state of all monitors for a Kuma instance.

  KumaMonitorsProvider call(String instanceId) =>
      KumaMonitorsProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'kumaMonitorsProvider';
}

/// The live state of all monitors for a Kuma instance.

abstract class _$KumaMonitors
    extends $StreamNotifier<Result<List<KumaMonitor>>> {
  late final _$args = ref.$arg as String;
  String get instanceId => _$args;

  Stream<Result<List<KumaMonitor>>> build(String instanceId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<List<KumaMonitor>>>,
              Result<List<KumaMonitor>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<List<KumaMonitor>>>,
                Result<List<KumaMonitor>>
              >,
              AsyncValue<Result<List<KumaMonitor>>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

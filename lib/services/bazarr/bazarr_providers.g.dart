// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazarr_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bazarrRepository)
final bazarrRepositoryProvider = BazarrRepositoryFamily._();

final class BazarrRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<BazarrRepository>,
          BazarrRepository,
          FutureOr<BazarrRepository>
        >
    with $FutureModifier<BazarrRepository>, $FutureProvider<BazarrRepository> {
  BazarrRepositoryProvider._({
    required BazarrRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bazarrRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bazarrRepositoryHash();

  @override
  String toString() {
    return r'bazarrRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<BazarrRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BazarrRepository> create(Ref ref) {
    final argument = this.argument as String;
    return bazarrRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BazarrRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bazarrRepositoryHash() => r'93f090fe9a82cfffa2505dcdf853495bb1d91434';

final class BazarrRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BazarrRepository>, String> {
  BazarrRepositoryFamily._()
    : super(
        retry: null,
        name: r'bazarrRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BazarrRepositoryProvider call(String instanceId) =>
      BazarrRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'bazarrRepositoryProvider';
}

@ProviderFor(bazarrWanted)
final bazarrWantedProvider = BazarrWantedFamily._();

final class BazarrWantedProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<BazarrWantedSubtitle>>>,
          Result<List<BazarrWantedSubtitle>>,
          FutureOr<Result<List<BazarrWantedSubtitle>>>
        >
    with
        $FutureModifier<Result<List<BazarrWantedSubtitle>>>,
        $FutureProvider<Result<List<BazarrWantedSubtitle>>> {
  BazarrWantedProvider._({
    required BazarrWantedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bazarrWantedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bazarrWantedHash();

  @override
  String toString() {
    return r'bazarrWantedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<BazarrWantedSubtitle>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<BazarrWantedSubtitle>>> create(Ref ref) {
    final argument = this.argument as String;
    return bazarrWanted(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BazarrWantedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bazarrWantedHash() => r'51a419bf844d416111b8cc4f6952d67e01c9e382';

final class BazarrWantedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<BazarrWantedSubtitle>>>,
          String
        > {
  BazarrWantedFamily._()
    : super(
        retry: null,
        name: r'bazarrWantedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BazarrWantedProvider call(String instanceId) =>
      BazarrWantedProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'bazarrWantedProvider';
}

@ProviderFor(bazarrStatus)
final bazarrStatusProvider = BazarrStatusFamily._();

final class BazarrStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<BazarrSystemStatus>>,
          Result<BazarrSystemStatus>,
          FutureOr<Result<BazarrSystemStatus>>
        >
    with
        $FutureModifier<Result<BazarrSystemStatus>>,
        $FutureProvider<Result<BazarrSystemStatus>> {
  BazarrStatusProvider._({
    required BazarrStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bazarrStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bazarrStatusHash();

  @override
  String toString() {
    return r'bazarrStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Result<BazarrSystemStatus>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<BazarrSystemStatus>> create(Ref ref) {
    final argument = this.argument as String;
    return bazarrStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BazarrStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bazarrStatusHash() => r'26cec54403d6e2bc0cc1f32bd6d051c1bdc68fe3';

final class BazarrStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<BazarrSystemStatus>>,
          String
        > {
  BazarrStatusFamily._()
    : super(
        retry: null,
        name: r'bazarrStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BazarrStatusProvider call(String instanceId) =>
      BazarrStatusProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'bazarrStatusProvider';
}

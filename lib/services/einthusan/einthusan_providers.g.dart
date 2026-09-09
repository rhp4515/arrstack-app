// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'einthusan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(einthusanRepository)
final einthusanRepositoryProvider = EinthusanRepositoryFamily._();

final class EinthusanRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<EinthusanRepository>,
          EinthusanRepository,
          FutureOr<EinthusanRepository>
        >
    with
        $FutureModifier<EinthusanRepository>,
        $FutureProvider<EinthusanRepository> {
  EinthusanRepositoryProvider._({
    required EinthusanRepositoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'einthusanRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$einthusanRepositoryHash();

  @override
  String toString() {
    return r'einthusanRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EinthusanRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EinthusanRepository> create(Ref ref) {
    final argument = this.argument as String;
    return einthusanRepository(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EinthusanRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$einthusanRepositoryHash() =>
    r'049bf99110920d9532bb83846eb50a54c9ae5c2a';

final class EinthusanRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EinthusanRepository>, String> {
  EinthusanRepositoryFamily._()
    : super(
        retry: null,
        name: r'einthusanRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EinthusanRepositoryProvider call(String instanceId) =>
      EinthusanRepositoryProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'einthusanRepositoryProvider';
}

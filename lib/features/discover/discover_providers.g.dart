// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedSeerrInstanceId)
final selectedSeerrInstanceIdProvider = SelectedSeerrInstanceIdProvider._();

final class SelectedSeerrInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedSeerrInstanceId, String?> {
  SelectedSeerrInstanceIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSeerrInstanceIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSeerrInstanceIdHash();

  @$internal
  @override
  SelectedSeerrInstanceId create() => SelectedSeerrInstanceId();
}

String _$selectedSeerrInstanceIdHash() =>
    r'e0aaf114a3aaa9e4143c8a560d058e3f937fd818';

abstract class _$SelectedSeerrInstanceId extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(hasSeerrInstance)
final hasSeerrInstanceProvider = HasSeerrInstanceProvider._();

final class HasSeerrInstanceProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  HasSeerrInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasSeerrInstanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasSeerrInstanceHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return hasSeerrInstance(ref);
  }
}

String _$hasSeerrInstanceHash() => r'e56716bd1ccbfd8f9130c05499d5d23956fa792a';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_clearing.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(artworkCacheClearer)
final artworkCacheClearerProvider = ArtworkCacheClearerProvider._();

final class ArtworkCacheClearerProvider
    extends
        $FunctionalProvider<
          ArtworkCacheClearer,
          ArtworkCacheClearer,
          ArtworkCacheClearer
        >
    with $Provider<ArtworkCacheClearer> {
  ArtworkCacheClearerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'artworkCacheClearerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$artworkCacheClearerHash();

  @$internal
  @override
  $ProviderElement<ArtworkCacheClearer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ArtworkCacheClearer create(Ref ref) {
    return artworkCacheClearer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ArtworkCacheClearer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ArtworkCacheClearer>(value),
    );
  }
}

String _$artworkCacheClearerHash() =>
    r'3d5338daa67266b23dcc67b1a17a3939bac59276';

@ProviderFor(CacheClearing)
final cacheClearingProvider = CacheClearingProvider._();

final class CacheClearingProvider
    extends $NotifierProvider<CacheClearing, bool> {
  CacheClearingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheClearingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheClearingHash();

  @$internal
  @override
  CacheClearing create() => CacheClearing();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$cacheClearingHash() => r'dbbae521c534c6cda91f12455afd2bbd7aa3858b';

abstract class _$CacheClearing extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

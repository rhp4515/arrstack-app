// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_instance_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryInstanceStore)
final libraryInstanceStoreProvider = LibraryInstanceStoreProvider._();

final class LibraryInstanceStoreProvider
    extends
        $FunctionalProvider<
          LibraryInstanceStore,
          LibraryInstanceStore,
          LibraryInstanceStore
        >
    with $Provider<LibraryInstanceStore> {
  LibraryInstanceStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryInstanceStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryInstanceStoreHash();

  @$internal
  @override
  $ProviderElement<LibraryInstanceStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LibraryInstanceStore create(Ref ref) {
    return libraryInstanceStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryInstanceStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryInstanceStore>(value),
    );
  }
}

String _$libraryInstanceStoreHash() =>
    r'f175aacb0c1479a1013846258d83e7bec7e56261';

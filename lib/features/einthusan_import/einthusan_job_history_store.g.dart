// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'einthusan_job_history_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(einthusanJobHistoryStore)
final einthusanJobHistoryStoreProvider = EinthusanJobHistoryStoreProvider._();

final class EinthusanJobHistoryStoreProvider
    extends
        $FunctionalProvider<
          EinthusanJobHistoryStore,
          EinthusanJobHistoryStore,
          EinthusanJobHistoryStore
        >
    with $Provider<EinthusanJobHistoryStore> {
  EinthusanJobHistoryStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'einthusanJobHistoryStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$einthusanJobHistoryStoreHash();

  @$internal
  @override
  $ProviderElement<EinthusanJobHistoryStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EinthusanJobHistoryStore create(Ref ref) {
    return einthusanJobHistoryStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EinthusanJobHistoryStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EinthusanJobHistoryStore>(value),
    );
  }
}

String _$einthusanJobHistoryStoreHash() =>
    r'0a7d4d649d9328540b8f0ba887b09083b54286ee';

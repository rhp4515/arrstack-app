// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedDownloadInstanceId)
final selectedDownloadInstanceIdProvider =
    SelectedDownloadInstanceIdProvider._();

final class SelectedDownloadInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedDownloadInstanceId, String?> {
  SelectedDownloadInstanceIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDownloadInstanceIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDownloadInstanceIdHash();

  @$internal
  @override
  SelectedDownloadInstanceId create() => SelectedDownloadInstanceId();
}

String _$selectedDownloadInstanceIdHash() =>
    r'c9dba7a6670897aa409b57d3a94021edc2c99e00';

abstract class _$SelectedDownloadInstanceId extends $AsyncNotifier<String?> {
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

@ProviderFor(DownloadFilter)
final downloadFilterProvider = DownloadFilterProvider._();

final class DownloadFilterProvider
    extends $NotifierProvider<DownloadFilter, TorrentFilter> {
  DownloadFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadFilterHash();

  @$internal
  @override
  DownloadFilter create() => DownloadFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TorrentFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TorrentFilter>(value),
    );
  }
}

String _$downloadFilterHash() => r'740ebc7d86a6b96e8967cbe7cf8e3c379ab40de0';

abstract class _$DownloadFilter extends $Notifier<TorrentFilter> {
  TorrentFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TorrentFilter, TorrentFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TorrentFilter, TorrentFilter>,
              TorrentFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

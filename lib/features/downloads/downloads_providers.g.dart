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

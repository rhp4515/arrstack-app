// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtitles_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedSubtitleInstanceId)
final selectedSubtitleInstanceIdProvider =
    SelectedSubtitleInstanceIdProvider._();

final class SelectedSubtitleInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedSubtitleInstanceId, String?> {
  SelectedSubtitleInstanceIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedSubtitleInstanceIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedSubtitleInstanceIdHash();

  @$internal
  @override
  SelectedSubtitleInstanceId create() => SelectedSubtitleInstanceId();
}

String _$selectedSubtitleInstanceIdHash() =>
    r'0a82535dcb8fecd88f346c284e985c9b70a4f534';

abstract class _$SelectedSubtitleInstanceId extends $AsyncNotifier<String?> {
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

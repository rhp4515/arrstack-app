// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uptime_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedUptimeInstanceId)
final selectedUptimeInstanceIdProvider = SelectedUptimeInstanceIdProvider._();

final class SelectedUptimeInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedUptimeInstanceId, String?> {
  SelectedUptimeInstanceIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedUptimeInstanceIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedUptimeInstanceIdHash();

  @$internal
  @override
  SelectedUptimeInstanceId create() => SelectedUptimeInstanceId();
}

String _$selectedUptimeInstanceIdHash() =>
    r'a832a0a46fc5e3f85169d48591b6c7978616b1a8';

abstract class _$SelectedUptimeInstanceId extends $AsyncNotifier<String?> {
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

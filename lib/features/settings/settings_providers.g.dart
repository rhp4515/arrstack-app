// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeSsidsSettings)
final homeSsidsSettingsProvider = HomeSsidsSettingsProvider._();

final class HomeSsidsSettingsProvider
    extends $AsyncNotifierProvider<HomeSsidsSettings, List<String>> {
  HomeSsidsSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeSsidsSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeSsidsSettingsHash();

  @$internal
  @override
  HomeSsidsSettings create() => HomeSsidsSettings();
}

String _$homeSsidsSettingsHash() => r'cd57f2792009773f63e56a5e1840750c2ad25a08';

abstract class _$HomeSsidsSettings extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DefaultEndpointModeSettings)
final defaultEndpointModeSettingsProvider =
    DefaultEndpointModeSettingsProvider._();

final class DefaultEndpointModeSettingsProvider
    extends $AsyncNotifierProvider<DefaultEndpointModeSettings, EndpointMode> {
  DefaultEndpointModeSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultEndpointModeSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultEndpointModeSettingsHash();

  @$internal
  @override
  DefaultEndpointModeSettings create() => DefaultEndpointModeSettings();
}

String _$defaultEndpointModeSettingsHash() =>
    r'8908631c71638b4f4325842727b50bed5caacf77';

abstract class _$DefaultEndpointModeSettings
    extends $AsyncNotifier<EndpointMode> {
  FutureOr<EndpointMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EndpointMode>, EndpointMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EndpointMode>, EndpointMode>,
              AsyncValue<EndpointMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

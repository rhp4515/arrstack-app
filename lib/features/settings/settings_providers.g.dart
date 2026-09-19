// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live version string for a Settings instance row (README §2m: the
/// `192.168.1.10:7878 · v5.14.0` subtitle). Only fetched for service types
/// whose client implements [ConnectionTestClient] over a plain,
/// already-authenticated request — Uptime Kuma's socket-session client and
/// Prowlarr/Einthusan (no version-bearing status endpoint wired up) are
/// deliberately excluded rather than faked. Best-effort: any failure
/// (unreachable instance, missing credential, parse error) resolves to
/// null so a version-fetch hiccup never turns into a page-level error —
/// the endpoint string alone is still a useful subtitle.

@ProviderFor(instanceVersion)
final instanceVersionProvider = InstanceVersionFamily._();

/// Live version string for a Settings instance row (README §2m: the
/// `192.168.1.10:7878 · v5.14.0` subtitle). Only fetched for service types
/// whose client implements [ConnectionTestClient] over a plain,
/// already-authenticated request — Uptime Kuma's socket-session client and
/// Prowlarr/Einthusan (no version-bearing status endpoint wired up) are
/// deliberately excluded rather than faked. Best-effort: any failure
/// (unreachable instance, missing credential, parse error) resolves to
/// null so a version-fetch hiccup never turns into a page-level error —
/// the endpoint string alone is still a useful subtitle.

final class InstanceVersionProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Live version string for a Settings instance row (README §2m: the
  /// `192.168.1.10:7878 · v5.14.0` subtitle). Only fetched for service types
  /// whose client implements [ConnectionTestClient] over a plain,
  /// already-authenticated request — Uptime Kuma's socket-session client and
  /// Prowlarr/Einthusan (no version-bearing status endpoint wired up) are
  /// deliberately excluded rather than faked. Best-effort: any failure
  /// (unreachable instance, missing credential, parse error) resolves to
  /// null so a version-fetch hiccup never turns into a page-level error —
  /// the endpoint string alone is still a useful subtitle.
  InstanceVersionProvider._({
    required InstanceVersionFamily super.from,
    required (String, ServiceType) super.argument,
  }) : super(
         retry: null,
         name: r'instanceVersionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$instanceVersionHash();

  @override
  String toString() {
    return r'instanceVersionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as (String, ServiceType);
    return instanceVersion(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is InstanceVersionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$instanceVersionHash() => r'8b355c82c1844c44a345ee66bee6246a12449d1b';

/// Live version string for a Settings instance row (README §2m: the
/// `192.168.1.10:7878 · v5.14.0` subtitle). Only fetched for service types
/// whose client implements [ConnectionTestClient] over a plain,
/// already-authenticated request — Uptime Kuma's socket-session client and
/// Prowlarr/Einthusan (no version-bearing status endpoint wired up) are
/// deliberately excluded rather than faked. Best-effort: any failure
/// (unreachable instance, missing credential, parse error) resolves to
/// null so a version-fetch hiccup never turns into a page-level error —
/// the endpoint string alone is still a useful subtitle.

final class InstanceVersionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, (String, ServiceType)> {
  InstanceVersionFamily._()
    : super(
        retry: null,
        name: r'instanceVersionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live version string for a Settings instance row (README §2m: the
  /// `192.168.1.10:7878 · v5.14.0` subtitle). Only fetched for service types
  /// whose client implements [ConnectionTestClient] over a plain,
  /// already-authenticated request — Uptime Kuma's socket-session client and
  /// Prowlarr/Einthusan (no version-bearing status endpoint wired up) are
  /// deliberately excluded rather than faked. Best-effort: any failure
  /// (unreachable instance, missing credential, parse error) resolves to
  /// null so a version-fetch hiccup never turns into a page-level error —
  /// the endpoint string alone is still a useful subtitle.

  InstanceVersionProvider call(String instanceId, ServiceType serviceType) =>
      InstanceVersionProvider._(
        argument: (instanceId, serviceType),
        from: this,
      );

  @override
  String toString() => r'instanceVersionProvider';
}

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

String _$homeSsidsSettingsHash() => r'8d61ac0d6fd0bea3899bacc24842b814a2782994';

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

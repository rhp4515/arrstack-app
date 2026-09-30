// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceAuthenticator)
final deviceAuthenticatorProvider = DeviceAuthenticatorProvider._();

final class DeviceAuthenticatorProvider
    extends
        $FunctionalProvider<
          DeviceAuthenticator,
          DeviceAuthenticator,
          DeviceAuthenticator
        >
    with $Provider<DeviceAuthenticator> {
  DeviceAuthenticatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceAuthenticatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceAuthenticatorHash();

  @$internal
  @override
  $ProviderElement<DeviceAuthenticator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceAuthenticator create(Ref ref) {
    return deviceAuthenticator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceAuthenticator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceAuthenticator>(value),
    );
  }
}

String _$deviceAuthenticatorHash() =>
    r'b8a84a3a0d8ce9db8ca168dd234b1092bdfa1ff9';

@ProviderFor(AppLockEnabled)
final appLockEnabledProvider = AppLockEnabledProvider._();

final class AppLockEnabledProvider
    extends $AsyncNotifierProvider<AppLockEnabled, bool> {
  AppLockEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockEnabledHash();

  @$internal
  @override
  AppLockEnabled create() => AppLockEnabled();
}

String _$appLockEnabledHash() => r'f947495342573183037779517ee9fed0906e652e';

abstract class _$AppLockEnabled extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

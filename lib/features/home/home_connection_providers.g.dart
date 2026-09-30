// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_connection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Synchronous by design — see the Task 3 brief's "Why synchronous" note.
/// Watches all three source providers' `AsyncValue`s in one pass so
/// Riverpod's own dependency tracking re-invokes this build automatically
/// as each resolves, rather than this provider trying to await-then-peek
/// them (which is always `loading`, permanently, in a `Future`-returning
/// version — see git history / task-3-report.md for the original bug).

@ProviderFor(homeConnectionState)
final homeConnectionStateProvider = HomeConnectionStateProvider._();

/// Synchronous by design — see the Task 3 brief's "Why synchronous" note.
/// Watches all three source providers' `AsyncValue`s in one pass so
/// Riverpod's own dependency tracking re-invokes this build automatically
/// as each resolves, rather than this provider trying to await-then-peek
/// them (which is always `loading`, permanently, in a `Future`-returning
/// version — see git history / task-3-report.md for the original bug).

final class HomeConnectionStateProvider
    extends
        $FunctionalProvider<
          HomeConnectionState,
          HomeConnectionState,
          HomeConnectionState
        >
    with $Provider<HomeConnectionState> {
  /// Synchronous by design — see the Task 3 brief's "Why synchronous" note.
  /// Watches all three source providers' `AsyncValue`s in one pass so
  /// Riverpod's own dependency tracking re-invokes this build automatically
  /// as each resolves, rather than this provider trying to await-then-peek
  /// them (which is always `loading`, permanently, in a `Future`-returning
  /// version — see git history / task-3-report.md for the original bug).
  HomeConnectionStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeConnectionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeConnectionStateHash();

  @$internal
  @override
  $ProviderElement<HomeConnectionState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeConnectionState create(Ref ref) {
    return homeConnectionState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeConnectionState>(value),
    );
  }
}

String _$homeConnectionStateHash() =>
    r'eedecc30e01a15a0e3a41c2b45b196730831b327';

/// Debug-only override for visual QA (README §3f: "switchable via a chip
/// row... for demo/dev purposes"). Null means "no override — use the real
/// computed state."

@ProviderFor(HomeConnectionStateDevOverride)
final homeConnectionStateDevOverrideProvider =
    HomeConnectionStateDevOverrideProvider._();

/// Debug-only override for visual QA (README §3f: "switchable via a chip
/// row... for demo/dev purposes"). Null means "no override — use the real
/// computed state."
final class HomeConnectionStateDevOverrideProvider
    extends
        $NotifierProvider<
          HomeConnectionStateDevOverride,
          HomeConnectionState?
        > {
  /// Debug-only override for visual QA (README §3f: "switchable via a chip
  /// row... for demo/dev purposes"). Null means "no override — use the real
  /// computed state."
  HomeConnectionStateDevOverrideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeConnectionStateDevOverrideProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeConnectionStateDevOverrideHash();

  @$internal
  @override
  HomeConnectionStateDevOverride create() => HomeConnectionStateDevOverride();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeConnectionState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeConnectionState?>(value),
    );
  }
}

String _$homeConnectionStateDevOverrideHash() =>
    r'b91c92ed352e1b006c6c9c7dc0a94d5f182f30ec';

/// Debug-only override for visual QA (README §3f: "switchable via a chip
/// row... for demo/dev purposes"). Null means "no override — use the real
/// computed state."

abstract class _$HomeConnectionStateDevOverride
    extends $Notifier<HomeConnectionState?> {
  HomeConnectionState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HomeConnectionState?, HomeConnectionState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HomeConnectionState?, HomeConnectionState?>,
              HomeConnectionState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The state Home actually renders: the dev override when set, otherwise
/// the real computed [homeConnectionStateProvider].

@ProviderFor(effectiveHomeConnectionState)
final effectiveHomeConnectionStateProvider =
    EffectiveHomeConnectionStateProvider._();

/// The state Home actually renders: the dev override when set, otherwise
/// the real computed [homeConnectionStateProvider].

final class EffectiveHomeConnectionStateProvider
    extends
        $FunctionalProvider<
          HomeConnectionState,
          HomeConnectionState,
          HomeConnectionState
        >
    with $Provider<HomeConnectionState> {
  /// The state Home actually renders: the dev override when set, otherwise
  /// the real computed [homeConnectionStateProvider].
  EffectiveHomeConnectionStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveHomeConnectionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveHomeConnectionStateHash();

  @$internal
  @override
  $ProviderElement<HomeConnectionState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HomeConnectionState create(Ref ref) {
    return effectiveHomeConnectionState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeConnectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeConnectionState>(value),
    );
  }
}

String _$effectiveHomeConnectionStateHash() =>
    r'fcd4547071b38b0d9e38cb8cb4e36a68e006b17a';

/// Whether the dev connection-state switcher chip row should render.
/// Defaults to [kDebugMode] but is overridable in tests so both branches
/// (present/absent) can be verified without a release build.

@ProviderFor(showDevConnectionSwitcher)
final showDevConnectionSwitcherProvider = ShowDevConnectionSwitcherProvider._();

/// Whether the dev connection-state switcher chip row should render.
/// Defaults to [kDebugMode] but is overridable in tests so both branches
/// (present/absent) can be verified without a release build.

final class ShowDevConnectionSwitcherProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the dev connection-state switcher chip row should render.
  /// Defaults to [kDebugMode] but is overridable in tests so both branches
  /// (present/absent) can be verified without a release build.
  ShowDevConnectionSwitcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showDevConnectionSwitcherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showDevConnectionSwitcherHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showDevConnectionSwitcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showDevConnectionSwitcherHash() =>
    r'27a04fe832d1e7b05a3e799e52753faa58991917';

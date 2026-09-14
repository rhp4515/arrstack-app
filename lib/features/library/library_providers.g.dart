// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which [LibraryTab] the Library page shows.
///
/// `go_router`'s `StatefulShellRoute.indexedStack` keeps the Library page
/// alive across visits, so its own widget state would otherwise retain
/// whatever tab was last active. Routing this through a provider lets Home's
/// service-tile taps (Radarr → movies, Sonarr → TV shows) force the correct
/// tab every time, not just on first load.

@ProviderFor(ActiveLibraryTab)
final activeLibraryTabProvider = ActiveLibraryTabProvider._();

/// Which [LibraryTab] the Library page shows.
///
/// `go_router`'s `StatefulShellRoute.indexedStack` keeps the Library page
/// alive across visits, so its own widget state would otherwise retain
/// whatever tab was last active. Routing this through a provider lets Home's
/// service-tile taps (Radarr → movies, Sonarr → TV shows) force the correct
/// tab every time, not just on first load.
final class ActiveLibraryTabProvider
    extends $NotifierProvider<ActiveLibraryTab, LibraryTab> {
  /// Which [LibraryTab] the Library page shows.
  ///
  /// `go_router`'s `StatefulShellRoute.indexedStack` keeps the Library page
  /// alive across visits, so its own widget state would otherwise retain
  /// whatever tab was last active. Routing this through a provider lets Home's
  /// service-tile taps (Radarr → movies, Sonarr → TV shows) force the correct
  /// tab every time, not just on first load.
  ActiveLibraryTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLibraryTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLibraryTabHash();

  @$internal
  @override
  ActiveLibraryTab create() => ActiveLibraryTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryTab>(value),
    );
  }
}

String _$activeLibraryTabHash() => r'c5f8eaf9f6cdea67b64b080d61045fd06e54d014';

/// Which [LibraryTab] the Library page shows.
///
/// `go_router`'s `StatefulShellRoute.indexedStack` keeps the Library page
/// alive across visits, so its own widget state would otherwise retain
/// whatever tab was last active. Routing this through a provider lets Home's
/// service-tile taps (Radarr → movies, Sonarr → TV shows) force the correct
/// tab every time, not just on first load.

abstract class _$ActiveLibraryTab extends $Notifier<LibraryTab> {
  LibraryTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibraryTab, LibraryTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryTab, LibraryTab>,
              LibraryTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.

@ProviderFor(SelectedLibraryInstanceId)
final selectedLibraryInstanceIdProvider = SelectedLibraryInstanceIdFamily._();

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.
final class SelectedLibraryInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedLibraryInstanceId, String?> {
  /// The currently selected instance ID for the Library view.
  /// Defaults to the first Radarr instance marked as default, or just the first.
  SelectedLibraryInstanceIdProvider._({
    required SelectedLibraryInstanceIdFamily super.from,
    required ServiceType super.argument,
  }) : super(
         retry: null,
         name: r'selectedLibraryInstanceIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$selectedLibraryInstanceIdHash();

  @override
  String toString() {
    return r'selectedLibraryInstanceIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SelectedLibraryInstanceId create() => SelectedLibraryInstanceId();

  @override
  bool operator ==(Object other) {
    return other is SelectedLibraryInstanceIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$selectedLibraryInstanceIdHash() =>
    r'9dd391d3c02cea9a1e329e1b3e1358020f634191';

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.

final class SelectedLibraryInstanceIdFamily extends $Family
    with
        $ClassFamilyOverride<
          SelectedLibraryInstanceId,
          AsyncValue<String?>,
          String?,
          FutureOr<String?>,
          ServiceType
        > {
  SelectedLibraryInstanceIdFamily._()
    : super(
        retry: null,
        name: r'selectedLibraryInstanceIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The currently selected instance ID for the Library view.
  /// Defaults to the first Radarr instance marked as default, or just the first.

  SelectedLibraryInstanceIdProvider call(ServiceType type) =>
      SelectedLibraryInstanceIdProvider._(argument: type, from: this);

  @override
  String toString() => r'selectedLibraryInstanceIdProvider';
}

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.

abstract class _$SelectedLibraryInstanceId extends $AsyncNotifier<String?> {
  late final _$args = ref.$arg as ServiceType;
  ServiceType get type => _$args;

  FutureOr<String?> build(ServiceType type);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Shows with partial download progress and an episode air date within
/// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
/// WATCHING"). Omits a series with no calendar entry in the window
/// rather than erroring — this row is a convenience surface.

@ProviderFor(continueWatching)
final continueWatchingProvider = ContinueWatchingFamily._();

/// Shows with partial download progress and an episode air date within
/// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
/// WATCHING"). Omits a series with no calendar entry in the window
/// rather than erroring — this row is a convenience surface.

final class ContinueWatchingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ContinueWatchingEntry>>,
          List<ContinueWatchingEntry>,
          FutureOr<List<ContinueWatchingEntry>>
        >
    with
        $FutureModifier<List<ContinueWatchingEntry>>,
        $FutureProvider<List<ContinueWatchingEntry>> {
  /// Shows with partial download progress and an episode air date within
  /// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
  /// WATCHING"). Omits a series with no calendar entry in the window
  /// rather than erroring — this row is a convenience surface.
  ContinueWatchingProvider._({
    required ContinueWatchingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'continueWatchingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$continueWatchingHash();

  @override
  String toString() {
    return r'continueWatchingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ContinueWatchingEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ContinueWatchingEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return continueWatching(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContinueWatchingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$continueWatchingHash() => r'2d0bf7d484941f4de42f0a6477cf21467f09d522';

/// Shows with partial download progress and an episode air date within
/// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
/// WATCHING"). Omits a series with no calendar entry in the window
/// rather than erroring — this row is a convenience surface.

final class ContinueWatchingFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ContinueWatchingEntry>>,
          String
        > {
  ContinueWatchingFamily._()
    : super(
        retry: null,
        name: r'continueWatchingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Shows with partial download progress and an episode air date within
  /// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
  /// WATCHING"). Omits a series with no calendar entry in the window
  /// rather than erroring — this row is a convenience surface.

  ContinueWatchingProvider call(String instanceId) =>
      ContinueWatchingProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'continueWatchingProvider';
}

@ProviderFor(ActiveLibrarySort)
final activeLibrarySortProvider = ActiveLibrarySortProvider._();

final class ActiveLibrarySortProvider
    extends $NotifierProvider<ActiveLibrarySort, LibrarySort> {
  ActiveLibrarySortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLibrarySortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLibrarySortHash();

  @$internal
  @override
  ActiveLibrarySort create() => ActiveLibrarySort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySort>(value),
    );
  }
}

String _$activeLibrarySortHash() => r'a05ec5977bad89d4a9b1c3996f178aea9a20571b';

abstract class _$ActiveLibrarySort extends $Notifier<LibrarySort> {
  LibrarySort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibrarySort, LibrarySort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibrarySort, LibrarySort>,
              LibrarySort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

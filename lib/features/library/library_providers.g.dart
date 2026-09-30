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

/// The configured instances of [type], in storage order — the options the
/// Library's instance switcher offers. Empty when the list can't be read.

@ProviderFor(libraryInstances)
final libraryInstancesProvider = LibraryInstancesFamily._();

/// The configured instances of [type], in storage order — the options the
/// Library's instance switcher offers. Empty when the list can't be read.

final class LibraryInstancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServiceInstance>>,
          List<ServiceInstance>,
          FutureOr<List<ServiceInstance>>
        >
    with
        $FutureModifier<List<ServiceInstance>>,
        $FutureProvider<List<ServiceInstance>> {
  /// The configured instances of [type], in storage order — the options the
  /// Library's instance switcher offers. Empty when the list can't be read.
  LibraryInstancesProvider._({
    required LibraryInstancesFamily super.from,
    required ServiceType super.argument,
  }) : super(
         retry: null,
         name: r'libraryInstancesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryInstancesHash();

  @override
  String toString() {
    return r'libraryInstancesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ServiceInstance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ServiceInstance>> create(Ref ref) {
    final argument = this.argument as ServiceType;
    return libraryInstances(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryInstancesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryInstancesHash() => r'e0960f9cc1f762a842729ec2f5cc5a13be3481f7';

/// The configured instances of [type], in storage order — the options the
/// Library's instance switcher offers. Empty when the list can't be read.

final class LibraryInstancesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ServiceInstance>>,
          ServiceType
        > {
  LibraryInstancesFamily._()
    : super(
        retry: null,
        name: r'libraryInstancesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The configured instances of [type], in storage order — the options the
  /// Library's instance switcher offers. Empty when the list can't be read.

  LibraryInstancesProvider call(ServiceType type) =>
      LibraryInstancesProvider._(argument: type, from: this);

  @override
  String toString() => r'libraryInstancesProvider';
}

/// The currently selected instance ID for the Library view.
///
/// Resolves to the instance last picked in the switcher (persisted via
/// [libraryInstanceStoreProvider]) when it still exists, else the instance
/// marked as default, else the first. Null when none of [type] exist.

@ProviderFor(SelectedLibraryInstanceId)
final selectedLibraryInstanceIdProvider = SelectedLibraryInstanceIdFamily._();

/// The currently selected instance ID for the Library view.
///
/// Resolves to the instance last picked in the switcher (persisted via
/// [libraryInstanceStoreProvider]) when it still exists, else the instance
/// marked as default, else the first. Null when none of [type] exist.
final class SelectedLibraryInstanceIdProvider
    extends $AsyncNotifierProvider<SelectedLibraryInstanceId, String?> {
  /// The currently selected instance ID for the Library view.
  ///
  /// Resolves to the instance last picked in the switcher (persisted via
  /// [libraryInstanceStoreProvider]) when it still exists, else the instance
  /// marked as default, else the first. Null when none of [type] exist.
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
    r'61972ec692b5f005f359ee07ac1f4209b378438f';

/// The currently selected instance ID for the Library view.
///
/// Resolves to the instance last picked in the switcher (persisted via
/// [libraryInstanceStoreProvider]) when it still exists, else the instance
/// marked as default, else the first. Null when none of [type] exist.

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
  ///
  /// Resolves to the instance last picked in the switcher (persisted via
  /// [libraryInstanceStoreProvider]) when it still exists, else the instance
  /// marked as default, else the first. Null when none of [type] exist.

  SelectedLibraryInstanceIdProvider call(ServiceType type) =>
      SelectedLibraryInstanceIdProvider._(argument: type, from: this);

  @override
  String toString() => r'selectedLibraryInstanceIdProvider';
}

/// The currently selected instance ID for the Library view.
///
/// Resolves to the instance last picked in the switcher (persisted via
/// [libraryInstanceStoreProvider]) when it still exists, else the instance
/// marked as default, else the first. Null when none of [type] exist.

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

/// Which [LibrarySection] the Library shows. Session-only, shared by the
/// Shows and Movies collections.

@ProviderFor(ActiveLibrarySection)
final activeLibrarySectionProvider = ActiveLibrarySectionProvider._();

/// Which [LibrarySection] the Library shows. Session-only, shared by the
/// Shows and Movies collections.
final class ActiveLibrarySectionProvider
    extends $NotifierProvider<ActiveLibrarySection, LibrarySection> {
  /// Which [LibrarySection] the Library shows. Session-only, shared by the
  /// Shows and Movies collections.
  ActiveLibrarySectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeLibrarySectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeLibrarySectionHash();

  @$internal
  @override
  ActiveLibrarySection create() => ActiveLibrarySection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySection>(value),
    );
  }
}

String _$activeLibrarySectionHash() =>
    r'1c2211cff3f4bcd5a1d5c0f1bd12a4ef451d7220';

/// Which [LibrarySection] the Library shows. Session-only, shared by the
/// Shows and Movies collections.

abstract class _$ActiveLibrarySection extends $Notifier<LibrarySection> {
  LibrarySection build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibrarySection, LibrarySection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibrarySection, LibrarySection>,
              LibrarySection,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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

String _$continueWatchingHash() => r'93b3afff39ab9dc1bfade24e2a678044118a9277';

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which [ActivityLens] the Activity page shows. `go_router`'s
/// `StatefulShellRoute` (or, after this phase, a single non-shell route)
/// keeps the page's own widget state around across visits, so this
/// provider — not local widget state — lets Home's tile taps and deep
/// links force the right lens every time. Mirrors `ActiveLibraryTab`
/// (`lib/features/library/library_providers.dart`).

@ProviderFor(ActiveActivityLens)
final activeActivityLensProvider = ActiveActivityLensProvider._();

/// Which [ActivityLens] the Activity page shows. `go_router`'s
/// `StatefulShellRoute` (or, after this phase, a single non-shell route)
/// keeps the page's own widget state around across visits, so this
/// provider — not local widget state — lets Home's tile taps and deep
/// links force the right lens every time. Mirrors `ActiveLibraryTab`
/// (`lib/features/library/library_providers.dart`).
final class ActiveActivityLensProvider
    extends $NotifierProvider<ActiveActivityLens, ActivityLens> {
  /// Which [ActivityLens] the Activity page shows. `go_router`'s
  /// `StatefulShellRoute` (or, after this phase, a single non-shell route)
  /// keeps the page's own widget state around across visits, so this
  /// provider — not local widget state — lets Home's tile taps and deep
  /// links force the right lens every time. Mirrors `ActiveLibraryTab`
  /// (`lib/features/library/library_providers.dart`).
  ActiveActivityLensProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeActivityLensProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeActivityLensHash();

  @$internal
  @override
  ActiveActivityLens create() => ActiveActivityLens();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityLens value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityLens>(value),
    );
  }
}

String _$activeActivityLensHash() =>
    r'7118bf66c5087b860021efa479a466289ea83cd7';

/// Which [ActivityLens] the Activity page shows. `go_router`'s
/// `StatefulShellRoute` (or, after this phase, a single non-shell route)
/// keeps the page's own widget state around across visits, so this
/// provider — not local widget state — lets Home's tile taps and deep
/// links force the right lens every time. Mirrors `ActiveLibraryTab`
/// (`lib/features/library/library_providers.dart`).

abstract class _$ActiveActivityLens extends $Notifier<ActivityLens> {
  ActivityLens build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ActivityLens, ActivityLens>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityLens, ActivityLens>,
              ActivityLens,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Missing episodes (aired, no file) across every configured Sonarr
/// instance, sorted by air date ascending. A single instance failing is
/// dropped silently — the Wanted lens shows whatever could be reached, no
/// banner (spec Decision 2: "Radarr and Sonarr are unaffected" by a Bazarr
/// outage, and the reverse holds too — a broken Sonarr instance doesn't
/// block the rest of the list).

@ProviderFor(sonarrMissingEpisodes)
final sonarrMissingEpisodesProvider = SonarrMissingEpisodesProvider._();

/// Missing episodes (aired, no file) across every configured Sonarr
/// instance, sorted by air date ascending. A single instance failing is
/// dropped silently — the Wanted lens shows whatever could be reached, no
/// banner (spec Decision 2: "Radarr and Sonarr are unaffected" by a Bazarr
/// outage, and the reverse holds too — a broken Sonarr instance doesn't
/// block the rest of the list).

final class SonarrMissingEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SonarrMissingEpisode>>,
          List<SonarrMissingEpisode>,
          FutureOr<List<SonarrMissingEpisode>>
        >
    with
        $FutureModifier<List<SonarrMissingEpisode>>,
        $FutureProvider<List<SonarrMissingEpisode>> {
  /// Missing episodes (aired, no file) across every configured Sonarr
  /// instance, sorted by air date ascending. A single instance failing is
  /// dropped silently — the Wanted lens shows whatever could be reached, no
  /// banner (spec Decision 2: "Radarr and Sonarr are unaffected" by a Bazarr
  /// outage, and the reverse holds too — a broken Sonarr instance doesn't
  /// block the rest of the list).
  SonarrMissingEpisodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sonarrMissingEpisodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sonarrMissingEpisodesHash();

  @$internal
  @override
  $FutureProviderElement<List<SonarrMissingEpisode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SonarrMissingEpisode>> create(Ref ref) {
    return sonarrMissingEpisodes(ref);
  }
}

String _$sonarrMissingEpisodesHash() =>
    r'57b7378d272aaf7e3766f77b6e37b33f5b940fc9';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_section_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Monitored releases/airings of [type] from [instanceId], day-grouped,
/// from the shared calendar window (today onward).

@ProviderFor(libraryUpcoming)
final libraryUpcomingProvider = LibraryUpcomingFamily._();

/// Monitored releases/airings of [type] from [instanceId], day-grouped,
/// from the shared calendar window (today onward).

final class LibraryUpcomingProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<CalendarDay>>>,
          Result<List<CalendarDay>>,
          FutureOr<Result<List<CalendarDay>>>
        >
    with
        $FutureModifier<Result<List<CalendarDay>>>,
        $FutureProvider<Result<List<CalendarDay>>> {
  /// Monitored releases/airings of [type] from [instanceId], day-grouped,
  /// from the shared calendar window (today onward).
  LibraryUpcomingProvider._({
    required LibraryUpcomingFamily super.from,
    required (ServiceType, String) super.argument,
  }) : super(
         retry: null,
         name: r'libraryUpcomingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryUpcomingHash();

  @override
  String toString() {
    return r'libraryUpcomingProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<CalendarDay>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<CalendarDay>>> create(Ref ref) {
    final argument = this.argument as (ServiceType, String);
    return libraryUpcoming(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryUpcomingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryUpcomingHash() => r'8dc42772acf8aba37843bc60223554b984b02f5f';

/// Monitored releases/airings of [type] from [instanceId], day-grouped,
/// from the shared calendar window (today onward).

final class LibraryUpcomingFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<CalendarDay>>>,
          (ServiceType, String)
        > {
  LibraryUpcomingFamily._()
    : super(
        retry: null,
        name: r'libraryUpcomingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Monitored releases/airings of [type] from [instanceId], day-grouped,
  /// from the shared calendar window (today onward).

  LibraryUpcomingProvider call(ServiceType type, String instanceId) =>
      LibraryUpcomingProvider._(argument: (type, instanceId), from: this);

  @override
  String toString() => r'libraryUpcomingProvider';
}

/// Sonarr's missing (aired, no file) episodes for [instanceId], most
/// recently aired first — the Activity Wanted lens's aggregation narrowed
/// to one instance.

@ProviderFor(libraryMissingEpisodes)
final libraryMissingEpisodesProvider = LibraryMissingEpisodesFamily._();

/// Sonarr's missing (aired, no file) episodes for [instanceId], most
/// recently aired first — the Activity Wanted lens's aggregation narrowed
/// to one instance.

final class LibraryMissingEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SonarrMissingEpisode>>,
          List<SonarrMissingEpisode>,
          FutureOr<List<SonarrMissingEpisode>>
        >
    with
        $FutureModifier<List<SonarrMissingEpisode>>,
        $FutureProvider<List<SonarrMissingEpisode>> {
  /// Sonarr's missing (aired, no file) episodes for [instanceId], most
  /// recently aired first — the Activity Wanted lens's aggregation narrowed
  /// to one instance.
  LibraryMissingEpisodesProvider._({
    required LibraryMissingEpisodesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'libraryMissingEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryMissingEpisodesHash();

  @override
  String toString() {
    return r'libraryMissingEpisodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SonarrMissingEpisode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SonarrMissingEpisode>> create(Ref ref) {
    final argument = this.argument as String;
    return libraryMissingEpisodes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryMissingEpisodesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryMissingEpisodesHash() =>
    r'd8a247d056b8315589ba4621e0b7b6a5b99e9765';

/// Sonarr's missing (aired, no file) episodes for [instanceId], most
/// recently aired first — the Activity Wanted lens's aggregation narrowed
/// to one instance.

final class LibraryMissingEpisodesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SonarrMissingEpisode>>,
          String
        > {
  LibraryMissingEpisodesFamily._()
    : super(
        retry: null,
        name: r'libraryMissingEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Sonarr's missing (aired, no file) episodes for [instanceId], most
  /// recently aired first — the Activity Wanted lens's aggregation narrowed
  /// to one instance.

  LibraryMissingEpisodesProvider call(String instanceId) =>
      LibraryMissingEpisodesProvider._(argument: instanceId, from: this);

  @override
  String toString() => r'libraryMissingEpisodesProvider';
}

/// The download queue for [instanceId], with titles and posters filled in
/// from the library list when it's already loaded.

@ProviderFor(libraryQueue)
final libraryQueueProvider = LibraryQueueFamily._();

/// The download queue for [instanceId], with titles and posters filled in
/// from the library list when it's already loaded.

final class LibraryQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<LibraryQueueEntry>>>,
          Result<List<LibraryQueueEntry>>,
          FutureOr<Result<List<LibraryQueueEntry>>>
        >
    with
        $FutureModifier<Result<List<LibraryQueueEntry>>>,
        $FutureProvider<Result<List<LibraryQueueEntry>>> {
  /// The download queue for [instanceId], with titles and posters filled in
  /// from the library list when it's already loaded.
  LibraryQueueProvider._({
    required LibraryQueueFamily super.from,
    required (ServiceType, String) super.argument,
  }) : super(
         retry: null,
         name: r'libraryQueueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryQueueHash();

  @override
  String toString() {
    return r'libraryQueueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Result<List<LibraryQueueEntry>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<LibraryQueueEntry>>> create(Ref ref) {
    final argument = this.argument as (ServiceType, String);
    return libraryQueue(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryQueueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryQueueHash() => r'd243ea950b2944dd7d58969ca463fa8fd9b645d3';

/// The download queue for [instanceId], with titles and posters filled in
/// from the library list when it's already loaded.

final class LibraryQueueFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Result<List<LibraryQueueEntry>>>,
          (ServiceType, String)
        > {
  LibraryQueueFamily._()
    : super(
        retry: null,
        name: r'libraryQueueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The download queue for [instanceId], with titles and posters filled in
  /// from the library list when it's already loaded.

  LibraryQueueProvider call(ServiceType type, String instanceId) =>
      LibraryQueueProvider._(argument: (type, instanceId), from: this);

  @override
  String toString() => r'libraryQueueProvider';
}

/// Paged history for one instance: [build] loads page 1, [loadMore]
/// appends the next.

@ProviderFor(LibraryHistory)
final libraryHistoryProvider = LibraryHistoryFamily._();

/// Paged history for one instance: [build] loads page 1, [loadMore]
/// appends the next.
final class LibraryHistoryProvider
    extends $AsyncNotifierProvider<LibraryHistory, Result<LibraryHistoryFeed>> {
  /// Paged history for one instance: [build] loads page 1, [loadMore]
  /// appends the next.
  LibraryHistoryProvider._({
    required LibraryHistoryFamily super.from,
    required (ServiceType, String) super.argument,
  }) : super(
         retry: null,
         name: r'libraryHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryHistoryHash();

  @override
  String toString() {
    return r'libraryHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryHistory create() => LibraryHistory();

  @override
  bool operator ==(Object other) {
    return other is LibraryHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryHistoryHash() => r'dae96bc6cbf07a20822ca1d1cec58aa36808fefb';

/// Paged history for one instance: [build] loads page 1, [loadMore]
/// appends the next.

final class LibraryHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryHistory,
          AsyncValue<Result<LibraryHistoryFeed>>,
          Result<LibraryHistoryFeed>,
          FutureOr<Result<LibraryHistoryFeed>>,
          (ServiceType, String)
        > {
  LibraryHistoryFamily._()
    : super(
        retry: null,
        name: r'libraryHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paged history for one instance: [build] loads page 1, [loadMore]
  /// appends the next.

  LibraryHistoryProvider call(ServiceType type, String instanceId) =>
      LibraryHistoryProvider._(argument: (type, instanceId), from: this);

  @override
  String toString() => r'libraryHistoryProvider';
}

/// Paged history for one instance: [build] loads page 1, [loadMore]
/// appends the next.

abstract class _$LibraryHistory
    extends $AsyncNotifier<Result<LibraryHistoryFeed>> {
  late final _$args = ref.$arg as (ServiceType, String);
  ServiceType get type => _$args.$1;
  String get instanceId => _$args.$2;

  FutureOr<Result<LibraryHistoryFeed>> build(
    ServiceType type,
    String instanceId,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Result<LibraryHistoryFeed>>,
              Result<LibraryHistoryFeed>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Result<LibraryHistoryFeed>>,
                Result<LibraryHistoryFeed>
              >,
              AsyncValue<Result<LibraryHistoryFeed>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

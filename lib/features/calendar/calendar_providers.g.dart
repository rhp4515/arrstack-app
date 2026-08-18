// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The merged, day-grouped schedule across all Sonarr + Radarr instances.
///
/// A single instance failing (offline, auth) is skipped rather than failing
/// the whole calendar — the schedule shows whatever could be reached. The
/// result is [Err] only when the instance list itself can't be read.

@ProviderFor(calendarSchedule)
final calendarScheduleProvider = CalendarScheduleProvider._();

/// The merged, day-grouped schedule across all Sonarr + Radarr instances.
///
/// A single instance failing (offline, auth) is skipped rather than failing
/// the whole calendar — the schedule shows whatever could be reached. The
/// result is [Err] only when the instance list itself can't be read.

final class CalendarScheduleProvider
    extends
        $FunctionalProvider<
          AsyncValue<Result<List<CalendarDay>>>,
          Result<List<CalendarDay>>,
          FutureOr<Result<List<CalendarDay>>>
        >
    with
        $FutureModifier<Result<List<CalendarDay>>>,
        $FutureProvider<Result<List<CalendarDay>>> {
  /// The merged, day-grouped schedule across all Sonarr + Radarr instances.
  ///
  /// A single instance failing (offline, auth) is skipped rather than failing
  /// the whole calendar — the schedule shows whatever could be reached. The
  /// result is [Err] only when the instance list itself can't be read.
  CalendarScheduleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarScheduleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarScheduleHash();

  @$internal
  @override
  $FutureProviderElement<Result<List<CalendarDay>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Result<List<CalendarDay>>> create(Ref ref) {
    return calendarSchedule(ref);
  }
}

String _$calendarScheduleHash() => r'4e451ff35719ca59dec87adcd179c15a0ce72a90';

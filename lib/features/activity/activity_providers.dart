/// Providers backing the Activity page: which lens is active, and the
/// Sonarr/Bazarr aggregations the Wanted lens needs (Phase 4 design
/// §Provider plan).
library;

import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_providers.g.dart';

/// The three switchable lenses on the Activity page (spec screens 2h/2i/2j).
enum ActivityLens { transfers, calendar, wanted }

/// Which [ActivityLens] the Activity page shows. `go_router`'s
/// `StatefulShellRoute` (or, after this phase, a single non-shell route)
/// keeps the page's own widget state around across visits, so this
/// provider — not local widget state — lets Home's tile taps and deep
/// links force the right lens every time. Mirrors `ActiveLibraryTab`
/// (`lib/features/library/library_providers.dart`).
@riverpod
class ActiveActivityLens extends _$ActiveActivityLens {
  @override
  ActivityLens build() => ActivityLens.transfers;

  void select(ActivityLens lens) => state = lens;
}

/// A missing episode paired with the Sonarr instance it came from —
/// `SonarrCalendarEpisode` alone has no `instanceId`, but the Wanted lens's
/// search button needs one (with `seriesId`) to route to
/// `RoutePaths.episodeReleaseSearch`.
@immutable
class SonarrMissingEpisode {
  const SonarrMissingEpisode({required this.instanceId, required this.episode});

  final String instanceId;
  final SonarrCalendarEpisode episode;
}

/// Missing episodes (aired, no file) across every configured Sonarr
/// instance, sorted by air date ascending. A single instance failing is
/// dropped silently — the Wanted lens shows whatever could be reached, no
/// banner (spec Decision 2: "Radarr and Sonarr are unaffected" by a Bazarr
/// outage, and the reverse holds too — a broken Sonarr instance doesn't
/// block the rest of the list).
@riverpod
Future<List<SonarrMissingEpisode>> sonarrMissingEpisodes(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return [];

  final sonarrInstances = instancesResult.value
      .where((i) => i.serviceType == ServiceType.sonarr)
      .toList();

  final lists = await Future.wait([
    for (final instance in sonarrInstances)
      _missingEpisodesFor(ref, instance.id),
  ]);

  final all = lists.expand((list) => list).toList();
  return sortMissingEpisodesByAirDate(all);
}

Future<List<SonarrMissingEpisode>> _missingEpisodesFor(
  Ref ref,
  String instanceId,
) async {
  try {
    final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
    final result = await repo.listMissingEpisodes();
    if (result case Ok(:final value)) {
      return [
        for (final episode in value)
          SonarrMissingEpisode(instanceId: instanceId, episode: episode),
      ];
    }
  } on Object {
    // Skip an unreachable/misconfigured instance; the Wanted lens's
    // missing-episodes section stays partial rather than erroring.
  }
  return const [];
}

/// Ascending by air date; entries with no air date (a data anomaly for a
/// missing-episode list, since Sonarr only reports aired episodes here)
/// sort last rather than crashing the comparator. Pure — unit-testable
/// without a running app.
List<SonarrMissingEpisode> sortMissingEpisodesByAirDate(
  List<SonarrMissingEpisode> episodes,
) {
  final sorted = [...episodes];
  sorted.sort((a, b) {
    final da = a.episode.airDateUtc;
    final db = b.episode.airDateUtc;
    if (da == null && db == null) return 0;
    if (da == null) return 1;
    if (db == null) return -1;
    return da.compareTo(db);
  });
  return sorted;
}

/// Wanted subtitles aggregated across every configured Bazarr instance
/// (spec Decision 2). Unlike [sonarrMissingEpisodes], a Bazarr failure is
/// surfaced — [BazarrWantedAggregate.hasUnreachableInstance] drives the
/// Wanted lens's single offline error card — but other instances' results
/// still show underneath it.
///
/// Fetches every instance concurrently via [Future.wait] (mirroring
/// [sonarrMissingEpisodes]'s pattern) rather than sequentially: a
/// sequential `for` loop that keeps calling `ref.watch` after an earlier
/// iteration's watched dependency has already thrown trips Riverpod's
/// "provider rebuilt while the previous build was still pending" guard —
/// the erroring dependency's AsyncValue change invalidates this provider's
/// in-flight build, and any subsequent `ref.watch` call in that same
/// build then throws a "Ref used after disposed" error instead of
/// reaching the next instance. Registering every dependency's watch
/// up front (before any of them can resolve or throw) avoids that.
@riverpod
Future<BazarrWantedAggregate> bazarrWantedAggregate(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) {
    return const BazarrWantedAggregate(
      subtitles: [],
      hasUnreachableInstance: false,
    );
  }

  final bazarrInstances = instancesResult.value
      .where((i) => i.serviceType == ServiceType.bazarr)
      .toList();

  final results = await Future.wait([
    for (final instance in bazarrInstances)
      _wantedSubtitlesFor(ref, instance.id),
  ]);

  final subtitles = <BazarrWantedSubtitle>[];
  var hasUnreachableInstance = false;
  for (final result in results) {
    if (result == null) {
      hasUnreachableInstance = true;
    } else {
      subtitles.addAll(result);
    }
  }

  return BazarrWantedAggregate(
    subtitles: subtitles,
    hasUnreachableInstance: hasUnreachableInstance,
  );
}

/// Wanted subtitles for a single Bazarr instance, or `null` if the
/// instance is unreachable — either an `Err` Result or a thrown error
/// (e.g. endpoint resolution failure in `dioForInstanceProvider`). Mirrors
/// [_missingEpisodesFor]'s isolation pattern for the Sonarr side.
Future<List<BazarrWantedSubtitle>?> _wantedSubtitlesFor(
  Ref ref,
  String instanceId,
) async {
  try {
    final result = await ref.watch(bazarrWantedProvider(instanceId).future);
    if (result case Ok(:final value)) return value;
  } on Object {
    // Falls through to null below; the caller treats a thrown error the
    // same as an `Err` Result.
  }
  return null;
}

const Duration _throughputSampleInterval = Duration(seconds: 5);
const Duration _throughputHistoryWindow = Duration(minutes: 60);

/// Prunes samples older than [_throughputHistoryWindow] and appends a new
/// sample. Pure function — unit-testable with synthetic [DateTime] values.
/// Mirrors [sortMissingEpisodesByAirDate]'s precedent.
List<ThroughputSample> pruneAndAppendThroughputSample(
  List<ThroughputSample> current,
  int dlSpeedBytesPerSecond,
  DateTime now,
) {
  final cutoff = now.subtract(_throughputHistoryWindow);
  return [
    ...current.where((s) => s.timestamp.isAfter(cutoff)),
    ThroughputSample(
      timestamp: now,
      dlSpeedBytesPerSecond: dlSpeedBytesPerSecond,
    ),
  ];
}

/// A session-only rolling buffer of the last 60 minutes of qBittorrent
/// download-speed samples for [instanceId], powering the Transfers lens's
/// throughput sparkline (spec Decision 3). Nothing in this app polls on an
/// interval anywhere else — this notifier is the one exception, scoped
/// tightly to stay alive only while the Transfers lens is mounted
/// (`autoDispose` + a `Timer` cancelled in `ref.onDispose`).
@riverpod
class TransfersThroughputHistory extends _$TransfersThroughputHistory {
  Timer? _timer;

  @override
  List<ThroughputSample> build(String instanceId) {
    ref.onDispose(() => _timer?.cancel());
    _timer = Timer.periodic(
      _throughputSampleInterval,
      (_) => _sample(instanceId),
    );
    return [];
  }

  Future<void> _sample(String instanceId) async {
    try {
      final result = await ref.read(qbitMainDataProvider(instanceId).future);
      if (!ref.mounted) return;
      if (result case Ok(:final value)) {
        state = pruneAndAppendThroughputSample(
          state,
          value.serverState.dlInfoSpeed,
          DateTime.now(),
        );
      }
    } on Object {
      // Skip a failed sample tick (e.g. missing credentials or an
      // unresolvable endpoint); the timer keeps running for future ticks.
    }
  }
}

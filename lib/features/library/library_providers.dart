/// Providers for the Library feature UI state (spec §7).
library;

import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/features/library/library_instance_store.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_providers.g.dart';

/// The two library surfaces, ordered to match the mockups (TV Shows first).
enum LibraryTab { tvShows, movies }

/// Which [LibraryTab] the Library page shows.
///
/// `go_router`'s `StatefulShellRoute.indexedStack` keeps the Library page
/// alive across visits, so its own widget state would otherwise retain
/// whatever tab was last active. Routing this through a provider lets Home's
/// service-tile taps (Radarr → movies, Sonarr → TV shows) force the correct
/// tab every time, not just on first load.
@riverpod
class ActiveLibraryTab extends _$ActiveLibraryTab {
  @override
  LibraryTab build() => LibraryTab.tvShows;

  void select(LibraryTab tab) => state = tab;
}

/// The configured instances of [type], in storage order — the options the
/// Library's instance switcher offers. Empty when the list can't be read.
@riverpod
Future<List<ServiceInstance>> libraryInstances(
  Ref ref,
  ServiceType type,
) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult case Ok(:final value)) {
    return value.where((i) => i.serviceType == type).toList();
  }
  return const [];
}

/// The currently selected instance ID for the Library view.
///
/// Resolves to the instance last picked in the switcher (persisted via
/// [libraryInstanceStoreProvider]) when it still exists, else the instance
/// marked as default, else the first. Null when none of [type] exist.
@riverpod
class SelectedLibraryInstanceId extends _$SelectedLibraryInstanceId {
  @override
  Future<String?> build(ServiceType type) async {
    final typed = await ref.watch(libraryInstancesProvider(type).future);
    if (typed.isEmpty) return null;
    if (typed.length > 1) {
      final saved = await ref.read(libraryInstanceStoreProvider).read(type);
      if (saved != null && typed.any((i) => i.id == saved)) return saved;
    }
    return typed.firstWhere((i) => i.isDefault, orElse: () => typed.first).id;
  }

  /// Switches the Library to [id] and remembers the choice.
  void selectInstance(String id) {
    state = AsyncData(id);
    unawaited(ref.read(libraryInstanceStoreProvider).write(type, id));
  }
}

/// The sub-tabs under the Library header, within each collection.
enum LibrarySection { all, upcoming, missing, queue, history }

/// Which [LibrarySection] the Library shows. Session-only, shared by the
/// Shows and Movies collections.
@riverpod
class ActiveLibrarySection extends _$ActiveLibrarySection {
  @override
  LibrarySection build() => LibrarySection.all;

  void select(LibrarySection section) => state = section;
}

/// Shows with partial download progress and an episode air date within
/// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
/// WATCHING"). Omits a series with no calendar entry in the window
/// rather than erroring — this row is a convenience surface.
@riverpod
Future<List<ContinueWatchingEntry>> continueWatching(
  Ref ref,
  String instanceId,
) async {
  final seriesResult = await ref.watch(sonarrSeriesProvider(instanceId).future);
  if (seriesResult is! Ok<List<SonarrSeries>>) return const [];
  final partial = seriesResult.value.where(hasPartialProgress).toList();
  if (partial.isEmpty) return const [];

  final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  final now = DateTime.now();
  final calendarResult = await repo.listCalendar(
    now.subtract(const Duration(days: 7)),
    now.add(const Duration(days: 14)),
  );
  if (calendarResult is! Ok<List<SonarrCalendarEpisode>>) return const [];

  final bySeriesId = <int, List<SonarrCalendarEpisode>>{};
  for (final ep in calendarResult.value) {
    final id = ep.seriesId;
    if (id != null) (bySeriesId[id] ??= []).add(ep);
  }

  final entries = <ContinueWatchingEntry>[];
  for (final series in partial) {
    final episodes = bySeriesId[series.id] ?? const [];
    final nearest = nearestEpisode(episodes, now);
    if (nearest?.airDateUtc == null) continue;
    final date = nearest!.airDateUtc!.toLocal();
    final code = nearest.seasonNumber != null && nearest.episodeNumber != null
        ? 'S${nearest.seasonNumber.toString().padLeft(2, '0')}'
              'E${nearest.episodeNumber.toString().padLeft(2, '0')} · '
        : '';
    entries.add(
      ContinueWatchingEntry(
        series: series,
        caption: '$code${continueWatchingCaption(date, now)}',
        referenceDate: date,
      ),
    );
  }

  final future = entries.where((e) => e.referenceDate.isAfter(now)).toList()
    ..sort((a, b) => a.referenceDate.compareTo(b.referenceDate));
  final past = entries.where((e) => !e.referenceDate.isAfter(now)).toList()
    ..sort((a, b) => b.referenceDate.compareTo(a.referenceDate));

  return [...future, ...past].take(3).toList();
}

/// Sort order for the Shows/Movies row lists (spec 2d "Recently added
/// v" / "Newest first v" toggles and the sort/filter chip). Session-only,
/// no persistence — mirrors ActiveActivityLens's pattern.
enum LibrarySort { recentlyAdded, title, year }

@riverpod
class ActiveLibrarySort extends _$ActiveLibrarySort {
  @override
  LibrarySort build() => LibrarySort.recentlyAdded;

  void select(LibrarySort sort) => state = sort;
}

/// A sorted copy of [items] for [sort]: newest-added first, A→Z by title,
/// or newest year first. Items missing the sort key go last. Pure — shared
/// by the Shows and Movies lists.
List<T> sortLibraryItems<T>(
  Iterable<T> items,
  LibrarySort sort, {
  required DateTime? Function(T) added,
  required String Function(T) title,
  required int? Function(T) year,
}) {
  final copy = [...items];
  switch (sort) {
    case LibrarySort.recentlyAdded:
      copy.sort((a, b) {
        final da = added(a);
        final db = added(b);
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
    case LibrarySort.title:
      copy.sort((a, b) => title(a).compareTo(title(b)));
    case LibrarySort.year:
      copy.sort((a, b) => (year(b) ?? 0).compareTo(year(a) ?? 0));
  }
  return copy;
}

/// Providers for the Library feature UI state (spec §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/library/continue_watching.dart';
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

/// The currently selected instance ID for the Library view.
/// Defaults to the first Radarr instance marked as default, or just the first.
@riverpod
class SelectedLibraryInstanceId extends _$SelectedLibraryInstanceId {
  @override
  Future<String?> build(ServiceType type) async {
    final instancesResult = await ref.watch(instancesProvider.future);
    if (instancesResult case Ok(:final value)) {
      final typed = value.where((i) => i.serviceType == type).toList();
      if (typed.isEmpty) return null;
      return typed.firstWhere((i) => i.isDefault, orElse: () => typed.first).id;
    }
    return null;
  }

  void selectInstance(String id) => state = AsyncData(id);
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
  final seriesResult = await ref.watch(
    sonarrSeriesProvider(instanceId).future,
  );
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
    final code =
        nearest.seasonNumber != null && nearest.episodeNumber != null
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

  entries.sort((a, b) => a.referenceDate.compareTo(b.referenceDate));
  return entries.take(3).toList();
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

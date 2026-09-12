/// Providers for the Library feature UI state (spec §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
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

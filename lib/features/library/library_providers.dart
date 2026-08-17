/// Providers for the Library feature UI state (spec §7).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_providers.g.dart';

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

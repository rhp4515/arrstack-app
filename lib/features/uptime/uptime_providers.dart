/// Providers for the Uptime feature UI state.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'uptime_providers.g.dart';

@riverpod
class SelectedUptimeInstanceId extends _$SelectedUptimeInstanceId {
  @override
  Future<String?> build() async {
    final instancesResult = await ref.watch(instancesProvider.future);
    if (instancesResult case Ok(:final value)) {
      final typed = value
          .where((i) => i.serviceType == ServiceType.uptimeKuma)
          .toList();
      if (typed.isEmpty) return null;
      return typed.firstWhere((i) => i.isDefault, orElse: () => typed.first).id;
    }
    return null;
  }

  void selectInstance(String id) => state = AsyncData(id);
}

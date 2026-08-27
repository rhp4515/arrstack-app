import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover_providers.g.dart';

@riverpod
class SelectedSeerrInstanceId extends _$SelectedSeerrInstanceId {
  @override
  Future<String?> build() async {
    final instancesResult = await ref.watch(instancesProvider.future);
    if (instancesResult case Ok(:final value)) {
      final typed = value.where((i) => i.serviceType == ServiceType.seerr).toList();
      if (typed.isEmpty) return null;
      return typed.firstWhere((i) => i.isDefault, orElse: () => typed.first).id;
    }
    return null;
  }

  void selectInstance(String id) => state = AsyncData(id);
}

@riverpod
Future<bool> hasSeerrInstance(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult case Ok(:final value)) {
    return value.any((i) => i.serviceType == ServiceType.seerr);
  }
  return false;
}

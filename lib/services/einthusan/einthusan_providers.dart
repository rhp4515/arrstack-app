/// Riverpod providers for the einthusan-downloader service module.
///
/// Wires up [EinthusanRepository] with the per-instance [Dio] composition
/// (see [dioForInstanceProvider]).
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'einthusan_providers.g.dart';

@riverpod
Future<EinthusanRepository> einthusanRepository(
  Ref ref,
  String instanceId,
) async {
  final dioResult = await ref.watch(dioForInstanceProvider(instanceId).future);

  final dio = switch (dioResult) {
    Ok(:final value) => value,
    Err(:final error) => throw error,
  };

  return EinthusanRepository(EinthusanClient(dio));
}

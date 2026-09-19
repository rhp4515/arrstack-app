/// Derived connection state driving which of Home's four layouts renders
/// (README §3f): `unconfigured` (no instances), `loading` (initial fetch
/// in flight), `offline` (nothing reachable), or `ready` (default). Never
/// persisted — always recomputed from the same providers Home already
/// watches. Named `HomeConnectionState` rather than the design doc's
/// literal `ConnectionState` to avoid colliding with Flutter's own
/// `ConnectionState` (StreamBuilder/AsyncSnapshot).
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_connection_providers.g.dart';

enum HomeConnectionState { unconfigured, loading, offline, ready }

/// Synchronous by design — see the Task 3 brief's "Why synchronous" note.
/// Watches all three source providers' `AsyncValue`s in one pass so
/// Riverpod's own dependency tracking re-invokes this build automatically
/// as each resolves, rather than this provider trying to await-then-peek
/// them (which is always `loading`, permanently, in a `Future`-returning
/// version — see git history / task-3-report.md for the original bug).
@riverpod
HomeConnectionState homeConnectionState(Ref ref) {
  final instancesAsync = ref.watch(instancesProvider);
  if (instancesAsync.isLoading && !instancesAsync.hasValue) {
    return HomeConnectionState.loading;
  }
  final instances = switch (instancesAsync.value) {
    Ok(:final value) => value,
    _ => const <ServiceInstance>[],
  };
  if (instances.isEmpty) return HomeConnectionState.unconfigured;

  final summariesAsync = ref.watch(homeServiceSummariesProvider);
  final rightNowAsync = ref.watch(rightNowProvider);
  final summariesInitialLoad =
      summariesAsync.isLoading && !summariesAsync.hasValue;
  final rightNowInitialLoad =
      rightNowAsync.isLoading && !rightNowAsync.hasValue;
  if (summariesInitialLoad || rightNowInitialLoad) {
    return HomeConnectionState.loading;
  }

  final summaries = summariesAsync.value ?? const [];
  final rightNow = rightNowAsync.value;
  // Einthusan has no real connectivity check (home_providers.dart's
  // _einthusanSummary always reports "Connected") — excluded here so an
  // Einthusan-only configuration can't produce a false `ready` while every
  // other, actually-checked service is unreachable.
  final anyReachable =
      summaries
          .where((s) => s.serviceType != ServiceType.einthusan)
          .any((s) => s.isReachable) ||
      rightNow != null;
  return anyReachable ? HomeConnectionState.ready : HomeConnectionState.offline;
}

/// Debug-only override for visual QA (README §3f: "switchable via a chip
/// row... for demo/dev purposes"). Null means "no override — use the real
/// computed state."
@Riverpod(keepAlive: true)
class HomeConnectionStateDevOverride extends _$HomeConnectionStateDevOverride {
  @override
  HomeConnectionState? build() => null;

  void set(HomeConnectionState? value) => state = value;
}

/// The state Home actually renders: the dev override when set, otherwise
/// the real computed [homeConnectionStateProvider].
@riverpod
HomeConnectionState effectiveHomeConnectionState(Ref ref) {
  final override = ref.watch(homeConnectionStateDevOverrideProvider);
  return override ?? ref.watch(homeConnectionStateProvider);
}

/// Whether the dev connection-state switcher chip row should render.
/// Defaults to [kDebugMode] but is overridable in tests so both branches
/// (present/absent) can be verified without a release build.
@riverpod
bool showDevConnectionSwitcher(Ref ref) => kDebugMode;

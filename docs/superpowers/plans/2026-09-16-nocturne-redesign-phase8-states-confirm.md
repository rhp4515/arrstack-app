# Nocturne Redesign Phase 8: States + Destructive Confirm Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build Home's empty/loading/offline states (a new `HomeConnectionState` derived value plus a new last-known-summary cache layer) and one shared destructive-confirm dialog consolidating the app's inconsistent delete flows, per `design_handoff_arrstack_hub/README.md` §3f/§3g.

**Architecture:** A new `HomeConnectionState` enum (`unconfigured | loading | offline | ready`) is derived — never persisted — from providers Home already watches, and drives which of four layouts `HomePage` renders. A new cache layer extends the existing `ConfigStore` (same JSON-blob-in-shared_preferences shape as `readInstances`/`writeInstances`) to persist each service's last-successful summary with its own timestamp, written on every successful fetch and read back only for the offline layout. A new `showDestructiveConfirmDialog` widget replaces six hand-rolled `AlertDialog`s at two call sites (torrent delete, instance delete).

**Tech Stack:** Flutter, Riverpod (`riverpod_generator` code-gen, `@riverpod`/`@Riverpod(keepAlive: true)`), `freezed` for models, `shared_preferences` for the cache store, `url_launcher` (already a dependency) for "Open Tailscale".

**Spec:** `docs/superpowers/specs/2026-09-16-nocturne-redesign-phase8-states-confirm-design.md`

## Global Constraints

- No new package dependencies — `url_launcher` is already in `pubspec.yaml`; do not add `hive`/`isar`/a shimmer package.
- Never hardcode colors/spacing/radius/typography — use `AppColors`/`AppSpacing`/`AppRadius`/`AppTypography`/`AppInsets` from `lib/app/theme/design_tokens.dart`.
- `package:` imports only, never relative (`../`) imports, per `dart/coding-style.md`.
- Every fallible storage/network operation returns `Result<T>` (`Ok`/`Err`) or degrades safely — never throws across a provider boundary.
- Any nullable field on a hand-written `copyWith` must use the `_Unset`/`identical` sentinel pattern (see `lib/features/onboarding/onboarding_providers.dart:23-30`), never bare `field ?? this.field` — this plan introduces no hand-written `copyWith`, but if a task adds one, this rule applies.
- `dart format --set-exit-if-changed .` and `dart analyze --fatal-infos` must pass after every task.
- After adding/editing any `@freezed` or `@riverpod` class, run `dart run build_runner build --delete-conflicting-outputs` before running tests.
- Radarr/Sonarr movie/series delete dialogs and Seerr request deletion are explicitly **out of scope** — do not touch `movie_detail_page.dart`, `series_detail_page.dart`, or reintroduce any request-delete UI.
- The debug connection-state switcher must never be reachable outside `kDebugMode` in a real build; route its visibility through the overridable `showDevConnectionSwitcherProvider` (defaults to `kDebugMode`), not a hardcoded `if (kDebugMode)` in the widget tree, so both branches are testable.

---

## Task 1: `CachedServiceSummary` model

**Files:**
- Create: `lib/core/models/cached_service_summary.dart`
- Modify: `lib/core/models/models.dart` (barrel export)
- Test: `test/core/models/cached_service_summary_test.dart`

**Interfaces:**
- Produces: `CachedServiceSummary({required String instanceId, required String instanceName, required ServiceType serviceType, required String summaryLine, required DateTime lastFetchedAt})`, with `.toJson()`/`CachedServiceSummary.fromJson(Map<String, dynamic>)`.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/models/cached_service_summary_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CachedServiceSummary', () {
    test('round-trips through JSON', () {
      final summary = CachedServiceSummary(
        instanceId: 'radarr-1',
        instanceName: 'Home Radarr',
        serviceType: ServiceType.radarr,
        summaryLine: '412 movies · 3 missing',
        lastFetchedAt: DateTime.utc(2026, 9, 16, 12, 30),
      );

      final decoded = CachedServiceSummary.fromJson(summary.toJson());

      expect(decoded, summary);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/models/cached_service_summary_test.dart`
Expected: FAIL — `CachedServiceSummary` is not defined.

- [ ] **Step 3: Write the model**

```dart
// lib/core/models/cached_service_summary.dart
/// One service's last-successful Home summary, persisted with its own
/// fetch timestamp — the data the offline layout (README §3f) falls back
/// to when nothing is currently reachable.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cached_service_summary.freezed.dart';
part 'cached_service_summary.g.dart';

@freezed
abstract class CachedServiceSummary with _$CachedServiceSummary {
  const factory CachedServiceSummary({
    required String instanceId,
    required String instanceName,
    required ServiceType serviceType,
    required String summaryLine,
    required DateTime lastFetchedAt,
  }) = _CachedServiceSummary;

  factory CachedServiceSummary.fromJson(Map<String, dynamic> json) =>
      _$CachedServiceSummaryFromJson(json);
}
```

Add the export to `lib/core/models/models.dart`, alphabetically after `auth_type.dart` and before `endpoint_mode.dart`:

```dart
export 'package:arrstack/core/models/auth_type.dart';
export 'package:arrstack/core/models/cached_service_summary.dart';
export 'package:arrstack/core/models/endpoint_mode.dart';
```

- [ ] **Step 4: Generate code and run the test**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/core/models/cached_service_summary_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/core/models/cached_service_summary.dart lib/core/models/cached_service_summary.freezed.dart lib/core/models/cached_service_summary.g.dart lib/core/models/models.dart test/core/models/cached_service_summary_test.dart
git commit -m "feat(home): add CachedServiceSummary model"
```

---

## Task 2: Cache storage — `ConfigStore` methods + `cachedServiceSummariesProvider`

**Files:**
- Modify: `lib/core/storage/config_store.dart`
- Modify: `test/core/storage/fakes.dart`
- Modify: `lib/core/storage/storage_providers.dart`
- Test: `test/core/storage/storage_providers_test.dart` (new file — none exists for this file today; provider tests for `cachedServiceSummariesProvider` live here since it's a `storage_providers.dart` provider, matching where `configStoreProvider` etc. are declared)

**Interfaces:**
- Consumes: `CachedServiceSummary.fromJson`/`.toJson` (Task 1).
- Produces: `ConfigStore.readCachedSummaries() → Future<List<Map<String, dynamic>>>`, `ConfigStore.writeCachedSummaries(List<Map<String, dynamic>>) → Future<void>`; `cachedServiceSummariesProvider → Future<List<CachedServiceSummary>>` (keepAlive).

- [ ] **Step 1: Write the failing test**

```dart
// test/core/storage/storage_providers_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('cachedServiceSummariesProvider', () {
    test('decodes cached summaries written to ConfigStore', () async {
      final configStore = FakeConfigStore();
      await configStore.writeCachedSummaries([
        CachedServiceSummary(
          instanceId: 'radarr-1',
          instanceName: 'Home Radarr',
          serviceType: ServiceType.radarr,
          summaryLine: '412 movies · 3 missing',
          lastFetchedAt: DateTime.utc(2026, 9, 16, 12),
        ).toJson(),
      ]);

      final container = ProviderContainer(
        overrides: [configStoreProvider.overrideWithValue(configStore)],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(result, hasLength(1));
      expect(result.single.instanceId, 'radarr-1');
    });

    test('skips a corrupt entry rather than discarding the whole cache', () async {
      final configStore = FakeConfigStore();
      final valid = CachedServiceSummary(
        instanceId: 'radarr-1',
        instanceName: 'Home Radarr',
        serviceType: ServiceType.radarr,
        summaryLine: '412 movies',
        lastFetchedAt: DateTime.utc(2026, 9, 16, 12),
      ).toJson();
      await configStore.writeCachedSummaries([
        valid,
        <String, dynamic>{'instanceId': 'broken'},
      ]);

      final container = ProviderContainer(
        overrides: [configStoreProvider.overrideWithValue(configStore)],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(result, hasLength(1));
      expect(result.single.instanceId, 'radarr-1');
    });

    test('returns an empty list when nothing is cached', () async {
      final container = ProviderContainer(
        overrides: [
          configStoreProvider.overrideWithValue(FakeConfigStore()),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(result, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/storage/storage_providers_test.dart`
Expected: FAIL — `writeCachedSummaries` and `cachedServiceSummariesProvider` are not defined.

- [ ] **Step 3: Extend `ConfigStore`**

In `lib/core/storage/config_store.dart`, add to the abstract interface (after `writeThemeMode`):

```dart
  /// The persisted last-known-good service summaries, as raw JSON maps
  /// (the caller decodes them via [CachedServiceSummary.fromJson]) — used
  /// by the offline layout (README §3f) to show stale-but-honest data.
  Future<List<Map<String, dynamic>>> readCachedSummaries();

  /// Persists the full cached-summary list (raw JSON maps).
  Future<void> writeCachedSummaries(List<Map<String, dynamic>> summaries);
```

Add the key constant next to the others:

```dart
const String _cachedSummariesKey = 'config.cachedSummaries';
```

Add the implementation to `SharedPreferencesConfigStore`, mirroring `readInstances`/`writeInstances` exactly:

```dart
  @override
  Future<List<Map<String, dynamic>>> readCachedSummaries() async {
    final raw = await _preferences.getString(_cachedSummariesKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> writeCachedSummaries(List<Map<String, dynamic>> summaries) {
    return _preferences.setString(_cachedSummariesKey, jsonEncode(summaries));
  }
```

- [ ] **Step 4: Extend `FakeConfigStore`**

In `test/core/storage/fakes.dart`, add to `FakeConfigStore`:

```dart
  List<Map<String, dynamic>> _cachedSummaries = const [];

  @override
  Future<List<Map<String, dynamic>>> readCachedSummaries() async =>
      _cachedSummaries;

  @override
  Future<void> writeCachedSummaries(
    List<Map<String, dynamic>> summaries,
  ) async {
    _cachedSummaries = List.unmodifiable(summaries);
  }
```

- [ ] **Step 5: Add `cachedServiceSummariesProvider`**

In `lib/core/storage/storage_providers.dart`, add the import:

```dart
import 'package:json_annotation/json_annotation.dart';
```

Add the provider:

```dart
/// Each service's last-successful summary, read back for Home's offline
/// layout (README §3f `lastKnown`). A corrupt individual entry is skipped
/// rather than discarding the whole cache — these are independent
/// per-service records, unlike the all-or-nothing instance list.
@Riverpod(keepAlive: true)
Future<List<CachedServiceSummary>> cachedServiceSummaries(Ref ref) async {
  final raw = await ref.watch(configStoreProvider).readCachedSummaries();
  final summaries = <CachedServiceSummary>[];
  for (final json in raw) {
    try {
      summaries.add(CachedServiceSummary.fromJson(json));
    } on FormatException {
      continue;
    } on CheckedFromJsonException {
      continue;
    } on TypeError {
      continue;
    } on ArgumentError {
      continue;
    }
  }
  return List.unmodifiable(summaries);
}
```

- [ ] **Step 6: Run test to verify it passes**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/core/storage/storage_providers_test.dart`
Expected: PASS

- [ ] **Step 7: Full-suite regression check**

Run: `flutter test`
Expected: All existing tests still PASS.

- [ ] **Step 8: Commit**

```bash
git add lib/core/storage/config_store.dart lib/core/storage/storage_providers.dart lib/core/storage/storage_providers.g.dart test/core/storage/fakes.dart test/core/storage/storage_providers_test.dart
git commit -m "feat(storage): add the last-known-summary cache store and provider"
```

---

## Task 3: `HomeConnectionState`

**Files:**
- Create: `lib/features/home/home_connection_providers.dart`
- Test: `test/features/home/home_connection_providers_test.dart`

**Interfaces:**
- Consumes: `instancesProvider`, `homeServiceSummariesProvider`, `rightNowProvider` (all existing, from `lib/features/home/home_providers.dart` / `lib/core/storage/storage_providers.dart`).
- Produces: `enum HomeConnectionState { unconfigured, loading, offline, ready }`; `homeConnectionStateProvider → HomeConnectionState` (synchronous — see note below); `HomeConnectionStateDevOverride` (`@Riverpod(keepAlive: true) class`, state `HomeConnectionState?`, method `set(HomeConnectionState? value)`); `effectiveHomeConnectionStateProvider → HomeConnectionState` (synchronous); `showDevConnectionSwitcherProvider → bool`.

**Why synchronous, not `Future<HomeConnectionState>`:** an async version that does `await ref.watch(instancesProvider.future)` and then synchronously checks `homeServiceSummariesProvider`/`rightNowProvider`'s `AsyncValue` has a deterministic bug — those two providers are being watched for the first time at that exact point, so they are always in their initial `AsyncLoading` state (a Dart async `Future` can never resolve within the same synchronous continuation that creates it). The async wrapper's own `Future` then resolves to `HomeConnectionState.loading` immediately and is handed to whoever awaited `.future` — permanently, since that specific `Future` has already completed and Riverpod's later recomputation (once the dependencies genuinely resolve) has no path back to that already-resolved value. Making the provider synchronous (return `HomeConnectionState` directly, watching all three source providers' `AsyncValue`s in one pass) fixes this: Riverpod re-invokes a synchronous provider's build automatically whenever a watched dependency's `AsyncValue` changes, so callers that `ref.watch()` it in a widget observe it transition from `loading` to its final state exactly like any other reactive Riverpod state. Callers in tests that want the settled value pre-warm the dependencies first (`await container.read(xProvider.future)`) before reading this provider synchronously.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/home/home_connection_providers_test.dart
import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  group('homeConnectionStateProvider', () {
    test('is loading before instances resolve', () {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith(
            (ref) => Completer<Result<List<ServiceInstance>>>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.loading,
      );
    });

    test('is unconfigured when there are no instances', () async {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => const Ok([])),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.unconfigured,
      );
    });

    test('is loading on the initial fetch, before summaries resolve', () async {
      final radarr = buildInstance(
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeServiceSummariesProvider.overrideWith(
            (ref) => Completer<List<HomeServiceSummary>>().future,
          ),
          rightNowProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.loading,
      );
    });

    test('is offline when instances exist but nothing is reachable', () async {
      final radarr = buildInstance(
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              HomeServiceSummary(
                instanceId: radarr.id,
                instanceName: radarr.name,
                serviceType: ServiceType.radarr,
                isReachable: false,
                summaryLine: 'Unreachable',
                statusLabel: 'Unreachable',
              ),
            ],
          ),
          rightNowProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);
      await container.read(homeServiceSummariesProvider.future);
      await container.read(rightNowProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.offline,
      );
    });

    test('is ready when at least one service is reachable', () async {
      final radarr = buildInstance(
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              HomeServiceSummary(
                instanceId: radarr.id,
                instanceName: radarr.name,
                serviceType: ServiceType.radarr,
                isReachable: true,
                summaryLine: '412 movies',
              ),
            ],
          ),
          rightNowProvider.overrideWith((ref) async => null),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);
      await container.read(homeServiceSummariesProvider.future);
      await container.read(rightNowProvider.future);

      expect(
        container.read(homeConnectionStateProvider),
        HomeConnectionState.ready,
      );
    });

    test(
      'is ready when only qBittorrent is configured and it is reachable',
      () async {
        final qbit = buildInstance(
          id: 'qbit-1',
          serviceType: ServiceType.qbittorrent,
          isDefault: true,
        );
        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => Ok([qbit])),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
            rightNowProvider.overrideWith(
              (ref) async => const RightNowSummary(
                downloadSpeed: 100,
                uploadSpeed: 0,
                downloadingCount: 1,
                seedingCount: 0,
                downloadingFraction: 1,
                pausedOrStalledFraction: 0,
                queuedFraction: 0,
              ),
            ),
          ],
        );
        addTearDown(container.dispose);
        await container.read(instancesProvider.future);
        await container.read(homeServiceSummariesProvider.future);
        await container.read(rightNowProvider.future);

        expect(
          container.read(homeConnectionStateProvider),
          HomeConnectionState.ready,
        );
      },
    );
  });

  group('effectiveHomeConnectionStateProvider', () {
    test('uses the real computed state when no override is set', () async {
      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => const Ok([])),
        ],
      );
      addTearDown(container.dispose);
      await container.read(instancesProvider.future);

      expect(
        container.read(effectiveHomeConnectionStateProvider),
        HomeConnectionState.unconfigured,
      );
    });

    test(
      'uses the dev override when set, ignoring the real computed state',
      () async {
        final container = ProviderContainer(
          overrides: [
            instancesProvider.overrideWith((ref) async => const Ok([])),
          ],
        );
        addTearDown(container.dispose);
        await container.read(instancesProvider.future);

        container
            .read(homeConnectionStateDevOverrideProvider.notifier)
            .set(HomeConnectionState.offline);

        expect(
          container.read(effectiveHomeConnectionStateProvider),
          HomeConnectionState.offline,
        );
      },
    );
  });

  group('showDevConnectionSwitcherProvider', () {
    test('defaults to kDebugMode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(showDevConnectionSwitcherProvider), kDebugMode);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/home_connection_providers_test.dart`
Expected: FAIL — the file doesn't exist yet.

- [ ] **Step 3: Write the providers**

```dart
// lib/features/home/home_connection_providers.dart
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

/// Synchronous by design — see "Why synchronous" above. Watches all three
/// source providers' `AsyncValue`s in one pass so Riverpod's own
/// dependency tracking re-invokes this build automatically as each
/// resolves, rather than this provider trying to await-then-peek them.
@riverpod
HomeConnectionState homeConnectionState(Ref ref) {
  final instancesAsync = ref.watch(instancesProvider);
  if (instancesAsync.isLoading && !instancesAsync.hasValue) {
    return HomeConnectionState.loading;
  }
  final instances = switch (instancesAsync.valueOrNull) {
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

  final summaries = summariesAsync.valueOrNull ?? const [];
  final rightNow = rightNowAsync.valueOrNull;
  final anyReachable =
      summaries.any((s) => s.isReachable) || rightNow != null;
  return anyReachable
      ? HomeConnectionState.ready
      : HomeConnectionState.offline;
}

/// Debug-only override for visual QA (README §3f: "switchable via a chip
/// row... for demo/dev purposes"). Null means "no override — use the real
/// computed state."
@Riverpod(keepAlive: true)
class HomeConnectionStateDevOverride
    extends _$HomeConnectionStateDevOverride {
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
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/home/home_connection_providers_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/home_connection_providers.dart lib/features/home/home_connection_providers.g.dart test/features/home/home_connection_providers_test.dart
git commit -m "feat(home): add HomeConnectionState derivation and dev override"
```

---

## Task 4: Cache write-through in `homeServiceSummariesProvider`

**Files:**
- Modify: `lib/features/home/home_providers.dart`
- Modify: `test/features/home/home_providers_test.dart`

**Interfaces:**
- Consumes: `CachedServiceSummary` (Task 1), `configStoreProvider`/`cachedServiceSummariesProvider` (Task 2) — all already imported into this file via `models.dart`/`storage_providers.dart`.

- [ ] **Step 1: Write the failing tests**

Add `import '../../core/storage/fakes.dart';` to the top of `test/features/home/home_providers_test.dart`, then append this group inside `main()`:

```dart
  group('homeServiceSummariesProvider cache write-through', () {
    test('caches a reachable summary with the current timestamp', () async {
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final configStore = FakeConfigStore();

      final container = ProviderContainer(
        overrides: [
          configStoreProvider.overrideWithValue(configStore),
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          radarrMoviesProvider(radarr.id).overrideWith(
            (ref) async =>
                const Ok([RadarrMovie(hasFile: true, monitored: true)]),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeServiceSummariesProvider.future);

      final cached = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(cached, hasLength(1));
      expect(cached.single.instanceId, 'radarr-1');
      expect(
        DateTime.now().difference(cached.single.lastFetchedAt).inSeconds,
        lessThan(5),
      );
    });

    test(
      "a currently-unreachable service's stale cache entry survives a "
      'write-through triggered by a different service succeeding',
      () async {
        final radarr = buildInstance(
          id: 'radarr-1',
          serviceType: ServiceType.radarr,
          isDefault: true,
        );
        final bazarr = buildInstance(
          id: 'bazarr-1',
          serviceType: ServiceType.bazarr,
          isDefault: true,
        );
        final configStore = FakeConfigStore();
        final staleTimestamp = DateTime.now().subtract(
          const Duration(hours: 1),
        );
        await configStore.writeCachedSummaries([
          CachedServiceSummary(
            instanceId: 'bazarr-1',
            instanceName: 'Home Bazarr',
            serviceType: ServiceType.bazarr,
            summaryLine: '4 wanted subtitles',
            lastFetchedAt: staleTimestamp,
          ).toJson(),
        ]);

        final container = ProviderContainer(
          overrides: [
            configStoreProvider.overrideWithValue(configStore),
            instancesProvider.overrideWith(
              (ref) async => Ok([radarr, bazarr]),
            ),
            radarrMoviesProvider(
              radarr.id,
            ).overrideWith((ref) async => const Ok([])),
            bazarrWantedProvider(
              bazarr.id,
            ).overrideWith((ref) async => const Err(NetworkError())),
          ],
        );
        addTearDown(container.dispose);

        await container.read(homeServiceSummariesProvider.future);

        final cached = await container.read(
          cachedServiceSummariesProvider.future,
        );
        expect(cached, hasLength(2));
        final bazarrEntry = cached.firstWhere(
          (c) => c.instanceId == 'bazarr-1',
        );
        expect(bazarrEntry.lastFetchedAt, staleTimestamp);
        final radarrEntry = cached.firstWhere(
          (c) => c.instanceId == 'radarr-1',
        );
        expect(
          DateTime.now().difference(radarrEntry.lastFetchedAt).inSeconds,
          lessThan(5),
        );
      },
    );

    test('does not write to cache when nothing is reachable', () async {
      final radarr = buildInstance(
        id: 'radarr-1',
        serviceType: ServiceType.radarr,
        isDefault: true,
      );
      final configStore = FakeConfigStore();

      final container = ProviderContainer(
        overrides: [
          configStoreProvider.overrideWithValue(configStore),
          instancesProvider.overrideWith((ref) async => Ok([radarr])),
          radarrMoviesProvider(
            radarr.id,
          ).overrideWith((ref) async => const Err(NetworkError())),
        ],
      );
      addTearDown(container.dispose);

      await container.read(homeServiceSummariesProvider.future);

      final cached = await container.read(
        cachedServiceSummariesProvider.future,
      );
      expect(cached, isEmpty);
    });
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/home_providers_test.dart`
Expected: FAIL — `configStoreProvider`/`cachedServiceSummariesProvider` overrides have no effect yet since nothing writes to the cache.

- [ ] **Step 3: Add the write-through**

In `lib/features/home/home_providers.dart`, modify `homeServiceSummaries`:

```dart
@riverpod
Future<List<HomeServiceSummary>> homeServiceSummaries(Ref ref) async {
  final instancesResult = await ref.watch(instancesProvider.future);
  if (instancesResult is! Ok<List<ServiceInstance>>) return [];
  final instances = instancesResult.value;

  final types = instances
      .map((i) => i.serviceType)
      .where((t) => t != ServiceType.qbittorrent)
      .toSet();

  final summaries = <HomeServiceSummary>[];
  for (final type in types) {
    final instance = _defaultInstanceOfType(instances, type);
    if (instance == null) continue;
    summaries.add(await _summaryFor(ref, instance));
  }

  await _cacheReachableSummaries(ref, summaries);
  return summaries;
}

/// Write-through cache (README §3f `lastKnown`): upserts every reachable
/// summary by instanceId, leaving cached entries for currently-unreachable
/// or since-removed services untouched, so a partial outage doesn't wipe
/// out other services' last-known-good data.
Future<void> _cacheReachableSummaries(
  Ref ref,
  List<HomeServiceSummary> summaries,
) async {
  final reachable = summaries.where((s) => s.isReachable);
  if (reachable.isEmpty) return;

  final configStore = ref.read(configStoreProvider);
  final existingRaw = await configStore.readCachedSummaries();
  final existing = <String, Map<String, dynamic>>{
    for (final json in existingRaw)
      if (json['instanceId'] is String) json['instanceId'] as String: json,
  };

  final now = DateTime.now();
  for (final summary in reachable) {
    existing[summary.instanceId] = CachedServiceSummary(
      instanceId: summary.instanceId,
      instanceName: summary.instanceName,
      serviceType: summary.serviceType,
      summaryLine: summary.summaryLine,
      lastFetchedAt: now,
    ).toJson();
  }

  await configStore.writeCachedSummaries(existing.values.toList());
  ref.invalidate(cachedServiceSummariesProvider);
}
```

No new imports needed — `models.dart` (for `CachedServiceSummary`) and `storage_providers.dart` (for `configStoreProvider`/`cachedServiceSummariesProvider`) are already imported in this file.

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/home/home_providers_test.dart`
Expected: PASS (all tests in this file, old and new)

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/home_providers.dart test/features/home/home_providers_test.dart
git commit -m "feat(home): write reachable summaries through to the cache on every fetch"
```

---

## Task 5: Shared destructive confirm dialog

**Files:**
- Create: `lib/core/widgets/confirm_dialog.dart`
- Test: `test/core/widgets/confirm_dialog_test.dart`

**Interfaces:**
- Produces: `class ConfirmDialogResult { final bool deleteFiles; const ConfirmDialogResult({this.deleteFiles = false}); }`; `Future<ConfirmDialogResult?> showDestructiveConfirmDialog(BuildContext context, {required String title, required String message, String cancelLabel = 'Cancel', String confirmLabel = 'Remove', bool showDeleteFilesToggle = false, String deleteFilesTitle = 'Also delete files on disk', String? deleteFilesSubtitle})`.

- [ ] **Step 1: Write the failing tests**

```dart
// test/core/widgets/confirm_dialog_test.dart
import 'dart:async';

import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return capturedContext;
  }

  testWidgets('cancel returns null', (tester) async {
    final context = await pumpHost(tester);
    ConfirmDialogResult? result;

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this torrent?',
        message: 'It will be removed from qBittorrent.',
      ).then((value) => result = value),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });

  testWidgets('confirm with the toggle off returns deleteFiles: false', (
    tester,
  ) async {
    final context = await pumpHost(tester);
    ConfirmDialogResult? result;

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this torrent?',
        message: 'It will be removed from qBittorrent.',
        showDeleteFilesToggle: true,
        deleteFilesSubtitle: '1.4 GB downloaded so far',
      ).then((value) => result = value),
    );
    await tester.pumpAndSettle();

    expect(find.text('Also delete files on disk'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.deleteFiles, isFalse);
  });

  testWidgets('toggling on before confirming returns deleteFiles: true', (
    tester,
  ) async {
    final context = await pumpHost(tester);
    ConfirmDialogResult? result;

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this torrent?',
        message: 'It will be removed from qBittorrent.',
        showDeleteFilesToggle: true,
      ).then((value) => result = value),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(result!.deleteFiles, isTrue);
  });

  testWidgets('the toggle is hidden by default', (tester) async {
    final context = await pumpHost(tester);

    unawaited(
      showDestructiveConfirmDialog(
        context,
        title: 'Remove this instance?',
        message: 'This removes it and its stored credentials.',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Switch), findsNothing);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/core/widgets/confirm_dialog_test.dart`
Expected: FAIL — the file doesn't exist yet.

- [ ] **Step 3: Write the widget**

```dart
// lib/core/widgets/confirm_dialog.dart
/// One shared destructive-confirm dialog for all delete flows (README
/// §3g): a title, a body naming the real consequence, an optional
/// off-by-default "delete files" toggle, and Cancel/Remove actions.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:flutter/material.dart';

class ConfirmDialogResult {
  const ConfirmDialogResult({this.deleteFiles = false});

  final bool deleteFiles;
}

/// Shows the shared destructive-confirm dialog. Returns null if the user
/// cancels or dismisses it, or a [ConfirmDialogResult] if they confirm.
Future<ConfirmDialogResult?> showDestructiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Remove',
  bool showDeleteFilesToggle = false,
  String deleteFilesTitle = 'Also delete files on disk',
  String? deleteFilesSubtitle,
}) {
  return showDialog<ConfirmDialogResult>(
    context: context,
    builder: (context) => _ConfirmDialog(
      title: title,
      message: message,
      cancelLabel: cancelLabel,
      confirmLabel: confirmLabel,
      showDeleteFilesToggle: showDeleteFilesToggle,
      deleteFilesTitle: deleteFilesTitle,
      deleteFilesSubtitle: deleteFilesSubtitle,
    ),
  );
}

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.showDeleteFilesToggle,
    required this.deleteFilesTitle,
    required this.deleteFilesSubtitle,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final bool showDeleteFilesToggle;
  final String deleteFilesTitle;
  final String? deleteFilesSubtitle;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  bool _deleteFiles = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.surface : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppTypography.sectionTitle.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              widget.message,
              style: AppTypography.body.copyWith(
                color: isDark ? AppColors.n400 : colorScheme.onSurfaceVariant,
              ),
            ),
            if (widget.showDeleteFilesToggle) ...[
              const SizedBox(height: AppSpacing.space4),
              LabeledToggleRow(
                title: widget.deleteFilesTitle,
                subtitle: widget.deleteFilesSubtitle ?? '',
                value: _deleteFiles,
                onChanged: (value) => setState(() => _deleteFiles = value),
              ),
            ],
            const SizedBox(height: AppSpacing.space6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.n400
                          : colorScheme.onSurfaceVariant,
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Text(widget.cancelLabel),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(
                      context,
                      ConfirmDialogResult(deleteFiles: _deleteFiles),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.down,
                      side: const BorderSide(color: AppColors.down),
                    ),
                    child: Text(widget.confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/core/widgets/confirm_dialog_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/confirm_dialog.dart test/core/widgets/confirm_dialog_test.dart
git commit -m "feat(widgets): add the shared destructive confirm dialog"
```

---

## Task 6: Wire the confirm dialog into torrent delete

**Files:**
- Modify: `lib/features/activity/widgets/torrent_block.dart`
- Modify: `test/features/activity/widgets/torrent_block_test.dart`

**Interfaces:**
- Consumes: `showDestructiveConfirmDialog`/`ConfirmDialogResult` (Task 5).

- [ ] **Step 1: Update the failing/changed tests**

In `test/features/activity/widgets/torrent_block_test.dart`, replace the two delete tests (`'downloading delete button calls deleteTorrents with hash'` and `'stalled delete button calls deleteTorrents non-destructively'`) with:

```dart
  testWidgets('downloading delete button opens the shared confirm dialog', (
    tester,
  ) async {
    final fakeRepo = FakeQbitRepository();
    await _pump(
      tester,
      _torrent(state: 'downloading'),
      fakeRepository: fakeRepo,
    );

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Remove this torrent?'), findsOneWidget);
    expect(find.text('Also delete files on disk'), findsOneWidget);

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(fakeRepo.deletedHashes, contains('h1'));
    expect(fakeRepo.deleteFilesMap['h1'], isFalse);
  });

  testWidgets('downloading delete cancel does not delete anything', (
    tester,
  ) async {
    final fakeRepo = FakeQbitRepository();
    await _pump(
      tester,
      _torrent(state: 'downloading'),
      fakeRepository: fakeRepo,
    );

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(fakeRepo.deletedHashes, isEmpty);
  });

  testWidgets(
    'stalled delete button now opens the shared confirm dialog '
    '(previously deleted with no confirmation at all)',
    (tester) async {
      final fakeRepo = FakeQbitRepository();
      await _pump(
        tester,
        _torrent(state: 'stalledDL'),
        fakeRepository: fakeRepo,
      );

      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Remove this torrent?'), findsOneWidget);
      expect(fakeRepo.deletedHashes, isEmpty);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(fakeRepo.deletedHashes, contains('h1'));
      expect(fakeRepo.deleteFilesMap['h1'], isFalse);
    },
  );
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/torrent_block_test.dart`
Expected: FAIL — the old `AlertDialog`/"Delete Torrent?" copy is still in place, so `'Remove this torrent?'` isn't found and the stalled path still deletes immediately with no dialog.

- [ ] **Step 3: Wire the dialog**

In `lib/features/activity/widgets/torrent_block.dart`, add the import:

```dart
import 'package:arrstack/core/widgets/confirm_dialog.dart';
```

Replace `_DownloadingBlock._confirmDelete`:

```dart
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Remove this torrent?',
      message:
          '"${torrent.name}" will be removed from qBittorrent. If Sonarr '
          'or Radarr is still monitoring it, they may grab it again.',
      showDeleteFilesToggle: true,
      deleteFilesSubtitle:
          '${FormatUtils.formatBytes((torrent.size * torrent.progress).round())} '
          'downloaded so far',
    );

    if (!context.mounted || result == null) return;
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    await repository.deleteTorrents(
      [torrent.hash],
      deleteFiles: result.deleteFiles,
    );
    if (!context.mounted) return;
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }
```

Replace `_StalledBlock._delete` with `_confirmDelete` (same body as above, since both blocks now share the identical confirm-then-delete flow), and update its `_IconAction`'s `onPressed` from `() => _delete(context, ref)` to `() => _confirmDelete(context, ref)`:

```dart
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Remove this torrent?',
      message:
          '"${torrent.name}" will be removed from qBittorrent. If Sonarr '
          'or Radarr is still monitoring it, they may grab it again.',
      showDeleteFilesToggle: true,
      deleteFilesSubtitle:
          '${FormatUtils.formatBytes((torrent.size * torrent.progress).round())} '
          'downloaded so far',
    );

    if (!context.mounted || result == null) return;
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    await repository.deleteTorrents(
      [torrent.hash],
      deleteFiles: result.deleteFiles,
    );
    if (!context.mounted) return;
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }
```

Delete the old `showDialog<bool>`/`StatefulBuilder`/`AlertDialog`/`CheckboxListTile` code from both methods.

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/torrent_block_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/torrent_block.dart test/features/activity/widgets/torrent_block_test.dart
git commit -m "fix(activity): use the shared confirm dialog for torrent delete, fixing the stalled-torrent no-confirm gap"
```

---

## Task 7: Wire the confirm dialog into instance delete

**Files:**
- Modify: `lib/features/onboarding/add_instance_page.dart`
- Modify: `lib/features/settings/settings_page.dart`
- Modify: `test/core/storage/fakes.dart`
- Modify: `test/features/onboarding/add_instance_page_test.dart`
- Modify: `test/features/settings/settings_page_test.dart`

**Interfaces:**
- Consumes: `showDestructiveConfirmDialog` (Task 5), `InstanceRepository` (`lib/core/storage/instance_repository.dart:14-41`).
- Produces: `FakeInstanceRepository` in `test/core/storage/fakes.dart` (records `deletedIds`).

- [ ] **Step 1: Add `FakeInstanceRepository` and write the failing tests**

Add the required import at the top of `test/core/storage/fakes.dart`:

```dart
import 'package:arrstack/core/network/network.dart';
```

Append to `test/core/storage/fakes.dart`:

```dart
class FakeInstanceRepository implements InstanceRepository {
  final List<String> deletedIds = [];

  @override
  Future<Result<List<ServiceInstance>>> list() async => const Ok([]);

  @override
  Future<Result<ServiceInstance>> getById(String id) async =>
      Err(NotFoundError(userMessage: 'Not found: $id'));

  @override
  Future<Result<ServiceInstance>> add(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) async => Ok(instance);

  @override
  Future<Result<ServiceInstance>> update(
    ServiceInstance instance, {
    ServiceCredential? credential,
  }) async => Ok(instance);

  @override
  Future<Result<void>> delete(String id) async {
    deletedIds.add(id);
    return const Ok(null);
  }

  @override
  Future<Result<ServiceInstance>> setDefault(String id) async =>
      Err(NotFoundError(userMessage: 'Not found: $id'));
}
```

Append to `test/features/settings/settings_page_test.dart` (add `import 'package:phosphor_icons/phosphor_icons.dart';` at the top):

```dart
  testWidgets(
    'tapping delete on an instance row opens the shared confirm dialog, '
    'and confirming deletes it',
    (tester) async {
      const instance = ServiceInstance(
        id: 'radarr-1',
        name: 'Radarr 4K',
        serviceType: ServiceType.radarr,
        authType: AuthType.apiKey,
        localBaseUrl: 'http://10.0.0.1:7878',
        endpointMode: EndpointMode.auto,
      );
      final fakeRepository = FakeInstanceRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            configStoreProvider.overrideWithValue(FakeConfigStore()),
            instanceRepositoryProvider.overrideWithValue(fakeRepository),
            instancesProvider.overrideWith(
              (ref) async => const Ok([instance]),
            ),
            homeServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
          ],
          child: const MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(PhosphorIconsRegular.trash));
      await tester.pumpAndSettle();

      expect(find.text('Remove Radarr 4K?'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(fakeRepository.deletedIds, ['radarr-1']);
    },
  );
```

Append to `test/features/onboarding/add_instance_page_test.dart` (add `import 'package:phosphor_icons/phosphor_icons.dart';` at the top):

```dart
  testWidgets(
    'tapping delete on the edit page opens the shared confirm dialog, '
    'and confirming deletes and pops',
    (tester) async {
      final fakeRepository = FakeInstanceRepository();
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const SizedBox()),
          GoRoute(
            path: '/edit',
            builder: (context, state) =>
                const AddInstancePage(instanceId: 'bazarr-1'),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            instanceFormProvider.overrideWith(_FakeFailingInstanceForm.new),
            configStoreProvider.overrideWithValue(FakeConfigStore()),
            instanceRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump();
      router.push('/edit');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(PhosphorIconsRegular.trash));
      await tester.pumpAndSettle();

      expect(find.text('Remove Bazarr?'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();

      expect(fakeRepository.deletedIds, ['bazarr-1']);
    },
  );
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/settings/settings_page_test.dart test/features/onboarding/add_instance_page_test.dart`
Expected: FAIL — both pages still show `'Delete Instance?'`, not `'Remove {name}?'`.

- [ ] **Step 3: Wire the dialog**

In `lib/features/onboarding/add_instance_page.dart`, add the import:

```dart
import 'package:arrstack/core/widgets/confirm_dialog.dart';
```

Change the trash button's `onPressed` from `() => _confirmDelete(context, state.id!)` to `() => _confirmDelete(context, state.id!, state.name)`, and replace `_confirmDelete`:

```dart
  Future<void> _confirmDelete(
    BuildContext context,
    String instanceId,
    String instanceName,
  ) async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Remove $instanceName?',
      message:
          'This removes $instanceName and its stored credentials from '
          'this device. The service itself keeps running elsewhere.',
    );
    if (result == null || !context.mounted) return;
    await ref.read(instanceRepositoryProvider).delete(instanceId);
    ref.invalidate(instancesProvider);
    if (context.mounted) context.pop();
  }
```

In `lib/features/settings/settings_page.dart`, add the import:

```dart
import 'package:arrstack/core/widgets/confirm_dialog.dart';
```

Replace `_InstanceRow._confirmDelete`:

```dart
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Remove ${instance.name}?',
      message:
          'This removes ${instance.name} and its stored credentials '
          'from this device. The service itself keeps running elsewhere.',
    );
    if (result == null) return;
    await ref.read(instanceRepositoryProvider).delete(instance.id);
    ref.invalidate(instancesProvider);
  }
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/settings/settings_page_test.dart test/features/onboarding/add_instance_page_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/onboarding/add_instance_page.dart lib/features/settings/settings_page.dart test/core/storage/fakes.dart test/features/onboarding/add_instance_page_test.dart test/features/settings/settings_page_test.dart
git commit -m "fix(settings,onboarding): consolidate the two instance-delete dialogs onto the shared confirm dialog"
```

---

## Task 8: Loading skeleton

**Files:**
- Create: `lib/features/home/widgets/home_band_skeleton.dart`
- Create: `lib/features/home/widgets/right_now_card_skeleton.dart`
- Create: `lib/features/home/widgets/service_tile_grid_skeleton.dart`
- Create: `lib/features/home/widgets/home_loading_state.dart`
- Test: `test/features/home/widgets/home_loading_state_test.dart`

**Interfaces:**
- Produces: `HomeBandSkeleton`, `RightNowCardSkeleton`, `ServiceTileGridSkeleton` (all `StatelessWidget`, no constructor params besides `key`); `HomeLoadingState` (`ConsumerWidget`, no constructor params).
- Consumes: `instancesProvider` (`lib/core/storage/storage_providers.dart`), `currentSsidProvider` (`lib/core/network/network.dart`).

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/home/widgets/home_loading_state_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/home_band_skeleton.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/right_now_card_skeleton.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../support/fixtures.dart';

void main() {
  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeLoadingState()),
            GoRoute(
              path: '/home/settings',
              builder: (_, _) => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('renders all three skeletons plus the caption with an SSID', (
    tester,
  ) async {
    final radarr = buildInstance(serviceType: ServiceType.radarr);

    await tester.pumpWidget(
      wrap([
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        currentSsidProvider.overrideWith(
          (ref) => Stream.value('Harivin-5G'),
        ),
      ]),
    );
    await tester.pump();

    expect(find.byType(HomeBandSkeleton), findsOneWidget);
    expect(find.byType(RightNowCardSkeleton), findsOneWidget);
    expect(find.byType(ServiceTileGridSkeleton), findsOneWidget);
    expect(
      find.text('Contacting 1 services on Harivin-5G…'),
      findsOneWidget,
    );
  });

  testWidgets('omits "on <ssid>" from the caption when the SSID is null', (
    tester,
  ) async {
    final radarr = buildInstance(serviceType: ServiceType.radarr);

    await tester.pumpWidget(
      wrap([
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        currentSsidProvider.overrideWith((ref) => Stream.value(null)),
      ]),
    );
    await tester.pump();

    expect(find.text('Contacting 1 services…'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/widgets/home_loading_state_test.dart`
Expected: FAIL — none of the four widgets exist yet.

- [ ] **Step 3: Write the skeleton widgets**

```dart
// lib/features/home/widgets/home_band_skeleton.dart
/// Static ghost-block skeleton for the `section` band, shown while Home's
/// initial fetch is in flight (README §3f "a real skeleton of 2c"). The
/// gear button stays real and tappable (dimmed along with the rest of the
/// band, per spec's "0.55 opacity") so Settings stays reachable while
/// loading.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomeBandSkeleton extends StatelessWidget {
  const HomeBandSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.55,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.space6),
        decoration: const BoxDecoration(color: AppColors.section),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ghostBlock(width: 96, height: 24),
                IconButton(
                  icon: const Icon(
                    PhosphorIconsRegular.gear,
                    color: AppColors.text,
                  ),
                  onPressed: () => context.go(RoutePaths.homeSettings),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space6),
            _ghostBlock(width: 72, height: 40),
            const SizedBox(height: AppSpacing.space3),
            _ghostBlock(width: 140, height: 12),
          ],
        ),
      ),
    );
  }

  Widget _ghostBlock({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.sectionGhost.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}
```

```dart
// lib/features/home/widgets/right_now_card_skeleton.dart
/// Static ghost-block skeleton for [RightNowCard] (README §3f "a card
/// skeleton").
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class RightNowCardSkeleton extends StatelessWidget {
  const RightNowCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.n900,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(width: 70, height: 10, color: AppColors.n800),
          const SizedBox(height: AppSpacing.space3),
          _bar(width: 120, height: 16, color: AppColors.n800),
          const SizedBox(height: AppSpacing.space2),
          _bar(width: 160, height: 10, color: AppColors.n800),
        ],
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}
```

```dart
// lib/features/home/widgets/service_tile_grid_skeleton.dart
/// Static 2x2 ghost-block skeleton for [ServiceTileGrid] (README §3f "a
/// 2x2 tile-grid skeleton in neutral-800 (title bars) and neutral-900
/// (meta bars)").
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class ServiceTileGridSkeleton extends StatelessWidget {
  const ServiceTileGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.space4,
      crossAxisSpacing: AppSpacing.space4,
      childAspectRatio: 1.6,
      children: List.generate(4, (_) => const _TileSkeleton()),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.n900,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.n800,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
          const Spacer(),
          Container(
            width: 80,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.n900,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        ],
      ),
    );
  }
}
```

```dart
// lib/features/home/widgets/home_loading_state.dart
/// The loading layout for Home (README §3f): skeletons shaped like the
/// real band/card/grid, plus "Contacting N services on <ssid>…".
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/home_band_skeleton.dart';
import 'package:arrstack/features/home/widgets/right_now_card_skeleton.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLoadingState extends ConsumerWidget {
  const HomeLoadingState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final ssidAsync = ref.watch(currentSsidProvider);
    final instanceCount = switch (instancesAsync.valueOrNull) {
      Ok(:final value) => value.length,
      _ => 0,
    };
    final ssid = ssidAsync.valueOrNull;
    final caption = ssid == null
        ? 'Contacting $instanceCount services…'
        : 'Contacting $instanceCount services on $ssid…';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const HomeBandSkeleton(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              const RightNowCardSkeleton(),
              const SizedBox(height: AppSpacing.space6),
              const ServiceTileGridSkeleton(),
              const SizedBox(height: AppSpacing.space8),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    Text(
                      caption,
                      style: AppTypography.meta,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/home/widgets/home_loading_state_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/widgets/home_band_skeleton.dart lib/features/home/widgets/right_now_card_skeleton.dart lib/features/home/widgets/service_tile_grid_skeleton.dart lib/features/home/widgets/home_loading_state.dart test/features/home/widgets/home_loading_state_test.dart
git commit -m "feat(home): add the real loading skeleton for Home's initial fetch"
```

---

## Task 9: Offline layout

**Files:**
- Create: `lib/features/home/widgets/offline_band.dart`
- Create: `lib/features/home/widgets/cached_summary_row.dart`
- Create: `lib/features/home/widgets/home_offline_state.dart`
- Test: `test/features/home/widgets/home_offline_state_test.dart`

**Interfaces:**
- Consumes: `cachedServiceSummariesProvider` (Task 2), `refreshHome` (existing, `lib/features/home/home_providers.dart:352`), `CachedServiceSummary` (Task 1), `ErrorCard` (existing, `lib/core/widgets/error_card.dart`).
- Produces: `OfflineBand`, `CachedSummaryRow({required CachedServiceSummary summary})`, `HomeOfflineState` (all widgets, no other constructor params).

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/home/widgets/home_offline_state_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows the error card and omits the LAST KNOWN block when the cache '
    'is empty',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => const [],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text('Tailscale looks disconnected'), findsOneWidget);
      expect(find.textContaining('LAST KNOWN'), findsNothing);
      expect(find.byType(CachedSummaryRow), findsNothing);
    },
  );

  testWidgets(
    'shows the LAST KNOWN kicker using the oldest cached timestamp',
    (tester) async {
      final now = DateTime.now();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cachedServiceSummariesProvider.overrideWith(
              (ref) async => [
                CachedServiceSummary(
                  instanceId: 'radarr-1',
                  instanceName: 'Home Radarr',
                  serviceType: ServiceType.radarr,
                  summaryLine: '412 movies',
                  lastFetchedAt: now.subtract(const Duration(minutes: 6)),
                ),
                CachedServiceSummary(
                  instanceId: 'bazarr-1',
                  instanceName: 'Home Bazarr',
                  serviceType: ServiceType.bazarr,
                  summaryLine: '4 wanted subtitles',
                  lastFetchedAt: now.subtract(const Duration(minutes: 2)),
                ),
              ],
            ),
          ],
          child: const MaterialApp(home: HomeOfflineState()),
        ),
      );
      await tester.pump();

      expect(find.text('LAST KNOWN · 6 MIN AGO'), findsOneWidget);
      expect(find.byType(CachedSummaryRow), findsNWidgets(2));
    },
  );
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/widgets/home_offline_state_test.dart`
Expected: FAIL — none of the three widgets exist yet.

- [ ] **Step 3: Write the widgets**

```dart
// lib/features/home/widgets/offline_band.dart
/// The flattened `section` band for Home's offline layout (README §3f):
/// no saturated color or glow when nothing is reachable, a red-ringed
/// "Remote · not on a home network" chip, and an em-dash where the
/// healthy-count numeral would be.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class OfflineBand extends StatelessWidget {
  const OfflineBand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space6),
      decoration: const BoxDecoration(color: AppColors.n900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space3,
                  vertical: AppSpacing.space2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: AppColors.down.withValues(alpha: 0.6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      PhosphorIconsRegular.cloudSlash,
                      size: 14,
                      color: AppColors.down,
                    ),
                    const SizedBox(width: AppSpacing.space2),
                    Text(
                      'Remote · not on a home network',
                      style: AppTypography.meta.copyWith(
                        color: AppColors.down,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  PhosphorIconsRegular.gear,
                  color: AppColors.text,
                ),
                onPressed: () => context.go(RoutePaths.homeSettings),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          Text(
            '—',
            style: AppTypography.heroNumeral.copyWith(color: AppColors.n600),
          ),
        ],
      ),
    );
  }
}
```

```dart
// lib/features/home/widgets/cached_summary_row.dart
/// A single read-only "last known" row on Home's offline layout (README
/// §3f): grey status dot, name, cached summary line, trailing clock icon.
/// Deliberately has no tap handler — cached data being non-interactive is
/// a structural fact, not a convention that could drift.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class CachedSummaryRow extends StatelessWidget {
  const CachedSummaryRow({required this.summary, super.key});

  final CachedServiceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.n600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.instanceName, style: AppTypography.cardTitle),
                Text(
                  summary.summaryLine,
                  style: AppTypography.meta.copyWith(color: AppColors.n500),
                ),
              ],
            ),
          ),
          const Icon(
            PhosphorIconsRegular.clockCounterClockwise,
            size: 13,
            color: AppColors.n600,
          ),
        ],
      ),
    );
  }
}
```

```dart
// lib/features/home/widgets/home_offline_state.dart
/// The offline layout for Home (README §3f): the flattened band, the
/// "Tailscale looks disconnected" error card, then a read-only "last
/// known" block built from the summary cache.
library;

import 'dart:async';

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/offline_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeOfflineState extends ConsumerWidget {
  const HomeOfflineState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedAsync = ref.watch(cachedServiceSummariesProvider);
    final cached = cachedAsync.valueOrNull ?? const [];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const OfflineBand(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              ErrorCard(
                title: 'Tailscale looks disconnected',
                message:
                    'All remote URLs timed out. On cellular the app needs '
                    'Tailscale up to reach your stack.',
                primaryActionLabel: 'Retry all',
                onPrimaryAction: () => refreshHome(ref),
                secondaryActionLabel: 'Open Tailscale',
                onSecondaryAction: _openTailscale,
              ),
              if (cached.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space6),
                Text(
                  'LAST KNOWN · ${_staleness(cached)} MIN AGO',
                  style: AppTypography.kicker,
                ),
                const SizedBox(height: AppSpacing.space2),
                for (final summary in cached)
                  CachedSummaryRow(summary: summary),
              ],
              const SizedBox(height: AppSpacing.space6),
              Text(
                'Cached figures are read-only — actions stay disabled '
                'until a service answers.',
                style: AppTypography.meta,
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }

  int _staleness(List<CachedServiceSummary> cached) {
    final oldest = cached
        .map((s) => s.lastFetchedAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    return DateTime.now().difference(oldest).inMinutes;
  }

  void _openTailscale() {
    unawaited(launchUrl(Uri.parse('tailscale://')).catchError((_) => false));
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/home/widgets/home_offline_state_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/widgets/offline_band.dart lib/features/home/widgets/cached_summary_row.dart lib/features/home/widgets/home_offline_state.dart test/features/home/widgets/home_offline_state_test.dart
git commit -m "feat(home): add the offline layout with read-only cached summaries"
```

---

## Task 10: Dev connection-state switcher chip row

**Files:**
- Create: `lib/features/home/widgets/connection_state_dev_chip_row.dart`
- Test: `test/features/home/widgets/connection_state_dev_chip_row_test.dart`

**Interfaces:**
- Consumes: `HomeConnectionState`, `HomeConnectionStateDevOverride`/`homeConnectionStateDevOverrideProvider` (Task 3).
- Produces: `ConnectionStateDevChipRow` (`ConsumerWidget`, no constructor params).

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/home/widgets/connection_state_dev_chip_row_test.dart
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a chip per HomeConnectionState plus Live', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: ConnectionStateDevChipRow()),
        ),
      ),
    );

    expect(find.text('Live'), findsOneWidget);
    for (final state in HomeConnectionState.values) {
      expect(find.text(state.name), findsOneWidget);
    }
  });

  testWidgets('tapping a chip sets the dev override', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: ConnectionStateDevChipRow()),
        ),
      ),
    );

    await tester.tap(find.text('offline'));
    await tester.pump();

    expect(
      container.read(homeConnectionStateDevOverrideProvider),
      HomeConnectionState.offline,
    );
  });

  testWidgets('tapping Live clears the dev override', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(homeConnectionStateDevOverrideProvider.notifier)
        .set(HomeConnectionState.offline);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: ConnectionStateDevChipRow()),
        ),
      ),
    );

    await tester.tap(find.text('Live'));
    await tester.pump();

    expect(container.read(homeConnectionStateDevOverrideProvider), isNull);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/widgets/connection_state_dev_chip_row_test.dart`
Expected: FAIL — the widget doesn't exist yet.

- [ ] **Step 3: Write the widget**

```dart
// lib/features/home/widgets/connection_state_dev_chip_row.dart
/// Debug-only chip row to switch Home's rendered [HomeConnectionState] for
/// visual QA (README §3f: "switchable via a chip row... for demo/dev
/// purposes"). Only ever mounted when [showDevConnectionSwitcherProvider]
/// is true — real production builds never render this.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionStateDevChipRow extends ConsumerWidget {
  const ConnectionStateDevChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(homeConnectionStateDevOverrideProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.space2,
      ),
      child: Row(
        children: [
          _chip(ref, label: 'Live', value: null, active: override == null),
          for (final state in HomeConnectionState.values)
            _chip(
              ref,
              label: state.name,
              value: state,
              active: override == state,
            ),
        ],
      ),
    );
  }

  Widget _chip(
    WidgetRef ref, {
    required String label,
    required HomeConnectionState? value,
    required bool active,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.space2),
      child: InkWell(
        onTap: () => ref
            .read(homeConnectionStateDevOverrideProvider.notifier)
            .set(value),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space3,
            vertical: AppSpacing.space2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: active ? AppColors.accent : AppColors.divider,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.chipLabel.copyWith(
              color: active ? AppColors.accent : AppColors.n400,
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/home/widgets/connection_state_dev_chip_row_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/widgets/connection_state_dev_chip_row.dart test/features/home/widgets/connection_state_dev_chip_row_test.dart
git commit -m "feat(home): add the debug-only connection-state switcher chip row"
```

---

## Task 11: "What's supported?" bottom sheet

**Files:**
- Create: `lib/features/home/widgets/supported_services_sheet.dart`
- Test: `test/features/home/widgets/supported_services_sheet_test.dart`

**Interfaces:**
- Produces: `SupportedServicesSheet` (`StatelessWidget`); `Future<void> showSupportedServicesSheet(BuildContext context)`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/home/widgets/supported_services_sheet_test.dart
import 'package:arrstack/features/home/widgets/supported_services_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('lists all seven supported services', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SupportedServicesSheet())),
    );

    for (final service in [
      'Sonarr',
      'Radarr',
      'Prowlarr',
      'Bazarr',
      'qBittorrent',
      'Uptime Kuma',
      'Seerr',
    ]) {
      expect(find.text(service), findsOneWidget);
    }
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/home/widgets/supported_services_sheet_test.dart`
Expected: FAIL — the file doesn't exist yet.

- [ ] **Step 3: Write the widget**

```dart
// lib/features/home/widgets/supported_services_sheet.dart
/// "What's supported?" bottom sheet (README §3f empty state), reusing the
/// same service-chip list as first-run's "SUPPORTED TODAY" section.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

const List<String> _supportedServices = [
  'Sonarr',
  'Radarr',
  'Prowlarr',
  'Bazarr',
  'qBittorrent',
  'Uptime Kuma',
  'Seerr',
];

Future<void> showSupportedServicesSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = colorScheme.brightness == Brightness.dark;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: isDark ? AppColors.surface : colorScheme.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => const SupportedServicesSheet(),
  );
}

class SupportedServicesSheet extends StatelessWidget {
  const SupportedServicesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space6,
          vertical: AppSpacing.space4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supported today',
              style: AppTypography.sectionTitle.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: [
                for (final service in _supportedServices)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space3,
                      vertical: AppSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.n900,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      service,
                      style: AppTypography.chipLabel.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/home/widgets/supported_services_sheet_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/widgets/supported_services_sheet.dart test/features/home/widgets/supported_services_sheet_test.dart
git commit -m "feat(home): add the What's supported? bottom sheet"
```

---

## Task 12: `HomePage` orchestration — wire all four states together

**Files:**
- Modify: `lib/features/home/home_page.dart`
- Modify: `test/features/home/home_page_test.dart`

**Interfaces:**
- Consumes: `effectiveHomeConnectionStateProvider`, `showDevConnectionSwitcherProvider` (Task 3), `HomeLoadingState` (Task 8), `HomeOfflineState` (Task 9), `ConnectionStateDevChipRow` (Task 10), `showSupportedServicesSheet` (Task 11).

- [ ] **Step 1: Write the failing/changed tests**

Replace the full contents of `test/features/home/home_page_test.dart`:

```dart
import 'dart:async';

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_page.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../support/fixtures.dart';

void main() {
  Widget wrap(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [GoRoute(path: '/', builder: (_, _) => const HomePage())],
        ),
      ),
    );
  }

  testWidgets('shows the empty state when there are no instances', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => const Ok([])),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.byType(HomeBand), findsNothing);
    expect(find.byType(ConnectionStateDevChipRow), findsNothing);
    expect(find.text('No services yet'), findsOneWidget);
    expect(find.text('Add a service'), findsOneWidget);
    expect(find.text("What's supported?"), findsOneWidget);
  });

  testWidgets('"What\'s supported?" opens the supported-services sheet', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => const Ok([])),
      ]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text("What's supported?"));
    await tester.pumpAndSettle();

    expect(find.text('Supported today'), findsOneWidget);
    expect(find.text('Radarr'), findsOneWidget);
  });

  testWidgets('shows the band and service grid when a service is reachable', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );

    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        homeServiceSummariesProvider.overrideWith(
          (ref) async => [
            const HomeServiceSummary(
              instanceId: 'radarr-1',
              instanceName: 'Home Radarr',
              serviceType: ServiceType.radarr,
              isReachable: true,
              summaryLine: '412 movies',
            ),
          ],
        ),
        rightNowProvider.overrideWith((ref) async => null),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeBand), findsOneWidget);
    expect(find.byType(ServiceTileGrid), findsOneWidget);
  });

  testWidgets('shows the loading skeleton on the initial fetch', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );
    final summariesCompleter = Completer<List<HomeServiceSummary>>();

    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        homeServiceSummariesProvider.overrideWith(
          (ref) => summariesCompleter.future,
        ),
        rightNowProvider.overrideWith((ref) async => null),
      ]),
    );
    await tester.pump();

    expect(find.byType(HomeLoadingState), findsOneWidget);

    summariesCompleter.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('shows the offline layout when nothing is reachable', (
    tester,
  ) async {
    final radarr = buildInstance(
      id: 'radarr-1',
      serviceType: ServiceType.radarr,
      isDefault: true,
    );

    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(false),
        instancesProvider.overrideWith((ref) async => Ok([radarr])),
        homeServiceSummariesProvider.overrideWith(
          (ref) async => [
            const HomeServiceSummary(
              instanceId: 'radarr-1',
              instanceName: 'Home Radarr',
              serviceType: ServiceType.radarr,
              isReachable: false,
              summaryLine: 'Unreachable',
              statusLabel: 'Unreachable',
            ),
          ],
        ),
        rightNowProvider.overrideWith((ref) async => null),
        cachedServiceSummariesProvider.overrideWith(
          (ref) async => const [],
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeOfflineState), findsOneWidget);
    expect(find.byType(HomeBand), findsNothing);
  });

  testWidgets('shows the dev chip row only when the flag is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(true),
        instancesProvider.overrideWith((ref) async => const Ok([])),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ConnectionStateDevChipRow), findsOneWidget);
  });

  testWidgets('selecting a dev override chip switches the rendered layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap([
        showDevConnectionSwitcherProvider.overrideWithValue(true),
        instancesProvider.overrideWith((ref) async => const Ok([])),
        cachedServiceSummariesProvider.overrideWith(
          (ref) async => const [],
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);

    await tester.tap(find.text('offline'));
    await tester.pumpAndSettle();

    expect(find.byType(HomeOfflineState), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/home_page_test.dart`
Expected: FAIL — `HomePage` still branches on raw `instancesProvider` with a conditional `AppBar`, not on `effectiveHomeConnectionStateProvider`.

- [ ] **Step 3: Rewrite `home_page.dart`**

Replace the full contents of `lib/features/home/home_page.dart`:

```dart
// lib/features/home/home_page.dart
/// Home tab: Nocturne band, "Right now" card, and the service-tile grid
/// (Phase 3 design §Widget plan). Branches on
/// [effectiveHomeConnectionStateProvider] to show the empty, loading,
/// offline, or ready layout (README §3f). Each state embeds its own gear
/// button (matching HomeBand/OfflineBand/HomeBandSkeleton) rather than a
/// Scaffold AppBar, so the debug connection-state switcher can sit above
/// all four states uniformly.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:arrstack/features/home/widgets/right_now_card.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:arrstack/features/home/widgets/supported_services_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(effectiveHomeConnectionStateProvider);
    final showDevSwitcher = ref.watch(showDevConnectionSwitcherProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (showDevSwitcher) const ConnectionStateDevChipRow(),
            Expanded(
              child: switch (connectionState) {
                HomeConnectionState.unconfigured => const _EmptyHome(),
                HomeConnectionState.loading => const HomeLoadingState(),
                HomeConnectionState.offline => const HomeOfflineState(),
                HomeConnectionState.ready => RefreshIndicator(
                  onRefresh: () => refreshHome(ref),
                  child: const _HomeContent(),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rightNowAsync = ref.watch(rightNowProvider);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const HomeBand(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              rightNowAsync.when(
                data: (summary) => summary == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.space6,
                        ),
                        child: RightNowCard(
                          summary: summary,
                          onTap: () {
                            ref
                                .read(activeActivityLensProvider.notifier)
                                .select(ActivityLens.transfers);
                            context.go(RoutePaths.activity);
                          },
                        ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const Text('SERVICES', style: AppTypography.kicker),
              const SizedBox(height: AppSpacing.space4),
              const ServiceTileGrid(),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.space2,
              right: AppSpacing.space4,
            ),
            child: IconButton(
              icon: const Icon(PhosphorIconsRegular.gear),
              onPressed: () => context.go(RoutePaths.homeSettings),
            ),
          ),
        ),
        const Expanded(
          child: EmptyState(
            icon: PhosphorIconsRegular.hardDrives,
            title: 'No services yet',
            message:
                'Add Radarr or Sonarr and this screen fills with your '
                'library, your transfers and your uptime. Everything '
                'stays on your device.',
            action: _EmptyHomeActions(),
          ),
        ),
      ],
    );
  }
}

class _EmptyHomeActions extends StatelessWidget {
  const _EmptyHomeActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: () => context.go(RoutePaths.homeAddInstance),
          icon: const Icon(PhosphorIconsRegular.plus),
          label: const Text('Add a service'),
        ),
        const SizedBox(height: AppSpacing.space3),
        TextButton(
          onPressed: () => showSupportedServicesSheet(context),
          child: const Text("What's supported?"),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/home/home_page_test.dart`
Expected: PASS

- [ ] **Step 5: Full-suite verification**

Run: `dart format --set-exit-if-changed .`
Run: `dart analyze --fatal-infos`
Run: `flutter test`
Expected: All pass, 0 analyzer issues, full suite green.

- [ ] **Step 6: Commit**

```bash
git add lib/features/home/home_page.dart test/features/home/home_page_test.dart
git commit -m "feat(home): orchestrate empty/loading/offline/ready layouts on HomePage"
```

---

## Post-plan note

Per the design spec, two things are deliberately **not** done in this plan and should not be added as drive-by fixes during implementation:
- Radarr/Sonarr movie/series delete dialogs are not touched, even though they share the shared-dialog's benefits.
- Seerr request deletion is not reintroduced.

Both are documented as explicit out-of-scope decisions in `docs/superpowers/specs/2026-09-16-nocturne-redesign-phase8-states-confirm-design.md`.

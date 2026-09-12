# Nocturne Redesign — Phase 4: Activity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Downloads/Calendar/Subtitles tabs with a single Activity page (`/activity`) that switches between Transfers, Calendar, and Wanted lenses via chips.

**Architecture:** One new `lib/features/activity/` feature folder holds the page, providers, and lens widgets. Calendar's existing provider/model/date-format files stay in `lib/features/calendar/` and are imported by the new Calendar lens rather than moved. A new Sonarr `wanted/missing` client+repository method backs the Wanted lens's missing-episodes section; Bazarr's existing per-instance `bazarrWantedProvider` is aggregated across instances by a new provider. `downloads_providers.dart` and `add_torrent_dialog.dart` are kept (still used by the new Transfers lens); `downloads_page.dart`, `torrent_tile.dart`, `calendar_page.dart`, `calendar_entry_tile.dart`, and all of `lib/features/subtitles/` are deleted.

**Tech Stack:** Flutter 3 / Dart 3.13, Riverpod (`@riverpod` codegen, `riverpod_generator: ^4.0.8`), `go_router`, `flutter_test`, `fake_async`, `http_mock_adapter` (client tests), `phosphor_icons`.

**Spec:** `docs/superpowers/specs/2026-09-12-nocturne-redesign-phase4-activity-design.md`

## Global Constraints

- Use `AppSpacing`/`AppRadius`/`AppColors`/`AppTypography`/`AppShadows`/`AppInsets` from `lib/app/theme/design_tokens.dart` throughout — never `LegacySpacing` in any new file.
- Icons: Phosphor regular weight (`PhosphorIconsRegular.*`) — no `Icons.*` Material icons in any new file.
- Every new/modified widget uses `Theme.of(context).colorScheme` for anything that must adapt between light/dark; use `AppColors`/`AppTypography` tokens directly only where the design is theme-invariant (spec Decision 4).
- Route: a single `GoRoute(path: RoutePaths.activity)` — no nested `calendar`/`subtitles/:instanceId` routes (spec Decision 1).
- `ActiveActivityLens` (not the URL) drives which lens renders after first build; the `lens` query param only seeds the initial value (spec Decision 1).
- Wanted lens: a failing Sonarr instance is dropped silently (no banner); a failing Bazarr instance shows the one offline error card while other instances' subtitles still list below it (spec Decision 2).
- `TransfersThroughputHistory` is session-only (`autoDispose`), samples every 5s, keeps a 60-minute window, and its `Timer` is cancelled via `ref.onDispose` (spec Decision 3).
- All new providers are `@riverpod` (autoDispose, default) — no `keepAlive`, matching Home's precedent (spec Edge cases).
- Never use bare `catch (e)` — use typed `on` clauses or `on Object` where a per-instance failure must be isolated (matches `calendarScheduleProvider`'s existing pattern).
- Generated files (`.g.dart`) are committed in this repo — every commit that touches an `@riverpod`-annotated file must also `git add` its generated counterpart. Codegen command: `dart run build_runner build --delete-conflicting-outputs`.
- `dart format --set-exit-if-changed .` and `dart analyze --fatal-infos` must stay clean after every task.
- **Deviations from the spec's literal text, found during recon (see task notes where they apply):**
  1. Home's service-tile grid has no qBittorrent tile (qBittorrent is represented by the tap-less `RightNowCard` instead) — Task 20 wires `RightNowCard`'s tap, not a nonexistent qBittorrent tile.
  2. Home's Sonarr tile is already committed to Library navigation (the Phase 3 nav fix) — it is **not** repointed to Activity/Wanted. The Wanted lens has no Home entry point this phase; it's reachable via the Activity tab's chips directly.
  3. `bazarrWantedAggregateProvider` cannot be `Result<List<BazarrWantedSubtitle>>` as the spec's Provider plan literally states — a `Result` can't carry both an error and the partial data the error card sits above. Task 5 uses a small `BazarrWantedAggregate {subtitles, hasUnreachableInstance}` value class instead.
  4. The spec's Files-touched list says delete all of `lib/features/downloads/`, but its own Provider plan says reuse `selectedDownloadInstanceIdProvider`/`downloadFilterProvider` (from `downloads_providers.dart`) unchanged. Task 21 deletes only `downloads_page.dart` and `widgets/torrent_tile.dart`; `downloads_providers.dart` and `widgets/add_torrent_dialog.dart` stay.

---

## File structure

```
lib/features/activity/                       (new folder)
  activity_page.dart                          (new)
  activity_providers.dart                     (new)
  models/
    activity_models.dart                      (new — ThroughputSample, BazarrWantedAggregate)
  widgets/
    lens_chips.dart                            (new)
    throughput_sparkline.dart                  (new)
    torrent_block.dart                         (new)
    week_strip.dart                            (new)
    calendar_timeline_row.dart                 (new)
    missing_episode_row.dart                   (new)
    wanted_subtitle_row.dart                   (new)
    transfers_lens.dart                        (new)
    calendar_lens.dart                         (new)
    wanted_lens.dart                           (new)

lib/core/widgets/error_card.dart              (new)

lib/services/sonarr/sonarr_client.dart        (modified, Task 1 — add getWantedMissing)
lib/services/sonarr/sonarr_repository.dart    (modified, Task 2 — add listMissingEpisodes)

lib/features/downloads/
  downloads_providers.dart                     (kept, unchanged — reused by transfers_lens.dart)
  widgets/add_torrent_dialog.dart               (kept, unchanged — reused by activity_page.dart)
  downloads_page.dart                           (deleted, Task 21)
  widgets/torrent_tile.dart                     (deleted, Task 21)

lib/features/calendar/
  calendar_providers.dart                       (kept, unchanged — reused by calendar_lens.dart)
  models/calendar_entry.dart                    (kept, unchanged)
  widgets/calendar_date_format.dart             (kept, unchanged)
  calendar_page.dart                            (deleted, Task 21)
  widgets/calendar_entry_tile.dart               (deleted, Task 21)

lib/features/subtitles/                        (deleted in full, Task 21)

lib/app/router.dart                            (modified, Task 19)
lib/app/route_paths.dart                       (modified, Task 19)
lib/features/home/widgets/service_tile_grid.dart (modified, Task 20)
lib/features/home/widgets/right_now_card.dart    (modified, Task 20)

test/services/sonarr/sonarr_client_test.dart          (new — appends to if created by Task 1; file doesn't exist yet)
test/services/sonarr/sonarr_repository_test.dart       (new)
test/features/activity/activity_providers_test.dart   (new)
test/features/activity/activity_page_test.dart         (new)
test/features/activity/widgets/
  lens_chips_test.dart                          (new)
  throughput_sparkline_test.dart                (new)
  torrent_block_test.dart                       (new)
  week_strip_test.dart                          (new)
  calendar_timeline_row_test.dart               (new)
  missing_episode_row_test.dart                 (new)
  wanted_subtitle_row_test.dart                 (new)
  transfers_lens_test.dart                      (new)
  calendar_lens_test.dart                       (new)
  wanted_lens_test.dart                          (new)
test/core/widgets/error_card_test.dart          (new)
test/features/home/widgets/service_tile_grid_test.dart (modified if exists, else new)
```

---

### Task 1: Sonarr `getWantedMissing` client method

**Files:**
- Modify: `lib/services/sonarr/sonarr_client.dart`
- Test: `test/services/sonarr/sonarr_client_test.dart`

**Interfaces:**
- Consumes: `SonarrCalendarEpisode.fromJson` (existing, `lib/services/sonarr/models/sonarr_models.dart`), `dioCall` (existing, `lib/core/network/network.dart`).
- Produces: `SonarrClient.getWantedMissing({int page, int pageSize})` → `Future<Result<List<SonarrCalendarEpisode>>>`.

- [ ] **Step 1: Write the failing client tests**

```dart
// test/services/sonarr/sonarr_client_test.dart
// SonarrClient.getWantedMissing must page through api/v3/wanted/missing,
// parse each record as SonarrCalendarEpisode (same shape includeSeries=true
// gives the calendar endpoint), skip a malformed record, and map a 5xx to Err.

import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = SonarrClient(dio);
  });

  test('getWantedMissing parses records and requests includeSeries', () async {
    RequestOptions? captured;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 1,
        'pageSize': 50,
        'totalRecords': 1,
        'records': [
          {
            'id': 501,
            'seriesId': 9,
            'seasonNumber': 2,
            'episodeNumber': 5,
            'title': 'The You You Are',
            'airDateUtc': '2022-03-25T00:00:00Z',
            'hasFile': false,
            'monitored': true,
            'series': {'id': 9, 'title': 'Severance'},
          },
        ],
      }),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing();

    expect(result.isOk, isTrue);
    final list = result.valueOrNull!;
    expect(list, hasLength(1));
    expect(list.single.id, 501);
    expect(list.single.series?.title, 'Severance');
    expect(captured!.queryParameters['includeSeries'], true);
  });

  test('getWantedMissing skips a malformed record and keeps the rest', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 1,
        'pageSize': 50,
        'totalRecords': 2,
        'records': [
          'not a map',
          {
            'id': 502,
            'seriesId': 9,
            'seasonNumber': 2,
            'episodeNumber': 6,
            'title': 'Chikhai Bardo',
            'hasFile': false,
            'monitored': true,
          },
        ],
      }),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.map((e) => e.id), [502]);
  });

  test('getWantedMissing respects a custom page and pageSize', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 2,
        'pageSize': 10,
        'totalRecords': 12,
        'records': <Map<String, dynamic>>[],
      }),
      queryParameters: {
        'page': 2,
        'pageSize': 10,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing(page: 2, pageSize: 10);

    expect(result.isOk, isTrue);
    expect(result.valueOrNull, isEmpty);
  });

  test('getWantedMissing maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(503, {'message': 'unavailable'}),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await client.getWantedMissing();

    expect(result.isErr, isTrue);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/services/sonarr/sonarr_client_test.dart`
Expected: FAIL — `getWantedMissing` is undefined on `SonarrClient`.

- [ ] **Step 3: Implement `getWantedMissing`**

Add to `lib/services/sonarr/sonarr_client.dart`, directly above the closing brace of the `SonarrClient` class (after `getQueue`):

```dart
  /// Episodes that have aired but have no file yet — Sonarr's paginated
  /// `wanted/missing` list. `includeSeries` embeds the parent series so a
  /// row can show a title without a second round-trip; the response shape
  /// matches [SonarrCalendarEpisode] exactly, so no separate model exists.
  Future<Result<List<SonarrCalendarEpisode>>> getWantedMissing({
    int page = 1,
    int pageSize = 50,
  }) {
    return dioCall(
      () => _dio.get(
        'api/v3/wanted/missing',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'sortKey': 'airDateUtc',
          'sortDirection': 'descending',
          'includeSeries': true,
        },
      ),
      map: (data) {
        if (data is! Map) return [];
        final records = data['records'];
        if (records is! List) return [];
        return records
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return SonarrCalendarEpisode.fromJson(json);
              } catch (e, st) {
                developer.log(
                  'SonarrCalendarEpisode (wanted/missing) parse error: $e',
                  name: 'arrstack.sonarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<SonarrCalendarEpisode>()
            .toList();
      },
    );
  }
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/services/sonarr/sonarr_client_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/services/sonarr/sonarr_client.dart test/services/sonarr/sonarr_client_test.dart
git commit -m "feat(sonarr): add getWantedMissing client method

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 2: Sonarr `listMissingEpisodes` repository method (pagination)

**Files:**
- Modify: `lib/services/sonarr/sonarr_repository.dart`
- Test: `test/services/sonarr/sonarr_repository_test.dart`

**Interfaces:**
- Consumes: `SonarrClient.getWantedMissing({int page, int pageSize})` (Task 1).
- Produces: `SonarrRepository.listMissingEpisodes()` → `Future<Result<List<SonarrCalendarEpisode>>>`.

- [ ] **Step 1: Write the failing repository tests**

```dart
// test/services/sonarr/sonarr_repository_test.dart
// SonarrRepository.listMissingEpisodes pages through wanted/missing until a
// page returns fewer than pageSize records, concatenating every page.

import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

Map<String, dynamic> _episode(int id) => {
  'id': id,
  'seriesId': 9,
  'seasonNumber': 1,
  'episodeNumber': id,
  'title': 'Episode $id',
  'hasFile': false,
  'monitored': true,
};

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repository = SonarrRepository(SonarrClient(dio));
  });

  test('stops after the first page when it has fewer than 50 records', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 1,
        'pageSize': 50,
        'totalRecords': 2,
        'records': [_episode(1), _episode(2)],
      }),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await repository.listMissingEpisodes();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.map((e) => e.id), [1, 2]);
  });

  test('fetches a second page when the first is exactly full', () async {
    final firstPage = List.generate(50, (i) => _episode(i + 1));
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 1,
        'pageSize': 50,
        'totalRecords': 51,
        'records': firstPage,
      }),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(200, {
        'page': 2,
        'pageSize': 50,
        'totalRecords': 51,
        'records': [_episode(51)],
      }),
      queryParameters: {
        'page': 2,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await repository.listMissingEpisodes();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull, hasLength(51));
    expect(result.valueOrNull!.last.id, 51);
  });

  test('returns Err immediately when the first page fails', () async {
    adapter.onGet(
      'api/v3/wanted/missing',
      (server) => server.reply(503, {'message': 'unavailable'}),
      queryParameters: {
        'page': 1,
        'pageSize': 50,
        'sortKey': 'airDateUtc',
        'sortDirection': 'descending',
        'includeSeries': true,
      },
    );

    final result = await repository.listMissingEpisodes();

    expect(result.isErr, isTrue);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/services/sonarr/sonarr_repository_test.dart`
Expected: FAIL — `listMissingEpisodes` is undefined on `SonarrRepository`.

- [ ] **Step 3: Implement `listMissingEpisodes`**

Add to `lib/services/sonarr/sonarr_repository.dart`, after `listQueue`:

```dart
  /// All episodes that have aired but have no file, across every page of
  /// Sonarr's `wanted/missing` list. Stops once a page returns fewer
  /// records than it asked for. A failure on the first page returns that
  /// error directly; a failure on a later page keeps whatever was already
  /// collected (mirrors `calendarScheduleProvider`'s partial-results
  /// philosophy, one instance's transient hiccup shouldn't drop everything
  /// already fetched from it this call).
  Future<Result<List<SonarrCalendarEpisode>>> listMissingEpisodes() async {
    const pageSize = 50;
    final all = <SonarrCalendarEpisode>[];
    var page = 1;
    while (true) {
      final result = await _client.getWantedMissing(
        page: page,
        pageSize: pageSize,
      );
      if (result case Err(:final error)) {
        return page == 1 ? Err(error) : Ok(all);
      }
      final batch = (result as Ok<List<SonarrCalendarEpisode>>).value;
      all.addAll(batch);
      if (batch.length < pageSize) break;
      page++;
    }
    return Ok(all);
  }
```

Add `import 'package:arrstack/core/network/network.dart';` to the top of the file if not already present (check — `Result`/`Ok`/`Err` are already imported for the existing methods' return types, so this should already be there).

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/services/sonarr/sonarr_repository_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/services/sonarr/sonarr_repository.dart test/services/sonarr/sonarr_repository_test.dart
git commit -m "feat(sonarr): add listMissingEpisodes repository pagination

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 3: `ActiveActivityLens` provider

**Files:**
- Create: `lib/features/activity/activity_providers.dart`
- Test: `test/features/activity/activity_providers_test.dart`

**Interfaces:**
- Produces: `enum ActivityLens { transfers, calendar, wanted }`, `ActiveActivityLens` (`@riverpod class`, `ActivityLens build() => ActivityLens.transfers`, `void select(ActivityLens lens)`).

- [ ] **Step 1: Write the failing test**

```dart
// test/features/activity/activity_providers_test.dart
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActiveActivityLens', () {
    test('defaults to transfers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(activeActivityLensProvider), ActivityLens.transfers);
    });

    test('select updates the state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(activeActivityLensProvider.notifier).select(ActivityLens.wanted);

      expect(container.read(activeActivityLensProvider), ActivityLens.wanted);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: FAIL — `package:arrstack/features/activity/activity_providers.dart` does not exist.

- [ ] **Step 3: Create `activity_providers.dart` with `ActiveActivityLens`**

```dart
// lib/features/activity/activity_providers.dart
/// Providers backing the Activity page: which lens is active, and the
/// Sonarr/Bazarr aggregations the Wanted lens needs (Phase 4 design
/// §Provider plan).
library;

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
```

- [ ] **Step 4: Generate Riverpod code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `lib/features/activity/activity_providers.g.dart` with no errors.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/features/activity/activity_providers.dart lib/features/activity/activity_providers.g.dart \
  test/features/activity/activity_providers_test.dart
git commit -m "feat(activity): add ActiveActivityLens provider

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 4: `sonarrMissingEpisodesProvider`

**Files:**
- Modify: `lib/features/activity/activity_providers.dart`
- Modify: `test/features/activity/activity_providers_test.dart`

**Interfaces:**
- Consumes: `instancesProvider` (`Future<Result<List<ServiceInstance>>>`, `lib/core/storage/storage_providers.dart`), `sonarrRepositoryProvider(String instanceId)` (`Future<SonarrRepository>`, `lib/services/sonarr/sonarr_providers.dart`), `SonarrRepository.listMissingEpisodes()` (Task 2).
- Produces: `SonarrMissingEpisode({required String instanceId, required SonarrCalendarEpisode episode})`, `sonarrMissingEpisodesProvider` (`Future<List<SonarrMissingEpisode>>`).

**Note:** `SonarrCalendarEpisode` alone has no `instanceId` — that only exists on the `ServiceInstance` used to fetch it. Task 13's search button needs both `instanceId` and `seriesId` to route to the existing `RoutePaths.episodeReleaseSearch` page, so aggregation must keep the pairing rather than flattening to a bare `List<SonarrCalendarEpisode>`.

- [ ] **Step 1: Write the failing tests**

Add these imports to the top of `test/features/activity/activity_providers_test.dart`:

```dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';

import '../../support/fixtures.dart';
```

Add this fake near the top of the file, above `main()`:

```dart
/// Stands in for a real `SonarrRepository` so tests control
/// `listMissingEpisodes()` without a live Dio/HTTP layer. `SonarrRepository`
/// is a plain (non-`final`) class, so overriding one method here is safe —
/// nothing else on it is called by `sonarrMissingEpisodesProvider`.
class _FakeSonarrRepository extends SonarrRepository {
  _FakeSonarrRepository(this._result) : super(SonarrClient(Dio()));
  final Result<List<SonarrCalendarEpisode>> _result;

  @override
  Future<Result<List<SonarrCalendarEpisode>>> listMissingEpisodes() async =>
      _result;
}
```

Append this group to `main()`:

```dart
  group('sonarrMissingEpisodesProvider', () {
    SonarrCalendarEpisode episode(int id, {DateTime? airDateUtc}) =>
        SonarrCalendarEpisode(id: id, airDateUtc: airDateUtc);

    test('aggregates missing episodes across every reachable Sonarr instance, keeping instanceId', () async {
      final a = buildInstance(id: 'sonarr-a', serviceType: ServiceType.sonarr);
      final b = buildInstance(id: 'sonarr-b', serviceType: ServiceType.sonarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          sonarrRepositoryProvider(a.id).overrideWith(
            (ref) async => _FakeSonarrRepository(Ok([episode(1)])),
          ),
          sonarrRepositoryProvider(b.id).overrideWith(
            (ref) async => _FakeSonarrRepository(Ok([episode(2)])),
          ),
        ],
      );
      addTearDown(container.dispose);

      final episodes = await container.read(sonarrMissingEpisodesProvider.future);
      expect(episodes.map((e) => e.episode.id), containsAll([1, 2]));
      expect(
        episodes.firstWhere((e) => e.episode.id == 1).instanceId,
        'sonarr-a',
      );
      expect(
        episodes.firstWhere((e) => e.episode.id == 2).instanceId,
        'sonarr-b',
      );
    });

    test('drops a failing instance silently and keeps the rest', () async {
      final a = buildInstance(id: 'sonarr-a', serviceType: ServiceType.sonarr);
      final b = buildInstance(id: 'sonarr-b', serviceType: ServiceType.sonarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          sonarrRepositoryProvider(a.id).overrideWith(
            (ref) async => _FakeSonarrRepository(const Err(NetworkError())),
          ),
          sonarrRepositoryProvider(b.id).overrideWith(
            (ref) async => _FakeSonarrRepository(Ok([episode(2)])),
          ),
        ],
      );
      addTearDown(container.dispose);

      final episodes = await container.read(sonarrMissingEpisodesProvider.future);
      expect(episodes.map((e) => e.episode.id), [2]);
    });

    test('sorts by airDateUtc ascending, nulls last', () {
      final unsorted = [
        SonarrMissingEpisode(instanceId: 'i', episode: episode(1, airDateUtc: DateTime.utc(2026, 3, 1))),
        SonarrMissingEpisode(instanceId: 'i', episode: episode(2)),
        SonarrMissingEpisode(instanceId: 'i', episode: episode(3, airDateUtc: DateTime.utc(2026, 1, 1))),
      ];

      final sorted = sortMissingEpisodesByAirDate(unsorted);

      expect(sorted.map((e) => e.episode.id), [3, 1, 2]);
    });

    test('returns empty when there are no Sonarr instances', () async {
      final container = ProviderContainer(
        overrides: [instancesProvider.overrideWith((ref) async => const Ok([]))],
      );
      addTearDown(container.dispose);

      final episodes = await container.read(sonarrMissingEpisodesProvider.future);
      expect(episodes, isEmpty);
    });
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: FAIL — `sonarrMissingEpisodesProvider` and `sortMissingEpisodesByAirDate` are undefined.

- [ ] **Step 3: Implement `sonarrMissingEpisodesProvider`**

Add these imports to the top of `lib/features/activity/activity_providers.dart`:

```dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
```

Append to `lib/features/activity/activity_providers.dart`:

```dart
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
    for (final instance in sonarrInstances) _missingEpisodesFor(ref, instance.id),
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
```

Add `import 'package:flutter/foundation.dart';` (for `@immutable`) alongside the other new imports at the top of `lib/features/activity/activity_providers.dart`.

- [ ] **Step 4: Regenerate and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/activity_providers.dart lib/features/activity/activity_providers.g.dart \
  test/features/activity/activity_providers_test.dart
git commit -m "feat(activity): add sonarrMissingEpisodesProvider

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 5: `BazarrWantedAggregate` model + `bazarrWantedAggregateProvider`

**Files:**
- Create: `lib/features/activity/models/activity_models.dart`
- Modify: `lib/features/activity/activity_providers.dart`
- Test: `test/features/activity/models/activity_models_test.dart`
- Modify: `test/features/activity/activity_providers_test.dart`

**Interfaces:**
- Consumes: `instancesProvider`, `bazarrWantedProvider(String instanceId)` (`Future<Result<List<BazarrWantedSubtitle>>>`, `lib/services/bazarr/bazarr_providers.dart`).
- Produces: `BazarrWantedAggregate({required List<BazarrWantedSubtitle> subtitles, required bool hasUnreachableInstance})`, `bazarrWantedAggregateProvider` (`Future<BazarrWantedAggregate>`).

**Note (deviation 3 from Global Constraints):** the design spec's Provider plan describes this as returning `Result<List<BazarrWantedSubtitle>>`, but 2j's error card sits *above* still-listed subtitles from working instances — a bare `Result` can't carry both an error and partial success data at once. `BazarrWantedAggregate` carries both.

- [ ] **Step 1: Write the failing model test**

```dart
// test/features/activity/models/activity_models_test.dart
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BazarrWantedAggregate holds subtitles and the unreachable flag', () {
    const aggregate = BazarrWantedAggregate(
      subtitles: [BazarrWantedSubtitle(title: 'x')],
      hasUnreachableInstance: true,
    );

    expect(aggregate.subtitles, hasLength(1));
    expect(aggregate.hasUnreachableInstance, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/activity/models/activity_models_test.dart`
Expected: FAIL — `package:arrstack/features/activity/models/activity_models.dart` does not exist.

- [ ] **Step 3: Create `activity_models.dart` with `BazarrWantedAggregate`**

```dart
// lib/features/activity/models/activity_models.dart
/// Plain value objects for the Activity feature that don't need freezed
/// (no JSON boundary, no nested equality beyond what Dart gives records/
/// simple classes for free) — mirrors `CalendarEntry`'s precedent
/// (`lib/features/calendar/models/calendar_entry.dart`).
library;

import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/foundation.dart';

/// Wanted subtitles aggregated across every configured Bazarr instance,
/// plus whether any instance failed to answer. Kept separate from a bare
/// `Result` because the Wanted lens must show both at once: the single
/// offline error card (2j) *and* whatever subtitles the working instances
/// still returned underneath it.
@immutable
class BazarrWantedAggregate {
  const BazarrWantedAggregate({
    required this.subtitles,
    required this.hasUnreachableInstance,
  });

  final List<BazarrWantedSubtitle> subtitles;
  final bool hasUnreachableInstance;
}

/// One sampled qBittorrent download-speed reading, kept in
/// [TransfersThroughputHistory]'s rolling 60-minute buffer.
@immutable
class ThroughputSample {
  const ThroughputSample({
    required this.timestamp,
    required this.dlSpeedBytesPerSecond,
  });

  final DateTime timestamp;
  final int dlSpeedBytesPerSecond;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/activity/models/activity_models_test.dart`
Expected: PASS.

- [ ] **Step 5: Write the failing provider tests**

Add these imports to the top of `test/features/activity/activity_providers_test.dart`:

```dart
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
```

Append this group to `main()`:

```dart
  group('bazarrWantedAggregateProvider', () {
    test('concatenates subtitles from every reachable instance', () async {
      final a = buildInstance(id: 'bazarr-a', serviceType: ServiceType.bazarr);
      final b = buildInstance(id: 'bazarr-b', serviceType: ServiceType.bazarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          bazarrWantedProvider(
            a.id,
          ).overrideWith((ref) async => const Ok([BazarrWantedSubtitle(title: 'x')])),
          bazarrWantedProvider(
            b.id,
          ).overrideWith((ref) async => const Ok([BazarrWantedSubtitle(title: 'y')])),
        ],
      );
      addTearDown(container.dispose);

      final aggregate = await container.read(bazarrWantedAggregateProvider.future);
      expect(aggregate.subtitles.map((s) => s.title), ['x', 'y']);
      expect(aggregate.hasUnreachableInstance, isFalse);
    });

    test('sets hasUnreachableInstance and keeps the other instance\'s subtitles', () async {
      final a = buildInstance(id: 'bazarr-a', serviceType: ServiceType.bazarr);
      final b = buildInstance(id: 'bazarr-b', serviceType: ServiceType.bazarr);

      final container = ProviderContainer(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([a, b])),
          bazarrWantedProvider(
            a.id,
          ).overrideWith((ref) async => const Err(NetworkError())),
          bazarrWantedProvider(
            b.id,
          ).overrideWith((ref) async => const Ok([BazarrWantedSubtitle(title: 'y')])),
        ],
      );
      addTearDown(container.dispose);

      final aggregate = await container.read(bazarrWantedAggregateProvider.future);
      expect(aggregate.hasUnreachableInstance, isTrue);
      expect(aggregate.subtitles.map((s) => s.title), ['y']);
    });

    test('is not unreachable and has no subtitles with zero Bazarr instances', () async {
      final container = ProviderContainer(
        overrides: [instancesProvider.overrideWith((ref) async => const Ok([]))],
      );
      addTearDown(container.dispose);

      final aggregate = await container.read(bazarrWantedAggregateProvider.future);
      expect(aggregate.subtitles, isEmpty);
      expect(aggregate.hasUnreachableInstance, isFalse);
    });
  });
```

- [ ] **Step 6: Run tests to verify they fail**

Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: FAIL — `bazarrWantedAggregateProvider` is undefined.

- [ ] **Step 7: Implement `bazarrWantedAggregateProvider`**

Add these imports to the top of `lib/features/activity/activity_providers.dart`:

```dart
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
```

Append to `lib/features/activity/activity_providers.dart`:

```dart
/// Wanted subtitles aggregated across every configured Bazarr instance
/// (spec Decision 2). Unlike [sonarrMissingEpisodes], a Bazarr failure is
/// surfaced — [BazarrWantedAggregate.hasUnreachableInstance] drives the
/// Wanted lens's single offline error card — but other instances' results
/// still show underneath it.
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

  final subtitles = <BazarrWantedSubtitle>[];
  var hasUnreachableInstance = false;
  for (final instance in bazarrInstances) {
    final result = await ref.watch(bazarrWantedProvider(instance.id).future);
    switch (result) {
      case Ok(:final value):
        subtitles.addAll(value);
      case Err():
        hasUnreachableInstance = true;
    }
  }

  return BazarrWantedAggregate(
    subtitles: subtitles,
    hasUnreachableInstance: hasUnreachableInstance,
  );
}
```

Add `import 'package:arrstack/services/bazarr/models/bazarr_models.dart';` alongside the other new imports.

- [ ] **Step 8: Regenerate and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/activity/activity_providers_test.dart test/features/activity/models/activity_models_test.dart`
Expected: PASS.

- [ ] **Step 9: Commit**

```bash
git add lib/features/activity/models/activity_models.dart lib/features/activity/activity_providers.dart \
  lib/features/activity/activity_providers.g.dart \
  test/features/activity/models/activity_models_test.dart test/features/activity/activity_providers_test.dart
git commit -m "feat(activity): add BazarrWantedAggregate and bazarrWantedAggregateProvider

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 6: `TransfersThroughputHistory` provider

**Files:**
- Modify: `lib/features/activity/activity_providers.dart`
- Modify: `test/features/activity/activity_providers_test.dart`

**Interfaces:**
- Consumes: `qbitMainDataProvider(String instanceId)` (`Future<Result<QbitMainData>>`, `lib/services/qbittorrent/qbit_providers.dart`), `ThroughputSample` (Task 5).
- Produces: `TransfersThroughputHistory` (`@riverpod class`, family by `instanceId`, `List<ThroughputSample> build(String instanceId)`).

- [ ] **Step 1: Write the failing tests**

Add these imports to the top of `test/features/activity/activity_providers_test.dart`:

```dart
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:fake_async/fake_async.dart';
```

Append this group to `main()`:

```dart
  group('TransfersThroughputHistory', () {
    Result<QbitMainData> mainData(int dlSpeed) => Ok(
      QbitMainData(
        serverState: QbitServerState(
          dlInfoSpeed: dlSpeed,
          dlInfoData: 0,
          upInfoSpeed: 0,
          upInfoData: 0,
          dlRateLimit: 0,
          upRateLimit: 0,
          dhtNodes: 0,
          connectionStatus: 'connected',
        ),
      ),
    );

    test('samples every 5 seconds while a listener is active', () {
      fakeAsync((async) {
        final container = ProviderContainer(
          overrides: [
            qbitMainDataProvider('qbit-1').overrideWith((ref) async => mainData(1024)),
          ],
        );
        addTearDown(container.dispose);

        container.listen(
          transfersThroughputHistoryProvider('qbit-1'),
          (_, _) {},
          fireImmediately: true,
        );
        async.flushMicrotasks();

        async.elapse(const Duration(seconds: 15));
        async.flushMicrotasks();

        final samples = container.read(transfersThroughputHistoryProvider('qbit-1'));
        expect(samples.length, greaterThanOrEqualTo(3));
        expect(samples.every((s) => s.dlSpeedBytesPerSecond == 1024), isTrue);
      });
    });

    test('drops samples older than 60 minutes', () {
      fakeAsync((async) {
        final container = ProviderContainer(
          overrides: [
            qbitMainDataProvider('qbit-1').overrideWith((ref) async => mainData(512)),
          ],
        );
        addTearDown(container.dispose);

        container.listen(
          transfersThroughputHistoryProvider('qbit-1'),
          (_, _) {},
          fireImmediately: true,
        );
        async.flushMicrotasks();

        async.elapse(const Duration(minutes: 70));
        async.flushMicrotasks();

        final samples = container.read(transfersThroughputHistoryProvider('qbit-1'));
        final cutoff = DateTime.now().subtract(const Duration(minutes: 60));
        expect(samples.every((s) => s.timestamp.isAfter(cutoff)), isTrue);
      });
    });

    test('starts empty before the first sample tick', () {
      final container = ProviderContainer(
        overrides: [
          qbitMainDataProvider('qbit-1').overrideWith((ref) async => mainData(0)),
        ],
      );
      addTearDown(container.dispose);

      final samples = container.read(transfersThroughputHistoryProvider('qbit-1'));
      expect(samples, isEmpty);
    });
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: FAIL — `transfersThroughputHistoryProvider` is undefined.

- [ ] **Step 3: Implement `TransfersThroughputHistory`**

Add these imports to the top of `lib/features/activity/activity_providers.dart`:

```dart
import 'dart:async';

import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
```

Append to `lib/features/activity/activity_providers.dart`:

```dart
const Duration _throughputSampleInterval = Duration(seconds: 5);
const Duration _throughputHistoryWindow = Duration(minutes: 60);

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
    final result = await ref.read(qbitMainDataProvider(instanceId).future);
    if (result case Ok(:final value)) {
      final now = DateTime.now();
      final cutoff = now.subtract(_throughputHistoryWindow);
      state = [
        ...state.where((s) => s.timestamp.isAfter(cutoff)),
        ThroughputSample(
          timestamp: now,
          dlSpeedBytesPerSecond: value.serverState.dlInfoSpeed,
        ),
      ];
    }
  }
}
```

- [ ] **Step 4: Regenerate and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/activity/activity_providers_test.dart`
Expected: PASS.

- [ ] **Step 5: Add the `fake_async` dev dependency if missing**

Run: `grep -q "fake_async" pubspec.yaml || echo "MISSING"`. If it prints `MISSING`, add `fake_async: ^1.3.1` under `dev_dependencies:` in `pubspec.yaml` and run `flutter pub get`. (Most Flutter/Dart repos already carry it transitively via `flutter_test`, but the direct dependency must be declared explicitly to `import` it.)

- [ ] **Step 6: Commit**

```bash
git add lib/features/activity/activity_providers.dart lib/features/activity/activity_providers.g.dart \
  test/features/activity/activity_providers_test.dart pubspec.yaml pubspec.lock
git commit -m "feat(activity): add TransfersThroughputHistory sampling provider

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 7: `ErrorCard` shared widget

**Files:**
- Create: `lib/core/widgets/error_card.dart`
- Test: `test/core/widgets/error_card_test.dart`

**Interfaces:**
- Produces: `ErrorCard({required String title, required String message, required String primaryActionLabel, required VoidCallback onPrimaryAction, required String secondaryActionLabel, required VoidCallback onSecondaryAction})`.

No existing `core/widgets/` component matches this pattern (confirmed by recon — `status_chip.dart`, `detail_chip.dart`, `empty_state.dart`, `poster_card.dart`, `resolved_poster.dart` are the only files there today). This is the "one error pattern" the README specifies for 2j, 2n, and 3f — building it in `core/widgets/` now means later phases reuse it rather than re-inventing it.

- [ ] **Step 1: Write the failing widget test**

```dart
// test/core/widgets/error_card_test.dart
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows title, message, and both action labels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            title: 'Bazarr is unreachable',
            message:
                "Subtitle searches will queue until it's back. Radarr and "
                'Sonarr are unaffected.',
            primaryActionLabel: 'Retry now',
            onPrimaryAction: () {},
            secondaryActionLabel: 'Open settings',
            onSecondaryAction: () {},
          ),
        ),
      ),
    );

    expect(find.text('Bazarr is unreachable'), findsOneWidget);
    expect(find.textContaining('Radarr and'), findsOneWidget);
    expect(find.text('Retry now'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
  });

  testWidgets('primary and secondary buttons call their callbacks', (tester) async {
    var primaryTapped = false;
    var secondaryTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            title: 't',
            message: 'm',
            primaryActionLabel: 'Retry now',
            onPrimaryAction: () => primaryTapped = true,
            secondaryActionLabel: 'Open settings',
            onSecondaryAction: () => secondaryTapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Retry now'));
    await tester.tap(find.text('Open settings'));

    expect(primaryTapped, isTrue);
    expect(secondaryTapped, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/error_card_test.dart`
Expected: FAIL — `package:arrstack/core/widgets/error_card.dart` does not exist.

- [ ] **Step 3: Implement `ErrorCard`**

```dart
// lib/core/widgets/error_card.dart
/// The one shared error pattern used across the app (README "Shared shell"
/// → "Error card", reused by screens 2j, 2n, 3f): a warning glyph, a title,
/// an explanation, and two actions — one recovery, one escape.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    required this.title,
    required this.message,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    required this.secondaryActionLabel,
    required this.onSecondaryAction,
    super.key,
  });

  final String title;
  final String message;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final String secondaryActionLabel;
  final VoidCallback onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.down.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                PhosphorIconsFill.warning,
                size: 15,
                color: AppColors.down,
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.cardTitle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            message,
            style: AppTypography.meta.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onPrimaryAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                  ),
                  child: Text(primaryActionLabel),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: OutlinedButton(
                  onPressed: onSecondaryAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Text(secondaryActionLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/error_card_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/error_card.dart test/core/widgets/error_card_test.dart
git commit -m "feat(core): add shared ErrorCard widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 8: `LensChips` widget

**Files:**
- Create: `lib/features/activity/widgets/lens_chips.dart`
- Test: `test/features/activity/widgets/lens_chips_test.dart`

**Interfaces:**
- Consumes: `activeActivityLensProvider` (Task 3), `ActivityLens` enum.
- Produces: `LensChips({int wantedCount = 0})`.

- [ ] **Step 1: Write the failing widget test**

```dart
// test/features/activity/widgets/lens_chips_test.dart
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/lens_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows all three lens labels, Wanted with its count', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: LensChips(wantedCount: 4)),
        ),
      ),
    );

    expect(find.text('Transfers'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.textContaining('Wanted'), findsOneWidget);
    expect(find.textContaining('4'), findsOneWidget);
  });

  testWidgets('tapping a chip updates ActiveActivityLens', (tester) async {
    late ProviderContainer container;

    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(home: Scaffold(body: LensChips()));
          },
        ),
      ),
    );

    await tester.tap(find.text('Calendar'));
    await tester.pump();

    expect(container.read(activeActivityLensProvider), ActivityLens.calendar);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/activity/widgets/lens_chips_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/lens_chips.dart` does not exist.

- [ ] **Step 3: Implement `LensChips`**

```dart
// lib/features/activity/widgets/lens_chips.dart
/// The Transfers/Calendar/Wanted switcher (README "Shared shell" → "Lens
/// chips"): 5px/10px padding, radius-sm, 11px/500 text. Inactive is muted;
/// active is accent text plus a 1px inset accent ring — no fill.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LensChips extends ConsumerWidget {
  const LensChips({this.wantedCount = 0, super.key});

  final int wantedCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeActivityLensProvider);

    return Row(
      children: [
        _LensChip(
          label: 'Transfers',
          lens: ActivityLens.transfers,
          isActive: active == ActivityLens.transfers,
        ),
        const SizedBox(width: AppSpacing.space2),
        _LensChip(
          label: 'Calendar',
          lens: ActivityLens.calendar,
          isActive: active == ActivityLens.calendar,
        ),
        const SizedBox(width: AppSpacing.space2),
        _LensChip(
          label: wantedCount > 0 ? 'Wanted $wantedCount' : 'Wanted',
          lens: ActivityLens.wanted,
          isActive: active == ActivityLens.wanted,
        ),
      ],
    );
  }
}

class _LensChip extends ConsumerWidget {
  const _LensChip({
    required this.label,
    required this.lens,
    required this.isActive,
  });

  final String label;
  final ActivityLens lens;
  final bool isActive;

  static const TextStyle _chipText = TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () => ref.read(activeActivityLensProvider.notifier).select(lens),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive ? Border.all(color: color) : null,
        ),
        child: Text(label, style: _chipText.copyWith(color: color)),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/activity/widgets/lens_chips_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/lens_chips.dart test/features/activity/widgets/lens_chips_test.dart
git commit -m "feat(activity): add LensChips switcher widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 9: `ThroughputSparkline` widget

**Files:**
- Create: `lib/features/activity/widgets/throughput_sparkline.dart`
- Test: `test/features/activity/widgets/throughput_sparkline_test.dart`

**Interfaces:**
- Consumes: `ThroughputSample` (Task 5).
- Produces: `bucketThroughputSamples(List<ThroughputSample> samples, {DateTime? now})` (`List<double>`, pure), `ThroughputSparkline({required List<ThroughputSample> samples})`.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/throughput_sparkline_test.dart
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/throughput_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bucketThroughputSamples', () {
    test('places samples into their 5-minute bucket, averaging duplicates', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      final samples = [
        ThroughputSample(
          timestamp: now.subtract(const Duration(seconds: 30)),
          dlSpeedBytesPerSecond: 1000,
        ),
        ThroughputSample(
          timestamp: now.subtract(const Duration(seconds: 10)),
          dlSpeedBytesPerSecond: 2000,
        ),
      ];

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets, hasLength(12));
      expect(buckets.last, 1500); // both samples fall in the most recent bucket
      expect(buckets.sublist(0, 11).every((b) => b == 0), isTrue);
    });

    test('drops samples older than the 60-minute window', () {
      final now = DateTime.utc(2026, 1, 1, 12);
      final samples = [
        ThroughputSample(
          timestamp: now.subtract(const Duration(minutes: 90)),
          dlSpeedBytesPerSecond: 5000,
        ),
      ];

      final buckets = bucketThroughputSamples(samples, now: now);

      expect(buckets.every((b) => b == 0), isTrue);
    });

    test('returns 12 zero buckets for an empty sample list', () {
      expect(bucketThroughputSamples(const []), List.filled(12, 0));
    });
  });

  group('ThroughputSparkline widget', () {
    testWidgets('shows a "now" speed and a peak caption', (tester) async {
      final now = DateTime.now();
      final samples = [
        ThroughputSample(timestamp: now, dlSpeedBytesPerSecond: 5600000),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ThroughputSparkline(samples: samples)),
        ),
      );

      expect(find.textContaining('Last 60 min'), findsOneWidget);
      expect(find.textContaining('now'), findsOneWidget);
      expect(find.textContaining('peak'), findsOneWidget);
    });

    testWidgets('renders without error for an empty sample list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThroughputSparkline(samples: [])),
        ),
      );

      expect(find.byType(ThroughputSparkline), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/throughput_sparkline_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/throughput_sparkline.dart` does not exist.

- [ ] **Step 3: Implement `bucketThroughputSamples` and `ThroughputSparkline`**

```dart
// lib/features/activity/widgets/throughput_sparkline.dart
/// The Transfers lens's "last 60 min" throughput chart (spec screen 2h):
/// 12 five-minute bars stepping from `accent-800` (oldest) to `accent`
/// (most recent), with a caption showing the live and peak speeds.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:flutter/material.dart';

const int _bucketCount = 12;
const Duration _bucketDuration = Duration(minutes: 5); // 12 * 5 = 60 min
const double _sparklineHeight = 52;

/// Buckets [samples] into 12 five-minute windows covering the hour up to
/// [now] (defaults to `DateTime.now()`), each bucket holding the average
/// download speed of the samples that fall in it (0 for an empty bucket).
/// Pure — unit-testable without a widget tree. Index 0 is the oldest
/// bucket, index 11 the most recent.
List<double> bucketThroughputSamples(
  List<ThroughputSample> samples, {
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  final windowStart = reference.subtract(_bucketDuration * _bucketCount);

  final sums = List<double>.filled(_bucketCount, 0);
  final counts = List<int>.filled(_bucketCount, 0);

  for (final sample in samples) {
    final offset = sample.timestamp.difference(windowStart);
    if (offset.isNegative) continue;
    final index =
        (offset.inMilliseconds / _bucketDuration.inMilliseconds).floor();
    if (index < 0 || index >= _bucketCount) continue;
    sums[index] += sample.dlSpeedBytesPerSecond;
    counts[index]++;
  }

  return [
    for (var i = 0; i < _bucketCount; i++)
      counts[i] == 0 ? 0 : sums[i] / counts[i],
  ];
}

class ThroughputSparkline extends StatelessWidget {
  const ThroughputSparkline({required this.samples, super.key});

  final List<ThroughputSample> samples;

  static const List<Color> _barColors = [
    AppColors.a800,
    AppColors.a700,
    AppColors.a600,
    AppColors.a500,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final buckets = bucketThroughputSamples(samples);
    final peak = buckets.fold<double>(0, (m, v) => v > m ? v : m);
    final nowSpeed = samples.isEmpty ? 0 : samples.last.dlSpeedBytesPerSecond;
    final onSurfaceMuted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _sparklineHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < buckets.length; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  child: Container(
                    height: peak == 0
                        ? 1
                        : (buckets[i] / peak * _sparklineHeight).clamp(
                            1,
                            _sparklineHeight,
                          ),
                    decoration: BoxDecoration(
                      color: _colorFor(i, buckets.length),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.space2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Last 60 min · ↓ ${FormatUtils.formatSpeed(nowSpeed)} now',
              style: AppTypography.meta.copyWith(color: onSurfaceMuted),
            ),
            Text(
              'peak ${FormatUtils.formatSpeed(peak.round())}',
              style: AppTypography.meta.copyWith(color: onSurfaceMuted),
            ),
          ],
        ),
      ],
    );
  }

  Color _colorFor(int index, int total) {
    final t = total <= 1 ? 0.0 : index / (total - 1);
    final scaled = t * (_barColors.length - 1);
    final lower = scaled.floor().clamp(0, _barColors.length - 1);
    final upper = scaled.ceil().clamp(0, _barColors.length - 1);
    return Color.lerp(_barColors[lower], _barColors[upper], scaled - lower)!;
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/throughput_sparkline_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/throughput_sparkline.dart \
  test/features/activity/widgets/throughput_sparkline_test.dart
git commit -m "feat(activity): add ThroughputSparkline widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 10: `TorrentBlock` widget (downloading/stalled/seeding variants)

**Files:**
- Create: `lib/features/activity/widgets/torrent_block.dart`
- Test: `test/features/activity/widgets/torrent_block_test.dart`

**Interfaces:**
- Consumes: `QbitTorrent`, `qbitRepositoryProvider(String instanceId)`, `qbitTorrentsProvider(String instanceId)` (existing, `lib/services/qbittorrent/qbit_providers.dart`).
- Produces: `torrentIsComplete(QbitTorrent)`, `torrentIsStalled(QbitTorrent)`, `TorrentBlock({required String instanceId, required QbitTorrent torrent})`. Replaces `lib/features/downloads/widgets/torrent_tile.dart`'s `TorrentTile` and its (identical) `torrentIsComplete`.

**Scope note:** the 2h stalled variant's "Find another release" button has no real target — qBittorrent's model carries no link back to the Sonarr/Radarr item a torrent came from, and neither this app nor the design spec defines one. The button shows an informational `SnackBar` pointing at Library/Wanted instead of silently doing nothing or inventing a fake integration.

- [ ] **Step 1: Write the failing widget tests**

```dart
// test/features/activity/widgets/torrent_block_test.dart
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

QbitTorrent _torrent({
  required String state,
  double progress = 0.5,
  double ratio = 0.0,
}) => QbitTorrent(
  hash: 'h1',
  name: 'Some.Release-GRP',
  size: 1000000000,
  progress: progress,
  dlspeed: 1000,
  upspeed: 500,
  priority: 1,
  numSeeds: 10,
  numLeechs: 5,
  numIncomplete: 0,
  ratio: ratio,
  eta: 300,
  state: state,
  tracker: 'https://torrentleech.org/announce',
  addedOn: 0,
  completionOn: 0,
  category: '',
  tags: '',
  savePath: '',
  timeActive: 0,
  lastActivity: 0,
);

Future<void> _pump(WidgetTester tester, QbitTorrent torrent) {
  return tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: TorrentBlock(instanceId: 'qbit-1', torrent: torrent),
        ),
      ),
    ),
  );
}

void main() {
  test('torrentIsComplete is true for finished/seeding states', () {
    expect(torrentIsComplete(_torrent(state: 'uploading', progress: 1)), isTrue);
    expect(torrentIsComplete(_torrent(state: 'stalledUP')), isTrue);
    expect(torrentIsComplete(_torrent(state: 'downloading', progress: 0.5)), isFalse);
  });

  test('torrentIsStalled is true only for stalledDL', () {
    expect(torrentIsStalled(_torrent(state: 'stalledDL')), isTrue);
    expect(torrentIsStalled(_torrent(state: 'downloading')), isFalse);
  });

  testWidgets('downloading state shows the Downloading tag and progress', (tester) async {
    await _pump(tester, _torrent(state: 'downloading', progress: 0.68));

    expect(find.text('Downloading'), findsOneWidget);
    expect(find.text('68%'), findsOneWidget);
    expect(find.text('Some.Release-GRP'), findsOneWidget);
  });

  testWidgets('stalled state shows the Stalled tag and a Find another release button', (
    tester,
  ) async {
    await _pump(tester, _torrent(state: 'stalledDL', progress: 0.23));

    expect(find.text('Stalled'), findsOneWidget);
    expect(find.text('Find another release'), findsOneWidget);
  });

  testWidgets('seeding state shows a compact row with the ratio', (tester) async {
    await _pump(tester, _torrent(state: 'uploading', progress: 1, ratio: 1.42));

    expect(find.text('1.42'), findsOneWidget);
    expect(find.text('Downloading'), findsNothing);
    expect(find.text('Find another release'), findsNothing);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/torrent_block_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/torrent_block.dart` does not exist.

- [ ] **Step 3: Implement `TorrentBlock`**

```dart
// lib/features/activity/widgets/torrent_block.dart
/// One torrent, rendered as one of 2h's three block variants: downloading
/// (progress + pause/trash), stalled (recovery action surfaced, not
/// hidden), or seeding (compact row). Replaces
/// `lib/features/downloads/widgets/torrent_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// Whether a torrent has finished downloading (belongs in the Seeding
/// filter rather than Downloading/Stalled).
bool torrentIsComplete(QbitTorrent t) =>
    t.progress >= 1.0 ||
    const {
      'uploading',
      'stalledUP',
      'forcedUP',
      'pausedUP',
      'queuedUP',
    }.contains(t.state);

/// Whether a still-downloading torrent has no peers (2h's "Stalled" block).
bool torrentIsStalled(QbitTorrent t) => t.state == 'stalledDL';

class TorrentBlock extends ConsumerWidget {
  const TorrentBlock({
    required this.instanceId,
    required this.torrent,
    super.key,
  });

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (torrentIsComplete(torrent)) return _SeedingRow(torrent: torrent);
    if (torrentIsStalled(torrent)) {
      return _StalledBlock(instanceId: instanceId, torrent: torrent);
    }
    return _DownloadingBlock(instanceId: instanceId, torrent: torrent);
  }
}

class _DownloadingBlock extends ConsumerWidget {
  const _DownloadingBlock({required this.instanceId, required this.torrent});

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurfaceMuted = theme.colorScheme.onSurfaceVariant;
    final host = FormatUtils.trackerHost(torrent.tracker);
    final percent = (torrent.progress * 100).round();
    final peers = torrent.numSeeds + torrent.numLeechs;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        border: AppShadows.ringSm,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: 'Downloading', color: theme.colorScheme.primary),
              const Spacer(),
              Text(
                '${FormatUtils.formatEta(torrent.eta)} left',
                style: AppTypography.meta.copyWith(color: onSurfaceMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            torrent.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle.copyWith(height: 1.35),
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: LinearProgressIndicator(
                    value: torrent.progress,
                    minHeight: 3,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: AppColors.a300,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Text(
                '$percent%',
                style: AppTypography.meta.copyWith(color: AppColors.a300),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${FormatUtils.formatBytes(torrent.size)} · $peers peers'
                  '${host != null ? ' · $host' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.meta.copyWith(color: onSurfaceMuted),
                ),
              ),
              _IconAction(
                icon: PhosphorIconsRegular.pause,
                tooltip: 'Pause',
                onPressed: () => _pause(ref),
              ),
              _IconAction(
                icon: PhosphorIconsRegular.trash,
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pause(WidgetRef ref) async {
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    await repository.stopTorrents([torrent.hash]);
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    var deleteFiles = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Delete Torrent?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to remove "${torrent.name}"?'),
              const SizedBox(height: AppSpacing.space4),
              CheckboxListTile(
                title: const Text('Also delete files on disk'),
                value: deleteFiles,
                onChanged: (val) => setState(() => deleteFiles = val ?? false),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: AppColors.down)),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final repository = await ref.read(
        qbitRepositoryProvider(instanceId).future,
      );
      await repository.deleteTorrents([torrent.hash], deleteFiles: deleteFiles);
      ref.invalidate(qbitTorrentsProvider(instanceId));
    }
  }
}

class _StalledBlock extends ConsumerWidget {
  const _StalledBlock({required this.instanceId, required this.torrent});

  final String instanceId;
  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurfaceMuted = theme.colorScheme.onSurfaceVariant;
    final percent = (torrent.progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      margin: const EdgeInsets.only(bottom: AppSpacing.space3),
      decoration: BoxDecoration(
        border: AppShadows.ringSm,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: 'Stalled', color: onSurfaceMuted),
              const Spacer(),
              Text(
                'no peers · ${FormatUtils.formatEta(torrent.eta)}',
                style: AppTypography.meta.copyWith(color: onSurfaceMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            torrent.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle.copyWith(height: 1.35),
          ),
          const SizedBox(height: AppSpacing.space3),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: torrent.progress,
              minHeight: 3,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: AppColors.n600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$percent%',
            style: AppTypography.meta.copyWith(color: onSurfaceMuted),
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _findAnotherRelease(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                  ),
                  child: const Text('Find another release'),
                ),
              ),
              _IconAction(
                icon: PhosphorIconsRegular.trash,
                tooltip: 'Delete',
                onPressed: () => _delete(ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _findAnotherRelease(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Search for a replacement release from the Library or Wanted tab.',
        ),
      ),
    );
  }

  Future<void> _delete(WidgetRef ref) async {
    final repository = await ref.read(
      qbitRepositoryProvider(instanceId).future,
    );
    await repository.deleteTorrents([torrent.hash], deleteFiles: false);
    ref.invalidate(qbitTorrentsProvider(instanceId));
  }
}

class _SeedingRow extends StatelessWidget {
  const _SeedingRow({required this.torrent});

  final QbitTorrent torrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceMuted = theme.colorScheme.onSurfaceVariant;
    final arrowColor = torrent.ratio >= 1.0 ? AppColors.up : AppColors.warning;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        children: [
          Icon(PhosphorIconsRegular.arrowUp, size: 16, color: arrowColor),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              '${torrent.name}  ${FormatUtils.formatBytes(torrent.size)} · '
              '↑ ${FormatUtils.formatSpeed(torrent.upspeed)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.meta.copyWith(color: onSurfaceMuted),
            ),
          ),
          Text(
            torrent.ratio.toStringAsFixed(2),
            style: AppTypography.meta.copyWith(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, size: 16),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/torrent_block_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/torrent_block.dart \
  test/features/activity/widgets/torrent_block_test.dart
git commit -m "feat(activity): add TorrentBlock widget with three 2h variants

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 11: `WeekStrip` widget

**Files:**
- Create: `lib/features/activity/widgets/week_strip.dart`
- Test: `test/features/activity/widgets/week_strip_test.dart`

**Interfaces:**
- Consumes: `CalendarDay` (existing, `lib/features/calendar/models/calendar_entry.dart`).
- Produces: `enum DayLoad { empty, light, busy }`, `WeekStripDay({required DateTime date, required DayLoad load, required bool isToday})`, `buildWeekStrip(List<CalendarDay> days, {DateTime? today})` (pure, `List<WeekStripDay>`), `WeekStrip({required List<CalendarDay> days})`.

**Scope note:** the README specifies bar widths (14px busy / 8px light / 0px empty) but not the entry-count thresholds that pick between them. `buildWeekStrip` uses `>= 3` entries for "busy," `>= 1` for "light" — a documented, simple choice, not a spec value.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/week_strip_test.dart
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/activity/widgets/week_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry _entry(DateTime date) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: 't',
);

void main() {
  group('buildWeekStrip', () {
    test('returns 6 days starting today, marking today', () {
      final today = DateTime(2026, 9, 2); // Wednesday
      final strip = buildWeekStrip(const [], today: today);

      expect(strip, hasLength(6));
      expect(strip.first.date, today);
      expect(strip.first.isToday, isTrue);
      expect(strip.last.date, today.add(const Duration(days: 5)));
      expect(strip.last.isToday, isFalse);
    });

    test('classifies load by entry count: empty/light/busy', () {
      final today = DateTime(2026, 9, 2);
      final days = [
        CalendarDay(date: today, entries: [_entry(today), _entry(today), _entry(today)]),
        CalendarDay(date: today.add(const Duration(days: 1)), entries: [_entry(today)]),
      ];

      final strip = buildWeekStrip(days, today: today);

      expect(strip[0].load, DayLoad.busy); // 3 entries
      expect(strip[1].load, DayLoad.light); // 1 entry
      expect(strip[2].load, DayLoad.empty); // no entries
    });
  });

  group('WeekStrip widget', () {
    testWidgets('renders 6 day cells with weekday and date text', (tester) async {
      final today = DateTime(2026, 9, 2);
      final days = [CalendarDay(date: today, entries: [_entry(today)])];

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: WeekStrip(days: days, today: today))),
      );

      expect(find.text('WED'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
```

Note the `import 'package:arrstack/core/models/service_type.dart';`-equivalent `ServiceType` is already exported by `calendar_entry.dart`'s own imports — if `ServiceType` is unresolved when this test file is compiled, add `import 'package:arrstack/core/models/models.dart';` alongside the other imports.

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/week_strip_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/week_strip.dart` does not exist.

- [ ] **Step 3: Implement `buildWeekStrip` and `WeekStrip`**

```dart
// lib/features/activity/widgets/week_strip.dart
/// The Calendar lens's week strip (spec screen 2i): six day cells, each a
/// weekday label, a tabular date, and a load bar sized by how many entries
/// land on that day. Today gets an accent ring and accent text.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';

enum DayLoad { empty, light, busy }

class WeekStripDay {
  const WeekStripDay({
    required this.date,
    required this.load,
    required this.isToday,
  });

  final DateTime date;
  final DayLoad load;
  final bool isToday;
}

const List<String> _weekdayAbbrev = [
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN',
];

/// Six days starting at [today] (defaults to `DateTime.now()`), each
/// classified by how many [days] entries land on it: 0 → empty, 1-2 →
/// light, 3+ → busy. Pure — unit-testable without a widget tree.
List<WeekStripDay> buildWeekStrip(List<CalendarDay> days, {DateTime? today}) {
  final now = today ?? DateTime.now();
  final referenceDate = DateTime(now.year, now.month, now.day);

  final countByDate = <DateTime, int>{
    for (final day in days)
      DateTime(day.date.year, day.date.month, day.date.day): day.entries.length,
  };

  return [
    for (var i = 0; i < 6; i++) _dayFor(referenceDate.add(Duration(days: i)), countByDate, referenceDate),
  ];
}

WeekStripDay _dayFor(DateTime date, Map<DateTime, int> countByDate, DateTime today) {
  final count = countByDate[date] ?? 0;
  final load = count == 0
      ? DayLoad.empty
      : (count >= 3 ? DayLoad.busy : DayLoad.light);
  return WeekStripDay(date: date, load: load, isToday: date == today);
}

class WeekStrip extends StatelessWidget {
  const WeekStrip({required this.days, this.today, super.key});

  final List<CalendarDay> days;

  /// Injected for deterministic tests; defaults to `DateTime.now()` in
  /// production via [buildWeekStrip].
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final strip = buildWeekStrip(days, today: today);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (final day in strip)
          Expanded(child: _DayCell(day: day, colorScheme: colorScheme)),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.colorScheme});

  final WeekStripDay day;
  final ColorScheme colorScheme;

  double get _barWidth => switch (day.load) {
    DayLoad.busy => 14,
    DayLoad.light => 8,
    DayLoad.empty => 0,
  };

  @override
  Widget build(BuildContext context) {
    final activeColor = colorScheme.primary;
    final mutedColor = colorScheme.onSurfaceVariant;
    final textColor = day.isToday ? activeColor : colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: day.isToday ? Border.all(color: activeColor) : null,
      ),
      child: Column(
        children: [
          Text(
            _weekdayAbbrev[day.date.weekday - 1],
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: day.isToday ? activeColor : mutedColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${day.date.day}',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: _barWidth,
            height: 2,
            color: day.isToday ? activeColor : mutedColor,
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/week_strip_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/week_strip.dart test/features/activity/widgets/week_strip_test.dart
git commit -m "feat(activity): add WeekStrip widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 12: `CalendarTimelineRow` widget

**Files:**
- Create: `lib/features/activity/widgets/calendar_timeline_row.dart`
- Test: `test/features/activity/widgets/calendar_timeline_row_test.dart`

**Interfaces:**
- Consumes: `CalendarEntry`, `formatClockTime` (existing, `lib/features/calendar/widgets/calendar_date_format.dart`).
- Produces: `relativeAirLabel(DateTime date, DateTime now)` (pure, `String`), `CalendarTimelineRow({required CalendarEntry entry, DateTime? now})`. Replaces `lib/features/calendar/widgets/calendar_entry_tile.dart`'s `CalendarEntryTile`.

**Scope note:** the 2i spec's "—" (dateless physical release) time-column case can't occur with this app's data — `CalendarEntry.fromRadarrMovie`/`fromSonarrEpisode` already return `null` (dropping the item before it becomes an entry) when there's no date, so every `CalendarEntry` this row ever receives has a real `date`. The row doesn't special-case a state that can't reach it. The 2i chip row's quality/size text ("1080p · 2.1 GB") also has no backing field on `CalendarEntry` — the chip shows "Downloaded"/"Monitored"/"Unmonitored" plus a relative air-time caption instead.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/calendar_timeline_row_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/features/activity/widgets/calendar_timeline_row.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry _entry({
  required DateTime date,
  bool hasFile = false,
  bool monitored = true,
  String? subtitle,
  String? network,
}) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: 'The Bear',
  subtitle: subtitle,
  network: network,
  hasFile: hasFile,
  monitored: monitored,
);

void main() {
  group('relativeAirLabel', () {
    test('future date under 24h shows hours', () {
      final now = DateTime(2026, 1, 1, 9);
      expect(relativeAirLabel(DateTime(2026, 1, 1, 20), now), 'airs in 11h');
    });

    test('future date 24h+ shows days', () {
      final now = DateTime(2026, 1, 1, 9);
      expect(relativeAirLabel(DateTime(2026, 1, 4, 9), now), 'airs in 3d');
    });

    test('past date under 24h shows hours ago', () {
      final now = DateTime(2026, 1, 1, 9);
      expect(relativeAirLabel(DateTime(2026, 1, 1, 3), now), 'aired 6h ago');
    });
  });

  group('CalendarTimelineRow widget', () {
    testWidgets('shows title, subtitle/network line, and a Downloaded chip', (tester) async {
      final now = DateTime(2026, 1, 1, 12);
      final entry = _entry(
        date: DateTime(2026, 1, 1, 3),
        hasFile: true,
        subtitle: 'S04E03',
        network: 'FX',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CalendarTimelineRow(entry: entry, now: now)),
        ),
      );

      expect(find.text('The Bear'), findsOneWidget);
      expect(find.textContaining('S04E03'), findsOneWidget);
      expect(find.text('Downloaded'), findsOneWidget);
    });

    testWidgets('shows a Monitored chip with a relative air caption when no file yet', (
      tester,
    ) async {
      final now = DateTime(2026, 1, 1, 9);
      final entry = _entry(date: DateTime(2026, 1, 1, 20));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CalendarTimelineRow(entry: entry, now: now)),
        ),
      );

      expect(find.text('Monitored'), findsOneWidget);
      expect(find.text('airs in 11h'), findsOneWidget);
    });

    testWidgets('shows an Unmonitored chip when not monitored and no file', (tester) async {
      final now = DateTime(2026, 1, 1, 9);
      final entry = _entry(date: DateTime(2026, 1, 1, 20), monitored: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CalendarTimelineRow(entry: entry, now: now)),
        ),
      );

      expect(find.text('Unmonitored'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/calendar_timeline_row_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/calendar_timeline_row.dart` does not exist.

- [ ] **Step 3: Implement `relativeAirLabel` and `CalendarTimelineRow`**

```dart
// lib/features/activity/widgets/calendar_timeline_row.dart
/// One scheduled item on the Calendar lens's day-grouped list (spec screen
/// 2i): a tabular time column, a left divider, a title/meta line, and a
/// status chip. Replaces
/// `lib/features/calendar/widgets/calendar_entry_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:flutter/material.dart';

/// "airs in 11h" / "airs in 3d" / "aired 6h ago" relative to [now]. Pure —
/// unit-testable without a widget tree.
String relativeAirLabel(DateTime date, DateTime now) {
  final diff = date.difference(now);
  if (diff.isNegative) {
    final ago = -diff;
    return ago.inHours < 24 ? 'aired ${ago.inHours}h ago' : 'aired ${ago.inDays}d ago';
  }
  return diff.inHours < 24 ? 'airs in ${diff.inHours}h' : 'airs in ${diff.inDays}d';
}

class CalendarTimelineRow extends StatelessWidget {
  const CalendarTimelineRow({required this.entry, this.now, super.key});

  final CalendarEntry entry;

  /// Injected for deterministic tests; defaults to `DateTime.now()`.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final entryDay = DateTime(entry.date.year, entry.date.month, entry.date.day);
    final hasAired = !entry.date.isAfter(reference);
    final timeColor = (entryDay == today && hasAired)
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final metaLine = [
      entry.subtitle,
      entry.network,
    ].where((s) => s != null && s.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Text(
                formatClockTime(entry.date),
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 11,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: timeColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 13),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (metaLine.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        metaLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 11.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.space2),
                    _StatusRow(entry: entry, now: reference),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.entry, required this.now});

  final CalendarEntry entry;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (entry.hasFile) {
      return const _Chip(label: 'Downloaded', color: AppColors.up);
    }
    if (!entry.monitored) {
      return const _Chip(label: 'Unmonitored', color: AppColors.n500);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Chip(label: 'Monitored', color: colorScheme.primary),
        const SizedBox(width: AppSpacing.space2),
        Text(
          relativeAirLabel(entry.date, now),
          style: AppTypography.meta.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/calendar_timeline_row_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/calendar_timeline_row.dart \
  test/features/activity/widgets/calendar_timeline_row_test.dart
git commit -m "feat(activity): add CalendarTimelineRow widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 13: `MissingEpisodeRow` widget

**Files:**
- Create: `lib/features/activity/widgets/missing_episode_row.dart`
- Test: `test/features/activity/widgets/missing_episode_row_test.dart`

**Interfaces:**
- Consumes: `SonarrMissingEpisode` (Task 4), `RoutePaths.episodeReleaseSearch(String instanceId, int seriesId, int episodeId, String title)` (existing, `lib/app/route_paths.dart`).
- Produces: `episodeCode(int? season, int? episode)` (pure, `String`), `formatAiredDate(DateTime? date)` (pure, `String`), `MissingEpisodeRow({required SonarrMissingEpisode missingEpisode})`.

**Scope note:** 2j's meta line ("aired 2022-03-25 · 3 releases found") needs a release count that would mean eagerly calling `searchEpisodeReleases` for every missing episode just to render the list — expensive and not how the search flow works elsewhere in the app. The row shows "aired {date}" only; tapping "Search releases" routes to the existing `ReleaseSearchPage` (same page used by episode/movie detail screens), where the real search happens. When `episode.seriesId` is null (a data anomaly — Sonarr always sets it on real episodes), the button is disabled rather than navigating with a bad route.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/missing_episode_row_test.dart
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/missing_episode_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('episodeCode', () {
    test('zero-pads season and episode', () {
      expect(episodeCode(4, 3), 'S04E03');
      expect(episodeCode(1, 12), 'S01E12');
    });

    test('falls back to 00 for a missing season or episode', () {
      expect(episodeCode(null, 3), 'S00E03');
      expect(episodeCode(4, null), 'S04E00');
    });
  });

  group('formatAiredDate', () {
    test('formats as YYYY-MM-DD', () {
      expect(formatAiredDate(DateTime.utc(2022, 3, 25)), '2022-03-25');
    });

    test('returns an em dash for a null date', () {
      expect(formatAiredDate(null), '—');
    });
  });

  group('MissingEpisodeRow widget', () {
    Widget wrap(Widget child) => MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => Scaffold(body: child)),
          GoRoute(
            path: '/library/sonarr/:instanceId/series/:seriesId/episode/:episodeId/search',
            builder: (context, state) => const Scaffold(body: Text('search page')),
          ),
        ],
      ),
    );

    testWidgets('shows the episode code, series/episode title, and aired date', (tester) async {
      final missing = SonarrMissingEpisode(
        instanceId: 'sonarr-1',
        episode: SonarrCalendarEpisode(
          id: 501,
          seriesId: 9,
          seasonNumber: 2,
          episodeNumber: 5,
          title: 'The You You Are',
          airDateUtc: DateTime.utc(2022, 3, 25),
          series: const SonarrSeries(title: 'Severance'),
        ),
      );

      await tester.pumpWidget(wrap(MissingEpisodeRow(missingEpisode: missing)));

      expect(find.text('S02E05'), findsOneWidget);
      expect(find.textContaining('Severance'), findsOneWidget);
      expect(find.textContaining('2022-03-25'), findsOneWidget);
    });

    testWidgets('tapping Search releases navigates to the release search route', (tester) async {
      final missing = SonarrMissingEpisode(
        instanceId: 'sonarr-1',
        episode: SonarrCalendarEpisode(id: 501, seriesId: 9, title: 'x'),
      );

      await tester.pumpWidget(wrap(MissingEpisodeRow(missingEpisode: missing)));
      await tester.tap(find.text('Search releases'));
      await tester.pumpAndSettle();

      expect(find.text('search page'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/missing_episode_row_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/missing_episode_row.dart` does not exist.

- [ ] **Step 3: Implement `episodeCode`, `formatAiredDate`, and `MissingEpisodeRow`**

```dart
// lib/features/activity/widgets/missing_episode_row.dart
/// One row in the Wanted lens's "MISSING EPISODES" section (spec screen
/// 2j): episode code, series/episode title, aired date, and a search
/// button that routes to the existing release-search page.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// "S04E03" — zero-padded, falling back to 00 for a missing part rather
/// than throwing. Pure — unit-testable without a widget tree.
String episodeCode(int? season, int? episode) {
  final s = (season ?? 0).toString().padLeft(2, '0');
  final e = (episode ?? 0).toString().padLeft(2, '0');
  return 'S${s}E$e';
}

/// "2022-03-25", or an em dash when there's no air date.
String formatAiredDate(DateTime? date) {
  if (date == null) return '—';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

class MissingEpisodeRow extends StatelessWidget {
  const MissingEpisodeRow({required this.missingEpisode, super.key});

  final SonarrMissingEpisode missingEpisode;

  @override
  Widget build(BuildContext context) {
    final episode = missingEpisode.episode;
    final colorScheme = Theme.of(context).colorScheme;
    final seriesId = episode.seriesId;
    final canSearch = seriesId != null;
    final actionColor = canSearch ? colorScheme.primary : colorScheme.outlineVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Text(
              episodeCode(episode.seasonNumber, episode.episodeNumber),
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${episode.series?.title ?? 'Unknown series'} · '
                  '${episode.title ?? 'Untitled episode'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle.copyWith(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  'aired ${formatAiredDate(episode.airDateUtc)}',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 10.5,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          SizedBox(
            height: 26,
            child: OutlinedButton.icon(
              onPressed: canSearch
                  ? () => context.go(
                      RoutePaths.episodeReleaseSearch(
                        missingEpisode.instanceId,
                        seriesId,
                        episode.id,
                        episode.title ?? 'Episode',
                      ),
                    )
                  : null,
              icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 14),
              label: const Text('Search releases'),
              style: OutlinedButton.styleFrom(
                foregroundColor: actionColor,
                side: BorderSide(color: actionColor),
                textStyle: const TextStyle(fontSize: 10.5),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/missing_episode_row_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/missing_episode_row.dart \
  test/features/activity/widgets/missing_episode_row_test.dart
git commit -m "feat(activity): add MissingEpisodeRow widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 14: `WantedSubtitleRow` widget

**Files:**
- Create: `lib/features/activity/widgets/wanted_subtitle_row.dart`
- Test: `test/features/activity/widgets/wanted_subtitle_row_test.dart`

**Interfaces:**
- Consumes: `BazarrWantedSubtitle` (existing, `lib/services/bazarr/models/bazarr_models.dart`).
- Produces: `WantedSubtitleRow({required BazarrWantedSubtitle subtitle})`. Replaces `lib/features/subtitles/widgets/wanted_subtitle_tile.dart`'s `WantedSubtitleTile`.

**Note:** unlike the old `WantedSubtitleTile`, this row has no per-item search button — 2j's Wanted-Subtitles rows show only title, meta line, and language tags; per-item search doesn't appear in that mockup (only the header's bulk "Search all" action does, wired in Task 18). This also sidesteps needing an `instanceId` on each row, since `bazarrWantedAggregateProvider` (Task 5) intentionally flattens to plain `BazarrWantedSubtitle` values — there's no per-row action left that would need it.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/wanted_subtitle_row_test.dart
import 'package:arrstack/features/activity/widgets/wanted_subtitle_row.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the title, series/episode meta line, and language tags', (tester) async {
    const subtitle = BazarrWantedSubtitle(
      title: 'The You You Are',
      type: 'episode',
      seriesTitle: 'Severance',
      seasonNumber: 2,
      episodeNumber: 5,
      languages: ['en', 'fr'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
      ),
    );

    expect(find.text('The You You Are'), findsOneWidget);
    expect(find.textContaining('Severance'), findsOneWidget);
    expect(find.textContaining('S02E05'), findsOneWidget);
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('FR'), findsOneWidget);
  });

  testWidgets('omits the meta line for a movie (no series title)', (tester) async {
    const subtitle = BazarrWantedSubtitle(
      title: 'Some Movie',
      type: 'movie',
      languages: ['en'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: WantedSubtitleRow(subtitle: subtitle)),
      ),
    );

    expect(find.text('Some Movie'), findsOneWidget);
    expect(find.textContaining('S0'), findsNothing);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/wanted_subtitle_row_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/wanted_subtitle_row.dart` does not exist.

- [ ] **Step 3: Implement `WantedSubtitleRow`**

```dart
// lib/features/activity/widgets/wanted_subtitle_row.dart
/// One row in the Wanted lens's "WANTED SUBTITLES" section (spec screen
/// 2j): title, an optional series/episode meta line, and one tag per
/// wanted language. Replaces
/// `lib/features/subtitles/widgets/wanted_subtitle_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:flutter/material.dart';

class WantedSubtitleRow extends StatelessWidget {
  const WantedSubtitleRow({required this.subtitle, super.key});

  final BazarrWantedSubtitle subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEpisode = subtitle.type == 'episode';
    final metaLine = isEpisode && subtitle.seriesTitle != null
        ? '${subtitle.seriesTitle} · '
              '${_seasonEpisodeCode(subtitle.seasonNumber, subtitle.episodeNumber)}'
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle.copyWith(color: colorScheme.onSurface),
                ),
                if (metaLine != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    metaLine,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 11.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Wrap(
            spacing: 4,
            children: [
              for (final language in subtitle.languages) _LanguageTag(label: language),
            ],
          ),
        ],
      ),
    );
  }

  String _seasonEpisodeCode(int? season, int? episode) {
    final s = (season ?? 0).toString().padLeft(2, '0');
    final e = (episode ?? 0).toString().padLeft(2, '0');
    return 'S${s}E$e';
  }
}

class _LanguageTag extends StatelessWidget {
  const _LanguageTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 9.5,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/wanted_subtitle_row_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/wanted_subtitle_row.dart \
  test/features/activity/widgets/wanted_subtitle_row_test.dart
git commit -m "feat(activity): add WantedSubtitleRow widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 15: `TransfersLens` composite widget

**Files:**
- Create: `lib/features/activity/widgets/transfers_lens.dart`
- Test: `test/features/activity/widgets/transfers_lens_test.dart`

**Interfaces:**
- Consumes: `selectedDownloadInstanceIdProvider`, `downloadFilterProvider`, `TorrentFilter` (existing, `lib/features/downloads/downloads_providers.dart` — kept per Global Constraints deviation 4), `qbitTorrentsProvider` (existing), `transfersThroughputHistoryProvider` (Task 6), `ThroughputSparkline` (Task 9), `TorrentBlock`/`torrentIsComplete`/`torrentIsStalled` (Task 10).
- Produces: `filterTorrents(List<QbitTorrent> all, TorrentFilter filter)` (pure, `List<QbitTorrent>`), `TransfersLens`.

**Note:** `TorrentFilter` has 7 values (kept unchanged per Global Constraints), but 2h's secondary chips only expose 3 (All/Downloading/Seeding). `filterTorrents` still switches on all 7 for completeness (a `_` fallback returns `all` for the 4 chips this lens doesn't surface), but only three drive UI here.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/transfers_lens_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/transfers_lens.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

QbitTorrent _torrent(String hash, String state) => QbitTorrent(
  hash: hash,
  name: hash,
  size: 1000,
  progress: 0.5,
  dlspeed: 100,
  upspeed: 0,
  priority: 1,
  numSeeds: 1,
  numLeechs: 1,
  numIncomplete: 0,
  ratio: 0,
  eta: 60,
  state: state,
  addedOn: 0,
  completionOn: 0,
  category: '',
  tags: '',
  savePath: '',
  timeActive: 0,
  lastActivity: 0,
);

void main() {
  group('filterTorrents', () {
    final torrents = [
      _torrent('a', 'downloading'),
      _torrent('b', 'uploading'),
      _torrent('c', 'pausedDL'),
    ];

    test('all returns every torrent', () {
      expect(filterTorrents(torrents, TorrentFilter.all), hasLength(3));
    });

    test('active returns only actively downloading torrents', () {
      final result = filterTorrents(torrents, TorrentFilter.active);
      expect(result.map((t) => t.hash), ['a']);
    });

    test('seeding returns completed/uploading torrents', () {
      final result = filterTorrents(torrents, TorrentFilter.seeding);
      expect(result.map((t) => t.hash), ['b']);
    });
  });

  group('TransfersLens widget', () {
    testWidgets('shows an empty state when there is no qBittorrent instance', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedDownloadInstanceIdProvider.overrideWith((ref) async => null),
          ],
          child: const MaterialApp(home: Scaffold(body: TransfersLens())),
        ),
      );
      await tester.pump();

      expect(find.text('No qBittorrent instance'), findsOneWidget);
    });

    testWidgets('shows the sparkline, secondary chips, and torrent list', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedDownloadInstanceIdProvider.overrideWith((ref) async => 'qbit-1'),
            qbitTorrentsProvider(
              'qbit-1',
            ).overrideWith((ref) async => Ok([_torrent('a', 'downloading')])),
            transfersThroughputHistoryProvider('qbit-1').overrideWith(() => _FakeHistory()),
          ],
          child: const MaterialApp(home: Scaffold(body: TransfersLens())),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('All'), findsOneWidget);
      expect(find.textContaining('Downloading'), findsWidgets);
      expect(find.textContaining('Seeding'), findsWidgets);
      expect(find.text('a'), findsOneWidget); // torrent name
    });
  });
}

/// Stands in for the real [TransfersThroughputHistory] so the widget test
/// doesn't start a live `Timer.periodic` — the sampling behavior itself is
/// covered by Task 6's provider tests.
class _FakeHistory extends TransfersThroughputHistory {
  @override
  List<ThroughputSample> build(String instanceId) => const [];
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/transfers_lens_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/transfers_lens.dart` does not exist.

- [ ] **Step 3: Implement `filterTorrents` and `TransfersLens`**

```dart
// lib/features/activity/widgets/transfers_lens.dart
/// The Transfers lens (spec screen 2h): throughput sparkline, secondary
/// filter chips, and the torrent list. Ties together
/// `selectedDownloadInstanceIdProvider`/`qbitTorrentsProvider`/
/// `downloadFilterProvider` (kept from the deleted `DownloadsPage`) with
/// the new `TransfersThroughputHistory` and `TorrentBlock`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/throughput_sparkline.dart';
import 'package:arrstack/features/activity/widgets/torrent_block.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/services/qbittorrent/models/qbit_models.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// Applies [filter] to [all]. Pure — unit-testable without a widget tree.
/// Only `all`/`active`/`seeding` drive this lens's UI (2h's three secondary
/// chips); the other `TorrentFilter` values pass through unfiltered rather
/// than being unreachable dead code, in case a future screen reuses them.
List<QbitTorrent> filterTorrents(List<QbitTorrent> all, TorrentFilter filter) {
  return switch (filter) {
    TorrentFilter.all => all,
    TorrentFilter.active => all
        .where((t) => !torrentIsComplete(t) && t.state != 'pausedDL' && t.state != 'stalledDL')
        .toList(),
    TorrentFilter.seeding => all.where(torrentIsComplete).toList(),
    _ => all,
  };
}

class TransfersLens extends ConsumerWidget {
  const TransfersLens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedDownloadInstanceIdProvider);

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const EmptyState(
              icon: PhosphorIconsRegular.downloadSimple,
              title: 'No qBittorrent instance',
              message: 'Configure a qBittorrent service in Settings to see transfers.',
            )
          : _TransfersBody(instanceId: id),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _TransfersBody extends ConsumerWidget {
  const _TransfersBody({required this.instanceId});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final samples = ref.watch(transfersThroughputHistoryProvider(instanceId));
    final torrentsAsync = ref.watch(qbitTorrentsProvider(instanceId));
    final filter = ref.watch(downloadFilterProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(qbitTorrentsProvider(instanceId).future),
      child: torrentsAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) => _TorrentListView(
            instanceId: instanceId,
            all: value,
            filter: filter,
            samples: samples,
          ),
          Err(:final error) => EmptyState(
            icon: PhosphorIconsRegular.warning,
            title: 'Failed to load torrents',
            message: error.userMessage,
            action: FilledButton(
              onPressed: () => ref.invalidate(qbitTorrentsProvider(instanceId)),
              child: const Text('Retry'),
            ),
          ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Unexpected error: $err')),
      ),
    );
  }
}

class _TorrentListView extends ConsumerWidget {
  const _TorrentListView({
    required this.instanceId,
    required this.all,
    required this.filter,
    required this.samples,
  });

  final String instanceId;
  final List<QbitTorrent> all;
  final TorrentFilter filter;
  final List<ThroughputSample> samples;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = filterTorrents(all, filter);
    final activeCount = filterTorrents(all, TorrentFilter.active).length;
    final seedingCount = filterTorrents(all, TorrentFilter.seeding).length;

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        ThroughputSparkline(samples: samples),
        const SizedBox(height: AppSpacing.space4),
        _SecondaryChips(
          filter: filter,
          allCount: all.length,
          activeCount: activeCount,
          seedingCount: seedingCount,
        ),
        const SizedBox(height: AppSpacing.space3),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space8),
            child: EmptyState(
              icon: PhosphorIconsRegular.trayEmpty,
              title: 'Nothing here',
              message: 'Try a different filter.',
            ),
          )
        else
          for (final torrent in filtered)
            TorrentBlock(instanceId: instanceId, torrent: torrent),
      ],
    );
  }
}

class _SecondaryChips extends ConsumerWidget {
  const _SecondaryChips({
    required this.filter,
    required this.allCount,
    required this.activeCount,
    required this.seedingCount,
  });

  final TorrentFilter filter;
  final int allCount;
  final int activeCount;
  final int seedingCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _SecondaryChip(
          label: 'All $allCount',
          isActive: filter == TorrentFilter.all,
          onTap: () => ref.read(downloadFilterProvider.notifier).setFilter(TorrentFilter.all),
        ),
        const SizedBox(width: AppSpacing.space2),
        _SecondaryChip(
          label: 'Downloading $activeCount',
          isActive: filter == TorrentFilter.active,
          onTap: () =>
              ref.read(downloadFilterProvider.notifier).setFilter(TorrentFilter.active),
        ),
        const SizedBox(width: AppSpacing.space2),
        _SecondaryChip(
          label: 'Seeding $seedingCount',
          isActive: filter == TorrentFilter.seeding,
          onTap: () =>
              ref.read(downloadFilterProvider.notifier).setFilter(TorrentFilter.seeding),
        ),
      ],
    );
  }
}

class _SecondaryChip extends StatelessWidget {
  const _SecondaryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive ? Border.all(color: color) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/transfers_lens_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/transfers_lens.dart \
  test/features/activity/widgets/transfers_lens_test.dart
git commit -m "feat(activity): add TransfersLens composite widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 16: `CalendarLens` composite widget

**Files:**
- Create: `lib/features/activity/widgets/calendar_lens.dart`
- Test: `test/features/activity/widgets/calendar_lens_test.dart`

**Interfaces:**
- Consumes: `calendarScheduleProvider` (existing, `lib/features/calendar/calendar_providers.dart` — kept, per Files structure), `CalendarDay`/`CalendarEntry` (existing), `formatDayHeader`/`relativeDayLabel` (existing, `lib/features/calendar/widgets/calendar_date_format.dart`), `WeekStrip` (Task 11), `CalendarTimelineRow` (Task 12).
- Produces: `CalendarLens`.

**Scope note:** 2i's header shows a search icon in the shared `AppBar`, but this lens keeps the inline `TextField` the old `CalendarPage` used (same behavior, restyled) rather than round-tripping search state through the `AppBar`'s per-lens action — one fewer provider and one fewer piece of cross-widget wiring for a same-screen feature that doesn't need to survive navigation. Task 18 gives Calendar no `AppBar` trailing action as a result.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/calendar_lens_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/widgets/calendar_lens.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEntry _entry(String title, DateTime date) => CalendarEntry(
  kind: CalendarEntryKind.episode,
  service: ServiceType.sonarr,
  instanceId: 'i',
  date: date,
  title: title,
);

void main() {
  testWidgets('shows an empty state when the schedule has no days', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarScheduleProvider.overrideWith((ref) async => const Ok([])),
        ],
        child: const MaterialApp(home: Scaffold(body: CalendarLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing scheduled'), findsOneWidget);
  });

  testWidgets('shows day entries and filters them by search text', (tester) async {
    final today = DateTime.now();
    final days = [
      CalendarDay(date: today, entries: [_entry('The Bear', today), _entry('Severance', today)]),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarScheduleProvider.overrideWith((ref) async => Ok(days)),
        ],
        child: const MaterialApp(home: Scaffold(body: CalendarLens())),
      ),
    );
    await tester.pump();

    expect(find.text('The Bear'), findsOneWidget);
    expect(find.text('Severance'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bear');
    await tester.pump();

    expect(find.text('The Bear'), findsOneWidget);
    expect(find.text('Severance'), findsNothing);
  });

  testWidgets('shows the error state and a retry button on Err', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarScheduleProvider.overrideWith(
            (ref) async => const Err(NetworkError()),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: CalendarLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Retry'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/calendar_lens_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/calendar_lens.dart` does not exist.

- [ ] **Step 3: Implement `CalendarLens`**

```dart
// lib/features/activity/widgets/calendar_lens.dart
/// The Calendar lens (spec screen 2i): a week strip above a day-grouped,
/// searchable timeline. Reuses `calendarScheduleProvider` unchanged from
/// the deleted `CalendarPage`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/widgets/calendar_timeline_row.dart';
import 'package:arrstack/features/activity/widgets/week_strip.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class CalendarLens extends ConsumerStatefulWidget {
  const CalendarLens({super.key});

  @override
  ConsumerState<CalendarLens> createState() => _CalendarLensState();
}

class _CalendarLensState extends ConsumerState<CalendarLens> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(CalendarEntry entry) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return entry.title.toLowerCase().contains(q) ||
        (entry.subtitle?.toLowerCase().contains(q) ?? false) ||
        (entry.network?.toLowerCase().contains(q) ?? false);
  }

  List<CalendarDay> _filter(List<CalendarDay> days) {
    if (_query.isEmpty) return days;
    return [
      for (final day in days)
        if (day.entries.any(_matches))
          CalendarDay(date: day.date, entries: day.entries.where(_matches).toList()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(calendarScheduleProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space3,
            AppSpacing.space6,
            AppSpacing.space3,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
              hintText: 'Search calendar…',
              prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass, size: 18),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(calendarScheduleProvider),
            child: scheduleAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) =>
                  _CalendarBody(allDays: value, filteredDays: _filter(value)),
                Err(:final error) => EmptyState(
                  icon: PhosphorIconsRegular.warning,
                  title: "Couldn't load the calendar",
                  message: error.userMessage,
                  action: FilledButton(
                    onPressed: () => ref.invalidate(calendarScheduleProvider),
                    child: const Text('Retry'),
                  ),
                ),
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => EmptyState(
                icon: PhosphorIconsRegular.warning,
                title: 'Unexpected error',
                message: err.toString(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody({required this.allDays, required this.filteredDays});

  final List<CalendarDay> allDays;
  final List<CalendarDay> filteredDays;

  @override
  Widget build(BuildContext context) {
    if (filteredDays.isEmpty) {
      return ListView(
        children: [
          Padding(padding: AppInsets.pageLg, child: WeekStrip(days: allDays)),
          const SizedBox(height: AppSpacing.space8),
          const EmptyState(
            icon: PhosphorIconsRegular.calendarX,
            title: 'Nothing scheduled',
            message:
                'Monitored episodes and movie releases will appear here '
                'once your Sonarr and Radarr instances have upcoming items.',
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space6,
        0,
        AppSpacing.space6,
        AppSpacing.space8,
      ),
      children: [
        WeekStrip(days: allDays),
        const SizedBox(height: AppSpacing.space4),
        for (final day in filteredDays) _DaySection(day: day),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day});

  final CalendarDay day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final relative = relativeDayLabel(day.date, now);
    final header = relative == null
        ? formatDayHeader(day.date)
        : '$relative · ${formatDayHeader(day.date)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header.toUpperCase(),
                style: AppTypography.kicker.copyWith(color: theme.colorScheme.primary),
              ),
              Text(
                '${day.entries.length}',
                style: AppTypography.meta.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final entry in day.entries) CalendarTimelineRow(entry: entry),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/calendar_lens_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/calendar_lens.dart \
  test/features/activity/widgets/calendar_lens_test.dart
git commit -m "feat(activity): add CalendarLens composite widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 17: `WantedLens` composite widget

**Files:**
- Create: `lib/features/activity/widgets/wanted_lens.dart`
- Test: `test/features/activity/widgets/wanted_lens_test.dart`

**Interfaces:**
- Consumes: `sonarrMissingEpisodesProvider` (Task 4), `bazarrWantedAggregateProvider` (Task 5), `MissingEpisodeRow` (Task 13), `WantedSubtitleRow` (Task 14), `ErrorCard` (Task 7).
- Produces: `enum WantedFilter { everything, episodes, subtitles }`, `WantedLens`.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/widgets/wanted_lens_test.dart
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/activity/widgets/wanted_lens.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the offline error card when Bazarr is unreachable', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith((ref) async => []),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async => const BazarrWantedAggregate(
              subtitles: [BazarrWantedSubtitle(title: 'still works')],
              hasUnreachableInstance: true,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Bazarr is unreachable'), findsOneWidget);
    expect(find.text('still works'), findsOneWidget); // partial data still lists
  });

  testWidgets('shows both sections with their kicker counts when data exists', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith(
            (ref) async => [
              SonarrMissingEpisode(
                instanceId: 'sonarr-1',
                episode: SonarrCalendarEpisode(id: 1, seriesId: 9, title: 'x'),
              ),
            ],
          ),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async => const BazarrWantedAggregate(
              subtitles: [BazarrWantedSubtitle(title: 'y')],
              hasUnreachableInstance: false,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    expect(find.textContaining('MISSING EPISODES'), findsOneWidget);
    expect(find.textContaining('WANTED SUBTITLES'), findsOneWidget);
    expect(find.text('Bazarr is unreachable'), findsNothing);
  });

  testWidgets('tapping the Episodes chip hides the subtitles section', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith(
            (ref) async => [
              SonarrMissingEpisode(
                instanceId: 'sonarr-1',
                episode: SonarrCalendarEpisode(id: 1, seriesId: 9, title: 'x'),
              ),
            ],
          ),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async => const BazarrWantedAggregate(
              subtitles: [BazarrWantedSubtitle(title: 'y')],
              hasUnreachableInstance: false,
            ),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Episodes'));
    await tester.pump();

    expect(find.textContaining('MISSING EPISODES'), findsOneWidget);
    expect(find.textContaining('WANTED SUBTITLES'), findsNothing);
  });

  testWidgets('shows an empty state when there is nothing wanted and no error', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrMissingEpisodesProvider.overrideWith((ref) async => []),
          bazarrWantedAggregateProvider.overrideWith(
            (ref) async =>
                const BazarrWantedAggregate(subtitles: [], hasUnreachableInstance: false),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: WantedLens())),
      ),
    );
    await tester.pump();

    expect(find.text('Nothing wanted'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/widgets/wanted_lens_test.dart`
Expected: FAIL — `package:arrstack/features/activity/widgets/wanted_lens.dart` does not exist.

- [ ] **Step 3: Implement `WantedLens`**

```dart
// lib/features/activity/widgets/wanted_lens.dart
/// The Wanted lens (spec screen 2j): everything incomplete from Sonarr and
/// Bazarr in one list, with the shared offline error card when Bazarr is
/// unreachable.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/missing_episode_row.dart';
import 'package:arrstack/features/activity/widgets/wanted_subtitle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

enum WantedFilter { everything, episodes, subtitles }

class WantedLens extends ConsumerStatefulWidget {
  const WantedLens({super.key});

  @override
  ConsumerState<WantedLens> createState() => _WantedLensState();
}

class _WantedLensState extends ConsumerState<WantedLens> {
  WantedFilter _filter = WantedFilter.everything;

  @override
  Widget build(BuildContext context) {
    final episodesAsync = ref.watch(sonarrMissingEpisodesProvider);
    final aggregateAsync = ref.watch(bazarrWantedAggregateProvider);

    if (episodesAsync.isLoading || aggregateAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final episodes = episodesAsync.valueOrNull ?? const [];
    final aggregate =
        aggregateAsync.valueOrNull ??
        const BazarrWantedAggregate(subtitles: [], hasUnreachableInstance: false);

    return _WantedBody(
      episodes: episodes,
      aggregate: aggregate,
      filter: _filter,
      onFilterChanged: (filter) => setState(() => _filter = filter),
    );
  }
}

class _WantedBody extends ConsumerWidget {
  const _WantedBody({
    required this.episodes,
    required this.aggregate,
    required this.filter,
    required this.onFilterChanged,
  });

  final List<SonarrMissingEpisode> episodes;
  final BazarrWantedAggregate aggregate;
  final WantedFilter filter;
  final ValueChanged<WantedFilter> onFilterChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showEpisodes = filter != WantedFilter.subtitles && episodes.isNotEmpty;
    final showSubtitles = filter != WantedFilter.episodes && aggregate.subtitles.isNotEmpty;
    final nothingWanted =
        episodes.isEmpty && aggregate.subtitles.isEmpty && !aggregate.hasUnreachableInstance;

    if (nothingWanted) {
      return const EmptyState(
        icon: PhosphorIconsRegular.checkCircle,
        title: 'Nothing wanted',
        message: 'All your media has files and subtitles.',
      );
    }

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        if (aggregate.hasUnreachableInstance) ...[
          ErrorCard(
            title: 'Bazarr is unreachable',
            message:
                "Subtitle searches will queue until it's back. Radarr and "
                'Sonarr are unaffected.',
            primaryActionLabel: 'Retry now',
            onPrimaryAction: () => ref.invalidate(bazarrWantedAggregateProvider),
            secondaryActionLabel: 'Open settings',
            onSecondaryAction: () => context.go(RoutePaths.homeSettings),
          ),
          const SizedBox(height: AppSpacing.space4),
        ],
        _SecondaryChips(
          filter: filter,
          onChanged: onFilterChanged,
          episodeCount: episodes.length,
          subtitleCount: aggregate.subtitles.length,
        ),
        const SizedBox(height: AppSpacing.space4),
        if (showEpisodes) ...[
          _SectionHeader(
            kicker: 'MISSING EPISODES · ${episodes.length}',
            trailing: 'Sonarr',
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final episode in episodes) MissingEpisodeRow(missingEpisode: episode),
          const SizedBox(height: AppSpacing.space4),
        ],
        if (showSubtitles) ...[
          _SectionHeader(
            kicker: 'WANTED SUBTITLES · ${aggregate.subtitles.length}',
            trailing: 'queued',
            trailingColor: AppColors.down,
          ),
          const SizedBox(height: AppSpacing.space3),
          for (final subtitle in aggregate.subtitles) WantedSubtitleRow(subtitle: subtitle),
        ],
      ],
    );
  }
}

class _SecondaryChips extends StatelessWidget {
  const _SecondaryChips({
    required this.filter,
    required this.onChanged,
    required this.episodeCount,
    required this.subtitleCount,
  });

  final WantedFilter filter;
  final ValueChanged<WantedFilter> onChanged;
  final int episodeCount;
  final int subtitleCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Chip(
          label: 'Everything ${episodeCount + subtitleCount}',
          isActive: filter == WantedFilter.everything,
          onTap: () => onChanged(WantedFilter.everything),
        ),
        const SizedBox(width: AppSpacing.space2),
        _Chip(
          label: 'Episodes',
          isActive: filter == WantedFilter.episodes,
          onTap: () => onChanged(WantedFilter.episodes),
        ),
        const SizedBox(width: AppSpacing.space2),
        _Chip(
          label: 'Subtitles',
          isActive: filter == WantedFilter.subtitles,
          onTap: () => onChanged(WantedFilter.subtitles),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive ? Border.all(color: color) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.kicker,
    required this.trailing,
    this.trailingColor,
  });

  final String kicker;
  final String trailing;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(kicker, style: AppTypography.kicker.copyWith(color: colorScheme.primary)),
        Text(
          trailing,
          style: AppTypography.meta.copyWith(
            color: trailingColor ?? colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/widgets/wanted_lens_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/widgets/wanted_lens.dart \
  test/features/activity/widgets/wanted_lens_test.dart
git commit -m "feat(activity): add WantedLens composite widget

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 18: `ActivityPage`

**Files:**
- Create: `lib/features/activity/activity_page.dart`
- Test: `test/features/activity/activity_page_test.dart`

**Interfaces:**
- Consumes: `activeActivityLensProvider` (Task 3), `sonarrMissingEpisodesProvider` (Task 4), `bazarrWantedAggregateProvider` (Task 5), `LensChips` (Task 8), `TransfersLens` (Task 15), `CalendarLens` (Task 16), `WantedLens` (Task 17), `selectedDownloadInstanceIdProvider`/`AddTorrentDialog` (existing, kept), `instancesProvider`/`bazarrRepositoryProvider` (existing).
- Produces: `ActivityPage({String? initialLens})`.

**Scope note (why not `IndexedStack`):** the design spec's Widget plan offers `AutomaticKeepAliveClientMixin` or `IndexedStack` to preserve scroll position across lens switches, but either keeps all three lenses' widgets mounted — which would keep `TransfersThroughputHistory`'s `Timer.periodic` running even while looking at Calendar or Wanted, directly violating the spec's own Edge Cases ("the timer must stop... so it doesn't keep polling qBittorrent while the user is on Calendar/Wanted"). `ActivityPage` instead builds only the active lens via a plain `switch`, which correctly disposes the inactive lenses' `autoDispose` providers (including the timer) at the cost of losing scroll position on switch-back — the documented tradeoff.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/activity/activity_page_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/activity/activity_page.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/models/activity_models.dart';
import 'package:arrstack/features/calendar/calendar_providers.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/services/qbittorrent/qbit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

List<Override> _baseOverrides() => [
  selectedDownloadInstanceIdProvider.overrideWith((ref) async => null),
  calendarScheduleProvider.overrideWith((ref) async => const Ok([])),
  sonarrMissingEpisodesProvider.overrideWith((ref) async => []),
  bazarrWantedAggregateProvider.overrideWith(
    (ref) async =>
        const BazarrWantedAggregate(subtitles: [], hasUnreachableInstance: false),
  ),
];

Widget _wrap({String? initialLens, List<Override> overrides = const []}) => ProviderScope(
  overrides: [..._baseOverrides(), ...overrides],
  child: MaterialApp.router(
    routerConfig: GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => ActivityPage(initialLens: initialLens),
        ),
        GoRoute(
          path: '/home/settings',
          builder: (context, state) => const Scaffold(body: Text('settings')),
        ),
      ],
    ),
  ),
);

void main() {
  testWidgets('defaults to the Transfers lens with an add-torrent action', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('No qBittorrent instance'), findsOneWidget); // Transfers empty state
    expect(find.byTooltip('Add torrent'), findsOneWidget);
  });

  testWidgets('seeds the lens from initialLens', (tester) async {
    await tester.pumpWidget(_wrap(initialLens: 'wanted'));
    await tester.pump();

    expect(find.text('Search all'), findsOneWidget); // Wanted's trailing action
    expect(find.text('Nothing wanted'), findsOneWidget);
  });

  testWidgets('tapping the Calendar chip switches lenses and hides the transfers action', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    await tester.tap(find.text('Calendar'));
    await tester.pump();

    expect(find.byTooltip('Add torrent'), findsNothing);
    expect(find.text('Nothing scheduled'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/activity/activity_page_test.dart`
Expected: FAIL — `package:arrstack/features/activity/activity_page.dart` does not exist.

- [ ] **Step 3: Implement `ActivityPage`**

```dart
// lib/features/activity/activity_page.dart
/// The Activity tab (spec screens 2h/2i/2j): a lens-chip header switching
/// between Transfers, Calendar, and Wanted, replacing the old separate
/// Downloads/Calendar/Subtitles pages.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/activity/widgets/calendar_lens.dart';
import 'package:arrstack/features/activity/widgets/lens_chips.dart';
import 'package:arrstack/features/activity/widgets/transfers_lens.dart';
import 'package:arrstack/features/activity/widgets/wanted_lens.dart';
import 'package:arrstack/features/downloads/downloads_providers.dart';
import 'package:arrstack/features/downloads/widgets/add_torrent_dialog.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

ActivityLens? _lensFromQueryValue(String? value) => switch (value) {
  'transfers' => ActivityLens.transfers,
  'calendar' => ActivityLens.calendar,
  'wanted' => ActivityLens.wanted,
  _ => null,
};

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({this.initialLens, super.key});

  /// The `?lens=` query value from the route, used only to seed
  /// [activeActivityLensProvider] on first build (spec Decision 1).
  final String? initialLens;

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  @override
  void initState() {
    super.initState();
    final seeded = _lensFromQueryValue(widget.initialLens);
    if (seeded != null) {
      ref.read(activeActivityLensProvider.notifier).select(seeded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lens = ref.watch(activeActivityLensProvider);
    final episodeCount = ref.watch(sonarrMissingEpisodesProvider).valueOrNull?.length ?? 0;
    final subtitleCount =
        ref.watch(bazarrWantedAggregateProvider).valueOrNull?.subtitles.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [_TrailingAction(lens: lens)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space6,
              vertical: AppSpacing.space3,
            ),
            child: LensChips(wantedCount: episodeCount + subtitleCount),
          ),
          Expanded(
            child: switch (lens) {
              ActivityLens.transfers => const TransfersLens(),
              ActivityLens.calendar => const CalendarLens(),
              ActivityLens.wanted => const WantedLens(),
            },
          ),
        ],
      ),
    );
  }
}

class _TrailingAction extends ConsumerWidget {
  const _TrailingAction({required this.lens});

  final ActivityLens lens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (lens) {
      ActivityLens.transfers => IconButton(
        icon: const Icon(PhosphorIconsRegular.plus),
        tooltip: 'Add torrent',
        onPressed: () => _addTorrent(context, ref),
      ),
      ActivityLens.calendar => const SizedBox.shrink(),
      ActivityLens.wanted => TextButton(
        onPressed: () => _searchAllSubtitles(context, ref),
        child: const Text('Search all'),
      ),
    };
  }

  Future<void> _addTorrent(BuildContext context, WidgetRef ref) async {
    final id = await ref.read(selectedDownloadInstanceIdProvider.future);
    if (!context.mounted) return;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please configure a qBittorrent instance first.'),
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (context) => AddTorrentDialog(instanceId: id),
    );
  }

  Future<void> _searchAllSubtitles(BuildContext context, WidgetRef ref) async {
    final instancesResult = await ref.read(instancesProvider.future);
    if (instancesResult is! Ok<List<ServiceInstance>>) return;

    final bazarrInstances = instancesResult.value
        .where((i) => i.serviceType == ServiceType.bazarr)
        .toList();

    var successCount = 0;
    for (final instance in bazarrInstances) {
      final repo = await ref.read(bazarrRepositoryProvider(instance.id).future);
      final result = await repo.searchAllSubtitles();
      if (result.isOk) successCount++;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Global search triggered on $successCount of '
          '${bazarrInstances.length} Bazarr instance(s).',
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/activity/activity_page_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/activity/activity_page.dart test/features/activity/activity_page_test.dart
git commit -m "feat(activity): add ActivityPage tying lenses and chips together

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 19: Route wiring — `router.dart` and `route_paths.dart`

**Files:**
- Modify: `lib/app/router.dart`
- Modify: `lib/app/route_paths.dart`

**Interfaces:**
- Consumes: `ActivityPage` (Task 18).
- Removes: `RoutePaths.activityCalendar`, `RoutePaths.activitySubtitles`.

**Scope note on testing:** `router.dart`'s Activity branch sits inside a `StatefulShellRoute.indexedStack`, which eagerly builds every branch's initial route (Home, Library, Activity) as soon as the shell mounts — a router-level widget test here would need working overrides for Home's and Library's full provider graphs too, not just Activity's, which is disproportionate to a routing swap. This task is verified by `flutter analyze` (catches any stale reference to the removed route constants or deleted page imports) and the existing `ActivityPage`/`LensChips` tests (Task 18/8), which already exercise the page this route now points at.

- [ ] **Step 1: Update `route_paths.dart`**

Replace the file's top-of-file doc comment and remove the two route constants:

```dart
// lib/app/route_paths.dart
/// Named route path constants for the bottom-nav shell (spec §5 features/).
///
/// Route map from design_handoff_arrstack_hub/README.md ("Route map").
library;

abstract final class RoutePaths {
  static const String home = '/home';
  static const String library = '/library';
  static const String activity = '/activity';

  static const String homeUptime = '/home/uptime';
  static String homeIndexers(String instanceId) => '/home/indexers/$instanceId';

  static const String homeSettings = '/home/settings';
  static const String homeAddInstance = '/home/settings/add';
  static String homeEditInstance(String id) => '/home/settings/$id/edit';

  static String homeEinthusanImport(String instanceId) =>
      '/home/einthusan/$instanceId';

  static const String homeDiscover = '/home/discover';
  static String homeDiscoverDetail(int id, String type) =>
      '/home/discover/detail/$id/$type';
  static String homeDiscoverGenre(String mediaType, int genreId, String name) =>
      '/home/discover/genre/$mediaType/$genreId?name=${Uri.encodeComponent(name)}';

  static String movieDetail(String instanceId, int movieId) =>
      '/library/radarr/$instanceId/movie/$movieId';
  static String addMovie(String instanceId) =>
      '/library/radarr/$instanceId/add';

  static String seriesDetail(String instanceId, int seriesId) =>
      '/library/sonarr/$instanceId/series/$seriesId';
  static String episodeDetail(String instanceId, int seriesId, int episodeId) =>
      '/library/sonarr/$instanceId/series/$seriesId/episode/$episodeId';
  static String addSeries(String instanceId) =>
      '/library/sonarr/$instanceId/add';

  static String episodeReleaseSearch(
    String instanceId,
    int seriesId,
    int episodeId,
    String title,
  ) =>
      '/library/sonarr/$instanceId/series/$seriesId/episode/$episodeId/search'
      '?title=${Uri.encodeComponent(title)}';

  static String movieReleaseSearch(
    String instanceId,
    int movieId,
    String title,
  ) =>
      '/library/radarr/$instanceId/movie/$movieId/search'
      '?title=${Uri.encodeComponent(title)}';
}
```

- [ ] **Step 2: Update `router.dart`'s Activity branch**

Replace the imports for the deleted pages — remove:

```dart
import 'package:arrstack/features/calendar/calendar_page.dart';
import 'package:arrstack/features/downloads/downloads_page.dart';
import 'package:arrstack/features/subtitles/subtitles_page.dart';
```

Add:

```dart
import 'package:arrstack/features/activity/activity_page.dart';
```

Replace the whole Activity `StatefulShellBranch` (the block starting `// Activity — temporarily shows the existing Downloads page...` through its closing `),`) with:

```dart
        // Activity — one page, three switchable lenses (Phase 4).
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePaths.activity,
              builder: (context, state) => ActivityPage(
                initialLens: state.uri.queryParameters['lens'],
              ),
            ),
          ],
        ),
```

- [ ] **Step 3: Verify no stale references remain**

Run: `grep -rn "activityCalendar\|activitySubtitles\|CalendarPage(\|DownloadsPage(\|SubtitlesPage(" lib/ test/`
Expected: no matches outside `lib/features/calendar/`, `lib/features/downloads/`, and `lib/features/subtitles/` themselves (those folders are trimmed/removed in Task 21 — a match inside them at this point is expected and fine).

- [ ] **Step 4: Analyze**

Run: `dart analyze --fatal-infos`
Expected: no errors. (Task 21 still needs to run afterward — `lib/features/subtitles/`, `downloads_page.dart`, `calendar_page.dart`, and `calendar_entry_tile.dart` are unreferenced now but not yet deleted, so analyze may warn about unused files only if the linter is configured for that; it is not fatal here.)

- [ ] **Step 5: Run the existing Activity/router-adjacent tests**

Run: `flutter test test/features/activity/`
Expected: PASS (unaffected by this task, confirms nothing regressed).

- [ ] **Step 6: Commit**

```bash
git add lib/app/router.dart lib/app/route_paths.dart
git commit -m "feat(activity): route /activity to the single lens-based ActivityPage

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 20: Home tile/card navigation — `service_tile_grid.dart` and `right_now_card.dart`

**Files:**
- Modify: `lib/features/home/widgets/service_tile_grid.dart`
- Modify: `lib/features/home/widgets/right_now_card.dart`
- Modify: `lib/features/home/home_page.dart`
- Create: `test/features/home/widgets/service_tile_grid_test.dart`
- Modify: `test/features/home/widgets/right_now_card_test.dart`

**Interfaces:**
- Consumes: `activeActivityLensProvider`/`ActivityLens` (Task 3).
- Produces: `RightNowCard({required RightNowSummary summary, VoidCallback? onTap})` (new optional parameter; `onTap` defaults to `null`, so every existing call site — and every existing test — keeps compiling unchanged unless it wants the new behavior).

**Deviations applied here (see Global Constraints 1 and 2):** the Bazarr tile is repointed from `RoutePaths.activitySubtitles(instanceId)` to the Activity page's Wanted lens. The Sonarr tile is **not** touched — it keeps navigating to Library (the Phase 3 fix). `RightNowCard` (qBittorrent's Home representation — there is no qBittorrent tile in `ServiceTileGrid`) gains a tap target that opens Activity's Transfers lens, which it didn't have before.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/home/widgets/service_tile_grid_test.dart
// ServiceTileGrid's Bazarr tile must select the Wanted lens and navigate
// to /activity (not the old /activity/subtitles/:instanceId route).
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('tapping the Bazarr tile selects the Wanted lens and navigates to /activity', (
    tester,
  ) async {
    late ProviderContainer container;
    String? visitedPath;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeServiceSummariesProvider.overrideWith(
            (ref) async => const [
              HomeServiceSummary(
                instanceId: 'bazarr-1',
                instanceName: 'Bazarr',
                serviceType: ServiceType.bazarr,
                isReachable: true,
                summaryLine: '2 wanted subtitles',
              ),
            ],
          ),
        ],
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/',
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (context, state) =>
                        const Scaffold(body: ServiceTileGrid()),
                  ),
                  GoRoute(
                    path: '/activity',
                    builder: (context, state) {
                      visitedPath = '/activity';
                      return const Scaffold(body: Text('activity'));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Bazarr'));
    await tester.pumpAndSettle();

    expect(visitedPath, '/activity');
    expect(container.read(activeActivityLensProvider), ActivityLens.wanted);
  });
}
```

Add these tests to the existing `test/features/home/widgets/right_now_card_test.dart` (append to `main()`):

```dart
  testWidgets('is tappable when onTap is provided', (tester) async {
    const summary = RightNowSummary(
      downloadSpeed: 0,
      uploadSpeed: 0,
      downloadingCount: 0,
      seedingCount: 0,
      downloadingFraction: 0,
      pausedOrStalledFraction: 0,
      queuedFraction: 0,
    );
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RightNowCard(summary: summary, onTap: () => tapped = true),
        ),
      ),
    );
    await tester.tap(find.byType(RightNowCard));

    expect(tapped, isTrue);
  });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/home/widgets/service_tile_grid_test.dart test/features/home/widgets/right_now_card_test.dart`
Expected: FAIL — `service_tile_grid_test.dart` fails because tapping "Bazarr" still navigates to the old route (no `/activity` route match / `visitedPath` stays null); `right_now_card_test.dart`'s new case fails because `RightNowCard` has no `onTap` parameter yet.

- [ ] **Step 3: Wire `RightNowCard`'s new `onTap`**

In `lib/features/home/widgets/right_now_card.dart`, change the constructor and wrap the returned `Container` in an `InkWell`:

```dart
class RightNowCard extends StatelessWidget {
  const RightNowCard({required this.summary, this.onTap, super.key});

  final RightNowSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final eta = summary.etaToNextFinishSeconds;
    final etaCaption = eta == null
        ? ''
        : ' · next in ${FormatUtils.formatEta(eta)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: AppShadows.ringSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RIGHT NOW',
              style: AppTypography.kicker.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.space3),
            Row(
              children: [
                Icon(
                  PhosphorIconsRegular.downloadSimple,
                  size: 16,
                  color: isDark ? AppColors.a300 : colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.space2),
                Text(
                  '${FormatUtils.formatSpeed(summary.downloadSpeed)} · '
                  '${FormatUtils.formatSpeed(summary.uploadSpeed)}',
                  style: AppTypography.statNumeral.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              '${summary.downloadingCount} downloading · '
              '${summary.seedingCount} seeding$etaCaption',
              style: AppTypography.meta.copyWith(
                color: isDark ? AppColors.n500 : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
            _SegmentBar(summary: summary),
          ],
        ),
      ),
    );
  }
}
```

(The rest of the file — `_SegmentBar` and anything below it — is unchanged.)

- [ ] **Step 4: Wire the tap at the call site in `home_page.dart`**

In `lib/features/home/home_page.dart`, add these imports:

```dart
import 'package:arrstack/features/activity/activity_providers.dart';
```

Change the `RightNowCard` usage (around line 90) from:

```dart
                        child: RightNowCard(summary: summary),
```

to:

```dart
                        child: RightNowCard(
                          summary: summary,
                          onTap: () {
                            ref
                                .read(activeActivityLensProvider.notifier)
                                .select(ActivityLens.transfers);
                            context.go(RoutePaths.activity);
                          },
                        ),
```

- [ ] **Step 5: Repoint the Bazarr tile in `service_tile_grid.dart`**

Add this import:

```dart
import 'package:arrstack/features/activity/activity_providers.dart';
```

Change the `ServiceType.bazarr` case in `_onTileTap` from:

```dart
      case ServiceType.bazarr:
        context.go(RoutePaths.activitySubtitles(summary.instanceId));
```

to:

```dart
      case ServiceType.bazarr:
        ref.read(activeActivityLensProvider.notifier).select(ActivityLens.wanted);
        context.go(RoutePaths.activity);
```

- [ ] **Step 6: Run tests to verify they pass**

Run: `flutter test test/features/home/widgets/service_tile_grid_test.dart test/features/home/widgets/right_now_card_test.dart test/features/home/home_page_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add lib/features/home/widgets/service_tile_grid.dart lib/features/home/widgets/right_now_card.dart \
  lib/features/home/home_page.dart \
  test/features/home/widgets/service_tile_grid_test.dart test/features/home/widgets/right_now_card_test.dart
git commit -m "feat(home): repoint Bazarr tile and Right Now card to Activity lenses

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 21: Delete the superseded pages and tiles

**Files:**
- Delete: `lib/features/downloads/downloads_page.dart`
- Delete: `lib/features/downloads/widgets/torrent_tile.dart`
- Delete: `lib/features/calendar/calendar_page.dart`
- Delete: `lib/features/calendar/widgets/calendar_entry_tile.dart`
- Delete: `lib/features/subtitles/` (entire folder: `subtitles_page.dart`, `subtitles_providers.dart`, `subtitles_providers.g.dart`, `widgets/wanted_subtitle_tile.dart`)

**Kept (per Global Constraints deviation 4 and the design spec's own Routing/file moves):** `lib/features/downloads/downloads_providers.dart`, `lib/features/downloads/widgets/add_torrent_dialog.dart`, `lib/features/calendar/calendar_providers.dart`, `lib/features/calendar/models/calendar_entry.dart`, `lib/features/calendar/widgets/calendar_date_format.dart` — all still imported by the new Activity feature (Tasks 4, 15, 16, 18).

No test files exist for any of the five deleted source files (confirmed via `find test/features/downloads test/features/calendar test/features/subtitles -iname "*.dart"`, which returns only `test/features/calendar/calendar_entry_test.dart` — a test for the *kept* `calendar_entry.dart`), so no test deletions are needed alongside them.

- [ ] **Step 1: Delete the five files**

```bash
git rm lib/features/downloads/downloads_page.dart \
  lib/features/downloads/widgets/torrent_tile.dart \
  lib/features/calendar/calendar_page.dart \
  lib/features/calendar/widgets/calendar_entry_tile.dart
git rm -r lib/features/subtitles
```

- [ ] **Step 2: Verify nothing still references the deleted symbols**

Run: `grep -rln "DownloadsPage\|TorrentTile\|CalendarPage\|CalendarEntryTile\|SubtitlesPage\|WantedSubtitleTile\|subtitles_providers\|SelectedSubtitleInstanceId" lib/ test/`
Expected: no output (empty). If anything prints, it's a leftover import or reference that must be fixed before continuing — most likely candidate is a stray import of one of the deleted files that survived Tasks 10/12/14's widget rewrites.

- [ ] **Step 3: Analyze and format**

Run: `dart analyze --fatal-infos`
Expected: no errors — in particular, no `unused_import` or `uri_does_not_exist` from the deleted files.

Run: `dart format --set-exit-if-changed .`
Expected: no output (already formatted).

- [ ] **Step 4: Run the full test suite**

Run: `flutter test`
Expected: PASS — every test file, old and new.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "chore(activity): remove the pages and tiles Activity replaces

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

---

### Task 22: Final integration verification

**Files:** none (verification only).

- [ ] **Step 1: Regenerate all code-gen output**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: no errors; no unexpected diffs in already-committed `.g.dart` files (if any generated file changes, `git diff` it and fold that into a fresh commit — codegen output must always match its source).

- [ ] **Step 2: Format**

Run: `dart format --set-exit-if-changed .`
Expected: no output.

- [ ] **Step 3: Analyze**

Run: `dart analyze --fatal-infos`
Expected: `No issues found!`

- [ ] **Step 4: Full test suite**

Run: `flutter test`
Expected: every test passes, including all new `test/features/activity/**`, `test/core/widgets/error_card_test.dart`, and `test/services/sonarr/{sonarr_client_test,sonarr_repository_test}.dart` files, plus every pre-existing test untouched by this plan.

- [ ] **Step 5: Manual smoke check**

Run the app (`flutter run`, or the project's existing `run` skill/script) against a real or test stack and confirm by hand:
- The bottom nav's Activity tab opens on the Transfers lens by default.
- Tapping the Calendar and Wanted chips switches lenses without errors; tapping back to Transfers resets its throughput sparkline (expected, per Task 18's documented scroll/timer tradeoff) rather than crashing.
- The Home tab's Bazarr tile (if a Bazarr instance is configured) opens Activity directly on the Wanted lens.
- The Home tab's "Right now" card (if a qBittorrent instance is configured) opens Activity directly on the Transfers lens.
- With a Bazarr instance configured but unreachable, the Wanted lens shows the offline error card, and Sonarr's missing episodes (if any) still list normally beneath it.
- Both light and dark theme look intentional on all three lenses (Global Constraints: theme-aware colors).

- [ ] **Step 6: Commit (only if Step 1 produced generated-file diffs)**

```bash
git add -A
git commit -m "chore(activity): regenerate code-gen output

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KBmzfmyfeEcUEy2WaDx8vc"
```

If Step 1 produced no diffs, skip this step — there's nothing to commit.

---

# Interactive Release Search for Sonarr & Radarr — Design

**Date:** 2026-09-07
**Status:** Approved (brainstorming)
**Branch:** `feat/interactive-release-search`

## Motivation

Automatic grabs sometimes pull junk — e.g. a "movie" release that is
actually a `.exe`. The user wants to trigger a manual (interactive)
indexer search from a specific episode or movie, see every candidate
release with enough detail to judge it (indexer, quality, size, peers,
age, rejection reasons), sort that list, and grab a good one by hand.

## Goals

- Trigger an interactive search from an **episode** (Sonarr) or a
  **movie** (Radarr) detail screen.
- Show all returned releases in one list with: release title, quality,
  size, seeders/leechers, indexer, age, and rejection reasons.
- A selectable sort: **Peers (high→low, default)**, Size (small→large),
  Age (new→old), Quality (best→worst).
- Tap a release → detail sheet → deliberate "Download" action that
  sends it to the download client via Sonarr/Radarr.
- Releases that Sonarr/Radarr rejected are shown dimmed with their
  reason(s) and remain force-grabbable.

## Non-Goals (out of scope for this work)

- Season-level or series-level search (episode + movie only).
- Removing / blocklisting the existing bad queue item ("blocklist &
  search"). Tracked as a separate future task.
- Usenet-first workflows. Usenet releases are handled (shown, grabbable)
  but sort as peers-unknown and sink under Peers ↓.
- Per-indexer success/failure reporting.
- Manual import / file-level interaction after the grab (Sonarr/Radarr
  own that).

## Decisions (from brainstorming)

| # | Decision |
|---|----------|
| 1 | One active sort at a time via a control; default **Peers ↓**. Options: Peers, Size, Age, Quality. |
| 2 | "Peers" = **seeders** only. Usenet / missing → `—`, sorts last under Peers ↓. |
| 3 | Tap row → **detail sheet** → "Download" button grabs. One deliberate confirmation step (the sheet). |
| 4 | Show **all** releases; rejected ones dimmed with reason(s); still grabbable (force). |
| 5 | Interactive search + manual grab only. No queue/blocklist changes. |

## Architecture — Approach C (hybrid)

The Sonarr v3 and Radarr v3 `Release` payloads are ~95% identical, but
the codebase convention is **per-service models even when identical**
(`SonarrQuality` vs `RadarrQuality` are separate today). So:

- **Data layer stays per-service and idiomatic**: `SonarrRelease` /
  `RadarrRelease` freezed models, release methods on each existing
  client, mapping to a shared view-model at the **repository**
  boundary.
- **Feature UI is written once**: a single `lib/features/release_search/`
  module whose widgets and providers operate on an app-level
  `ReleaseCandidate` view-model.

```
Episode/Movie detail page
        │  context.push(release-search route)
        ▼
release_search_page  ──watch──►  releaseSearchResults(service, instanceId, targetId)
        │                               │  switch(service)
        │                               ▼
        │                    SonarrRepository / RadarrRepository
        │                     .searchEpisodeReleases / .searchMovieReleases
        │                               │  GET api/v3/release?episodeId=/movieId=
        │                               ▼
        │                    List<SonarrRelease|RadarrRelease>
        │                               │  map at repo boundary
        │                               ▼
        │                    Result<List<ReleaseCandidate>>
        ▼
  applySort(list, releaseSort)  ──►  ListView<ReleaseTile>
        │  tap
        ▼
  release_detail_sheet  ──ref.read(repo).grabRelease(guid, indexerId)──►  POST api/v3/release
```

## Components

### 1. Sonarr data layer (`lib/services/sonarr/`)

**`models/sonarr_models.dart` — new `@freezed SonarrRelease`** (only
UI-relevant fields; per-item parse guarded by the mapper like
`getSeries`):

| Field | JSON | Type | Notes |
|-------|------|------|-------|
| `guid` | `guid` | `String` | grab identity |
| `title` | `title` | `String` | full release name |
| `size` | `size` | `int` | bytes |
| `indexerId` | `indexerId` | `int` | grab identity |
| `indexer` | `indexer` | `String?` | display name |
| `seeders` | `seeders` | `int?` | torrent only |
| `leechers` | `leechers` | `int?` | torrent only |
| `protocol` | `protocol` | `String?` | `"torrent"` / `"usenet"` |
| `quality` | `quality` | `SonarrQualityInfo?` | reuse existing model |
| `qualityWeight` | `qualityWeight` | `int?` | sort key for Quality |
| `ageMinutes` | `ageMinutes` | `num?` | sort key for Age |
| `rejected` | `rejected` | `bool` | default `false` |
| `rejections` | `rejections` | `List<String>` | default `[]` |
| `releaseGroup` | `releaseGroup` | `String?` | |
| `downloadAllowed` | `downloadAllowed` | `bool` | default `true` |
| `customFormatScore` | `customFormatScore` | `int?` | display only |

**`sonarr_client.dart` — new methods:**

```dart
Future<Result<List<SonarrRelease>>> searchEpisodeReleases(int episodeId) {
  return dioCall(
    () => _dio.get(
      'api/v3/release',
      queryParameters: {'episodeId': episodeId},
      options: Options(receiveTimeout: const Duration(seconds: 90)),
    ),
    map: (data) => /* guarded list map → SonarrRelease, skip bad items */,
  );
}

Future<Result<void>> grabRelease({
  required String guid,
  required int indexerId,
}) {
  return dioCall(
    () => _dio.post(
      'api/v3/release',
      data: {'guid': guid, 'indexerId': indexerId},
    ),
    map: (_) {},
  );
}
```

The global `receiveTimeout` is 20s (`DioFactory`); interactive search
routinely exceeds it, hence the per-request 90s override.

**`sonarr_repository.dart` — new methods:**

```dart
Future<Result<List<ReleaseCandidate>>> searchEpisodeReleases(int episodeId) =>
    _client.searchEpisodeReleases(episodeId)
        .then((r) => r.map((list) => list.map(ReleaseCandidate.fromSonarr).toList()));

Future<Result<void>> grabRelease({required String guid, required int indexerId}) =>
    _client.grabRelease(guid: guid, indexerId: indexerId);
```

### 2. Radarr data layer (`lib/services/radarr/`)

Identical shape:
- `models/radarr_models.dart`: `@freezed RadarrRelease` (same fields;
  `quality` reuses Radarr's existing quality model).
- `radarr_client.dart`: `searchMovieReleases(int movieId)` →
  `GET api/v3/release?movieId=` (90s timeout); `grabRelease(...)` →
  `POST api/v3/release` `{guid, indexerId}`.
- `radarr_repository.dart`: `searchMovieReleases(movieId)` →
  `Result<List<ReleaseCandidate>>` via `ReleaseCandidate.fromRadarr`;
  `grabRelease(...)` passthrough.

### 3. Shared feature (`lib/features/release_search/`)

**`models/release_candidate.dart`** — plain immutable class, no JSON
(view-model). Two named constructors `fromSonarr(SonarrRelease)` /
`fromRadarr(RadarrRelease)`.

```dart
enum ReleaseProtocol { torrent, usenet, unknown }

@immutable
class ReleaseCandidate {
  const ReleaseCandidate({
    required this.guid,
    required this.indexerId,
    required this.indexerName,
    required this.title,
    required this.sizeBytes,
    required this.protocol,
    required this.qualityLabel,
    required this.qualityWeight,
    required this.ageMinutes,
    required this.isRejected,
    required this.rejections,
    required this.downloadAllowed,
    this.seeders,
    this.leechers,
    this.releaseGroup,
    this.customFormatScore,
  });

  final String guid;
  final int indexerId;
  final String indexerName;
  final String title;
  final int sizeBytes;
  final ReleaseProtocol protocol;
  final String qualityLabel;      // e.g. "WEB-DL 1080p" or "—"
  final int qualityWeight;        // 0 when unknown
  final int ageMinutes;           // 0 when unknown
  final bool isRejected;
  final List<String> rejections;
  final bool downloadAllowed;
  final int? seeders;
  final int? leechers;
  final String? releaseGroup;
  final int? customFormatScore;

  /// Sort key for Peers ↓: seeders, or -1 when unknown (sinks to bottom).
  int get peersKey => seeders ?? -1;
}
```

`qualityLabel` is derived in the `fromX` constructors from the service
quality model (`quality?.quality?.name ?? '—'`).

**`release_sort.dart`**:

```dart
enum ReleaseSort { peers, size, age, quality }

/// Pure, returns a new sorted list; input is not mutated.
List<ReleaseCandidate> applySort(List<ReleaseCandidate> items, ReleaseSort sort) {
  final copy = [...items];
  switch (sort) {
    case ReleaseSort.peers:
      copy.sort((a, b) => b.peersKey.compareTo(a.peersKey));
    case ReleaseSort.size:
      copy.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
    case ReleaseSort.age:
      copy.sort((a, b) => a.ageMinutes.compareTo(b.ageMinutes));
    case ReleaseSort.quality:
      copy.sort((a, b) => b.qualityWeight.compareTo(a.qualityWeight));
  }
  return copy;
}
```

Tie stability of `List.sort` is not guaranteed — tests assert only the
primary key ordering, not tie stability.

**`release_search_providers.dart`** (`@riverpod`, `part` gen file):

```dart
@riverpod
Future<Result<List<ReleaseCandidate>>> releaseSearchResults(
  Ref ref, {
  required ServiceType service,   // sonarr | radarr
  required String instanceId,
  required int targetId,          // episodeId | movieId
}) async {
  switch (service) {
    case ServiceType.sonarr:
      final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
      return repo.searchEpisodeReleases(targetId);
    case ServiceType.radarr:
      final repo = await ref.watch(radarrRepositoryProvider(instanceId).future);
      return repo.searchMovieReleases(targetId);
    default:
      return const Err(UnknownError(userMessage: 'Unsupported service for release search.'));
  }
}

@riverpod
class ReleaseSortController extends _$ReleaseSortController {
  @override
  ReleaseSort build() => ReleaseSort.peers;
  void set(ReleaseSort value) => state = value;
}
```

(Provider auto-disposes — default for `@riverpod` function providers —
so navigating back abandons an in-flight search. Refetch = `ref.invalidate`.)

Grab is **not** a provider: the sheet calls
`ref.read(sonarr/radarrRepositoryProvider(instanceId).future)` then
`grabRelease(...)`, mirroring `episode_detail_page._searchSubtitlesInBazarr`.

### 4. UI

**`release_search_page.dart`** — `ConsumerWidget`:
- `AppBar`: title `"Search Releases"`; `bottom` = one-line target label
  (`title` query param) + the sort control; `actions` = refresh
  `IconButton` (`ref.invalidate(releaseSearchResultsProvider(...))`).
- Sort control: `SegmentedButton<ReleaseSort>` — Peers / Size / Age /
  Quality — bound to `releaseSortControllerProvider`.
- Body:
  - `loading` → centered `CircularProgressIndicator` + text
    *"Searching all indexers… this can take up to a minute."*
  - `Err` → `EmptyState(icon: error_outline, message: error.userMessage,
    action: Retry)`.
  - `Ok` empty → `EmptyState(icon: search_off, title: "No releases found")`.
  - `Ok` non-empty → header row (`"${n} releases"`) + `ListView.builder`
    of `ReleaseTile`, list = `applySort(value, sort)`.

**`widgets/release_tile.dart`** — `StatelessWidget`, `onTap` opens sheet:
- Line 1: `title`, `maxLines: 2`, `TextOverflow.ellipsis`.
- Line 2: a `Wrap` of compact facts — quality chip · `FormatUtils.formatBytes(size)`
  · `▲{seeders} ▼{leechers}` or `usenet` · `indexerName` · `{age}` (new
  helper `formatReleaseAge(minutes)` in `format_utils.dart`).
- If `isRejected`: wrap tile in `Opacity(0.55)` and add a red-tinted
  line — first rejection reason, `"+N more"` when `rejections.length > 1`.

**`widgets/release_detail_sheet.dart`** — `showModalBottomSheet`
(`isScrollControlled: true`), `ConsumerStatefulWidget`:
- Selectable full `title`.
- Rows: Indexer, Quality, Size, Seeders / Leechers, Age, Protocol,
  Release group, Custom-format score (omit rows whose value is null).
- If `isRejected`: a "Rejected because" section listing every reason.
- Primary `FilledButton`:
  - label `"Download"`, or `"Force download"` (theme error color) when
    `isRejected || !downloadAllowed`.
  - on tap: set `_isGrabbing`, call `grabRelease(guid, indexerId)`.
    - `Ok` → close sheet, `context.pop()` the page, snackbar
      *"Sent to {indexerName} — check Downloads"*.
    - `Err` → keep sheet open, show `error.userMessage` in red under the
      button; button re-enabled.

**Navigation** (`route_paths.dart`, `router.dart`):
- `RoutePaths.episodeReleaseSearch(instanceId, seriesId, episodeId, title)`
  → `/library/sonarr/:instanceId/series/:seriesId/episode/:episodeId/search?title=…`
- `RoutePaths.movieReleaseSearch(instanceId, movieId, title)`
  → `/library/radarr/:instanceId/movie/:movieId/search?title=…`
- Nested `GoRoute(path: 'search')` under the existing episode and movie
  routes; builder reads path params + `state.uri.queryParameters['title']`
  and constructs `ReleaseSearchPage(service:, instanceId:, targetId:, title:)`.

**Entry point wiring** (replace stubs):
- `episode_detail_page.dart`: the search `IconButton.onPressed` →
  `context.push(RoutePaths.episodeReleaseSearch(...))` (remove the
  "coming soon" snackbar).
- `movie_detail_page.dart`: `case 'search'` →
  `context.push(RoutePaths.movieReleaseSearch(...))`.

## Error handling & edge cases

| Case | Handling |
|------|----------|
| Search > 90s | `Err(NetworkError)` → *"Search timed out. Some indexers may be slow — try again."* + Retry |
| Partial indexer failure | Sonarr/Radarr return 200 with partial results; render what came back |
| Malformed release item | per-item try/catch in mapper — log + skip, keep the rest (matches `getSeries`) |
| Grab fails | inline error in sheet; page stays so another release can be picked |
| `seeders`/`leechers` null | show `—`; `peersKey == -1` → sorts last under Peers ↓ |
| Back nav mid-search | provider auto-disposes; request abandoned |
| Repo build failure (bad instance) | `releaseSearchResults` throws → `.when` error branch → `EmptyState` |
| Unsupported `ServiceType` | `Err(UnknownError)` from the provider |

## Testing

| Target | Kind | Assertions |
|--------|------|-----------|
| `applySort` | unit | each sort key orders correctly; nulls-last for peers; empty list; single item |
| `ReleaseCandidate.fromSonarr` / `.fromRadarr` | unit | fixture JSON → model → fields; protocol enum mapping; `rejections` list; null `seeders`; `qualityLabel` fallback `—` |
| `SonarrClient.searchEpisodeReleases` / Radarr | unit (`http_mock_adapter`) | captured fixture parses to N candidates; skips a malformed entry |
| `grabRelease` | unit (`http_mock_adapter`) | POST body is exactly `{guid, indexerId}`; 2xx→`Ok`, 4xx→`Err` |
| `releaseSearchResults` provider | unit (`ProviderContainer` + overridden repos) | routes to Sonarr vs Radarr repo by `ServiceType`; propagates `Err` |
| `ReleaseSortController` notifier | unit | default `peers`; `set` updates |
| `release_search_page` | widget | loading text shown; results render; tap tile → sheet; rejected tile dimmed |
| `release_detail_sheet` | widget | force-download label when rejected; grab `Ok` pops; grab `Err` shows inline message |

Coverage target ≥ 80% on new non-widget code.

## New / changed files

**New:**
- `lib/features/release_search/models/release_candidate.dart`
- `lib/features/release_search/release_sort.dart`
- `lib/features/release_search/release_search_providers.dart` (+ `.g.dart`)
- `lib/features/release_search/release_search_page.dart`
- `lib/features/release_search/widgets/release_tile.dart`
- `lib/features/release_search/widgets/release_detail_sheet.dart`
- tests mirroring the above under `test/`

**Changed:**
- `lib/services/sonarr/models/sonarr_models.dart` (+regen)
- `lib/services/sonarr/sonarr_client.dart`
- `lib/services/sonarr/sonarr_repository.dart`
- `lib/services/radarr/models/radarr_models.dart` (+regen)
- `lib/services/radarr/radarr_client.dart`
- `lib/services/radarr/radarr_repository.dart`
- `lib/app/route_paths.dart`
- `lib/app/router.dart`
- `lib/features/library/episode_detail_page.dart`
- `lib/features/library/movie_detail_page.dart`
- `lib/core/utils/format_utils.dart` (add `formatReleaseAge`)

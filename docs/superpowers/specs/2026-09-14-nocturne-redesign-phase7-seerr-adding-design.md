# Nocturne Redesign Phase 7: Seerr + Adding

**Date:** 2026-09-14
**Scope:** README §3a–3e (Discover, Discover detail/request, Requests queue, Add to
library, Manual release search). §3f/3g (empty/loading/offline, destructive confirm)
are explicitly out — that's Phase 8 per the README's implementation order.

Verified against `design_handoff_arrstack_hub/screenshots/3a.png`–`3e.png` directly
(not just the README prose) before writing this spec.

## Decisions locked during brainstorming

1. **3b's quality-profile/root-folder/free-space data comes from Seerr's own
   service-details API**, not the direct Radarr/Sonarr providers `add_movie_options.dart`
   already uses. New `SeerrClient.getRadarrService(serviceId)` /
   `getSonarrService(serviceId)` (`GET /service/radarr|sonarr/:id`) return the profiles
   and root folders (with free/total space) Seerr itself will send the request to —
   matches "Request to Radarr" semantics without the app needing to resolve which
   local Radarr/Sonarr instance backs a given Seerr server.
2. **3b's AVAILABILITY block is best-effort from Seerr's own cached `MediaInfo`,
   not a live pre-add search.** Radarr/Sonarr's interactive-search APIs require the
   item to already exist there (confirmed by this app's own `ReleaseSearchPage`,
   which takes an existing `movieId`/`episodeId`) — there's no "search without
   adding" endpoint. Render digital-release date and already-available quality/size
   when Seerr's `MediaInfo` has them; **omit the indexer-hit-count line and the
   "Best available" line entirely when Seerr has nothing cached**, rather than
   showing a fabricated `0 releases` or `—` that reads as a real (if disappointing)
   answer. If `mediaInfo` is null entirely (title never touched Seerr), skip the
   whole AVAILABILITY block.
3. **release_search's sort chips trim to the 3 spec'd values**: Best match (renamed
   from `peers`, same seeders-based default) / Size / Seeders. `ReleaseSort.age` and
   `.quality` and their `applySort` branches are deleted, not kept as hidden extras.
4. **3c is a new standalone page/route** (`/home/requests`), not a restyle of the
   existing in-page tab. `requests_tab_view.dart` and `request_list_tile.dart` are
   deleted; the "Requests" `SegmentedButton` tab is removed from `discover_page.dart`
   in favor of a `ph-receipt` header button that pushes the new route (matches the
   README's route map, which has never had `/home/discover` and `/home/requests`
   sharing one page).
5. **`MediaDetailHeader` gains a `poster` widget slot instead of being handed a
   relative URL + service + instanceId.** Today it hardcodes `ResolvedPoster`, which
   only resolves Radarr/Sonarr relative URLs by instance — Seerr's `SeerrResult.posterUrl`
   is already an absolute TMDB URL. Existing call sites (`movie_detail_page.dart`,
   `series_detail_page.dart`) pass `ResolvedPoster(...)` explicitly instead of the raw
   URL; 3b passes a plain `CachedNetworkImage`-backed poster. No behavior change for
   existing callers, just an explicit poster widget instead of an implicit one.
6. **A single pure status-presentation function replaces three duplicated switch
   statements.** `discover_detail_page.dart`'s `_RequestStatusChip`,
   `request_list_tile.dart`'s `_mediaStatusChip`, and `poster_carousel_section.dart`'s
   inline `available` check each independently map `SeerrMediaStatus` → a label/color.
   New `lib/services/seerr/models/seerr_status_presentation.dart` exposes
   `mediaStatusPresentation(int status) -> ({String label, Color color})?` (null for
   `unknown`/`deleted`, matching "Nosferatu — unbadged" in the 3a mock) as the one
   source of truth, unit tested directly. 3a's poster badge, 3b's "Not in library"
   chip, and 3c's in-progress trailing tag all consume it.
7. **The stats-row counts on 3c mix two different status axes on purpose — this is
   the correctness trap to get right, not paper over.** "PENDING" counts requests
   where the *request itself* is awaiting approval (`SeerrRequestStatus.pending`,
   i.e. `getRequests(filter: 'pending')`). "PROCESSING" and "AVAILABLE" count by the
   *media's* fulfillment status (`SeerrMediaStatus`) among non-declined/non-failed
   requests. A request can be `approved` (request status) while its media is still
   `processing` (media status) — those are the "in progress" rows. Declined/failed
   requests appear in none of the three buckets (nothing to act on, nothing to show
   as progress).

   **Verify before implementing the provider calls**: Overseerr/Jellyseerr's `GET
   /request` `filter` param is documented (openapi.json shipped with both projects)
   to also accept `processing` and `available` values beyond the `pending | approved
   | declined | all` this app already uses. If confirmed, use three parallel
   `getRequests(filter: 'pending'|'processing'|'available')` calls — `pageInfo.results`
   (the API's total count for that filter) is the stat number, **not**
   `results.length`, which is just the current page. **If that filter vocabulary
   turns out not to exist on the target server**, fall back to one `getRequests
   (filter: 'all')` call paginated to completion, bucketed client-side by the
   request-status/media-status combination above — implement whichever this
   verification confirms, and note which path was taken in the task's completion
   notes.
8. **Approve/Deny call the new repository methods directly and invalidate the three
   filtered providers on success** (optimistic-disable-then-refetch: the tapped
   button shows a spinner and both buttons on that card disable during the call,
   rather than an optimistic list removal that has to be unwound on failure).
9. **In-progress status text is generic, not literally per-episode.** Overseerr's
   request API doesn't expose "downloading S01E06"-level detail (that's a
   Sonarr/qBittorrent-layer concept). `processing` → "searching indexers" for both
   movies and TV; `partiallyAvailable` → green "Partial" tag with a
   `request.seasons` summary (e.g. "seasons 1, 2") since that data **is** on the
   model already. The mock's "downloading S01E06" is a fidelity example, not an
   achievable literal string here — documented so it isn't quietly reintroduced as a
   TODO later.
10. **The "needs a decision" card's attribution line omits the quality-profile
    fragment if `SeerrRequest` doesn't actually carry one.** The mock shows "by
    harivin · 3h ago · 2160p profile"; today's `SeerrRequest` model has no
    profile-name field. Check the real Overseerr `GET /request` response during
    implementation — if a profile name/id is present, add it to the model and show
    it; if not, the line reads "by harivin · 3h ago" rather than fabricating a
    profile string.

## Shared components (new)

### `lib/services/seerr/models/seerr_status_presentation.dart`

```dart
({String label, Color color})? mediaStatusPresentation(int status);
```
Pure function, unit tested for every `SeerrMediaStatus` value including unmapped
ints (`unknown`/`deleted` → `null`, matching "unbadged").

### `lib/features/discover/widgets/media_status_badge.dart` — `MediaStatusBadge`

The 3a poster-corner badge: a small solid-fill pill (5px inset from `PosterCard`'s
existing `badge` slot — no change needed there, it already positions top-left).
`available`/`partiallyAvailable` → accent fill, "In library". `pending`/`processing`
→ neutral-900 fill, "Requested". Anything else → `SizedBox.shrink()`. Built on
`mediaStatusPresentation`, but with **solid** fills per the mock (not
`StatusChip`'s translucent tint-plus-border treatment, which stays as-is for other
call sites).

### `lib/core/widgets/labeled_dropdown_field.dart` — `LabeledDropdownField<T>`

```dart
LabeledDropdownField<T>({
  required String label,          // "Quality profile", "Root folder"
  required T? value,
  required List<DropdownMenuItem<T>> items,
  required ValueChanged<T?> onChanged,
  String? caption,                // e.g. "2.4 TB free of 18 TB"
})
```
Replaces the plain `DropdownButtonFormField` used today in `add_movie_options.dart`/
`add_series_options.dart` (Material default chrome) and is new for 3b. Nocturne
styling: label above, `surface` fill / 1px `divider` border / `radius-md` box,
caption below in `AppTypography.meta`. Extracted now because 3b introduces this
field for the first time and 3d's restyle needs the identical look — two screens,
one visual contract, not a one-off per screen.

### `lib/core/widgets/labeled_toggle_row.dart` — `LabeledToggleRow`

```dart
LabeledToggleRow({
  required String title,     // "Search immediately", "Search for it now"
  required String subtitle,  // "Otherwise it waits for the next RSS sweep"
  required bool value,
  required ValueChanged<bool> onChanged,
})
```
Replaces `SwitchListTile` (default `ListTile` chrome/padding) in both sheets and 3b.
Delegates to Flutter's `Switch` for the actual toggle visuals (the app theme already
governs switch colors), just fixes layout/typography to match the title+subtitle
pattern used throughout the design.

## Service layer changes

`lib/services/seerr/models/seerr_models.dart` gains:
```dart
@freezed
abstract class SeerrServiceProfile with _$SeerrServiceProfile {
  const factory SeerrServiceProfile({required int id, required String name}) = _SeerrServiceProfile;
  factory SeerrServiceProfile.fromJson(Map<String, dynamic> json) => _$SeerrServiceProfileFromJson(json);
}

@freezed
abstract class SeerrServiceRootFolder with _$SeerrServiceRootFolder {
  const factory SeerrServiceRootFolder({
    required String path,
    int? freeSpace,
    int? totalSpace,
  }) = _SeerrServiceRootFolder;
  factory SeerrServiceRootFolder.fromJson(Map<String, dynamic> json) => _$SeerrServiceRootFolderFromJson(json);
}

@freezed
abstract class SeerrServiceDetails with _$SeerrServiceDetails {
  const factory SeerrServiceDetails({
    @Default([]) List<SeerrServiceProfile> profiles,
    @Default([]) List<SeerrServiceRootFolder> rootFolders,
  }) = _SeerrServiceDetails;
  factory SeerrServiceDetails.fromJson(Map<String, dynamic> json) => _$SeerrServiceDetailsFromJson(json);
}
```
Exact field names/paths depend on the real Overseerr/Jellyseerr response shape —
confirm against a live instance or the shipped OpenAPI spec during implementation;
this is the expected shape, not a verified one.

`SeerrClient`/`SeerrRepository` gain:
```dart
Future<Result<SeerrServiceDetails>> getRadarrService(int serviceId);
Future<Result<SeerrServiceDetails>> getSonarrService(int serviceId);
Future<Result<SeerrRequest>> approveRequest(int requestId);
Future<Result<SeerrRequest>> declineRequest(int requestId);
```
`request()` gains optional `int? serverId, int? profileId, String? rootFolder`
params, forwarded into the POST body — currently only `mediaType`/`mediaId`/`seasons`
are sent, so a user's profile/folder choice on 3b would otherwise be silently
discarded.

New/changed providers in `seerr_providers.dart`, following the existing
`@riverpod` family-provider pattern:
```dart
@riverpod
Future<Result<SeerrServiceDetails>> seerrRadarrService(Ref ref, {required String instanceId, required int serviceId});
@riverpod
Future<Result<SeerrServiceDetails>> seerrSonarrService(Ref ref, {required String instanceId, required int serviceId});
```
`seerrRequestsProvider` stays as-is (already takes `filter`/`sort`); 3c calls it
three times with `filter: 'pending' | 'processing' | 'available'` per Decision 7,
or once with `filter: 'all'` if that verification fails.

## 3a — Discover (`/home/discover`)

**File:** `discover_page.dart`, restyled in place; `poster_carousel_section.dart`,
`genre_pill_row.dart` get token/spacing passes (`LegacySpacing`/`AppBar`/
`SegmentedButton` → `AppColors`/`AppSpacing`/`SubPageHeader`-style header).

**Header:** back, kicker "SEERR" over "Discover", `ph-receipt` button that pushes
`RoutePaths.homeRequests` (new). The `_MainTab` enum and requests `SegmentedButton`
are deleted (Decision 4) — this page only ever shows Discover content now.

**Search field:** restyle the existing `TextField` to the 38px surface-fill/divider
look; behavior unchanged (`_SearchList` already works).

**Body:** unchanged data flow (`_DiscoverSections`'s per-section
`ref.watch(...)` + independent error-swallow-to-`SizedBox.shrink()` stays — that's
deliberate resilience, not a bug, per its existing doc comment). Carousel cards use
`MediaStatusBadge` in `PosterCard`'s `badge` slot, computed from
`item.mediaInfo`.

**`genre_results_page.dart`** (the "All →" destination, not its own README screen ID
but directly reachable from 3a and currently equally pre-Nocturne): same header
restyle (`SubPageHeader`) and the same `MediaStatusBadge` treatment on its grid —
kept consistent with 3a rather than left behind.

## 3b — Discover detail / request (`/home/discover/detail/:id/:type`)

**File:** `discover_detail_page.dart`, rewritten body.

**Header:** back + external-link button (opens TMDB, reusing the existing
`url_launcher` pattern from `request_list_tile.dart`'s "View in TMDB").

**Above the fold:** `MediaDetailHeader` (Decision 5's poster-slot version) — 104×156
poster via `CachedNetworkImage(item.posterUrl)`, title, meta (`year · runtime` if TV
add episode count instead), chips (`tag-accent` rating via existing `DetailChip`,
`tag-neutral` "Not in library" via `mediaStatusPresentation` — falls back to a plain
neutral "Not in library" chip when the function returns null, since 2g's chip slot
always shows *something* here unlike the poster badge which can be blank). Overview
text below, unchanged from today.

**Request panel** (entirely new — today there's just one generic button):
- Kicker "REQUEST TO RADARR" (or "REQUEST TO SONARR" for `mediaType == 'tv'`).
- `LabeledDropdownField` for quality profile, `LabeledDropdownField` for root folder
  with the free-space caption, both sourced from `seerrRadarrService`/
  `seerrSonarrService` (instance's default configured server — if Seerr has
  multiple Radarr/Sonarr servers configured, default to the first and note this as
  a known simplification; a server picker is out of scope here).
- `LabeledToggleRow` "Search immediately" / "Otherwise it waits for the next RSS
  sweep", **on** by default.
- Rule, kicker "AVAILABILITY", rendered per Decision 2 (best-effort, lines omitted
  rather than faked when data is missing).
- **On profile/folder fetch failure**: show an inline error message where the
  fields would be (matching `add_movie_options.dart`'s existing
  `Text('Error loading profiles: ...')` pattern) and disable the Request button —
  never silently fall back to a phantom "first profile" the way `_save()`'s
  existing fallback-to-first-item logic could look confident about a choice the
  user never actually saw.

**Action bar:** flexible primary "Request" (`+`, calls the extended `request()`
with the selected `serverId`/`profileId`/`rootFolder`).

**Correction found during plan-writing:** the mock's secondary "Browse releases" →
`ReleaseSearchPage` action is **not implemented in Phase 7**. This section
originally assumed it could be gated on "the title already existing in
Radarr/Sonarr," but `SeerrMediaInfo` carries no Radarr/Sonarr-side
`movieId`/`episodeId` — `ReleaseSearchPage`'s required `targetId` has nothing to
bind to from Seerr's own data. The gating condition isn't just usually false, it's
unsatisfiable with today's data model. Shipping a button with no working
destination would violate the same no-fake-confidence principle as Decision 2, so
it's cut rather than faked or half-wired. See the plan's Out-of-scope section.

## 3c — Requests queue (`/home/requests`, new route)

**Files:** new `lib/features/discover/requests_page.dart` (or promoted to its own
`lib/features/requests/` directory, matching this app's one-feature-per-directory
convention — implementer's call, follow whichever existing sibling feature
directories suggest is more consistent); new `RequestCard`/`InProgressRow` widgets.
`requests_tab_view.dart` and `request_list_tile.dart` are deleted (Decision 4).

**Route:** add to `router.dart` under the Home branch, alongside `discover`:
```dart
GoRoute(path: 'requests', builder: (context, state) => const RequestsPage()),
```
plus `RoutePaths.homeRequests = '/home/requests'`.

**Header:** `SubPageHeader(kicker: 'SEERR', title: 'Requests', actions: [funnel])`.
The funnel button's filter behavior: reasonable minimum is toggling between "all
statuses" and "pending only" (mirroring the funnel-vs-full-list relationship implied
by the mock); doesn't need to replicate every filter option `requests_tab_view.dart`
had (approved/declined filters) since those requests aren't shown on this screen's
sections anyway.

**Stats row:** three numerals per Decision 7, colored `AppColors.warning` (PENDING),
`AppColors.accent` (PROCESSING), `AppColors.up` (AVAILABLE).

**"Needs a decision" section:** kicker with count, then one `RequestCard` per pending
request — 44×66 poster (needs the same detail-lookup pattern
`request_list_tile.dart` already uses, since `SeerrRequest.media` doesn't carry
poster/title), title, chip row (type + fixed "Pending" tag, `accent-800` fill /
`#FFC230` text — a one-off style since every card in this section is pending by
construction, not a mapped status), attribution line per Decision 10, then Approve
(`OutlinedButton`, accent outline, check icon, calls `approveRequest`) / Deny
(`OutlinedButton`, neutral outline, calls `declineRequest`) side by side — no
overflow menu.

**"In progress" section:** kicker with count, `InProgressRow` per request — 32×48
poster, title, status line via Decision 9, trailing tag via
`mediaStatusPresentation` (falls back to a plain "Processing" `tag-accent` when the
underlying media status doesn't map to "Partial").

**Trailing row:** "N available requests ›" (N = the AVAILABLE stat) — taps through
to the same page filtered to `available`, reusing `RequestsPage` with a
`statusFilter` param rather than a second file.

## 3d — Add to library (`/library/radarr|sonarr/:instanceId/add`)

**Files:** `add_movie_page.dart`, `add_series_page.dart`, `add_movie_options.dart`,
`add_series_options.dart` — styling pass only, symmetric across both. Logic already
correct: `movie.id != null` dedupe check, working "search now" toggle.

**Search field:** active-state styling (1px accent border, accent glyph, dismiss
`×`) plus the "N results from TMDB via Radarr/Sonarr" caption line (new — today
there's no result-count caption).

**Results list:** 40×60 poster, title, tabular meta, trailing 28px add button.
**Primary** (filled/emphasized) for the top result, **secondary** (outline) for the
rest — today both render identically as an `IconButton`. Already-in-library rows:
0.6 opacity, "{year} · already in library" meta text (new — today it's just the
year), green fill-weight check (already present via `Icons.check_circle`, just
needs the opacity treatment on the whole row).

**Add sheet:** grab handle, 44×66 poster beside title/"{year} · adding to
Radarr/Sonarr" subtitle (new copy), `LabeledDropdownField` ×2 (replacing the plain
`DropdownButtonFormField`s), `LabeledToggleRow` "Search for it now" / "Uses your N
enabled indexers" (the indexer count is new — pull from
`prowlarrIndexersProvider`-equivalent already used by the Indexers page, filtered to
enabled; if that data isn't cheaply available from this sheet's context, the
caption falls back to the existing generic copy rather than showing a fabricated
count), full-width primary "Add to library" / "Add series to library".

## 3e — Manual release search (`/library/.../search`)

**Files:** `release_search_page.dart`, `release_sort.dart`, `release_tile.dart` —
token migration plus the visual gaps the screenshot revealed.

**`release_sort.dart`:** per Decision 3, `enum ReleaseSort { best, size, seeders }`
(renamed from `peers`; `seeders` is a genuinely new sort key — sort by `seeders`
descending directly, distinct from `best`'s existing `peersKey` logic only in name,
not behavior, since `peersKey` already *is* the seeder count with a `-1` sink for
unknowns — confirm during implementation whether "Best match" and "Seeders" should
actually differ in tie-breaking, or whether the mock's 3-chip UI intentionally maps
two labels to the same sort for now). `age`/`quality` cases deleted from
`applySort`.

**Header:** `SubPageHeader`-style kicker ("SEVERANCE · S01E08") + title "Releases",
refresh action. Sort chips restyled to the accent-ring-no-fill active state; the
"N found" count moves out of the results list (today it's `_Results`'s first list
item) into the header row, right-aligned, tabular.

**Rows:** `release_tile.dart` gains a trailing icon — 15px `ph-download-simple` in
accent for allowed releases, 15px `ph-prohibit` in `#F44336` for rejected ones
(neither exists today; today's row has no trailing icon at all). Rejected-row
opacity (0.55) and red rejection text already match the spec — no change needed
there.

**Footer:** closing note "Rejected releases stay listed — tapping one downloads it
anyway, overriding the profile." (new — doesn't exist today). Tap-to-download
behavior on a rejected release is unchanged (already works via the same `onTap` →
`showReleaseDetailSheet` path); this is a copy addition, not a new interaction.

## Testing

- `mediaStatusPresentation`: unit test every `SeerrMediaStatus` value, including the
  unmapped-to-null cases.
- `MediaStatusBadge`: widget test for each of the three render states (in-library,
  requested, blank).
- `LabeledDropdownField`/`LabeledToggleRow`: widget tests for label/caption
  rendering and the `onChanged` callback firing.
- Seerr repository: unit tests (fake `SeerrClient`) for `approveRequest`/
  `declineRequest`/`getRadarrService`/`getSonarrService`, and that `request()`
  forwards `serverId`/`profileId`/`rootFolder` in the request body when provided.
- 3b: widget test that a profile/folder fetch `Err` disables the Request button and
  shows the inline error, not a silently-selected first item; test that the
  AVAILABILITY block omits the indexer-hits/best-available lines when `mediaInfo`
  lacks that data, and the whole block when `mediaInfo` is null.
- 3c: unit tests for the bucketing logic (whichever path Decision 7's verification
  lands on) — specifically a case where a request is `approved` but its media is
  still `pending`/`processing` (must land in "in progress", not be miscounted as
  "needs a decision" or dropped); a declined/failed request appears in no bucket.
  Widget test that Approve/Deny disable both buttons on that card during the call
  and that a failure re-enables them with a visible error rather than silently
  reverting.
- 3e: unit tests for the trimmed `applySort` (three cases only); widget test that a
  rejected release shows the prohibit icon and an allowed one shows the download
  icon.
- Golden/screenshot check (per this app's existing visual-regression practice) for
  3a's badge placement, 3c's card layout, and 3e's icon states, matching the
  reference screenshots this spec was verified against.

## Out of scope

- §3f (empty/loading/offline) and §3g (destructive confirm) — Phase 8.
- A Radarr/Sonarr server picker on 3b when Seerr has more than one configured
  server of that type (defaults to the first).
- Literal per-episode "downloading SxxEyy" status text on 3c's in-progress rows
  (Decision 9) — not available from Overseerr's request API.
- Any change to `ResolvedPoster` itself — Decision 5 only changes what
  `MediaDetailHeader` accepts, not how Radarr/Sonarr poster resolution works.
- Rebuilding `requests_tab_view.dart`'s approved/declined filter options — 3c's
  funnel only needs pending-vs-all, since those statuses aren't otherwise shown here.

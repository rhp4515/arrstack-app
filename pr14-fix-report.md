# PR #14 Fix Report — Seerr Request-Submission Flow (Phase 7)

Branch: `nocturne-redesign-phase7` (confirmed via `git branch --show-current` before any edits; no branch switch performed).

## Bug 1 (High): Hardcoded service id breaks requests on some Seerr installations

### What changed

- `lib/services/seerr/models/seerr_models.dart`
  - Added `SeerrServiceSummary` (`{required int id, required bool isDefault}`), placed right after `SeerrServiceRootFolder` and before `SeerrServiceDetails`, matching the existing freezed style in the file.
- `lib/services/seerr/seerr_client.dart`
  - Added private `_serviceSummaries(String path)` helper (mirrors the existing `_genreSlider` list-parsing pattern) and public `getRadarrServices()` / `getSonarrServices()`, hitting `api/v1/service/radarr` / `api/v1/service/sonarr` (no id segment), each wrapped in `dioCall` exactly like every other client method.
- `lib/services/seerr/seerr_repository.dart`
  - Mirrored `getRadarrServices()` / `getSonarrServices()`.
- `lib/services/seerr/seerr_providers.dart`
  - Added `@riverpod` functions `seerrRadarrServices(Ref ref, String instanceId)` / `seerrSonarrServices(Ref ref, String instanceId)`, same shape as the existing single-positional-arg family providers (e.g. `seerrDiscoverMovies`).
- `lib/features/discover/discover_detail_page.dart`
  - Removed the `const _defaultServiceId = 0;` constant and its doc comment (old lines 35–42).
  - `_DetailContentState.build()` now watches `seerrRadarrServicesProvider`/`seerrSonarrServicesProvider` first, then resolves the actual server id via new helper `_resolveServiceDetailsAsync` → `_detailsAsyncForResolvedId` → `_pickDefaultServiceId`, and only then watches the existing per-id `seerrRadarrServiceProvider`/`seerrSonarrServiceProvider` with the *resolved* id (discover_detail_page.dart:127–130, :266–325).
  - `_pickDefaultServiceId` (discover_detail_page.dart:310–320, new) picks the server Seerr marked `isDefault`; falls back to `.first.id` if none is marked default; returns `null` when the list is empty.
  - When resolution yields `null` (empty server list) or the services-list fetch itself errors, the page surfaces a real `Err`/`UnknownError` through the same `serviceAsync`/`Result` plumbing the existing profile-fetch-failure path already used — so the Request button disables and a visible error message shows, exactly like the pre-existing "failed profile fetch" behavior. No fabricated id is ever used.
  - `_handleRequest()` (discover_detail_page.dart:356–366) now awaits the services-list provider, resolves the id the same way, and uses that resolved id both for the detail lookup and as the `serverId` sent with `repository.request(...)`.
  - New doc comment on `_pickDefaultServiceId` explains the fallback-to-first simplification and that a full multi-server picker remains out of scope for this phase (per the Phase 7 design spec).

### TDD evidence

RED (before generating code / before page changes):
- `flutter test test/services/seerr/models/seerr_models_test.dart test/services/seerr/seerr_client_test.dart` failed to compile — `SeerrServiceSummary`/`_$SeerrServiceSummaryFromJson` did not exist yet (expected; codegen not run).
- `flutter test test/features/discover/discover_detail_page_test.dart` (after adding `singleDefaultRadarrService`/isDefault/fallback/empty-list tests, before touching the page) failed to compile — `seerrRadarrServicesProvider` didn't exist. After adding providers but before rewiring the page, the 4 new tests failed with concrete assertion failures (e.g. `resolves to the server Seerr marked isDefault, not server 0` — found 0 widgets with text "Ultra-HD"; `falls back to the first server...` — found 0 widgets with text "Standard"; `shows an error...no configured server` — `StateError: No element` looking for a disabled Request button; both confirmed genuine RED, not just compile failures).

GREEN (after `dart run build_runner build --delete-conflicting-outputs` + page rewiring):
- All 8 model tests, all 8 (5 new + 3 existing) client tests, and all 8 (6 new + 2 existing) page tests pass.

## Bug 2 (High): Requests use `.first` instead of Seerr's configured defaults

### What changed

- `lib/services/seerr/models/seerr_models.dart`
  - Extended `SeerrServiceDetails` with `int? activeProfileId` and `String? activeDirectory` — parsed from the same `/service/radarr|sonarr/{id}` response `getRadarrService`/`getSonarrService` already fetch; no new endpoint.
- `lib/features/discover/discover_detail_page.dart`
  - New top-level (file-private) helpers `_defaultProfileId(SeerrServiceDetails)` and `_defaultRootFolder(SeerrServiceDetails)` (discover_detail_page.dart:451–466): each prefers Seerr's `activeProfileId`/`activeDirectory`, but **only** when that value is actually present in the returned `profiles`/`rootFolders` list (validated via `.any(...)`); otherwise falls back to `.first`. Comments document this as the one remaining honest simplification.
  - `_handleRequest()`'s fallback logic (discover_detail_page.dart:384–385) now calls these helpers instead of reaching for `.first` directly.
  - `_RequestFields.build()` (discover_detail_page.dart:489–497) now uses the same helpers for the dropdowns' displayed/selected values when the user hasn't picked anything. The user's own `_selectedProfileId`/`_selectedRootFolder` still always takes priority (unchanged `??` ordering).

### TDD evidence

RED: two new widget tests (`prefers Seerr's activeProfileId/activeDirectory over the first entry`, `falls back to the first entry when Seerr's active profile/folder is not actually in the returned lists`) failed against the pre-change page — first with `found 0 widgets with text "4K"` (page was still showing `HD-1080p`, the `.first` entry), confirming the bug reproduces; the second test was written to lock in the validation-fallback behavior.

GREEN: both pass after adding `activeProfileId`/`activeDirectory` to the model and wiring `_defaultProfileId`/`_defaultRootFolder` into both the dropdown-init and `_handleRequest` fallback paths.

## Full test suite

`flutter test` (whole suite, after all changes): **529 tests, 0 failures** ("All tests passed!").

Targeted re-run: `flutter test test/services/seerr/ test/features/discover/` → **46 tests, 0 failures**.

## Static analysis / formatting

- `dart analyze` (whole repo): 1 issue — `info - lib/features/discover/discover_detail_page.dart:284:14 - Closure should be a tearoff... - unnecessary_lambdas`. This is a pre-existing info-level lint on a line I did not touch (`onProfileChanged: (v) => setState(...)`), confirmed via `git diff` showing no change at that line. No errors or warnings anywhere in the repo.
- `dart format --set-exit-if-changed .`: clean, 0 files needed formatting after my own `dart format` pass on the touched files.

## Files changed

- `lib/services/seerr/models/seerr_models.dart` — `SeerrServiceSummary` model; `SeerrServiceDetails.activeProfileId`/`activeDirectory`.
- `lib/services/seerr/models/seerr_models.freezed.dart`, `lib/services/seerr/models/seerr_models.g.dart` — regenerated (`build_runner`).
- `lib/services/seerr/seerr_client.dart` — `getRadarrServices()`, `getSonarrServices()`, `_serviceSummaries()`.
- `lib/services/seerr/seerr_repository.dart` — mirrors the two new client methods.
- `lib/services/seerr/seerr_providers.dart` — `seerrRadarrServicesProvider`, `seerrSonarrServicesProvider`.
- `lib/services/seerr/seerr_providers.g.dart` — regenerated (`build_runner`).
- `lib/features/discover/discover_detail_page.dart` — service-id resolution (Bug 1) and active-profile/directory preference (Bug 2), replacing the two fallback-to-`.first`/hardcoded-`0` bug sites.
- `test/services/seerr/models/seerr_models_test.dart` — `SeerrServiceSummary` parsing tests; `SeerrServiceDetails` active-field tests.
- `test/services/seerr/seerr_client_test.dart` — `getRadarrServices`/`getSonarrServices` endpoint tests.
- `test/features/discover/discover_detail_page_test.dart` — updated existing 2 tests to override the new services-list provider; added 6 new tests covering isDefault resolution, fallback-to-first, empty-server-list error handling, and active-profile/directory preference with and without validation.

Unrelated pre-existing modified files in the working tree (`lib/features/activity/activity_providers.g.dart`, `lib/features/library/library_providers.g.dart`, `lib/features/onboarding/onboarding_providers.g.dart`) were present before I started (per the initial `git status`) and were not touched by this work; `build_runner` did not further modify them.

## Self-review findings

- Confirmed the `_handleRequest()` server-id resolution uses `ref.read(...future)` on the *same* provider family/instance that `build()` watches, so the resolved id is consistent with what's rendered — no risk of resolving against stale/different data mid-request under normal usage.
- Confirmed the conditional-`ref.watch` pattern (watching a different provider depending on `_isTv`/resolved id) is a supported Riverpod pattern (dependent/chained providers evaluated fresh each build) — not a hooks-style conditional-hook violation.
- Renamed the two new fallback helpers from public (`defaultProfileId`/`defaultRootFolder`) to file-private (`_defaultProfileId`/`_defaultRootFolder`) during self-review, since they're internal implementation details of this page and the file is a `library;`-declared unit — avoids accidentally growing the file's public surface.
- Verified `details == null` early-return in `_handleRequest()` still holds — if the detail fetch itself fails, no request is submitted (unchanged from before).
- Did not build a multi-server picker UI, per explicit instruction — the isDefault→first fallback is documented in three places (model doc comment, `_pickDefaultServiceId` doc comment, and this report).

## Concerns / field-name accuracy

- The exact field names `isDefault` (on the services-list entries) and `activeProfileId`/`activeDirectory` (on the per-id service-detail response) are taken directly from the task's citation of Seerr's own `server/routes/service.ts`, which I could not independently fetch/verify against a live Overseerr/Jellyseerr instance or its source in this session. If a reviewer has access to a running Seerr instance or the actual `service.ts`/`service-radarr.ts` route source, it would be worth a quick confirmation that:
  1. The list endpoint (`GET /api/v1/service/radarr` / `.../sonarr`) returns a bare JSON array (as modeled) rather than a wrapped object.
  2. `isDefault` and `activeProfileId`/`activeDirectory` are exactly those names (not `is4kDefault`/`activeDirectory4k`-style variants, which Seerr does have for the 4K-server case — out of scope here since this app doesn't distinguish 4K servers).
  - If the field names differ, the fix is localized to the two new `fromJson` mappings (freezed auto-generates from field names, so a rename is a small, low-risk follow-up).
- No other concerns; all tests, analyze, and format are clean.

---

## Addendum: Task-Reviewer Follow-up Fixes (Group A, round 2)

The task reviewer approved the Group A fix overall but flagged two Important issues. Both addressed below.

### Finding 1 — Missing negative-path test for the services-list fetch itself failing

Every override of `seerrRadarrServicesProvider`/`seerrSonarrServicesProvider` in `test/features/discover/discover_detail_page_test.dart` previously returned `Ok(...)` (populated or empty) — the `error:`/`Err` branch of `_resolveServiceDetailsAsync` (the path that stops the app from silently falling back when the *list endpoint itself* fails, as distinct from it returning an empty list) was untested.

**Fix:** Added a new widget test, `'a failed services-list fetch disables Request and shows a visible error, not a silent fallback to any id'` (`test/features/discover/discover_detail_page_test.dart`, inserted after the existing empty-list test). It overrides `seerrRadarrServicesProvider(instanceId)` to return `Err(UnknownError(userMessage: 'Could not list Seerr servers'))` and asserts:
- the error message renders (`find.textContaining('Could not list Seerr servers')`, `findsOneWidget`), and
- the Request button's `onPressed` is `null` (disabled) — i.e. no fallback to any fabricated id.

### Finding 2 — Unguarded `await` before `setState` in `_handleRequest()`

`_handleRequest()`'s new first statement, `final servicesResult = await (...)`, had no `mounted` check before the `setState`/`ref.read` calls that follow, unlike the method's existing pattern of guarding after awaits (e.g. `if (!mounted) return;` later in the same method, after the `repository.request(...)` await).

**Fix:** `lib/features/discover/discover_detail_page.dart` — added `if (!mounted) return;` immediately after the new `await (_isTv ? ref.read(seerrSonarrServicesProvider(...).future) : ref.read(seerrRadarrServicesProvider(...).future))`, before computing `resolvedServiceId` or touching `setState`/`ref.read` further.

### Covering tests run

```
flutter test test/features/discover/discover_detail_page_test.dart
```
Result: **8/8 passed** (7 pre-existing + 1 new negative-path test), including the new `'a failed services-list fetch disables Request and shows a visible error, not a silent fallback to any id'` test.

```
flutter test test/features/discover/
```
Result: **23/23 passed** (whole `discover` feature test folder).

```
flutter test
```
Result: **530/530 passed** ("All tests passed!") — up from 529 (one new test added), confirming no regressions.

### Static analysis / formatting

```
dart format lib/features/discover/discover_detail_page.dart test/features/discover/discover_detail_page_test.dart
```
→ `Formatted 2 files (0 changed)`.

```
dart analyze lib/features/discover/discover_detail_page.dart test/features/discover/discover_detail_page_test.dart
```
→ 1 info-level issue: the same pre-existing, untouched `unnecessary_lambdas` hint at `discover_detail_page.dart:284:14` noted in the original report. No errors/warnings.

```
dart format --set-exit-if-changed .   # whole repo
dart analyze                          # whole repo
```
→ Both clean (same single pre-existing info-level lint; 0 files needed formatting).

### Files changed (this round)

- `lib/features/discover/discover_detail_page.dart` — added `if (!mounted) return;` guard in `_handleRequest()`.
- `test/features/discover/discover_detail_page_test.dart` — added the services-list-`Err` negative-path test.

### Commit

`8bbb7a0` — `fix(discover): guard mounted after services-list await; test list-fetch failure`

### Concerns

None new. The pre-existing field-name-accuracy concern from the original report (Overseerr/Jellyseerr's `isDefault`/`activeProfileId`/`activeDirectory` field names, inferred from the task's citation rather than independently verified) still stands.

---

## Bug 3 (Medium): Requests queue floods Seerr with N parallel detail lookups

### What changed

- `lib/features/requests/requests_page.dart`
  - `_RequestsList.build()` (requests_page.dart:117–284) previously built one eager `ListView(padding: AppInsets.pageMd, children: [...])` containing `for (final request in pending) ...RequestCard(...)` / `for (final request in progress) ...InProgressRow(...)` / `for (final request in available) ...InProgressRow(...)` loops directly in the widget list — `ListView(children:)` builds every child immediately regardless of what's on screen, so every row's `seerrDetailProvider` watch (in `RequestCard`/`InProgressRow`) fired at once on page open.
  - Converted the body to `RefreshIndicator` → `CustomScrollView` → a single `SliverPadding(padding: AppInsets.pageMd, sliver: SliverMainAxisGroup(slivers: [...]))`. `SliverMainAxisGroup` lets one `SliverPadding` wrap a whole sequence of slivers, reproducing `ListView`'s "padding around the entire scrollable content" behavior exactly (top/bottom padding once, at the very start/end; the same padding value on every side, since `AppInsets.pageMd == EdgeInsets.all(AppSpacing.space4)`).
  - Each per-request section (`pending`, `progress`, `available`) is now a `SliverList.builder(itemCount: ..., itemBuilder: (context, index) => ...)` — a `SliverChildBuilderDelegate` under the hood — so `RequestCard`/`InProgressRow` (and their `seerrDetailProvider` watches) are only constructed for rows that actually scroll into/near view (subject to `Viewport`'s cache extent), not all N at once.
  - The one-off elements — stat header `Row`, "NEEDS A DECISION · N" / "IN PROGRESS · N" kickers, the empty-state `Padding`, the inter-section `SizedBox` spacers, and the "N available requests ›" drill-down `InkWell` — stayed as plain `SliverToBoxAdapter`s, unchanged in content, order, or spacing values (`AppSpacing.space3/4/6/8`, exactly as before).
  - `key: ValueKey(request.id)` preserved on every `RequestCard`/`InProgressRow` construction (unchanged from the earlier fix round).
  - `RefreshIndicator(onRefresh: () async => refresh())` unchanged — it now wraps `CustomScrollView` instead of `ListView`, which `RefreshIndicator` supports natively.
  - Did not touch `request_card.dart`, `in_progress_row.dart`, or `requests_bucketing.dart` — scoped entirely to how `_RequestsList` builds its children.

### How I verified the fix is genuinely lazy (not just restructured)

1. **Behavioral test** (new): `test/features/requests/requests_page_test.dart` — `'lazily builds request rows: a far-down request's detail provider is never watched while only the top of a long list is on screen'`. Builds a list of 30 plain pending requests (no `tmdbId`, so their own detail lookups are no-ops) followed by a 31st pending request that *does* have a `tmdbId`, placed at the very end (far below the fold in an 800×600 test viewport). `seerrDetailProvider` for that specific `(instanceId, tmdbId, mediaType)` is overridden with a closure that flips a `farDownProviderWatched` flag to `true` and returns an `Err` (same idiom as `test/features/discover/discover_detail_page_test.dart`'s "server 0 should not be queried" pattern) before returning. After `pumpWidget` + `pumpAndSettle()` (no scrolling performed), the test asserts `farDownProviderWatched` is `false` — i.e. Riverpod never even instantiated that provider, meaning `RequestCard`'s `build()` (and therefore its `ref.watch(seerrDetailProvider(...))` call) never ran for that far-down row. This directly exercises the bug's actual mechanism (N eager provider watches on open) rather than only checking widget types.
   - Note: I used a provider-watched flag rather than asserting rendered error text, because `RequestCard`/`InProgressRow` silently fall back to `'Request #<id>'` on a failed detail fetch (they don't surface `Err.userMessage` visibly) — so "error text absent" wouldn't distinguish "never watched" from "watched, failed, and silently swallowed." The flag proves the override closure itself was never invoked, which is the stronger and more direct signal.
2. **Structural check** (same test, belt-and-suspenders): asserts `find.byType(ListView)` is `findsNothing` (no eager fixed-children container survives anywhere in the tree) and that every `SliverList` found in the tree has a `.delegate` of type `SliverChildBuilderDelegate` (not `SliverChildListDelegate`, which would be eager despite being a "sliver").
3. Manually re-read `SliverList.builder`'s generated delegate (`SliverChildBuilderDelegate`) to confirm it calls `itemBuilder` lazily per `RenderSliverList` layout, consistent with standard Flutter `ListView.builder` laziness semantics — not something that needs to be taken on faith, it's the same delegate `ListView.builder` uses internally.

### Existing test updates

`test/features/requests/requests_page_test.dart`'s four pre-existing tests (`shows the pending/processing/available stat counts`, `a pending request renders under "NEEDS A DECISION"`, `an in-progress request renders under "IN PROGRESS"`, `a failed fetch shows a distinct error, not an empty list`) needed **no changes** — none referenced `ListView` or relied on synchronous eager building beyond the `pumpAndSettle()` they already used, and they all continue to pass unmodified against the new `CustomScrollView`/`SliverList` tree since they only assert on rendered text, which is unaffected (all their fixtures have ≤3 requests, well within the first-screen build window regardless of laziness).

### Full test suite

```
flutter test test/features/requests/
```
Result: **23/23 passed** (all pre-existing requests tests unchanged + the 1 new laziness test).

```
flutter test   # whole suite
```
Result: **531/531 passed** ("All tests passed!") — up from 530 (one new test added), confirming no regressions anywhere else in the app.

### Static analysis / formatting

```
dart analyze                          # whole repo
```
→ 1 issue: the same pre-existing, untouched `info - unnecessary_lambdas` hint at `lib/features/discover/discover_detail_page.dart:284:14` noted in earlier sections of this report. Nothing new introduced by this change. (Initially my new test also tripped a `prefer_const_constructors` info on the `SeerrRequest(...)` literal at line 126; fixed by making it `const SeerrRequest(...)` — both `SeerrRequest` and `SeerrRequestMedia` have `const factory` constructors — confirmed clean afterward.)

```
dart format --set-exit-if-changed .   # whole repo
```
→ Clean: `Formatted 344 files (0 changed)`.

### Files changed

- `lib/features/requests/requests_page.dart` — `_RequestsList.build()` rewritten from `ListView(children: [...])` to `CustomScrollView` + `SliverPadding` + `SliverMainAxisGroup` + `SliverList.builder` per per-request section; everything else (bucketing calls, `refresh()`, `RefreshIndicator`, `_Stat`) unchanged.
- `test/features/requests/requests_page_test.dart` — added the new laziness/structural test; no changes to the four pre-existing tests.

### Self-review findings

- Double-checked `AppInsets.pageMd` is `EdgeInsets.all(AppSpacing.space4)` (uniform on all sides), not just horizontal — this matters because it confirms `SliverPadding` wrapping the single `SliverMainAxisGroup` reproduces `ListView`'s padding behavior exactly (top/bottom applied once at the very ends of the scrollable content, left/right applied to every child's width) rather than needing per-sliver padding.
- Verified `SliverMainAxisGroup` is available in the pinned Flutter SDK (`Flutter 3.47.0` per `flutter --version`; `SliverMainAxisGroup` shipped in Flutter 3.10) — no new dependency needed.
- Verified the empty-state, kicker, and drill-down `SliverToBoxAdapter`s render identical widgets/text/styles to before — this was a mechanical wrap-in-`SliverToBoxAdapter`, not a rewrite, for every one-off element.
- Confirmed `key: ValueKey(request.id)` is still present on every `RequestCard`/`InProgressRow` construction inside all three `itemBuilder`s (grep-checked before committing).
- Considered whether `SliverList.builder`'s default `addAutomaticKeepAlives`/`addRepaintBoundaries` (both default `true`) change any existing behavior — they don't affect `RequestCard`'s internal `_busy`/`_error` `State` semantics since keep-alive only matters once a widget has been scrolled off *after* being built; nothing in the current tests exercises scroll-then-approve, and this matches `ListView.builder`'s own defaults, so it's not a regression risk introduced by this fix.
- Considered adding a `cacheExtent` override to make the "far-down item never built" test even more deterministic. Left the default `Viewport.defaultCacheExtent` (250 logical pixels) in place since the test's far-down item is ~30 rows below the fold (each `RequestCard` well over 250px tall including padding) — comfortably outside the cache extent without needing to touch shipped widget config for test purposes.

### Concerns

- None functional. Visual structure, spacing, `RefreshIndicator` behavior, and the `AppInsets.pageMd` padding are all reproduced exactly per the constraints; the fix directly targets the eager-build root cause (verified via the provider-watch-flag test, not just a widget-tree type check).
- Minor: `SliverList.builder`'s lazy build window depends on `Viewport`'s cache extent (a Flutter framework default, not something this fix configures), so in a real device with a very tall screen or a large cache extent override elsewhere in the app, more rows than "only what's visible" may build ahead of scroll — this is expected, standard `ListView.builder`/`SliverList.builder` behavior and is the same trade-off any lazy list makes; it's not unbounded like the original bug (all N at once) and needs no further action here.

### Commit

`f38b882` — `fix(requests): lazily build request rows to stop N+1 Seerr detail lookups`

---

## Bug 4 (Medium): "Best match" sorts identically to "Seeders", discarding original order

### What changed

- `lib/features/release_search/release_sort.dart`
  - `ReleaseSort`'s doc comment (lines 7–14) rewritten: no longer claims `best`/`seeders` "currently produce identical orderings." Now states `best` preserves the service's own original ordering (the order Radarr/Sonarr's repository returned candidates in) while `seeders` explicitly re-sorts by `peersKey` descending — documented as a deliberate distinction ("trust the backend's own ordering" vs. "re-rank by peers regardless of what the backend preferred").
  - `applySort()` (lines 17–31): `case ReleaseSort.best:` no longer falls through into the `seeders` sort branch. It now does `break;` — i.e. no re-sort — so it returns `sorted`, the shallow copy (`[...items]`) made at the top of the function, in the exact order `items` was passed in. This satisfies "still a new list, never the same instance" per the function's existing contract, while genuinely preserving input order. `ReleaseSort.seeders` keeps the original `sorted.sort((a, b) => b.peersKey.compareTo(a.peersKey))` as the *only* case using that comparator. `ReleaseSort.size` is untouched.

### TDD evidence

RED: Stashed only the two `lib/` implementation files (`release_sort.dart`, `release_tile.dart`) via `git stash push --keep-index` (keeping the new/updated tests staged in the working tree), then ran `flutter test test/features/release_search/release_sort_test.dart test/features/release_search/release_tile_test.dart` against the old implementations. Confirmed genuine failures:
- `applySort best: preserves the original (service-provided) order` — failed: expected `['a','b','c']`, got `['c','a','b']` (old code still sorted by peers).
- `applySort best: returns a new list instance, not the same one` — failed: expected `['a','b']`, got `['b','a']` (same root cause).
- (Bug 5's new tile test also failed in this same RED run — see below.)

Then `git stash pop` to restore both implementation fixes.

GREEN: `flutter test test/features/release_search/release_sort_test.dart` — all sort tests pass, including the two rewritten `best` tests and the unchanged `seeders`/`size`/no-mutation/empty-list tests.

### Test changes

- `test/features/release_search/release_sort_test.dart`
  - Header comment rewritten to match the new, accurate doc comment.
  - `best: descending by seeders, null seeders last` (the test that had previously asserted `best` and `seeders` produce the *same* order) replaced with two distinct tests:
    - `best: preserves the original (service-provided) order` — asserts an unsorted input (`a`,`b`,`c` with seeders 5/null/50) comes back in the exact same `a, b, c` order.
    - `best: returns a new list instance, not the same one` — asserts `identical(out, input)` is `false` while order is preserved, locking in the "still copies, still doesn't sort" contract.
  - `seeders: descending by seeders, null seeders last` test left unchanged — it already asserted the correct, still-current descending-by-`peersKey` behavior.

### Downstream regression found and fixed (not part of the original two bugs, but caused by fixing Bug 4)

`test/features/release_search/release_search_page_test.dart` had a test, `'renders results sorted by peers by default'`, that fed unsorted input through the page's *default* sort (`best`) and asserted the output came back sorted by seeders descending — i.e. it was asserting the exact bug being fixed. Running the full suite after the fix caught this as a genuine failure (`Expected: 'high' / Actual: 'low'`), not noise. Fixed by:
- Renaming/rewriting it to `'renders results in the service's original order by default (Best match)'`, asserting the *unsorted* input order is preserved when no sort chip has been tapped.
- Adding a new, separate test, `'switching sort to Seeders re-orders the list by peers'`, which taps the visible `'Seeders'` sort chip and asserts the list re-sorts descending by seeders — covering the behavior the old (now-removed) test was actually trying to exercise, just correctly attributed to the `Seeders` chip instead of the default.

## Bug 5 (Medium): Non-rejected-but-disallowed releases look like normal downloads

### What changed

- `lib/features/release_search/widgets/release_tile.dart`
  - Top-of-file doc comment (lines 1–9) rewritten to explain "blocked" now covers both `isRejected` and `downloadAllowed: false`, matching `release_detail_sheet.dart`'s `_isForce` getter, and to call out that reason text still only appears for a genuine rejection.
  - `build()` (line ~29): added `final isBlocked = release.isRejected || !release.downloadAllowed;` — computed once, matching `_ReleaseDetailSheetState._isForce`'s exact logic (`release_detail_sheet.dart:57`) verbatim.
  - Replaced every prior `release.isRejected` read used for *visual treatment* with `isBlocked`:
    - Title text color (line ~57): `isBlocked ? AppColors.n500 : AppColors.text` (was `release.isRejected ? ... `). This is a dimming treatment that keyed off `isRejected` alone, per the task's instruction to check for "any existing opacity/dimming treatment."
    - Trailing icon choice and color (lines ~92–96): `isBlocked ? PhosphorIconsRegular.prohibit : PhosphorIconsRegular.downloadSimple` / `isBlocked ? AppColors.down : AppColors.accent`.
    - Outer `Opacity(opacity: 0.55, ...)` wrap (line ~103): now gated on `isBlocked` instead of `release.isRejected`.
  - **Did not** touch the rejection-reason text block's condition — it remains exactly `release.isRejected && release.rejections.isNotEmpty` (unchanged), per the explicit instruction not to fabricate reason text for a disallowed-but-not-rejected release, which would have an empty `rejections` list.

### Why the title-text dimming was also changed (not just icon/color)

The task said to also update "any existing opacity/dimming treatment that currently keys off `isRejected` alone." The title `Text`'s color (`AppColors.n500` muted vs. `AppColors.text`) is exactly that — a second, independent dimming signal alongside the outer `Opacity` wrap. Left unchanged, a disallowed-but-not-rejected release would have full-brightness title text even after `isBlocked` fixed the icon/opacity, which would be an inconsistent half-fix. Confirmed via `release_candidate.dart` and `release_detail_sheet.dart` that there's no other field this should key off.

### TDD evidence

RED (same stash-and-run as Bug 4 above, `release_tile_test.dart` against the pre-fix `release_tile.dart`):
- New test `'a non-rejected but disallowed release is treated as blocked, with no fabricated reason text'` failed with a `TestFailure`: `Expected: no matching candidates / Actual: <Found 1 widget with icon "IconData(U+0E20C)">` — i.e. the old code showed the accent-colored `downloadSimple` icon (not `prohibit`) for a `downloadAllowed: false, isRejected: false` release, exactly the bug described.

GREEN: `flutter test test/features/release_search/release_tile_test.dart` — all 7 tests pass (6 pre-existing + 1 new), including the new blocked-but-not-rejected case.

### Test changes

- `test/features/release_search/release_tile_test.dart`
  - `release(...)` test-fixture helper: added a `downloadAllowed` parameter (default `true`, preserving every existing call site's behavior unchanged) so tests can construct a `downloadAllowed: false` fixture.
  - New test: `'a non-rejected but disallowed release is treated as blocked, with no fabricated reason text'`. Constructs `release(rejected: false, downloadAllowed: false, rejections: const [])` — confirmed against `release_candidate.dart`'s `fromSonarr`/`fromRadarr` factories that `isRejected`/`rejections` are always populated together from the same underlying API fields, so a realistic `downloadAllowed: false` release with `isRejected: false` genuinely has an empty `rejections` list; this is not a contrived/unrealistic fixture. Asserts:
    - the `downloadSimple` icon is absent and the `prohibit` icon is present with `AppColors.down` color (same as a rejected release), and
    - an `Opacity` widget is present (dimmed, same as a rejected release), and
    - no text containing `'more'` (the reason-text block's `'+N more'` suffix) is rendered — i.e. no fabricated rejection reason.

### Full test suite

```
flutter test test/features/release_search/
```
Result: **36/36 passed** (all pre-existing tests + the 2 new sort tests + 1 new tile test + the rewritten/added page-level sort tests).

```
flutter test   # whole suite
```
Result: **534/534 passed** ("All tests passed!") — up from 531 (net +3 tests: 2 in release_sort_test.dart, 1 in release_tile_test.dart, plus 1 added/1 rewritten in release_search_page_test.dart which nets to +1 there), confirming no regressions anywhere else in the app.

### Static analysis / formatting

```
dart analyze   # whole repo
```
→ 1 issue: the same pre-existing, untouched `info - unnecessary_lambdas` hint at `lib/features/discover/discover_detail_page.dart:284:14` noted in earlier sections of this report. Nothing new introduced by this change.

```
dart format --set-exit-if-changed .   # whole repo
```
→ Initially reported 2 files needing formatting (`release_search_page_test.dart`, `release_tile_test.dart` — long test-description strings needed re-wrapping). Ran `dart format .` to apply, then re-ran `--set-exit-if-changed .`: clean, `Formatted 344 files (0 changed)`.

### Files changed

- `lib/features/release_search/release_sort.dart` — `best` no longer shares the `seeders` comparator; doc comment corrected.
- `lib/features/release_search/widgets/release_tile.dart` — `isBlocked` computed from `isRejected || !downloadAllowed`, used for icon/color/dimming (title text + outer `Opacity`); rejection-reason text condition left untouched.
- `test/features/release_search/release_sort_test.dart` — split the one shared `best`/`seeders` test into two `best`-specific tests plus the existing `seeders` test.
- `test/features/release_search/release_tile_test.dart` — added `downloadAllowed` param to the fixture helper; added the new blocked-but-not-rejected test.
- `test/features/release_search/release_search_page_test.dart` — fixed the downstream test that had been asserting the Bug 4 bug itself; added a new test covering the `Seeders` chip's re-sort behavior.

### Self-review findings

- Verified the rejection-reason text block's condition (`release.isRejected && release.rejections.isNotEmpty`) is byte-for-byte unchanged in the diff — confirmed via `git diff`, only the icon/color/opacity/title-color lines changed.
- Verified `_isForce`'s logic in `release_detail_sheet.dart` (`r.isRejected || !r.downloadAllowed`) matches `isBlocked`'s logic in `release_tile.dart` exactly, operator-for-operator.
- Checked `release_candidate.dart`'s two factory constructors (`fromSonarr`, `fromRadarr`) to confirm `isRejected`/`rejections`/`downloadAllowed` are three independently-named fields mapped from three independently-named upstream fields (`r.rejected`, `r.rejections`, `r.downloadAllowed`) — i.e. the model does not implicitly force `rejections` non-empty whenever `downloadAllowed` is false, confirming the test fixture (`downloadAllowed: false, isRejected: false, rejections: []`) is a real, reachable data shape rather than one the model would never actually produce.
- Ran the RED/GREEN stash-and-restore procedure for both bugs together (they touch adjacent files but are logically independent), then re-verified the final working tree matches intended edits via a full `git diff` review before running the final test/analyze/format pass.
- Caught and fixed the pre-existing `release_search_page_test.dart` test that encoded the Bug 4 bug as expected behavior — this would have been a silent regression (a passing test enforcing the wrong behavior) had it not been caught by running the full suite rather than only the scoped `release_search/` directory.

### Concerns

- None functional. Both fixes are narrowly scoped, match the task's exact specification (including the "don't fabricate reason text" and "still copy, don't mutate" constraints), and the one downstream test that encoded the old buggy behavior was found and corrected rather than left to bit-rot.
- Minor style note: `dart format` re-wrapped two of my longer test-description strings across lines differently than I originally typed them (moved the string literal onto its own line instead of splitting mid-call-arguments) — purely cosmetic, no semantic change, already applied and verified clean.

### Commits

(recorded after commit — see below)

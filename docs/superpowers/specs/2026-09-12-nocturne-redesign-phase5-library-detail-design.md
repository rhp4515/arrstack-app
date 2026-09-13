# Nocturne Redesign Phase 5 — Library & Detail Screens — Design

## Problem

Phases 1–4 (merged into `worktree-nocturne-redesign`) rewrote the tokens,
shell, Home tab, and Activity tab. This phase — item 5 of
`design_handoff_arrstack_hub/README.md`'s "Implementation order" — restyles
the Library tab and its three detail screens onto Nocturne (spec screens
**2d–2g**):

- `lib/features/library/library_page.dart` (2d)
- `lib/features/library/series_detail_page.dart` (2e)
- `lib/features/library/episode_detail_page.dart` (2f)
- `lib/features/library/movie_detail_page.dart` (2g)
- Their widgets (`widgets/media_list_tile.dart`, `widgets/movie_list.dart`,
  `widgets/series_list.dart`) and `library_providers.dart`.

The headline structural change is **poster-beside-title** on both detail
screens (2e/2g): the shipped app centers a large poster above the title,
pushing seasons below the fold; Nocturne puts a 104×156 poster to the left
of a title/meta/chips/stat column instead. Everything else is a restyle of
already-correct information, not new functionality.

This phase also root-causes a recurring Phase 4 bug: `colorScheme
.onSurfaceVariant` renders at full brightness (not muted) in dark mode
because `app_theme.dart`'s dark `ColorScheme.dark()` never set it
explicitly, forcing every widget to manually branch `isDark ? AppColors
.n400 : colorScheme.onSurfaceVariant` (fixed 4 separate times across
`LensChips`, `WeekStrip` ×2, `CalendarTimelineRow` ×2 in Phase 4).

**Non-goals:** `add_movie_page.dart`/`add_series_page.dart` (item 7,
"adding"), release search pages, Uptime/Indexers/Settings sub-pages, and
full per-language Bazarr subtitle provenance (see Design decision 6) —
unchanged or deferred by this phase.

## Current state

- All four pages use `LegacySpacing`, generic `Card`/`ExpansionTile`/
  `SegmentedButton`/`PopupMenuButton`, and ad-hoc `Colors.green`/`.orange`/
  `.red` instead of Nocturne tokens and status colors.
- `library_page.dart`: `SegmentedButton<LibraryTab>` + always-visible
  `SearchBar` + `FloatingActionButton`. `ActiveLibraryTab` (`@riverpod
  class`, `select(tab)`) already exists from the Phase 3 nav fix — Home's
  Radarr/Sonarr tiles already navigate here correctly and this is
  preserved untouched.
- `series_detail_page.dart` / `movie_detail_page.dart`: centered poster,
  title, meta, `_ChipRow` (rating/monitored/IMDb/TMDB/TVDB — tappable,
  copies the URL to clipboard, no `url_launcher`), `_OverviewCard` and
  `_DetailsCard` as `ExpansionTile`s (Status/Runtime/Network/Path — **not**
  in the 2e/2g spec), `PopupMenuButton` with Monitor/Search/Delete
  (movie adds Subtitles). Series adds an unstyled `_SeasonTile` →
  `_SeasonEpisodes` → `_EpisodeCard` chain.
- `episode_detail_page.dart`: title/meta/chips, `_OverviewCard`,
  `_DetailsCard` (Quality/Size/Path), two header `IconButton`s (Subtitles,
  Search releases) — the spec wants these promoted to real primary/
  secondary buttons in the body.
- `media_list_tile.dart` / `movie_list.dart` / `series_list.dart`: poster-
  left `Card` rows, no fading-rule separators, no state-aware
  percentage/progress-bar/dimmed-unmonitored trailing per spec.
- Sonarr's calendar (`sonarrRepository.listCalendar(start, end)` →
  `SonarrCalendarEpisode`, embeds the parent series) is already wired for
  Activity's Calendar lens and is reusable here with no new client method.
- `SonarrSeries` has no `nextAiring`/`previousAiring` field — not needed
  once we're deriving from the calendar endpoint instead (see decision 2).
- `RadarrRepository`/`RadarrClient` have `listMovies`, `getMovie`,
  `updateMovie`, `deleteMovie`, `searchMovieReleases`, `grabRelease`,
  `listCalendar`, `listQueue` — no bulk "search all missing" command yet.
- `BazarrWantedSubtitle` (`languages: List<String>`, `episodeId`/
  `radarrId`) is the only subtitle model — it names *missing* languages
  for an item, nothing about downloaded languages' provider or embedded
  state.
- `app_theme.dart`'s dark `ColorScheme.dark(...)` sets `primary`,
  `onPrimary`, `secondary`, `onSecondary`, `surface`, `onSurface`, `error`,
  `onError`, `outline`, `outlineVariant` — but not `onSurfaceVariant`,
  which is why it falls back to Flutter's Material 3 default instead of a
  Nocturne-muted tone.
- No shared `FadingRule` widget exists anywhere in the app yet (grepped —
  zero hits outside this phase's plan). `LensChips`
  (`lib/features/activity/widgets/lens_chips.dart`) implements the same
  visual spec ("Shared shell" → "Lens chips") but is hardwired to
  `activeActivityLensProvider` and a fixed 3-item enum — not reusable
  as-is without refactoring Activity, which is out of scope.

## Design decisions

### 1. Root-cause the `onSurfaceVariant` dark-mode bug in `app_theme.dart`

Add `onSurfaceVariant: AppColors.n400` to the dark `ColorScheme.dark(...)`
constructor — the exact value every prior manual fix converged on. Light
theme's `ColorScheme.fromSeed` is untouched (its derived variant is
already correct). This phase's new widgets read `colorScheme
.onSurfaceVariant` directly with no `isDark` branch. The 4 existing
Activity call sites that already branch manually are **left alone** —
they still render correctly (redundant, not wrong) and touching them is
outside this phase's file list.

### 2. Shared detail-header and spec-block widgets (DRY, matches "same anatomy")

New widgets in `lib/features/library/widgets/` (feature-local — nothing
outside Library needs them yet, same precedent as Activity's lens
widgets):

- **`MediaDetailHeader`** — the poster-beside-title block: 104×156 poster
  left; title (`sectionTitle`), meta line, chip row, and a 2-up stat row
  (numeral + `statCaption` label) right. Series passes
  `("19/19", "EPISODES")` / `("61 GB", "ON DISK")`; movie passes
  `("2160p", "QUALITY")` / `("54.2 GB", "ON DISK")`. This is the shared
  anatomy the spec calls out explicitly for 2e/2g.
- **`SpecBlock`** — the label/value row block for episode's FILE/
  SUBTITLES and movie's FILE (`neutral-500` label left, tabular value
  right, wraps with `space-6` left padding).
- **`SeasonRow`** — collapsible season row (caret, label, 64px progress
  bar, 38px tabular count, color-coded complete/partial/zero) with
  indented `EpisodeRow` children (44px accent episode code, ellipsized
  title, trailing quality tag or red "Missing"). Replaces `_SeasonTile`/
  `_SeasonEpisodes`/`_EpisodeCard`/`_CountPill`.
- **`LibraryRow`** — the fading-rule-separated row for "All shows"/
  "Recently added" (36×54 poster, title + tabular meta, trailing %/
  progress-bar/dimmed-"Unmonitored"). Replaces `MediaListTile` in place
  (only used inside Library — safe to restyle without a rename).
- **`lib/core/widgets/fading_rule.dart`** — new shared primitive (1px,
  gradient-to-transparent at both ends per the Shared Shell spec), since
  none exists yet. Used by `LibraryRow` separators and between detail
  sections (e.g. before "SEASONS").

Library's Shows/Movies chip switch is a **new, Library-local** widget
built to the same "Lens chips" visual spec as `LensChips`, not a shared
component — generalizing `LensChips` would mean touching Activity files,
which is out of scope this phase.

### 3. "Continue watching" is derived from Sonarr's calendar, not new series fields

`continueWatchingProvider(instanceId)` (new, in `library_providers.dart`):

1. Fetch `sonarrRepository.listCalendar(now - 7d, now + 14d)` (same call
   Activity's Calendar lens already uses).
2. Filter `sonarrSeriesProvider(instanceId)` to partial progress
   (`0 < episodeFileCount < totalEpisodeCount`).
3. For each such series, pick the calendar entry closest to now
   (nearest future airing preferred; most recent past airing as
   fallback) to build the caption (`"S02E05 · next Fri"` / `"today"` /
   `"9 PM"`), reusing Activity's existing relative-date-label logic
   (promoted to a shared util if currently private to
   `calendar_timeline_row.dart`, rather than duplicated).
4. Cap at 3, ordered soonest-airing first. A partial-progress series with
   no calendar entry in the window is simply omitted — not an error
   state, the row just renders fewer than 3 cards.

### 4. "Missing" movies is a client-side filter, no new fetch

Movies tab's "Missing" section filters the already-loaded
`radarrMoviesProvider(instanceId)` list to `monitored && !hasFile`,
sorted by `calendarDate` (digital → physical → cinema, whichever is set)
descending. No new provider.

### 5. "Search all" wires a real bulk-search command

New `RadarrRepository.searchMovies(List<int> movieIds)` →
`RadarrClient` method POSTing `{name: 'MoviesSearch', movieIds: [...]}`
to Radarr's command endpoint, mirroring the existing `grabRelease`
command-POST pattern. Tapping "Search all" gathers the currently-missing
IDs, calls it, shows a snackbar confirmation. No optimistic UI change —
a search doesn't immediately produce a file.

### 6. Episode SUBTITLES block uses existing wanted-subtitle data, not new Bazarr API

The spec's per-language "OpenSubtitles · embedded" provenance text isn't
buildable from the current `BazarrWantedSubtitle` model (missing-languages
list only, no provider/embedded detail for present languages) without new
API research. This phase ships a **lighter approximation**: cross-reference
the episode's ID against `bazarrRepository.listWantedEpisodes()` — any
language named there renders as `tag-neutral` + red "Wanted"; anything not
in that list renders as a generic "Downloaded" state (no provider/embedded
sub-text, since that data isn't available). Full per-language provenance
is deferred to a future phase if wanted.

### 7. Legacy detail fields not in the 2e/2g spec are dropped, not relocated

`_DetailsCard`'s Status/Runtime/Network/Path rows on series/movie detail
have no equivalent in the 2e/2g anatomy (a lean 2-up stat row + overview +
genre line, for movies). These are dropped from the top-level view
following the spec exactly — Path/Video/Audio return for movies inside
the new 2g FILE `SpecBlock`; series has no equivalent since it isn't one
file. Network is still visible in the meta line
("2022 · Apple TV+ · TV-MA").

### 8. Preserve existing interactive behavior, restyle the chrome around it

Monitor/Unmonitor toggle, Delete (with confirm dialog), release search
navigation, Bazarr subtitle search, and the instance selector all keep
their current logic/providers — only the widgets presenting them change.
Episode detail's two header `IconButton`s become real primary "Find
release" / secondary "Subtitles" buttons in the body, calling the same
`_searchSubtitlesInBazarr` / release-search navigation as today. Movie
detail's overflow keeps Monitor/Delete/Search Movie (Radarr release
search stays in overflow — the spec doesn't promote it to a primary
button on movies, unlike episode's "Find release"). Series detail's
header promotes Search out of the overflow into a secondary icon button
(per spec), keeping Monitor/Delete in the 30px overflow.

## Provider plan — `lib/features/library/library_providers.dart`

- `ActiveLibraryTab`, `SelectedLibraryInstanceId` — unchanged.
- `continueWatchingProvider(instanceId)` — new, `@riverpod`, returns
  `List<ContinueWatchingEntry>` (a small local record/class: series,
  caption, calendar date) per Design decision 3.
- `missingMoviesProvider` — **not** a provider; `MovieList`/the Movies tab
  computes the filter inline from the already-watched
  `radarrMoviesProvider(instanceId)` value (Design decision 4), avoiding a
  redundant cache of the same list.
- `librarySortProvider` (or similar small enum notifier) for the "Newest
  first ⌄" / "Recently added ⌄" toggles and the sort/filter chip's Sort
  option — session-only state, no persistence, mirroring
  `ActiveActivityLens`'s pattern.

## Widget plan

- `lib/core/widgets/fading_rule.dart` — new.
- `lib/features/library/widgets/media_detail_header.dart` — new.
- `lib/features/library/widgets/spec_block.dart` — new.
- `lib/features/library/widgets/season_row.dart` — new (replaces the
  `_SeasonTile`/`_SeasonEpisodes`/`_EpisodeCard`/`_CountPill` private
  classes currently inline in `series_detail_page.dart`).
- `lib/features/library/widgets/library_row.dart` — restyle of
  `media_list_tile.dart` in place.
- `lib/features/library/widgets/continue_watching_row.dart` — new.
- `lib/features/library/widgets/collection_chips.dart` — new (Shows/
  Movies switch, Design decision 2).
- `movie_list.dart` / `series_list.dart` — updated to use `LibraryRow`
  and the new state-aware trailing logic; `MovieList` gains the Missing
  section split.
- `lib/app/theme/app_theme.dart` — one-line addition (Design decision 1).
- `lib/services/radarr/radarr_client.dart` / `radarr_repository.dart` —
  new `searchMovies` method (Design decision 5).

## Edge cases

- **No Radarr/Sonarr instance configured**: existing `_NoRadarrInstance`/
  `_NoSonarrInstance` empty states are preserved, restyled onto
  `EmptyState`'s Nocturne look (already done in an earlier phase — no
  change needed beyond confirming it still renders correctly under the
  new chip-row header).
- **Continue watching with zero eligible shows**: the row and its
  "CONTINUE WATCHING" kicker are omitted entirely (not an empty-state
  card) — "All shows" simply becomes the first thing shown.
- **Missing movies with zero entries**: the "MISSING · N" kicker and
  "Search all" are omitted; Movies tab opens directly on "RECENTLY ADDED".
- **Calendar fetch fails while building Continue Watching**: the row is
  omitted (same as zero eligible shows) rather than surfacing an error —
  Continue Watching is a convenience surface, not a required one; "All
  shows" still renders from `sonarrSeriesProvider` independently.
- **`searchMovies` command fails**: snackbar shows the error message,
  matching every other command failure path in these pages today.
- **Season with zero episodes on disk**: `SeasonRow`'s progress bar/count
  render the zero-state (`#F44336`) per spec, same as one missing episode
  case but for the whole season.

## Testing plan

- Widget tests per new shared widget (`MediaDetailHeader`, `SpecBlock`,
  `SeasonRow`, `LibraryRow`, `ContinueWatchingRow`, `CollectionChips`)
  covering each state-driven visual: 100%/partial/unmonitored trailing,
  complete/partial/zero season coloring, missing-vs-downloaded episode
  rows, missing-vs-wanted subtitle chips.
- Unit tests for `continueWatchingProvider` (calendar cross-reference:
  soonest-future preferred, past-fallback, omission when no entry in
  window, cap at 3) and `RadarrRepository.searchMovies` (command payload
  shape, error propagation).
- Golden/manual smoke pass on both themes for all four screens, mirroring
  Phase 4's closing smoke test.

## Files touched (summary)

**New:**
`lib/core/widgets/fading_rule.dart`,
`lib/features/library/widgets/media_detail_header.dart`,
`lib/features/library/widgets/spec_block.dart`,
`lib/features/library/widgets/season_row.dart`,
`lib/features/library/widgets/continue_watching_row.dart`,
`lib/features/library/widgets/collection_chips.dart`.

**Restyled/modified:**
`lib/features/library/library_page.dart`,
`lib/features/library/series_detail_page.dart`,
`lib/features/library/episode_detail_page.dart`,
`lib/features/library/movie_detail_page.dart`,
`lib/features/library/library_providers.dart`,
`lib/features/library/widgets/media_list_tile.dart`,
`lib/features/library/widgets/movie_list.dart`,
`lib/features/library/widgets/series_list.dart`,
`lib/app/theme/app_theme.dart`,
`lib/services/radarr/radarr_client.dart`,
`lib/services/radarr/radarr_repository.dart`.

**Out of scope:** `add_movie_page.dart`, `add_series_page.dart`,
`widgets/add_movie_options.dart`, `widgets/add_series_options.dart`, all
Activity feature files, release-search pages.

# Nocturne Redesign Phase 4 — Activity — Design

## Problem

Phases 1–3 (merged into `worktree-nocturne-redesign`) rewrote the tokens,
shell, and Home tab. This phase — item 4 of
`design_handoff_arrstack_hub/README.md`'s "Implementation order," and the
README's own "biggest change" — replaces the **Downloads**, **Calendar**,
and **Subtitles** tabs (currently reachable via `/activity`,
`/activity/calendar`, `/activity/subtitles/:instanceId`) with a single
**Activity** page (spec screens **2h/2i/2j**) that switches between three
lenses — Transfers, Calendar, Wanted — via chips, matching the README's
route map: `/activity (?lens=transfers|calendar|wanted)`.

`route_paths.dart`'s existing top-of-file comment flags `activityCalendar`/
`activitySubtitles` as a temporary carryover pending exactly this merge.

**Non-goals:** Library/detail restyling, sub-pages (Uptime/Indexers/
Settings), Seerr screens, and the §3f/3g cache-layer/empty-state work
(explicitly phase 8) — unchanged by this phase. Radarr's missing movies are
**not** added to the Wanted lens (2j only merges Sonarr missing episodes +
Bazarr wanted subtitles — Radarr's missing count already surfaces on its
Home tile and Library).

## Current state

- **Transfers** (`lib/features/downloads/`): `DownloadsPage` — single
  qBittorrent instance via `selectedDownloadInstanceIdProvider`
  (default-instance rule), `qbitTorrentsProvider`/`qbitMainDataProvider`
  (one-shot fetch, not polled), `downloadFilterProvider` (7-way filter enum),
  `TorrentTile` widget using `LegacySpacing`/hardcoded `Colors.blue`.
- **Calendar** (`lib/features/calendar/`): `CalendarPage` —
  `calendarScheduleProvider` aggregates every configured Sonarr + Radarr
  instance into day-grouped `CalendarDay`/`CalendarEntry` (60-day lookahead
  from today), skipping any instance that errors so the schedule stays
  partial rather than failing outright. `CalendarEntryTile` also uses
  `LegacySpacing`.
- **Subtitles** (`lib/features/subtitles/`): `SubtitlesPage(instanceId)` —
  single Bazarr instance selected via the route param (Home's tile taps
  `/activity/subtitles/:instanceId` directly), `bazarrWantedProvider`
  (already used elsewhere, e.g. `home_providers.dart`'s `_bazarrSummary`,
  which treats an `Err` result as "unreachable").
- No provider in the app polls on an interval — every fetch is one-shot,
  refreshed by pull-to-refresh or `ref.invalidate`. The 2h throughput
  sparkline ("Last 60 min") has no data source today.
- No Sonarr "missing episodes" call exists anywhere (`SonarrClient`/
  `SonarrRepository` have no `wanted/missing` method). Sonarr's
  `GET /api/v3/wanted/missing` is paginated (`page`/`pageSize` →
  `{records, totalRecords}`, same shape `getQueue()` already parses) and,
  with `includeSeries=true`, returns episode resources shaped exactly like
  `SonarrCalendarEpisode` (`id`, `seriesId`, `seasonNumber`, `episodeNumber`,
  `title`, `airDateUtc`, `hasFile`, `monitored`, `series`) — so that
  existing model is reusable as-is, no new model needed.
- `lib/features/library/library_providers.dart`'s `ActiveLibraryTab`
  (`@riverpod class`, `select(tab)`) is the precedent for lens/tab state:
  Home's `service_tile_grid.dart` sets it before navigating so Radarr/Sonarr
  tiles land on the right Library tab.
- Design tokens already anticipate this phase: `AppColors`' accent ramp
  (`a100`–`a900`) doc comment explicitly calls out "the throughput
  sparkline"; `AppColors.divider`/`n500`/status-dot colors and
  `core/widgets/status_chip.dart` cover the lens-chip and tag styling.

## Design decisions

### 1. One route, one in-session lens notifier

The route map has no per-lens sub-path or instance param — just
`/activity?lens=`. A new `ActiveActivityLens` provider
(`lib/features/activity/activity_providers.dart`, `@riverpod class`, enum
`ActivityLens { transfers, calendar, wanted }`, default `transfers`) mirrors
`ActiveLibraryTab`. The single `GoRoute(path: RoutePaths.activity)` reads
`state.uri.queryParameters['lens']` once, on first build, to seed the
notifier (supports deep links); after that the notifier — not the URL —
drives which lens renders, exactly like `ActiveLibraryTab` drives Library's
tab today. `RoutePaths.activityCalendar`/`activitySubtitles` and the nested
routes in `router.dart` are removed, along with the doc-comment caveat in
`route_paths.dart`.

### 2. Wanted lens aggregates across instances; Bazarr failure is the only banner

Calendar already proves the "aggregate across all instances of a type,
skip the ones that fail" pattern for Sonarr/Radarr. Wanted reuses it for
both its sources:

- **Missing episodes:** a new `sonarrMissingEpisodesProvider` iterates
  every configured Sonarr instance, calling the new
  `SonarrRepository.listMissingEpisodes()`; a failing instance is dropped
  silently (try/catch around each instance's call, same shape as
  `calendarScheduleProvider`'s `_sonarrEntries`) — no error surfaces for a
  Sonarr-side failure, matching 2j's copy ("Radarr and Sonarr are
  unaffected").
- **Wanted subtitles:** a new `bazarrWantedAggregateProvider` iterates every
  configured Bazarr instance via the existing `bazarrWantedProvider`. If
  **any** instance's call fails, the lens shows the single 2j error card
  ("Bazarr is unreachable" / retry + open-settings); successful instances'
  subtitles still render below it. (In practice almost every install has at
  most one Bazarr instance, so this rarely needs to distinguish "which
  one" — the copy doesn't ask it to.)

This also means Bazarr no longer needs a route-level `instanceId` — Home's
Bazarr tile now just sets the lens and navigates, like Radarr/Sonarr →
Library already does.

### 3. Throughput sparkline is a session-only sampled buffer, not persisted history

Nothing in the app polls on an interval; qBittorrent's API only exposes
instantaneous speed. Building true persisted 60-minute history (surviving
app restarts) would require new background-polling infrastructure this app
doesn't have anywhere else, which is out of proportion to one sparkline.

**Decision:** a new `TransfersThroughputHistory` notifier
(`@riverpod class`, `keepAlive: false`) samples `qbitMainDataProvider`'s
`dlInfoSpeed` on a `Timer.periodic(Duration(seconds: 5))` while the
Transfers lens is mounted (started in `build()`, cancelled via
`ref.onDispose`), keeping a ring buffer of samples from the last 60 minutes
(older samples drop off each tick). The sparkline renders whatever's been
collected so far — sparse right after the lens first mounts this session,
filling in over time. This is explicitly a "recent activity" visualization,
not analytics; resetting on navigation away and back, or on app restart, is
acceptable and doesn't need to be called out to the user.

### 4. Full widget restyle, not a page merge with old widgets

`TorrentTile`, `CalendarEntryTile`, and `WantedSubtitleTile` all predate
Nocturne (`LegacySpacing`, hardcoded `Colors.blue`/`Colors.green`). The
2h/2i/2j mockups specify materially different layouts (torrent-state
blocks instead of uniform rows, timeline rows with fading dividers, the
shared error-card pattern). Per Phase 3's convention, all new widgets use
`Theme.of(context).colorScheme` branching for anything that must adapt
between light/dark, and `AppColors`/`AppTypography`/`AppSpacing` tokens
directly where the design is theme-invariant (e.g., the sparkline's accent
gradient, tag-chip colors) — old widgets are replaced, not patched.

### 5. Home tile taps pre-select the right lens

Mirrors Phase 3's Radarr/Sonarr → Library-tab fix. In
`service_tile_grid.dart`, tapping the qBittorrent tile sets
`ActiveActivityLens` to `transfers`; tapping Sonarr or Bazarr sets it to
`wanted`; both then `context.go(RoutePaths.activity)`. (Radarr's tile keeps
going to Library, per the Phase 3 fix and this phase's Non-goals — Radarr
has no Activity presence.)

## Provider plan — `lib/features/activity/activity_providers.dart`

- `ActiveActivityLens` — `@riverpod class`, `ActivityLens build() =>
  ActivityLens.transfers`, `void select(ActivityLens lens)`.
- `sonarrMissingEpisodesProvider` — `@riverpod Future<List<SonarrCalendarEpisode>>`,
  aggregates `SonarrRepository.listMissingEpisodes()` across all configured
  Sonarr instances (per-instance try/catch-skip), sorted by `airDateUtc`
  ascending (nulls — physical-release-style entries — last, mirroring
  `CalendarEntry`'s existing dateless handling).
- `bazarrWantedAggregateProvider` — `@riverpod Future<Result<List<BazarrWantedSubtitle>>>`,
  iterates configured Bazarr instances; returns `Err` (triggering the
  offline card) if any instance's `bazarrWantedProvider` call errors,
  otherwise `Ok` with every reachable instance's subtitles concatenated.
- `TransfersThroughputHistory` — `@riverpod class`, `List<ThroughputSample>
  build()` (empty list), internal `Timer.periodic` appending
  `ThroughputSample(timestamp, dlInfoSpeed)` from
  `qbitMainDataProvider(selectedInstanceId)`, pruning samples older than 60
  minutes each tick; `ref.onDispose` cancels the timer.
- Existing providers reused unchanged: `selectedDownloadInstanceIdProvider`,
  `qbitTorrentsProvider`, `downloadFilterProvider`, `calendarScheduleProvider`.
- New Sonarr layer: `SonarrClient.getWantedMissing({int page = 1})` →
  `GET api/v3/wanted/missing` with `includeSeries: true`, parsed as
  `SonarrCalendarEpisode` (same try/catch-per-record logging pattern as
  `getEpisodes`/`getCalendar`), paging until a page returns fewer than
  `pageSize` records; `SonarrRepository.listMissingEpisodes()` wraps it.

## Widget plan

`lib/features/activity/`:

- `activity_page.dart` — `Scaffold` with an `AppBar` whose title is always
  "Activity" and whose trailing action switches on `ActiveActivityLens`
  (add-torrent `+` / search / "Search all", per 2h/2i/2j headers); body
  swaps between the three lens widgets keyed by the active lens (each kept
  alive via `AutomaticKeepAliveClientMixin` or an `IndexedStack` so
  switching tabs doesn't reset scroll position).
- `widgets/lens_chips.dart` — the reusable chip row (Transfers / Calendar /
  Wanted, with the Wanted badge count), styled per README "Lens chips"
  (accent text + 1px inset accent ring when active, no fill).
- **Transfers:** `widgets/transfers_lens.dart` (sparkline + caption row +
  secondary chips + list), `widgets/throughput_sparkline.dart` (12-bar
  chart from `TransfersThroughputHistory`, `AppColors.a800`→`a500` gradient
  per spec), `widgets/torrent_block.dart` replacing `TorrentTile` with the
  three 2h variants (downloading/stalled/seeding).
- **Calendar:** `widgets/calendar_lens.dart` (week strip + day-grouped
  timeline, reusing `calendarScheduleProvider`), `widgets/week_strip.dart`
  (6 day cells, load bar height from that day's entry count, today ring),
  `widgets/calendar_timeline_row.dart` replacing `CalendarEntryTile`.
- **Wanted:** `widgets/wanted_lens.dart` (error card + secondary chips +
  two kicker sections), `widgets/missing_episode_row.dart` (episode code +
  title + aired/found-releases line + search button),
  `widgets/wanted_subtitle_row.dart` replacing `WantedSubtitleTile` (title +
  meta line + language tag chips). Error card reuses the existing 2j/2n/3f
  pattern — check `core/widgets/` for a shared component before writing a
  new one; if none exists yet, add `core/widgets/error_card.dart` since
  future phases (2n, 3f) need the identical pattern.

## Routing / file moves

- `router.dart`: the Activity `StatefulShellBranch` becomes a single
  `GoRoute(path: RoutePaths.activity, builder: (context, state) =>
  ActivityPage(initialLens: ...))` with no nested routes.
- `route_paths.dart`: remove `activityCalendar`/`activitySubtitles` and the
  top-of-file caveat comment about them.
- `lib/features/downloads/`, `lib/features/calendar/` (page + old tile;
  `calendar_providers.dart`, `models/calendar_entry.dart`, and
  `widgets/calendar_date_format.dart` are kept — reused by the new
  Calendar lens), `lib/features/subtitles/` (page + old tile; provider
  folded into the new aggregate) move into `lib/features/activity/` or are
  deleted per the Files touched list below.
- `service_tile_grid.dart`: qBittorrent/Sonarr/Bazarr tile `onTap` updated
  per Decision 5.

## Edge cases

- **No qBittorrent instance:** Transfers lens shows the existing
  `_NoQbitInstance`-equivalent empty state; sparkline/stats bar omitted.
- **No Sonarr or no Bazarr instances configured:** their section of the
  Wanted lens is simply empty (kicker + "0", or omit the section) — not an
  error, same as Calendar's existing "nothing scheduled" handling.
  `sonarrMissingEpisodesProvider`/`bazarrWantedAggregateProvider` both
  already return empty/Ok on zero instances.
- **All Sonarr instances fail:** missing-episodes section is empty (no
  banner — matches Decision 2's "Sonarr failures are silent").
  **Any Bazarr instance fails:** offline error card shown once; other
  Bazarr instances' subtitles still list below it.
- **Switching away from Transfers lens:** `TransfersThroughputHistory`'s
  timer must stop (`autoDispose` + `ref.onDispose`) so it doesn't keep
  polling qBittorrent while the user is on Calendar/Wanted or another tab.
- **Deep link with `?lens=` unset or invalid:** falls back to
  `ActivityLens.transfers` (the notifier's default).
- **Rapid lens switching:** each lens widget's own provider watches stay
  `autoDispose` (Calendar/Transfers/Wanted don't need `keepAlive` — Home's
  precedent is that nothing here chains awaits without an active watcher),
  so an unmounted lens's providers dispose normally.

## Testing plan

Mirrors Phase 3's rigor:

- Unit tests (`test/features/activity/activity_providers_test.dart`):
  `sonarrMissingEpisodesProvider` aggregation across mixed
  reachable/unreachable Sonarr instances; `bazarrWantedAggregateProvider`
  Err-on-any-failure + Ok-concatenation behavior; `ActiveActivityLens`
  default + `select`; `TransfersThroughputHistory` sample pruning (use
  `fake_async` to advance past 60 minutes and assert old samples drop).
- New Sonarr client/repo tests
  (`test/services/sonarr/sonarr_client_test.dart`,
  `sonarr_repository_test.dart`): `getWantedMissing`/`listMissingEpisodes`
  pagination and malformed-record handling, mirroring existing
  `getEpisodes`/`getQueue` test coverage.
- Widget tests: `LensChips` active/inactive states + tap-to-switch;
  `ThroughputSparkline` renders bar heights proportional to samples and
  handles an empty buffer; `TorrentBlock` downloading/stalled/seeding
  variants; `WeekStrip` today-ring + load-bar sizing; `WantedLens` shows
  the offline card only when Bazarr aggregate errors; `ActivityPage`
  switches lens on chip tap and preserves the other lenses' scroll state.
- `flutter analyze`, `dart format --set-exit-if-changed .`, full `flutter
  test` green before PR into `worktree-nocturne-redesign`.

## Files touched (summary)

**New:** `lib/features/activity/activity_page.dart`,
`activity_providers.dart`, `widgets/lens_chips.dart`,
`widgets/transfers_lens.dart`, `widgets/throughput_sparkline.dart`,
`widgets/torrent_block.dart`, `widgets/calendar_lens.dart`,
`widgets/week_strip.dart`, `widgets/calendar_timeline_row.dart`,
`widgets/wanted_lens.dart`, `widgets/missing_episode_row.dart`,
`widgets/wanted_subtitle_row.dart`; possibly `core/widgets/error_card.dart`;
plus matching `test/features/activity/**` files and
`test/services/sonarr/*` additions.

**Deleted:** `lib/features/downloads/` (all files), `lib/features/calendar/calendar_page.dart`
+ `widgets/calendar_entry_tile.dart` (provider/model/date-format files kept
and moved into `activity/` or left in place per implementation-time call),
`lib/features/subtitles/` (all files — provider logic folds into
`bazarrWantedAggregateProvider`).

**Modified:** `lib/app/router.dart`, `lib/app/route_paths.dart`,
`lib/features/home/widgets/service_tile_grid.dart`,
`lib/services/sonarr/sonarr_client.dart`, `sonarr_repository.dart`.

# Nocturne Redesign Phase 6: Sub-pages (Uptime, Indexers, Settings, Edit-instance)

**Date:** 2026-09-13
**Scope:** README §2k–2n. Rebuilds the four Home-reachable sub-pages onto Nocturne.
Routes already exist (`router.dart`); this phase replaces page bodies only — no new
routes, no new persisted state beyond what's already modeled.

## Decisions locked during brainstorming

1. **Uptime instance selector is dropped.** The mockup shows no selector; Uptime
   resolves to the default Kuma instance the same way Indexers already resolves via
   the instance ID Home hands it. `selectedUptimeInstanceIdProvider`'s
   default-resolution logic (`isDefault` else first) stays; the `_InstanceSelector`
   dropdown widget is deleted.
2. **Retest reconnects + refreshes.** No Kuma admin "run check now" API exists here.
   Retest tears down and re-establishes the socket connection for that instance
   (`ref.invalidate(kumaMonitorsProvider(instanceId))`, which disposes and rebuilds
   the stream provider, forcing `ensureConnected()` again) — a real action, not
   cosmetic.
3. **"Use Remote for now" is session-only.** `EndpointSessionOverride` already exists
   in `instance_dio_providers.dart` for exactly this. The button calls
   `ref.read(endpointSessionOverrideProvider.notifier).update(instanceId,
   EndpointMode.forceRemote)`, then invalidates `resolvedEndpointProvider(instanceId)`
   and the instance's test result so the form re-evaluates against the new endpoint.
   Nothing is written to `ServiceInstance.endpointMode` (the persisted field).
4. **Settings reuses `homeServiceSummariesProvider`** for live status dots and
   per-instance error text — one reachability definition shared with Home, not a
   second cheaper health check.
5. **Verbatim exception text is available.** `AppError.cause` always carries the raw
   exception (`dio_exception_mapper.dart` populates it on every branch). Edit-instance's
   error card renders `error.cause.toString()` (falling back to `userMessage` if null),
   not the friendly `userMessage`.

## Shared components (new)

### `lib/core/widgets/sub_page_header.dart` — `SubPageHeader`

A `PreferredSizeWidget` (wraps `AppBar`) replacing the ad hoc "back + kicker/title"
`AppBar(title: Column(...))` pattern already used once in `episode_detail_page.dart`.
Five usages (that one plus this phase's four) crosses the real-duplication threshold.

```dart
SubPageHeader({
  String? kicker,       // e.g. "UPTIME KUMA", "PROWLARR", "BAZARR" — null for Settings
  required String title, // e.g. "Monitors", "Indexers", "Settings", "Edit instance"
  List<Widget>? actions,
})
```

Renders the back chevron via `AppBar`'s default leading-back behavior — GoRouter
already supplies it when there's a route to pop, no custom back button needed.
Title area: kicker (`AppTypography.kicker`) over title (`AppTypography.sectionTitle`)
in a `Column` when `kicker != null`; otherwise just the title. `episode_detail_page.dart`
is **not** retrofitted — out of scope, no behavior change needed there.

### `lib/features/uptime/widgets/heartbeat_strip.dart` — `HeartbeatStrip`

Replaces `monitor_tile.dart`'s private `_HeartbeatBar`.

```dart
HeartbeatStrip({
  required List<KumaHeartbeat> heartbeats,
  required int beatCount,   // 24 for the down hero card, 12 for healthy rows
  required double height,   // 22 for hero, 14 for healthy rows
  required Color upColor,
})
```

Same oldest→newest left-to-right ordering and empty-slot padding as today's
`_HeartbeatBar`; only the bar count/height become parameters and gaps drop from the
current ad hoc value to the spec's 1.5px.

## Uptime (`/home/uptime`) — README §2k

**File:** `lib/features/uptime/uptime_page.dart` (rewritten in place). Deletes the
2×2 `_AdminOverview`/`_StatCard` grid, the `_InstanceSelector`, and
`monitor_tile.dart` (superseded by the three widgets below).

**Header:** `SubPageHeader(kicker: 'UPTIME KUMA', title: 'Monitors', actions: [refresh IconButton])`.
Refresh invalidates `kumaMonitorsProvider(instanceId)`.

**Stat row** (new, inline under the header — no `AppBar.bottom`, just the first
child of the body `ListView`): three `Column`s (numeral over `AppTypography.statCaption`
label), `AppSpacing.space8` apart — UP count in `AppColors.up`, DOWN in `AppColors.down`,
PAUSED in `AppColors.n500`. Computed from `monitors`: `up = status == 1 && active`,
`down = status == 0 && active`, `paused = !active`.

**Body**, in order:
- `DownMonitorCard` (new widget) — one per down-and-active monitor. Full card, 1px
  inset `AppColors.down` ring (reuse the `Border.all(color: AppColors.down...)` style
  `ErrorCard` already uses): 8px glowing status dot + name (14px) + `DetailChip` type
  badge (e.g. "HTTP"); URL in tabular `AppTypography.meta`;
  `HeartbeatStrip(beatCount: 24, height: 22)`; footer row "Down {duration} · {uptime}%
  24h" in `AppColors.down` + primary "Retest" button (`OutlinedButton`, accent
  outline) that calls `ref.invalidate(kumaMonitorsProvider(instanceId))`.

  **Down-duration calculation** (pure function, unit-testable): `heartbeats` is
  newest-first. Walk from index 0 while `status == 0`, keeping the `time` of the
  last (oldest-in-that-run) entry seen; the duration is `now - thatTime`. If the
  walk exits immediately (index 0 isn't down — stale data mid-transition) or
  `heartbeats` is empty, fall back to `"just now"`. Format with a new
  `formatCompactDuration(Duration)` helper in `core/utils/format_utils.dart`
  (`"38m"`, `"2h 14m"`, `"3d"` — reused by the paused-row duration below).
- Kicker "HEALTHY · {n}", then one `HealthyMonitorRow` per up-and-active monitor:
  7px dot, name, `HeartbeatStrip(beatCount: 12, height: 14)` (74px wide), trailing
  tabular latency (`{latestPing} ms`).
- Paused monitors: a trivial inline row (grey dot, name at reduced opacity, "paused
  {duration}", no strip) built directly in `uptime_page.dart` — not its own file,
  it's a three-line `Row`. Duration here is `now - monitor.heartbeats.first.time`
  (most recent heartbeat before pausing), same `formatCompactDuration` helper,
  falling back to `"paused"` (no duration suffix) if there are no heartbeats.

**Empty/error/no-instance states:** keep existing `EmptyState` usage, restyled with
Nocturne tokens where it renders inline (icon/title/message colors from `AppColors`).

## Indexers (`/home/indexers/:instanceId`) — README §2l

**File:** `lib/features/indexers/indexers_page.dart` (full rewrite — today's version
predates the design system entirely, plain `ListTile`s).

**Header:** `SubPageHeader(kicker: 'PROWLARR', title: 'Indexers', actions: [refresh])`.

**Stat row:** ENABLED (count of `indexer.enable`), GRABS 30D (sum of
`stat.numberOfGrabs` across all indexers — the existing `prowlarrIndexerStatsProvider`
call already scopes to a 30-day window server-side), SLOWEST ms (max
`averageResponseTime` across indexers, colored `AppColors.warning` when it clears the
slow threshold below).

**Slow-indexer threshold:** `averageResponseTime > 1000ms` is "slow" — not specified
numerically in the README (only the 1284ms example), so this is a judgment call
documented here as a named constant (`_slowResponseThresholdMs`) rather than a
magic number, easy to retune.

**Body:** kicker "INDEXERS · {n}", then one row per indexer:
- 16px fill-weight status circle (`PhosphorIconsFill.checkCircle` green /
  `PhosphorIconsFill.xCircle` red) keyed off `indexer.enable` (Prowlarr's REST model
  doesn't expose a separate live-reachability signal from this endpoint — enabled/
  disabled is the only per-indexer status this API surfaces here).
- Name over tabular meta: `"{protocol} · priority {priority}"`.
- Trailing: grab count (34px, tabular, from the matching `IndexerStat`) then response
  time (52px, tabular) — response time is `AppColors.warning` + a "torrent · slow
  responses" meta override when over threshold, else normal text.
- Disabled rows (`!indexer.enable`): whole row at 0.62 opacity, count/response fields
  show "—" instead of stats (Prowlarr doesn't return meaningful stats for a disabled
  indexer).

**Footer:** `FadingRule`, then "LAST 24H" kicker block — Queries / Grabs / Failures
summed across all `IndexerStat`s, Failures in `AppColors.warning` when nonzero.

## Settings (`/home/settings`) — README §2m

**File:** `lib/features/settings/settings_page.dart` (rewritten in place).

**Header:** `SubPageHeader(kicker: null, title: 'Settings', actions: [primary "Add"])`.

**Instances section:** kicker "INSTANCES · {n}" with "tap to edit" meta. Each row:
live status dot from `homeServiceSummariesProvider` (`isReachable` → up/down color,
matching `ServiceTile`'s dot treatment), name + `DetailChip` "Default" when
`isDefault`, tabular meta line `"{endpoint} · v{version}"` when reachable or the
summary's error label (e.g. "Connection refused · retried 4×" — sourced from the
summary's existing error surfacing) when not, trailing caret. Delete stays a confirm
dialog (existing behavior, restyled to Nocturne button treatment, not the
destructive-confirm pattern from 3g since that pattern isn't built until Phase 8 —
a plain `AlertDialog` is acceptable here and matches what's already shipped).

**Home Networks section:** kicker "HOME NETWORKS" + explanation line, then the SSID
chips restyled (`neutral-900` fill pill with dismiss `x`, per README) inside
`home_ssid_setting.dart`, "Add an SSID" field + secondary "Detect" button
(`ph-wifi-high`).

**Default endpoint / Theme:** two value rows ("Default endpoint" → "Auto ⌄" etc.,
"Theme" → "Dark ⌄"), restyled as tappable rows with a trailing caret opening the
existing `DropdownButton` (kept functionally identical, just restyled — no new
picker UI component needed since the existing dropdown already covers the
three-option case).

## Edit instance (failing) (`/home/settings/:id/edit`) — README §2n

**Files:** `add_instance_page.dart` and `instance_form.dart` gain an error-first
branch; no new route (the existing `homeEditInstance` route already covers this —
2b "Add a service" and 2n are the same route/page, just different states of the
same form, matching how the README frames 2n as "the failure state of 2b").

**Behavior:** on `load(instanceId)`, after populating the form, auto-run
`testLocal()` (and `testRemote()`) once so a stale/broken local URL surfaces
immediately without the user tapping Test — this is new: today `load()` only
populates fields.

**Layout when editing AND `localTestResult` is an `Err`:**
1. `SubPageHeader(kicker: <serviceType.displayName.toUpperCase()>, title: 'Edit instance', actions: [trash])`.
2. `ErrorCard` first: title "Local URL refused the connection" (or a message derived
   from the error type — `NetworkError` → "refused the connection", `AuthError` →
   "rejected the credentials", etc.), message = `localTestResult.error.cause`'s
   `toString()` in tabular styling (reuse `AppTypography.meta` with
   `FontFeature.tabularFigures()`), primary action "Test again" (re-runs
   `testLocal()`), secondary action "Use Remote for now" (the session-override call
   from Decision 3 above, then pops back to Settings since the instance is now
   usable — an escape hatch, not a dead-end).
3. Then the existing form, with the Local URL field getting a `AppColors.down` border
   and its inline result line, Remote URL showing its own test result if present.
4. Action bar: "Save changes" (same `AddInstancePage` save flow, unchanged).

When there's no error (normal add/edit), the page renders exactly as it does today
(2b), just with `SubPageHeader` swapped in for the current `AppBar`.

## Testing

- `HeartbeatStrip`: widget tests for beat count, empty-slot padding, color mapping.
- `SubPageHeader`: widget test confirming kicker/no-kicker rendering and that it
  satisfies `PreferredSizeWidget`.
- Uptime: unit tests for the up/down/paused counting logic and down-duration
  calculation (pure functions, extracted so they're testable without pumping
  widgets); widget tests for `DownMonitorCard`/`HealthyMonitorRow` states.
- Indexers: unit tests for the slow-threshold coloring and LAST-24H aggregation
  (pure functions); widget test for disabled-row dimming.
- Settings: widget test that a `homeServiceSummariesProvider` error surfaces as the
  row's meta line.
- Edit-instance: widget test that load() auto-tests and that an `Err` result renders
  the error-first branch with the verbatim `cause` text; test that "Use Remote for
  now" calls `endpointSessionOverrideProvider.notifier.update` with `forceRemote`.

## Out of scope

- The 3g destructive-confirm pattern (Phase 8) — Settings' delete dialog stays a
  plain `AlertDialog`.
- Retrofitting `episode_detail_page.dart` onto `SubPageHeader`.
- Any change to `EndpointMode`, `ServiceInstance`, or the Prowlarr/Kuma API clients
  themselves — this phase is UI-layer only, built on existing providers.

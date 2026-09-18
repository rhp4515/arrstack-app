# Nocturne Redesign Phase 8: States (Empty/Loading/Offline) + Destructive Confirm

Design spec for the final phase of the Nocturne redesign, covering `design_handoff_arrstack_hub/README.md` §3f (Home's empty/loading/offline states) and §3g (a shared destructive-confirm dialog pattern). Branches off `worktree-nocturne-redesign` at commit `b7166a4` (Phase 7 merged).

## Context

Phases 1–7 are complete. Home (`lib/features/home/`) is built with real, live-networked Riverpod providers — no mock data. Per-service failures inside `homeServiceSummariesProvider` already degrade gracefully into `isReachable: false` tiles with a red dot; what's missing is: any distinct UI for "the whole stack is unreachable" (aggregate failures mostly render `SizedBox.shrink()` today), any loading skeleton (only bare `CircularProgressIndicator`s), any cache of last-known-good data, and any shared confirm-dialog pattern (6 hand-rolled `AlertDialog`s exist today with inconsistent copy, coloring, and toggle exposure).

Full research findings (Home providers/state shape, all existing delete flows, storage conventions) are in the brainstorming transcript that preceded this doc; this spec captures the decisions reached there.

## Scope

**In scope:**
1. A derived `ConnectionState` (`unconfigured | loading | offline | ready`) driving which of four Home layouts renders.
2. A new cache layer: each service's last-successful `HomeServiceSummary`, persisted with its own fetch timestamp, read back for the offline layout.
3. Loading skeleton shaped like the real Home layout (band/card/grid), not a spinner-only placeholder.
4. Restyled empty state (`_EmptyHome` already exists functionally; needs the 3f visual treatment and wired actions).
5. A `kDebugMode`-gated dev chip row to switch `ConnectionState` for visual QA.
6. One shared `showDestructiveConfirmDialog` widget, applied to torrent delete (both the downloading and previously-unconfirmed stalled path) and instance delete (both existing call sites).

**Explicitly out of scope** (decided during brainstorming, not to be added as drive-by scope creep):
- Radarr/Sonarr movie/series delete dialogs are **not** touched, even though they share the same copy-paste inconsistency and their repository methods already support a `deleteFiles` flag the UI never exposes. They aren't one of the three deletes §3g names. Flagged as a good, low-risk follow-up for a future phase — not this one.
- Request deletion/cancellation is **not** reintroduced. Phase 7 deliberately removed it when building the Approve/Deny queue; the `SeerrRepository.deleteRequest` method is dead code with no call site and no design-doc screen specifies a delete affordance for requests. Confirmed out of scope with the user directly (the open question flagged when this phase was kicked off).

## `ConnectionState`

```dart
enum ConnectionState { unconfigured, loading, offline, ready }
```

Derived (never persisted) from existing providers, checked in this precedence order:

1. **`unconfigured`** — `instancesProvider` resolves `Ok([])` (no instances configured).
2. **`loading`** — instances resolved non-empty, but `homeServiceSummariesProvider` and/or `rightNowProvider` are on their *initial* fetch (`AsyncLoading` with no prior value — not a background pull-to-refresh, which should keep showing existing content per standard Riverpod/Material pull-to-refresh conventions).
3. **`offline`** — both of the above resolved with a value, but **zero** entries in `homeServiceSummariesProvider`'s result have `isReachable: true`, and `rightNowProvider` is also null/unreachable.
4. **`ready`** — default; at least one service reachable.

Checking `unconfigured` first guarantees that by the time `loading` is evaluated, the instance count is already known — so the loading caption ("Contacting N services on `<ssid>`…") always has a real N, never a placeholder.

This lives as a new `@riverpod` provider (e.g. `lib/features/home/home_connection_providers.dart`), auto-dispose like the rest of Home's leaf providers (per the existing convention that Home has no `keepAlive` providers since it's always live-watched while visible).

### Dev/demo override

A second `@Riverpod(keepAlive: true) class ConnectionStateDevOverride` holding `ConnectionState?` (null = no override). A new `effectiveConnectionStateProvider` reads the override first, falling back to the computed value. The header's state-switcher chip row (§3f: "switchable via a chip row... for demo/dev purposes") writes to this override, and is only rendered when `kDebugMode` is true — release builds never show it and always reflect real state.

## Cache layer

The one genuinely new piece of infrastructure this phase adds.

### Model

New freezed model, `lib/core/models/cached_service_summary.dart`:

```dart
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

No `isReachable` field — presence in the cache *is* the "last known good" signal. `DateTime` serializes via the default ISO-8601 codec, matching every other nullable `DateTime` field in the codebase (no custom `JsonKey`/converter).

### Storage

Extend `ConfigStore` (`lib/core/storage/config_store.dart`) rather than introducing a new store class — this is exactly the shape of the existing `readInstances`/`writeInstances` pair (a JSON-encoded list of objects under a single `shared_preferences` key):

```dart
Future<List<Map<String, dynamic>>> readCachedSummaries();
Future<void> writeCachedSummaries(List<Map<String, dynamic>> summaries);
```

New key constant `config.cachedSummaries`, following the existing `config.*` namespace. Decode failures degrade to `const []`, matching `readInstances`'s existing behavior — never throw.

A new `@Riverpod(keepAlive: true) Future<List<CachedServiceSummary>> cachedServiceSummaries(Ref ref)` provider reads this back, wrapped in the same defensive decode pattern as `InstanceRepository.list()` (catch `FormatException`/`CheckedFromJsonException`/`TypeError`/`ArgumentError`, degrade to empty rather than crash).

### Write-through

Inside `homeServiceSummariesProvider` (`lib/features/home/home_providers.dart`), after computing the full `List<HomeServiceSummary>`:

1. Filter to `isReachable: true` entries.
2. Map each to a `CachedServiceSummary` with `lastFetchedAt: DateTime.now()`.
3. Read the current cached list, **upsert** by `instanceId` (replace if present, append if not) — entries for services not in this batch (e.g. currently unreachable, or removed) are left untouched, not deleted.
4. Write the merged list back via `ConfigStore.writeCachedSummaries`.
5. Invalidate `cachedServiceSummariesProvider` so any visible offline UI picks up the fresh cache immediately.

This runs on **every** successful fetch — including normal `ready`-state operation, not only when about to go offline — so the cache is continuously warm rather than written defensively at the offline boundary. It does not invalidate `homeServiceSummariesProvider` itself (no self-triggering loop).

### Staleness display

The offline layout's "LAST KNOWN · N MIN AGO" kicker uses the **oldest** (`min`) `lastFetchedAt` among the cached rows currently being displayed — a deliberately conservative "nothing shown here is fresher than this" statement, never overstating freshness of the whole block. Computed as `DateTime.now().difference(oldest).inMinutes`, using the same clock source (`DateTime.now()`, local time) consistently on both the write and read/display sides — no UTC/local mixing, which is the exact bug class that slipped through review in Phases 6 and 7.

**Empty-cache edge case**: a fresh install that goes offline before ever completing a successful fetch has no cached entries. The "LAST KNOWN" block is omitted entirely in that case (not rendered with a misleading "0 min ago" or an empty rows list) — the offline screen still shows the error card, just without the stale-data section beneath it.

### Rendering — read-only by construction

Cached rows in the offline layout render as a **distinct, non-interactive list** — separate from the normal tappable `ServiceTileGrid` — per spec: "grey-dotted rows with cached figures and a trailing `ph-clock-counter-clockwise`." No `InkWell`/`GestureDetector`/navigation wired to these rows at all. This makes "actions stay disabled" a structural fact (the widget has no tap handler) rather than a disabled-flag convention that could drift out of sync with the design intent.

## Loading skeleton

New static widgets (no shimmer package — no new dependency, matches the "ghost blocks" description in the design doc, which doesn't call for shimmer animation) shaped like the real Home layout, replacing the bare `CircularProgressIndicator`s used today:

- `HomeBandSkeleton` — the `section` band at 0.55 opacity with `section-ghost` blocks standing in for the endpoint chip, hero numeral, and status caption.
- `RightNowCardSkeleton` — a card-shaped block.
- `ServiceTileGridSkeleton` — a 2×2 grid of tile-shaped blocks, `neutral-800` for title bars and `neutral-900` for meta bars, per spec.

Below the skeleton, a centered 12px accent spinner ring plus the caption "Contacting N services on `<ssid>`…" — N from the resolved instance count, `<ssid>` from `currentSsidProvider` (omitted from the caption when null, e.g. on cellular: "Contacting N services…").

## Empty state

`_EmptyHome` already exists in `home_page.dart` (the `instancesAsync.when` branch for an empty `Ok` list already routes here) — this phase restyles it to the 3f spec rather than building it from scratch: centered `ph-hard-drives` icon (`neutral-600`, 30px), "No services yet" (21px), explanatory paragraph (12.5px/1.6, `neutral-500`), primary "Add a service" button, ghost "What's supported?" button.

- **"Add a service"** navigates to the existing add-instance flow (same destination Settings' "Add" button uses).
- **"What's supported?"** opens a small bottom sheet listing the same service chips shown on first-run's "SUPPORTED TODAY" section (Sonarr, Radarr, Prowlarr, Bazarr, qBittorrent, Uptime Kuma, Seerr) — reusing that content rather than a new screen or duplicated copy.

## Offline layout

Per §3f: the `section` band flattens to flat `neutral-900` (no saturated color when nothing is reachable), with a red-ringed "Remote · not on a home network" chip and a `neutral-500` em-dash where the healthy-count numeral would be. Body, top to bottom:

1. The one shared error-card pattern (`lib/core/widgets/error_card.dart` — already exists, already generalizes title/message/two-action), titled "Tailscale looks disconnected," with **Retry** (re-runs the same invalidation `refreshHome` already does — instances, leaf service providers, then the three derived Home providers) and **Open Tailscale** (attempts to open the Tailscale app via `url_launcher`; a failed launch is a no-op, not a crash — there's no reliable cross-platform "is this app installed" check worth building for one button).
2. "LAST KNOWN · N MIN AGO" kicker + the non-interactive cached-rows list described above (omitted entirely if the cache is empty).
3. A closing note stating explicitly that cached figures are read-only and actions stay disabled until a service answers — the honesty requirement is structural (no tap handlers) *and* stated in copy, so the state can never be mistaken for live data.

## Shared destructive confirm dialog

New widget, `lib/core/widgets/confirm_dialog.dart`:

```dart
class ConfirmDialogResult {
  final bool deleteFiles;
  const ConfirmDialogResult({this.deleteFiles = false});
}

Future<ConfirmDialogResult?> showDestructiveConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Remove',
  bool showDeleteFilesToggle = false,
  String deleteFilesTitle = 'Also delete files on disk',
  String? deleteFilesSubtitle,
});
```

Returns `null` on cancel/dismiss, a `ConfirmDialogResult` on confirm (`deleteFiles` reflects the toggle, default `false` — matching the design's "off by default"). Reuses the existing `LabeledToggleRow` widget (`lib/core/widgets/labeled_toggle_row.dart`) for the toggle rather than building a new one. Styling per §3g: `surface` fill, `radius-lg`, `shadow-lg`; Cancel is the secondary (`divider`-outline) button; Remove is a primary-outline button in `#F44336` for both text and border — the one dialog in the app that colors its destructive action, made consistent everywhere instead of only on the torrent dialog as today.

### Call sites

- **Torrent delete** (`lib/features/activity/widgets/torrent_block.dart`) — both the downloading-block dialog (currently hand-rolled with the toggle) *and* the stalled-block delete (currently has **no confirmation dialog at all** — an existing gap, not something this phase introduces) now go through the shared widget. Title "Remove this torrent?", body: `"${torrent.name}" will be removed from qBittorrent. If Sonarr or Radarr is still monitoring it, they may grab it again.`, toggle shown with subtitle showing bytes downloaded so far.
- **Instance delete** — both existing call sites (`lib/features/onboarding/add_instance_page.dart` and `lib/features/settings/settings_page.dart`) consolidate onto the shared widget instead of their two slightly-different copy-pasted dialogs. Title "Remove `{name}`?", body: "This removes `{name}` and its stored credentials from this device. The service itself keeps running elsewhere.", no toggle.

## Testing focus

Standard project testing conventions apply (unit + widget tests, TDD). Specific risk areas from this phase's design, called out for deliberate test coverage given past phases' date/time bugs slipping past individual-task review:

- `ConnectionState` derivation: boundary between `offline` (zero reachable) and `ready` (one reachable), and between `loading` (initial fetch) and a background refresh that should *not* re-trigger the loading skeleton.
- Cache write-through: upsert-by-`instanceId` logic — a currently-unreachable service's stale cache entry must survive a write-through triggered by a *different* service's success, not get dropped.
- Staleness computation: oldest-timestamp selection across multiple cached entries with different ages; empty-cache-while-offline renders without the "LAST KNOWN" block rather than crashing or showing "0 min ago".
- `showDestructiveConfirmDialog`: toggle defaults off, cancel returns `null`, confirm returns the correct `deleteFiles` value regardless of toggle interaction order.
- Cross-file integration: the debug-only chip row must actually be absent (not just visually hidden) outside `kDebugMode`; the stalled-torrent delete path must be verified to now show a dialog (regression test for the gap fix) rather than just trusting the code read.

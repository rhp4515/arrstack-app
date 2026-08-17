# ArrStack Companion — Build Spec

> A cross-platform (iOS + Android) Flutter app to manage a self-hosted **\*arr** media
> stack from one client. **Primary services:** Sonarr, Radarr, Bazarr, Prowlarr,
> qBittorrent, and **Uptime Kuma**. Browse & monitor movies/TV, add new content, watch
> the download pipeline, and see service uptime. No paid backend; the app talks directly
> to each service using a locally-stored, encrypted URL + API key.

This document is the **single source of truth** for building the app. It doubles as a
**standing work order** for Haiku/Sonnet subagents that build the app incrementally over
many sessions. See [§11 Subagent Build Protocol](#11-subagent-build-protocol).

---

## 1. Goals & Non-Goals

**Goals**
- One client to manage the whole \*arr stack from a phone/tablet.
- View monitored movies/series; add new ones; see & control downloads; monitor uptime.
- Support **multiple instances** per service (e.g. two Radarr servers) with fast switching.
- **Network-aware endpoints:** each instance can hold a **local LAN URL** and a **remote
  Tailscale URL**; the app auto-selects based on the connected **WiFi SSID** (home → local,
  else → Tailscale), with a manual override. See [§6a](#6a-network-aware-endpoint-selection-tailscale).
- Fully offline-capable config; **direct device → service** connections (no gateway to host).
- Adaptive **light & dark** themes, both first-class. Material 3.

**Non-Goals (v1)**
- No custom backend / proxy / cloud account.
- No media playback (this is a *manager*, not a player).
- **Seerr** (Overseerr/Jellyseerr discovery/requests) is **optional / stretch** for v1.
- Lidarr / Readarr / SABnzbd / NZBGet / Deluge / Tautulli are **post-v1** (architecture
  must not preclude them — see the service-plugin pattern in §5).

## 2. Reference Apps (learn from, do not copy code without license check)
- **ArrStack** (`com.arrstack.android`) — the paywalled app being replaced; feature target.
- **LunaSea** — MIT-licensed, **archived**; the canonical Flutter multi-\*arr controller.
  Best reference for API integrations and screen structure.
- **Seekarr**, **Helmarr** — current Flutter apps in this space.
- **Ruddarr** — open-source SwiftUI (iOS-only) Radarr/Sonarr app; good UX reference.

## 3. Locked Decisions
| Decision | Choice |
|---|---|
| Framework | **Flutter** (single Dart codebase → iOS + Android; desktop/web later) |
| v1 scope (primary) | **Sonarr, Radarr, Bazarr, Prowlarr, qBittorrent, Uptime Kuma** |
| v1 optional | Seerr (Overseerr/Jellyseerr) — build only if time allows |
| Connectivity | **Direct device → each service**; encrypted local storage of URL + API key |
| Theme | **Adaptive** light + dark, Material 3, per-service accent colors |
| Top-level nav | **Per-service modules** (dashboard → pick a service → its screens) |
| Backend | **None** |

## 4. Tech Stack (packages)
- **State management:** `flutter_riverpod` + `riverpod_generator` (typed, testable providers).
- **Networking:** `dio` (interceptors for `X-Api-Key`, base URL, logging, error mapping).
- **Models / serialization:** `freezed` + `json_serializable` (immutable models, unions).
- **Routing:** `go_router` (declarative, deep-link friendly).
- **Secure storage:** `flutter_secure_storage` for API keys/credentials (Keychain/Keystore).
- **Config/cache store:** `shared_preferences` (non-secret settings); optionally `hive`/`isar` for cached lists.
- **Realtime (Uptime Kuma):** `socket_io_client` (Kuma's primary API is Socket.io — see §6).
- **Connectivity / SSID:** `connectivity_plus` (network-change events) + `network_info_plus`
  (read current WiFi SSID) for the network-aware endpoint switch (§6a). SSID reads require
  runtime permission (see §6a).
- **Images:** `cached_network_image` (posters/fanart).
- **Testing:** `flutter_test`, `mocktail`, `integration_test`, `http_mock_adapter` (Dio mocking).
- **Lint:** `flutter_lints` (or `very_good_analysis`).

> Prefer code generation (`build_runner`) for models and Riverpod providers to keep hand-written boilerplate low.

## 5. Architecture — feature-first, service-plugin

```
lib/
├── main.dart
├── app/                      # App widget, router, theme wiring
│   ├── router.dart
│   └── theme/                # light/dark ColorSchemes, per-service accents, tokens
├── core/
│   ├── network/              # Dio factory, interceptors, error mapping, Result type
│   ├── storage/              # SecureStore (keys), ConfigStore (prefs)
│   ├── models/               # shared value objects (MediaItem, DownloadItem, ...)
│   └── widgets/              # shared UI (PosterCard, StatusChip, EmptyState, ...)
├── services/                 # one folder per integration = a "service plugin"
│   ├── contracts/            # ArrService interface(s): test connection, list, add, search...
│   ├── radarr/               # api client + repository + models + providers
│   ├── sonarr/
│   ├── prowlarr/
│   ├── bazarr/
│   ├── qbittorrent/
│   ├── uptimekuma/
│   └── seerr/                # optional
├── features/                 # UI, grouped by surface
│   ├── onboarding/           # add-service flow, connection test
│   ├── settings/             # instances CRUD, per-service config, theme
│   ├── dashboard/            # home: service tiles + aggregate activity
│   ├── library/              # Radarr/Sonarr browse + detail + add
│   ├── indexers/             # Prowlarr status + search
│   ├── subtitles/            # Bazarr status + search
│   ├── downloads/            # qBittorrent queue + controls
│   ├── uptime/               # Uptime Kuma monitors + status
│   └── discover/             # Seerr discovery + request (optional)
└── l10n/                     # (optional) localization
```

**Rules**
- Each service under `services/<name>/` implements a shared **contract** so features stay
  service-agnostic where possible, and post-v1 services drop in without touching UI plumbing.
- Repositories return a `Result<T, AppError>` (no throwing across layers). All external data
  is validated at the boundary (schema-driven `freezed.fromJson`), never trusted raw.
- Immutable models only (freezed). No in-place mutation. Files < 400 lines (800 hard max).

## 6. Service Integrations (endpoints & auth)
\*arr services: header **`X-Api-Key: <key>`**, base `http(s)://host:port`.

| Service | Base / API | Auth | Key endpoints (v1) |
|---|---|---|---|
| **Sonarr** | `/api/v3` | `X-Api-Key` | `GET /series`, `GET /series/lookup?term=`, `POST /series`, `GET /episode`, `GET /queue`, `GET /calendar`, `GET /qualityProfile`, `GET /rootFolder`, `POST /command` |
| **Radarr** | `/api/v3` | `X-Api-Key` | `GET /movie`, `GET /movie/lookup?term=`, `POST /movie`, `PUT/DELETE /movie/{id}`, `GET /queue`, `GET /calendar`, `GET /qualityProfile`, `GET /rootFolder`, `POST /command` (search) |
| **Bazarr** | `/api` | `X-Api-Key` | `GET /movies`, `GET /episodes/wanted`, `GET /movies/wanted`, `PATCH` search subtitles, `GET /system/status` |
| **Prowlarr** | `/api/v1` | `X-Api-Key` | `GET /indexer`, `GET /indexerstats`, `GET /search?query=`, `GET /system/status` |
| **qBittorrent** | `/api/v2` | **session cookie** via `POST /auth/login` (user+pass) | `GET /torrents/info`, `POST /torrents/pause\|resume\|delete`, `POST /torrents/add`, `GET /transfer/info`, `GET /app/version` |
| **Uptime Kuma** | Socket.io (`/socket.io`) | **login over socket** (user+pass, optional 2FA) | events: `monitorList`, `heartbeatList`, `uptime`, `avgPing`; actions: `login`, `getMonitorList` |
| **Seerr** *(optional)* | `/api/v1` | `X-Api-Key` | `GET /discover/movies`, `GET /discover/tv`, `GET /search?query=`, `POST /request`, `GET /request` |

> **Two integrations differ from the `X-Api-Key` norm — encapsulate each fully in its folder:**
> - **qBittorrent:** cookie-session auth; manage login, the `SID` cookie, and re-auth on 403.
> - **Uptime Kuma:** its supported API is **Socket.io realtime**, not plain REST. Authenticate
>   with username/password over the socket, then consume pushed `monitorList`/`heartbeatList`
>   events. *Confirm the exact auth flow against the user's instance before finalizing; if a
>   public status page is preferred, `GET /api/status-page/<slug>` + `/heartbeat/<slug>` is a
>   read-only fallback.*

**Connection test** (per service): a lightweight authenticated call (`/system/status` for
\*arr, `/app/version` for qBittorrent, socket `login` for Kuma) → clear success/failure +
parsed version/identity.

## 6a. Network-Aware Endpoint Selection (Tailscale)

**Goal:** use the fast **local LAN** address at home and the **Tailscale** address when away —
automatically, based on the connected WiFi network — without hosting anything.

**Per-instance data model** (extends the instance model in §5):
- `localBaseUrl` — optional LAN URL, e.g. `http://192.168.1.10:7878`.
- `remoteBaseUrl` — optional Tailscale MagicDNS URL, e.g. `http://nas.tailnet-xxxx.ts.net:7878`.
- `homeSsids` — one or more SSIDs treated as "home" (stored once at app level, reused by all
  instances; per-instance override allowed).
- `endpointMode` — `auto` (default) | `forceLocal` | `forceRemote` (manual override).

**Resolution logic** (`EndpointResolver` in `core/network`):
1. If `endpointMode` is forced → use that URL.
2. Else read the current SSID (via `network_info_plus`). If it matches a `homeSsids` entry →
   `localBaseUrl`; otherwise → `remoteBaseUrl`.
3. **Fallbacks (robustness):** if the chosen URL is missing, use the other. If SSID is
   unavailable (no permission / not on WiFi / desktop) → default to `remoteBaseUrl` (Tailscale
   works from anywhere), and surface a one-tap "Use local" override. Optionally, on a failed
   request to the selected endpoint, retry the alternate once before erroring.
4. Recompute on `connectivity_plus` network-change events; Dio `baseUrl` is derived from the
   resolver, never hardcoded per request.

**Permissions (must handle gracefully):**
- **Android:** reading SSID needs location permission (`ACCESS_FINE_LOCATION`) and location
  services enabled (OS constraint); on Android 13+ prefer `NEARBY_WIFI_DEVICES` where available.
- **iOS:** SSID via `CNCopyCurrentNetworkInfo`/`NEHotspotNetwork` needs the Location entitlement
  and When-In-Use location permission.
- If permission is denied, the app must **degrade to manual override** (never break connectivity)
  and clearly explain why SSID auto-switch is unavailable.

**UX:** a small endpoint indicator (Local / Remote) in the app bar, tappable to override for the
session; settings screen to define home SSID(s) and per-instance local/remote URLs, with a
**Test connection** button for *each* endpoint independently.

**Testing:** unit-test `EndpointResolver` across the matrix — home SSID vs away, forced modes,
missing URL fallbacks, SSID-unavailable path — with a mocked SSID/connectivity source.

## 7. Feature Scope (v1)

**Onboarding & Settings**
- Add service instance: pick type → enter name, **local URL** and/or **Tailscale URL**, API key
  (or user/pass for qBittorrent & Uptime Kuma) → **Test connection** (per endpoint) → save
  (secret in secure storage). Multiple instances per type; mark a default.
- **Home network setting:** define home WiFi SSID(s) and default endpoint mode (auto/local/remote)
  used by the network-aware switch (§6a); request SSID permission with a clear rationale, degrade
  to manual override if denied.
- Import/export configuration (JSON; **secrets excluded** from plaintext export or encrypted).
- Theme setting: System / Light / Dark.

**Dashboard**
- Tiles per configured service showing health + a headline stat (queue count, wanted count,
  monitors up/down).
- Aggregate "Activity" strip: combined download queue across Radarr/Sonarr/qBittorrent.

**Radarr / Sonarr (Library)**
- Poster grid of monitored items; filter/sort; search within library.
- Detail: artwork, overview, files/episodes, monitored toggle, quality profile, "Search" (trigger).
- **Add new:** search lookup → choose root folder + quality profile + monitor options → add.
- Calendar (upcoming/airing). Queue view with per-item progress.

**Bazarr (Subtitles)**
- Wanted subtitles (movies & episodes); trigger subtitle search; per-item language status.

**Prowlarr (Indexers)**
- Indexer list with health/enabled state; indexer stats; manual search across indexers.

**qBittorrent (Downloads)**
- Torrent list with state/progress/speed; pause/resume/delete (with "also delete files");
  add via magnet/URL; global transfer stats.

**Uptime Kuma (Uptime)**
- Monitor list with up/down status, uptime %, and latest ping; per-monitor heartbeat history;
  overall status summary tile on the dashboard.

**Seerr (Discover) — optional**
- Discover/trending movies & TV; search; request flow (season selection for TV); request status.

## 8. Design System
- **Material 3**, adaptive light/dark via `ColorScheme.fromSeed` + hand-tuned surfaces.
- **Per-service accent** used in that service's screens/badges:
  Sonarr `#35C5F0` (sky), Radarr `#FFC230` (amber), Bazarr `#BE4BDB` (purple),
  Prowlarr `#E66000` (orange), qBittorrent `#2F67BA` (blue), Uptime Kuma `#5CDD8B` (green),
  Seerr `#6366F1` (indigo). *(Tune to brand; keep semantic — accent = which service you're in.)*
- Poster-forward cards, generous imagery, clear status chips (Monitored/Missing/Downloading/Up/Down).
- Design tokens (spacing, radius, durations, elevation) centralized in `app/theme/`.
- Motion on compositor-friendly properties only; respect reduced-motion.
- Accessibility: WCAG AA contrast in both themes; semantic labels; keyboard/focus order on desktop.

## 9. Testing Strategy (target ≥ 80% on logic layers)
- **Unit:** every service client/repository — JSON parsing (freezed `fromJson`), request
  building (headers/paths), and error mapping — using `http_mock_adapter`/`mocktail`.
- **Provider tests:** Riverpod providers with overridden repositories.
- **Widget tests:** key screens (add-service form validation, library grid states:
  loading/empty/error/data, download controls, monitor list).
- **Integration (`integration_test`):** onboarding → dashboard happy path against mocked clients.
- **TDD:** write failing tests first for each repository method (RED → GREEN → refactor).

## 10. Build Roadmap (phased backlog)

Each phase is a self-contained, shippable unit with a **Definition of Done (DoD)**: code +
tests passing + `flutter analyze` clean + reviewed. Check off `[x]` as completed. Subagents
pick up the **first unchecked phase** (see §11).

- [x] **Phase 0 — Mockups first (gate).** Produce an interactive HTML/Flutter mockup of the
      core screens (onboarding with **dual local/Tailscale URLs + home-SSID setting**, dashboard
      with **Local/Remote endpoint indicator**, Radarr/Sonarr library + detail + add, downloads,
      uptime) in **both themes**. **User reviews and approves before any production coding.**
      *(Do not start Phase 2+ until approved.)* ✅ Approved 2026-08-16 — 11 screens,
      `mockups/phase0.html`, both themes.
- [x] **Phase 1 — Project scaffold.** `flutter create` (org `com.<you>.arrstack`), add packages
      (§4), analysis_options, folder skeleton (§5), theme tokens + light/dark, `go_router` shell
      with bottom nav, `build_runner` wiring. DoD: app boots to an empty dashboard on both
      platforms; `flutter analyze` clean.
      ✅ Done 2026-08-16. App ID **`dev.hraman.arrstack`** (org `dev.hraman`, project `arrstack`),
      iOS+Android. Brand seed teal `#0E9E92`. 5-tab `StatefulShellRoute` shell (Dashboard/Library/
      Downloads/Uptime/Settings); Dashboard shows real empty state, rest are `ComingSoonPage`.
      Convention set for all future modules: **`package:arrstack/...` imports only**
      (`always_use_package_imports` lint on); design tokens (`AppSpacing/AppRadius/AppSizes/...`)
      + `ServiceAccents` in `lib/app/theme/`; codegen proven via `AppThemeMode` (`@Riverpod(keepAlive:true)`).
      **freezed pinned exactly to `4.0.0-dev.3`** — stable 3.x needs analyzer <11 but
      build_runner/riverpod_generator need analyzer ^13, so no all-stable combo resolves on Dart
      3.13/Flutter 3.47; revisit when freezed 4.x ships stable. analyze clean, 2/2 tests, reviewed
      (0 CRITICAL/HIGH; 3 MEDIUM + 2 LOW all fixed).
- [x] **Phase 2 — Core plumbing.** `core/network` Dio factory + `X-Api-Key` interceptor + `Result`
      + `AppError`; **`EndpointResolver` + connectivity/SSID source (§6a)** driving Dio's baseUrl;
      `core/storage` SecureStore + ConfigStore; instance model (local+remote URLs, homeSsids,
      endpointMode) & repository. Tests (incl. resolver matrix).
      ✅ Done 2026-08-16. `Result<T>` (Ok/Err) + sealed `AppError` (7 variants) + `mapDioException`;
      interceptors: `ApiKeyInterceptor`, error-mapping, `RedactingLogInterceptor` (redacts key/
      auth/cookie headers + secret query params — tested that the raw key never appears in logs).
      **`EndpointResolver` verified correct against the full §6a matrix** (pure fn; `SsidSource`/
      `ConnectivitySource` abstracted for tests). `ServiceInstance`/`ServiceCredential` (secret union
      lives ONLY in SecureStore) / `ServiceIdentity` freezed models + boundary validation. Corrupt/
      legacy stored JSON degrades to `Err`/`null`, never throws across the boundary. Providers:
      `configStore/secureStore/instanceRepository/instances/homeSsids/defaultEndpointMode`. Seed
      contract `ConnectionTestClient` in `services/contracts/`. 94 tests, analyze clean, reviewed
      (0 CRITICAL; 2 HIGH corrupt-JSON crash paths **fixed** + regression-tested; secret-safety +
      resolver confirmed clean).
      **Deferred to Phase 4 (do these FIRST, in `core/`, so all service modules mirror one pattern):**
      (a) a `dioForInstance(instanceId)` / `resolvedBaseUrlProvider` composition wiring
      EndpointResolver + `currentSsidProvider` + `homeSsidsProvider` + DioFactory + SecureStore into
      ONE place — never hand-build a baseUrl in a service repo (§11 guardrail). (b) Harden
      `SecureStore.writeCredential`/`ConfigStore` write failures (Keychain/pref errors) into `AppError`
      rather than letting them throw. (c) LOW: in `InstanceRepository`, replace `as Ok<..>` casts with
      `case Ok(:final value)` destructuring; set `needsManualOverride` when a *forced* endpoint mode
      falls back to the other URL.
- [x] **Phase 3 — Onboarding & Settings.** Add/edit/delete instances, per-type forms with **dual
      URL + per-endpoint Test connection**, **home SSID setting** + permission flow + endpoint
      override UI, default selection, theme setting. Tests (form validation + storage + resolver UX).
      ✅ Done 2026-08-16. `AddInstancePage` + `InstanceForm` (dual URL, per-endpoint testing with
      Stub client); `SettingsPage` with Instance CRUD, Home SSID management (auto-detect via
      `SsidSource`), and Theme selection (persisted to `ConfigStore`). `EndpointIndicator` in
      Dashboard AppBar with session override. `InstanceRepository` hardened with pattern
      matching and `StorageError` handling. `dioForInstance` provider composition wired.
      20 logic tests passing.
- [x] **Phase 4 — Radarr module.** Client + repo + models + providers + Library grid/detail/add/
      queue/calendar UI. Full test suite. (This is the **reference module**; later services mirror it.)
      ✅ Done 2026-08-16. `RadarrClient` + `RadarrRepository` + `RadarrMovie` (lookup-safe) models.
      Library UI with `MovieGrid`, `MovieDetailPage` (monitored-toggle/delete actions), and
      `AddMoviePage` (search lookup + options sheet for profile/folder). Establish
      `PosterCard` and `StatusChip` shared widgets. 100% logic coverage goal met.
- [x] **Phase 5 — Sonarr module.** Mirror Phase 4 for series/episodes/seasons.
      ✅ Done 2026-08-16. `SonarrClient` + `SonarrRepository` + `SonarrSeries` models.
      Library UI updated with `SeriesGrid`, `SeriesDetailPage` (Season/Episode expansion
      tiles), and `AddSeriesPage` (search lookup + options sheet). Implemented image
      debugging logs and robust URL resolution to address decoder errors.
- [x] **Phase 6 — qBittorrent module.** Cookie-session client, torrent list + controls + add. Tests.
      ✅ Done 2026-08-16. `QbitClient` with session/cookie interceptor + `QbitRepository`
      with automatic re-login. `DownloadsPage` UI with `TorrentTile` (progress, speed,
      pause/resume/delete) and `AddTorrentDialog` (magnet/URL). Established
      `FormatUtils` for data sizes and speeds.
- [x] **Phase 7 — Bazarr module.** Wanted subtitles + search. Tests.
      ✅ Done 2026-08-16. `BazarrClient` + `BazarrRepository` with lenient parsing.
      `SubtitlesPage` UI with filtering and search actions.
- [ ] **Phase 8 — Prowlarr module.** Indexer status/stats + manual search. Tests.
- [x] **Phase 9 — Uptime Kuma module.** Socket.io client + monitor list + heartbeat/status UI. Tests.
      *(Confirm auth flow against a real instance first — see §6.)*
      ✅ Done 2026-08-16. `KumaClient` with Socket.io (supports API Key and User/Pass) +
      `KumaRepository` with live heartbeat merging. `UptimePage` UI with `MonitorTile`
      (live status, uptime %, heartbeat history bar) and health summary header.
      Integrated with `InstanceForm` for auth-type switching.
- [x] **Phase 10 — Dashboard aggregation & polish.** Cross-service activity strip, health tiles,
      empty/error states, pull-to-refresh, a11y pass, screenshot/visual-regression check.
      ✅ Done 2026-08-16. Redesigned Dashboard with `ServiceHealthTile` (accented status)
      and `ActivityStrip` (unified Radarr/Sonarr/qBittorrent queue). Aggregation providers
      established for cross-instance health and activity monitoring. Material 3 surfaces
      finalized.
- [ ] **Phase 11 — Seerr module (optional).** Discovery + search + request flow. Tests.
- [ ] **Phase 12 — Release prep.** Icons/splash, app IDs, store metadata, build flavors, README.

**Post-v1 backlog:** Lidarr, SABnzbd/NZBGet, Deluge, Tautulli (each = one new `services/<name>/`
plugin + a module screen; no core changes).

---

## 11. Subagent Build Protocol

> **Purpose:** let Haiku/Sonnet subagents build this app incrementally and periodically —
> one phase (or one service module) per run — with consistent quality. Follow this exactly.

### Model routing
- **Sonnet** — scaffolding (Phase 1), core plumbing (Phase 2), the **reference Radarr module**
  (Phase 4), the **Uptime Kuma socket module** (Phase 9), cross-cutting/architecture, and any
  phase touching shared contracts or `core/`.
- **Haiku** — the repetitive service modules that **mirror the Radarr reference pattern**
  (Sonarr, qBittorrent, Bazarr, Prowlarr internals; Seerr), test scaffolding, and mechanical
  boilerplate. Escalate to Sonnet if a module diverges materially from the reference.
- **Review/verify** — after each phase, run a review pass with the `flutter-reviewer` agent and
  the `tdd-guide` discipline; fix CRITICAL/HIGH before marking the phase done.

### Standing loop (run each time)
1. **Select work:** open the **first unchecked phase** in §10. Do not skip ahead. If Phase 0
   (mockups) is unchecked, **stop and produce mockups for user review — no production code yet.**
2. **Plan the slice:** list the files to add/change for this phase only. Keep files < 400 lines.
3. **TDD:** write failing unit tests first (RED) for the phase's repositories/logic → implement
   (GREEN) → refactor. Add widget/integration tests where the phase includes UI.
4. **Follow the reference:** for any service module, copy the structure of `services/radarr/`
   and `features/library/` exactly — same layering (client → repo → providers → UI), same
   `Result`/error handling, same test shape. Consistency over cleverness.
5. **Validate:** `flutter analyze` clean, `flutter test` green, `dart format` applied,
   `build_runner` regenerated if models/providers changed.
6. **Review:** run `flutter-reviewer`; address CRITICAL/HIGH.
7. **Record:** check off the phase in §10, note anything deferred, and **commit** with a
   conventional message (`feat(radarr): library grid + detail`, `test(core): dio interceptor`).
   One phase ≈ one focused commit/PR.
8. **Stop** after one phase unless told to continue. This spec is the memory between runs.

### Guardrails (hard rules)
- **Never** commit secrets; API keys/passwords live only in `flutter_secure_storage`, never in
  code, logs, or plaintext export. Redact keys/URLs in any logging interceptor.
- **Immutable** data only (freezed); no mutation of existing objects.
- **Validate** every external response at the boundary; map failures to `AppError` with a
  user-friendly message — never swallow errors silently.
- Respect the **contracts** in `services/contracts/`; don't fork per-service architectures.
- **Never** derive a Dio `baseUrl` by hand in a repository — always go through `EndpointResolver`
  (§6a). If SSID permission is denied, **degrade to manual override**; never break connectivity.
- Do **not** advance past the **Phase 0 mockup gate** without explicit user approval.
- Ask the user (don't guess) on: final app id/brand, exact accent palette, and any auth quirk
  discovered against a real server (especially qBittorrent sessions and Uptime Kuma sockets).

### Definition of Done (every phase)
`code + tests (RED→GREEN) + analyze clean + format + reviewed (no CRITICAL/HIGH) + phase
checked off + committed`.

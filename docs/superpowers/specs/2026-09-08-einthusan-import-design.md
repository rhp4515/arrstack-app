# Einthusan Import — Design

## Problem

Add a client for the einthusan-downloader API
(`/Users/hraman/Documents/projects/code/einthusan-downloader`, spec at
`docs/openapi.json`) as a new service inside arrstack-app. The only user
input is an Einthusan movie page URL; the app must visualize the TMDB-match
step and the download/import progress by polling the job until it is
imported into Radarr, then offer a link into the Radarr library entry.

## Upstream API (reference)

Base path `/api/v1`, auth via `X-Api-Key` header (matches this app's
existing `ApiKeyInterceptor` convention exactly).

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | connection test |
| POST | `/movies` | body `{url}` → creates a job (202), state `resolving` |
| GET | `/jobs/{id}` | poll job state |
| PATCH | `/jobs/{id}` | body `{tmdb_id}` → change selected TMDB candidate |
| POST | `/jobs/{id}/download` | confirm match → starts download+import |
| DELETE | `/jobs/{id}` | cancel/cleanup |

Job state machine: `resolving` → `resolve_failed` | `awaiting_verification`
→ `downloading` → `importing` → `done` | `error`. `progress` is populated
only while `downloading`/`importing`. `result` (on `done`) carries `file`,
`radarr_movie_id`, `tmdb_id`.

Jobs are in-memory/ephemeral on the server (no persistence across API
restarts) — the UI does not attempt to persist job state across app
restarts either.

## Approach

Follow the existing `services/<name>/` plugin pattern (see `radarr`,
`seerr`) and the existing `ServiceInstance`/onboarding infrastructure,
rather than inventing new config/storage:

1. **New `ServiceType.einthusan`** (displayName "Einthusan Downloader",
   defaultPort 8503, `AuthType.apiKey`). This is a drop-in addition to the
   existing enum switch statements (`displayName`, `defaultPort`,
   `defaultAuthType`) — no other core changes needed. It automatically
   gets onboarding (add/edit instance, local+remote URL, API key entry,
   "Test connection" via `GET /health`), secure credential storage, and
   `X-Api-Key` injection via the existing `ApiKeyInterceptor` (already the
   default for every type except qBittorrent/Uptime Kuma).

2. **New service plugin** `lib/services/einthusan/`:
   - `models/einthusan_models.dart` — freezed `EinthusanJob`, `TmdbCandidate`,
     `JobProgress`, `JobResult`, `JobError`, and a `JobState` enum
     (`resolving`, `resolveFailed`, `awaitingVerification`, `downloading`,
     `importing`, `done`, `error`) with `@JsonValue` snake_case mapping.
   - `einthusan_client.dart` — implements `ConnectionTestClient`
     (`testConnection` → `GET /health`) plus `createJob`, `getJob`,
     `patchJob`, `startDownload`, `deleteJob`.
   - `einthusan_repository.dart` — thin pass-through, matching
     `RadarrRepository`'s shape.
   - `einthusan_providers.dart` — `einthusanRepositoryProvider(instanceId)`
     wiring the per-instance `Dio` (via `dioForInstanceProvider`), same as
     every other service.
   - `einthusan.dart` barrel export.

3. **New feature** `lib/features/einthusan_import/`:
   - Reached as a nested route under Dashboard (like Bazarr/Prowlarr today):
     `RoutePaths.einthusanImport(instanceId)` =
     `/dashboard/einthusan/:instanceId`, opened by tapping the instance
     tile in `DashboardPage._InstanceListTile`. No new bottom-nav tab —
     this is a one-shot tool, not a browsable surface, matching the
     existing pattern for single-purpose service screens.
   - `einthusan_import_providers.dart` — a plain `@riverpod` notifier
     class `EinthusanImportController` (family on `instanceId`), holding a
     freezed `EinthusanImportState` (`job`, `isSubmitting`,
     `lastError`), mirroring the shape of `InstanceFormProvider`
     (manual state fields, not `AsyncNotifier`, since actions need
     independent in-flight flags rather than one Future-driven state).
     Responsibilities:
     - `submitUrl(url)` → `POST /movies`, store job, start polling.
     - `selectCandidate(tmdbId)` → local selection only (no API call
       until confirm, to match the reference client's "only PATCH if the
       choice changed" behavior).
     - `confirmDownload()` → PATCH (if selection changed) then
       `POST /download`, resume polling.
     - `cancel()` → `DELETE /jobs/{id}`, stop polling, reset to input step.
     - `reset()` → clear state for "import another movie".
     - Internal `Timer.periodic` (~2s) calls `GET /jobs/{id}` while
       `job.state` is non-terminal; cancelled in `ref.onDispose` and on
       reaching a terminal state (`done`, `error`, `resolveFailed`).
   - `einthusan_import_page.dart` — `ConsumerWidget`, switches on
     controller state to render one step widget:
     - **Input** — URL text field + "Fetch details" button.
     - **Resolving** — spinner, "Fetching page and searching TMDB…".
     - **Preview** (`awaiting_verification`) — radio list of TMDB
       candidates (poster, title, year, "View on TMDB" link via
       `url_launcher`, already a dependency), "Confirm and download" /
       "Cancel" actions.
     - **Running** (`downloading`/`importing`) — linear progress bar when
       `progress.totalBytes > 0` (MB/MB, speed), indeterminate spinner
       otherwise.
     - **Done** — success message with imported filename, and a
       **"View in Radarr library"** button.
     - **Error** (`error`/`resolve_failed`, or a client-side failure in
       `lastError`) — message + "Start over".

4. **Radarr deep link**: the job result has `radarr_movie_id` but not which
   configured Radarr *instance* that belongs to (the downloader's own
   server-side config decides that, opaque to this app). Resolve it to the
   app's currently-selected/default Radarr instance via the existing
   `selectedLibraryInstanceIdProvider(ServiceType.radarr)` (same provider
   `LibraryPage` already uses) and navigate with
   `context.go(RoutePaths.movieDetail(radarrInstanceId, radarrMovieId))` —
   landing directly on the existing in-app Radarr movie detail screen. If
   no Radarr instance is configured, the button is omitted and only the
   filename is shown.

## Error handling

- Network/auth/server errors from any call surface through the existing
  `Result<T>`/`AppError` types (`guardDioCall`/`dioCall`), rendered via
  `error.userMessage` — no new error taxonomy needed.
- A poll that returns `Err` stops the timer and surfaces the error as a
  terminal state (same visual treatment as a job-reported `error` state),
  rather than silently retrying forever.

## Testing

- Unit tests for `EinthusanClient` (request shaping, response mapping,
  error mapping) using a mock `Dio` adapter, matching existing
  `radarr_client_test.dart`-style coverage.
- Unit tests for `EinthusanImportController` covering each state
  transition (submit → resolving → preview → confirm → running → done;
  cancel from preview; error surfaces at each step) using `fake_async` for
  the polling timer.
- Widget tests for each step view rendering the right content for a given
  state.

## Out of scope (YAGNI)

- No job list/history UI (`GET /jobs` is unused) — only the single active
  job the user just started.
- No persistence of job id across app restarts (matches the ephemeral
  server-side job store).
- No option to link to a non-default Radarr instance — single/default
  instance covers the expected usage; can be revisited if requested.

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
| GET | `/jobs` | every job the service holds, oldest first (array of the job shape below) |
| GET | `/jobs/{id}` | one job's state |
| PATCH | `/jobs/{id}` | body `{tmdb_id}` → change selected TMDB candidate |
| POST | `/jobs/{id}/download` | confirm match → starts download+import |
| DELETE | `/jobs/{id}` | cancel a running job / remove a finished one (404 if unknown) |

Job state machine: `resolving` → `resolve_failed` | `awaiting_verification`
→ `downloading` → `importing` → `done` | `error`. `progress` is populated
only while `downloading`/`importing`. `result` (on `done`) carries `file`,
`radarr_movie_id`, `tmdb_id`.

Jobs are in-memory on the server: they stay until `DELETE /jobs/{id}` or an
API restart, which loses all of them (`GET /jobs/{id}` then answers 404
`job_not_found`). A job carries no timestamps. The app therefore keeps its
own history of the jobs it has seen — see "Job list and history" below.

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
     (`testConnection` → `GET /health`) plus `createJob`, `listJobs`,
     `getJob`, `patchJob`, `startDownload`, `deleteJob`.
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
   - `einthusan_import_providers.dart` — a plain
     `@Riverpod(keepAlive: true)` notifier class `EinthusanImportController`
     (family on `instanceId`), holding a freezed `EinthusanImportState`
     (`jobs`, `activeJobId`, `selectedTmdbId`, `isSubmitting`, `lastError`,
     `serverUnreachable`), mirroring the shape of `InstanceFormProvider`
     (manual state fields, not `AsyncNotifier`, since actions need
     independent in-flight flags rather than one Future-driven state).
     Responsibilities:
     - `submitUrl(url)` → `POST /movies`, track the job and make it active,
       start polling.
     - `selectCandidate(tmdbId)` → local selection only (no API call
       until confirm, to match the reference client's "only PATCH if the
       choice changed" behavior).
     - `confirmDownload()` → PATCH (if selection changed) then
       `POST /download`, resume polling.
     - `cancel()` → `DELETE /jobs/{id}` for the active job, drop it from
       the list, return to the input step.
     - `reset()` → leave the active job's step for the input step and list
       ("Import another movie" / "Start over"); the job stays listed.
     - `openJob(id)` / `dismiss(id)` → see "Job list and history".
     - Internal `Timer.periodic` (~2s) calls `GET /jobs` while any tracked
       job is in progress; cancelled in `ref.onDispose` and once nothing is
       in progress (every job `done`, `error`, `resolveFailed` or lost).
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
     - **Status unknown** (a lost job) — see "Job list and history".

   With no active job the page shows the input step and, below it, the
   **Recent imports** list.

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
- A listing that returns `Err` (at startup or while polling) keeps the jobs
  last known and sets `serverUnreachable`, shown as "Can't reach the
  downloader — showing last known status". Polling carries on at the same
  interval while a job is in progress, so the page recovers by itself and
  the notice clears on the next successful listing. Errors from the user's
  own actions (submit, confirm) still surface through `lastError`.

## Job list and history

The controller is kept alive, so leaving the page neither stops polling nor
forgets the jobs, and "Import another movie" / "Start over" only return to
the input step: every job started stays in the list until dismissed.

**History store.** `einthusan_job_history_store.dart` saves an
`EinthusanJobRecord` per job (id, URL, TMDB title/year once known, state,
Radarr movie id and file for a finished job, error message, created and
updated times) as a JSON list under `einthusan.jobs.<instanceId>` in
`AppPreferences`, newest first, capped at 25. It follows
`LibraryInstanceStore`: every read and write swallows failures, and
malformed data reads as an empty history. Records are written on submit, on
confirming a candidate (which records the chosen title/year) and whenever a
job's state or outcome changes — not on every progress tick.

**Startup and merge.** On first use the controller loads the history, then
calls `GET /jobs` once and merges:

- the downloader is authoritative for every job it lists; jobs it lists that
  the history lacks are added (titled from their selected candidate, else
  shown by URL);
- a recorded job that was still in progress but is no longer listed is
  marked **lost** — the downloader restarted and its outcome is unknown;
- a recorded job that had finished and is no longer listed keeps its
  recorded outcome;
- if the listing fails, the recorded jobs are shown as they were.

After a cold start the page shows the input step and the list; an opened
job is only remembered within the session. A job that disappears from a
poll while in progress is marked lost the same way.

**List.** Rows, newest first, show the title (and year) or the URL, a state
label (Resolving / Needs confirmation / Downloading 42% / Importing /
Imported / Failed / Status unknown), a progress bar while downloading, the
error message for a failure, and for a lost job "The downloader restarted,
so this job's status is unknown. Check Radarr." Tapping a row (`openJob`)
shows the usual step for that job; the app bar back arrow and system back
return to the list. Finished rows offer "View in Radarr library". Finished,
failed and lost rows have a dismiss button (`dismiss`), which asks the
downloader to delete the job (any failure, such as a 404, is ignored) and
removes it from the list and history.

## Testing

- Unit tests for `EinthusanClient` (request shaping, response mapping,
  error mapping) using a mock `Dio` adapter, matching existing
  `radarr_client_test.dart`-style coverage.
- Unit tests for `EinthusanImportController` covering each state
  transition (submit → resolving → preview → confirm → running → done;
  cancel from preview; error surfaces at each step) and the job list
  (restore, history/listing merge, lost detection, dismiss, unreachable
  downloader) using `fake_async` for the polling timer.
- Unit tests for the history store (round trip, cap, malformed data).
- Widget tests for each step view rendering the right content for a given
  state, and for the Recent imports list.

## Out of scope (YAGNI)

- No history beyond the 25 most recent jobs per instance, and no
  timestamps in the list (the downloader provides none).
- No remembering which job was open across an app restart.
- No option to link to a non-default Radarr instance — single/default
  instance covers the expected usage; can be revisited if requested.

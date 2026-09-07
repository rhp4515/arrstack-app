# Interactive Release Search Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let the user trigger an interactive indexer search from a specific Sonarr episode or Radarr movie, browse the returned releases sorted by peers/size/age/quality with indexer + rejection detail, and grab a chosen release by hand.

**Architecture:** Approach C (hybrid). Per-service `SonarrRelease` / `RadarrRelease` freezed models + release methods on each existing client, mapped to a shared `ReleaseCandidate` view-model at the repository boundary. One shared `lib/features/release_search/` module (providers, page, tile, detail sheet) drives the UI for both services.

**Tech Stack:** Flutter 3.47.0, Dart 3.13; `dio` for HTTP; `freezed` + `json_serializable` for models; `riverpod` / `riverpod_annotation` (`@riverpod`) for state; `go_router` for navigation; `flutter_test` + `http_mock_adapter` + `ProviderContainer` for tests.

**Spec:** `docs/superpowers/specs/2026-09-07-interactive-release-search-design.md`

## Global Constraints

- Flutter SDK **3.47.0** (stable), Dart `^3.13.0`. Java 17 for Android.
- `flutter analyze` must report **zero issues** (CI gate `Analyze & test`). No `info`-level lints left behind — wrap single-line `if` bodies in braces (`curly_braces_in_flow_control_structures`).
- `dart format` clean: 80-column, trailing commas on multi-line argument/parameter lists.
- Generated sources are committed. After editing any `@freezed` or `@riverpod` file, run `dart run build_runner build --delete-conflicting-outputs` and commit the regenerated `*.freezed.dart` / `*.g.dart`.
- **Immutability:** never mutate inputs. `applySort` returns a new list.
- Every fallible operation in `core`/`services` returns `Result<T>` (`Ok` / `Err`), never throws across a layer boundary.
- `package:` imports only (no relative `../`), ordered `dart:` → external `package:` → internal `package:arrstack/...`.
- **Per-service models even when identical** — do not introduce a shared `Release` model in `lib/services/`. The shared type (`ReleaseCandidate`) lives in `lib/features/release_search/models/`.
- Tests: AAA structure, behavior-focused names. Target ≥ 80% line coverage on new non-widget code (models, mappers, `applySort`, clients, repos, providers).
- Branch: `feat/interactive-release-search`. Conventional commit messages (`feat:`, `test:`, `refactor:`). End every commit body with:

  ```
  Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
  Claude-Session: https://claude.ai/code/session_01KioRrF1e6tSGYY2b2W921s
  ```

- `main` is branch-protected (PR + `Analyze & test` check). All work lands via PR from `feat/interactive-release-search`.

## File Structure

**New / modified source files:**

| File | Responsibility |
|------|----------------|
| `lib/services/sonarr/models/sonarr_models.dart` *(modify)* | add `SonarrRelease` + `_rejectionsFromJson` |
| `lib/services/radarr/models/radarr_models.dart` *(modify)* | add `RadarrRelease` + `_rejectionsFromJson` |
| `lib/features/release_search/models/release_candidate.dart` *(new)* | `ReleaseCandidate` view-model, `ReleaseProtocol` enum, `fromSonarr` / `fromRadarr` mappers |
| `lib/features/release_search/release_sort.dart` *(new)* | `ReleaseSort` enum + pure `applySort` |
| `lib/features/release_search/release_search_providers.dart` (+ `.g.dart`) *(new)* | `releaseSearchResults` family provider, `ReleaseSortController` notifier |
| `lib/features/release_search/release_search_page.dart` *(new)* | the screen: app bar, sort control, list/loading/error/empty states |
| `lib/features/release_search/widgets/release_tile.dart` *(new)* | one release row; opens the detail sheet on tap |
| `lib/features/release_search/widgets/release_detail_sheet.dart` *(new)* | `showReleaseDetailSheet()` modal + grab flow |
| `lib/core/utils/format_utils.dart` *(modify)* | add `formatReleaseAge(int minutes)` |
| `lib/services/sonarr/sonarr_client.dart` *(modify)* | `searchEpisodeReleases`, `grabRelease` |
| `lib/services/radarr/radarr_client.dart` *(modify)* | `searchMovieReleases`, `grabRelease` |
| `lib/services/sonarr/sonarr_repository.dart` *(modify)* | `searchEpisodeReleases` → `Result<List<ReleaseCandidate>>`, `grabRelease` |
| `lib/services/radarr/radarr_repository.dart` *(modify)* | `searchMovieReleases` → `Result<List<ReleaseCandidate>>`, `grabRelease` |
| `lib/app/route_paths.dart` *(modify)* | `episodeReleaseSearch`, `movieReleaseSearch` |
| `lib/app/router.dart` *(modify)* | nested `search` `GoRoute`s |
| `lib/features/library/episode_detail_page.dart` *(modify)* | replace search stub with navigation |
| `lib/features/library/movie_detail_page.dart` *(modify)* | replace `'search'` stub with navigation |

**New test files** mirror the source tree under `test/`:
`test/services/sonarr/sonarr_release_test.dart`, `test/services/radarr/radarr_release_test.dart`, `test/features/release_search/release_candidate_test.dart`, `test/features/release_search/release_sort_test.dart`, `test/services/sonarr/sonarr_release_client_test.dart`, `test/services/radarr/radarr_release_client_test.dart`, `test/services/sonarr/sonarr_release_repository_test.dart`, `test/services/radarr/radarr_release_repository_test.dart`, `test/features/release_search/release_search_providers_test.dart`, `test/core/utils/format_utils_test.dart` *(create or extend)*, `test/features/release_search/release_detail_sheet_test.dart`, `test/features/release_search/release_tile_test.dart`, `test/features/release_search/release_search_page_test.dart`, `test/app/route_paths_test.dart`.

---

## Task 1: Release models (`SonarrRelease`, `RadarrRelease`)

**Files:**
- Modify: `lib/services/sonarr/models/sonarr_models.dart` (append new classes near the other quality `@freezed` types)
- Modify: `lib/services/radarr/models/radarr_models.dart`
- Test: `test/services/sonarr/sonarr_release_test.dart`, `test/services/radarr/radarr_release_test.dart`

**Interfaces:**
- Consumes: existing `SonarrQualityInfo` / `RadarrQualityInfo` freezed types; `package:freezed_annotation/freezed_annotation.dart` (already imported in both model files).
- Produces:
  - `SonarrRelease` — `@freezed`, fields: `String guid` (default `''`), `String title` (default `''`), `int size` (default `0`), `int indexerId` (default `0`), `String? indexer`, `int? seeders`, `int? leechers`, `String? protocol`, `SonarrQualityInfo? quality`, `int? qualityWeight`, `num? ageMinutes`, `bool rejected` (default `false`), `List<String> rejections` (`@JsonKey(fromJson: _rejectionsFromJson)`, default `const []`), `String? releaseGroup`, `bool downloadAllowed` (default `true`), `int? customFormatScore`. `factory SonarrRelease.fromJson(Map<String, dynamic>)`.
  - `RadarrRelease` — same field set; `quality` typed `RadarrQualityInfo?`; `factory RadarrRelease.fromJson(...)`.
  - `List<String> _rejectionsFromJson(dynamic raw)` — top-level private function in each models file.

- [ ] **Step 1: Write the failing tests**

`test/services/sonarr/sonarr_release_test.dart`:

```dart
// SonarrRelease parsing against a realistic /api/v3/release payload:
// torrent releases carry seeders/leechers; rejections may be plain strings
// (Sonarr v3) or {reason,type} objects (newer Sonarr). Both must land as
// List<String> so the UI can show them.

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> releaseJson() => {
    'guid': 'MyIndexer-98765',
    'title': 'Show.S01E01.1080p.WEB-DL.x264-GRP',
    'size': 2147483648,
    'indexerId': 3,
    'indexer': 'MyIndexer',
    'seeders': 42,
    'leechers': 3,
    'protocol': 'torrent',
    'quality': {
      'quality': {'id': 9, 'name': 'WEBDL-1080p', 'resolution': 1080},
      'revision': {'version': 1, 'real': 0},
    },
    'qualityWeight': 6,
    'ageMinutes': 342.6,
    'rejected': true,
    'rejections': ['Not a preferred protocol', 'Unknown quality'],
    'downloadAllowed': true,
    'releaseGroup': 'GRP',
    'customFormatScore': 0,
  };

  group('SonarrRelease.fromJson', () {
    test('parses a torrent release with seeders and quality', () {
      final r = SonarrRelease.fromJson(releaseJson());

      expect(r.guid, 'MyIndexer-98765');
      expect(r.title, 'Show.S01E01.1080p.WEB-DL.x264-GRP');
      expect(r.size, 2147483648);
      expect(r.indexerId, 3);
      expect(r.indexer, 'MyIndexer');
      expect(r.seeders, 42);
      expect(r.leechers, 3);
      expect(r.protocol, 'torrent');
      expect(r.quality?.quality?.name, 'WEBDL-1080p');
      expect(r.qualityWeight, 6);
      expect(r.ageMinutes, 342.6);
      expect(r.rejected, isTrue);
      expect(r.rejections, ['Not a preferred protocol', 'Unknown quality']);
      expect(r.downloadAllowed, isTrue);
      expect(r.releaseGroup, 'GRP');
    });

    test('normalises object-shaped rejections to a list of reason strings', () {
      final json = releaseJson()
        ..['rejections'] = [
          {'reason': 'Wrong quality', 'type': 'permanent'},
          {'reason': 'Release rejected by list', 'type': 'temporary'},
        ];

      final r = SonarrRelease.fromJson(json);

      expect(r.rejections, ['Wrong quality', 'Release rejected by list']);
    });

    test('applies defaults for a usenet release missing torrent fields', () {
      final json = <String, dynamic>{
        'guid': 'g',
        'title': 't',
        'size': 100,
        'indexerId': 1,
        'protocol': 'usenet',
      };

      final r = SonarrRelease.fromJson(json);

      expect(r.seeders, isNull);
      expect(r.leechers, isNull);
      expect(r.rejected, isFalse);
      expect(r.rejections, isEmpty);
      expect(r.downloadAllowed, isTrue);
    });
  });
}
```

`test/services/radarr/radarr_release_test.dart` — the same three tests, `RadarrRelease.fromJson`, importing `package:arrstack/services/radarr/models/radarr_models.dart` (identical payload shape).

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/services/sonarr/sonarr_release_test.dart test/services/radarr/radarr_release_test.dart`
Expected: FAIL — `SonarrRelease` / `RadarrRelease` are not defined.

- [ ] **Step 3: Add the models**

Append to `lib/services/sonarr/models/sonarr_models.dart` (after the existing `SonarrQuality` block, keeping it grouped with the quality types):

```dart
/// One release from Sonarr's interactive search (`GET /api/v3/release?episodeId=`).
@freezed
abstract class SonarrRelease with _$SonarrRelease {
  const factory SonarrRelease({
    @Default('') String guid,
    @Default('') String title,
    @Default(0) int size,
    @Default(0) int indexerId,
    String? indexer,
    int? seeders,
    int? leechers,
    String? protocol,
    SonarrQualityInfo? quality,
    int? qualityWeight,
    num? ageMinutes,
    @Default(false) bool rejected,
    @JsonKey(fromJson: _rejectionsFromJson)
    @Default(<String>[])
    List<String> rejections,
    String? releaseGroup,
    @Default(true) bool downloadAllowed,
    int? customFormatScore,
  }) = _SonarrRelease;

  factory SonarrRelease.fromJson(Map<String, dynamic> json) =>
      _$SonarrReleaseFromJson(json);
}

/// Sonarr v3 returns `rejections` as `List<String>`; newer Sonarr returns
/// `[{reason, type}]`. Normalise both to a list of reason strings.
List<String> _rejectionsFromJson(dynamic raw) {
  if (raw is! List) return const [];
  return raw.map((e) {
    if (e is String) return e;
    if (e is Map) return (e['reason'] ?? e).toString();
    return e.toString();
  }).toList();
}
```

Append the mirror to `lib/services/radarr/models/radarr_models.dart` (after `RadarrQuality`): class `RadarrRelease`, `SonarrQualityInfo` → `RadarrQualityInfo`, `_$SonarrReleaseFromJson` → `_$RadarrReleaseFromJson`, and its own copy of `_rejectionsFromJson` (private per file).

- [ ] **Step 4: Regenerate freezed/json code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: updates `sonarr_models.freezed.dart` / `.g.dart` and the Radarr equivalents with `_SonarrRelease` / `_RadarrRelease`.

- [ ] **Step 5: Run the tests to verify they pass**

Run: `flutter test test/services/sonarr/sonarr_release_test.dart test/services/radarr/radarr_release_test.dart`
Expected: PASS (6 tests).

- [ ] **Step 6: analyze + format**

Run: `flutter analyze` (expect no issues)
Run: `dart format lib/services/sonarr/models/sonarr_models.dart lib/services/radarr/models/radarr_models.dart test/services/sonarr/sonarr_release_test.dart test/services/radarr/radarr_release_test.dart`

- [ ] **Step 7: Commit**

```bash
git add lib/services/sonarr/models/ lib/services/radarr/models/ test/services/sonarr/sonarr_release_test.dart test/services/radarr/radarr_release_test.dart
git commit -m "feat: add SonarrRelease and RadarrRelease models

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01KioRrF1e6tSGYY2b2W921s"
```

(Every subsequent task's commit body ends with the same two-line footer; it is written as `$COMMIT_FOOTER` below to keep the plan readable.)

---

## Task 2: `ReleaseCandidate` view-model + mappers

**Files:**
- Create: `lib/features/release_search/models/release_candidate.dart`
- Test: `test/features/release_search/release_candidate_test.dart`

**Interfaces:**
- Consumes: `SonarrRelease`, `RadarrRelease` (Task 1); `package:meta/meta.dart` (`@immutable`).
- Produces:
  - `enum ReleaseProtocol { torrent, usenet, unknown }`
  - `class ReleaseCandidate` (`@immutable`, `const` constructor) with fields exactly:
    `String guid`, `int indexerId`, `String indexerName`, `String title`, `int sizeBytes`, `ReleaseProtocol protocol`, `String qualityLabel`, `int qualityWeight`, `int ageMinutes`, `bool isRejected`, `List<String> rejections`, `bool downloadAllowed`, `int? seeders`, `int? leechers`, `String? releaseGroup`, `int? customFormatScore`
  - getter `int get peersKey => seeders ?? -1;`
  - `factory ReleaseCandidate.fromSonarr(SonarrRelease r)`
  - `factory ReleaseCandidate.fromRadarr(RadarrRelease r)`

- [ ] **Step 1: Write the failing test**

`test/features/release_search/release_candidate_test.dart`:

```dart
// ReleaseCandidate flattens a SonarrRelease/RadarrRelease into the view-model
// the shared release_search UI renders. Protocol strings map to an enum,
// missing seeders means "peers unknown" (peersKey -1, sorts last), and a
// missing quality name falls back to an em dash.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReleaseCandidate.fromSonarr', () {
    test('maps a fully populated torrent release', () {
      final c = ReleaseCandidate.fromSonarr(
        const SonarrRelease(
          guid: 'g1',
          title: 'Show.S01E01.1080p.WEB-DL-GRP',
          size: 2000,
          indexerId: 7,
          indexer: 'MyIndexer',
          seeders: 30,
          leechers: 2,
          protocol: 'torrent',
          quality: SonarrQualityInfo(quality: SonarrQuality(name: 'WEBDL-1080p')),
          qualityWeight: 6,
          ageMinutes: 610.9,
          rejected: false,
          rejections: [],
          releaseGroup: 'GRP',
          downloadAllowed: true,
          customFormatScore: 15,
        ),
      );

      expect(c.guid, 'g1');
      expect(c.indexerId, 7);
      expect(c.indexerName, 'MyIndexer');
      expect(c.sizeBytes, 2000);
      expect(c.protocol, ReleaseProtocol.torrent);
      expect(c.qualityLabel, 'WEBDL-1080p');
      expect(c.qualityWeight, 6);
      expect(c.ageMinutes, 611); // rounded
      expect(c.seeders, 30);
      expect(c.peersKey, 30);
      expect(c.isRejected, isFalse);
      expect(c.releaseGroup, 'GRP');
      expect(c.customFormatScore, 15);
    });

    test('usenet release: protocol enum, null seeders, peersKey -1', () {
      final c = ReleaseCandidate.fromSonarr(
        const SonarrRelease(
          guid: 'g2',
          title: 't',
          size: 1,
          indexerId: 1,
          protocol: 'usenet',
          rejected: true,
          rejections: ['Unknown quality'],
          downloadAllowed: false,
        ),
      );

      expect(c.protocol, ReleaseProtocol.usenet);
      expect(c.seeders, isNull);
      expect(c.peersKey, -1);
      expect(c.qualityLabel, '—');
      expect(c.qualityWeight, 0);
      expect(c.ageMinutes, 0);
      expect(c.indexerName, 'Unknown indexer');
      expect(c.isRejected, isTrue);
      expect(c.rejections, ['Unknown quality']);
      expect(c.downloadAllowed, isFalse);
    });

    test('unrecognised protocol string maps to ReleaseProtocol.unknown', () {
      final c = ReleaseCandidate.fromSonarr(
        const SonarrRelease(guid: 'g', title: 't', indexerId: 1, protocol: null),
      );
      expect(c.protocol, ReleaseProtocol.unknown);
    });
  });

  group('ReleaseCandidate.fromRadarr', () {
    test('maps a Radarr movie release', () {
      final c = ReleaseCandidate.fromRadarr(
        const RadarrRelease(
          guid: 'm1',
          title: 'Movie.2024.2160p.BluRay-GRP',
          size: 50000,
          indexerId: 2,
          indexer: 'RadarrIndexer',
          seeders: 8,
          leechers: 1,
          protocol: 'torrent',
          quality: RadarrQualityInfo(quality: RadarrQuality(name: 'Bluray-2160p')),
          qualityWeight: 20,
          ageMinutes: 45,
        ),
      );

      expect(c.protocol, ReleaseProtocol.torrent);
      expect(c.qualityLabel, 'Bluray-2160p');
      expect(c.qualityWeight, 20);
      expect(c.ageMinutes, 45);
      expect(c.peersKey, 8);
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/release_search/release_candidate_test.dart`
Expected: FAIL — file/class not found.

- [ ] **Step 3: Create the view-model**

`lib/features/release_search/models/release_candidate.dart`:

```dart
/// Flattened, service-agnostic view of one interactive-search release. The
/// shared release_search UI renders only this type; `SonarrRepository` /
/// `RadarrRepository` map their raw releases into it.
library;

import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:meta/meta.dart';

/// Download protocol of a release. `unknown` covers a null or unexpected
/// `protocol` value from the API.
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

  /// e.g. `WEBDL-1080p`, or `—` when the API omitted a quality name.
  final String qualityLabel;

  /// Sonarr/Radarr `qualityWeight`; `0` when unknown. Sort key for Quality.
  final int qualityWeight;

  /// Release age in whole minutes; `0` when unknown. Sort key for Age.
  final int ageMinutes;

  final bool isRejected;
  final List<String> rejections;
  final bool downloadAllowed;
  final int? seeders;
  final int? leechers;
  final String? releaseGroup;
  final int? customFormatScore;

  /// Sort key for Peers (high→low): seeders, or `-1` when unknown so
  /// usenet / seeder-less releases sink to the bottom.
  int get peersKey => seeders ?? -1;

  factory ReleaseCandidate.fromSonarr(SonarrRelease r) => ReleaseCandidate(
    guid: r.guid,
    indexerId: r.indexerId,
    indexerName: (r.indexer == null || r.indexer!.isEmpty)
        ? 'Unknown indexer'
        : r.indexer!,
    title: r.title,
    sizeBytes: r.size,
    protocol: _protocol(r.protocol),
    qualityLabel: r.quality?.quality?.name ?? '—',
    qualityWeight: r.qualityWeight ?? 0,
    ageMinutes: (r.ageMinutes ?? 0).round(),
    isRejected: r.rejected,
    rejections: r.rejections,
    downloadAllowed: r.downloadAllowed,
    seeders: r.seeders,
    leechers: r.leechers,
    releaseGroup: r.releaseGroup,
    customFormatScore: r.customFormatScore,
  );

  factory ReleaseCandidate.fromRadarr(RadarrRelease r) => ReleaseCandidate(
    guid: r.guid,
    indexerId: r.indexerId,
    indexerName: (r.indexer == null || r.indexer!.isEmpty)
        ? 'Unknown indexer'
        : r.indexer!,
    title: r.title,
    sizeBytes: r.size,
    protocol: _protocol(r.protocol),
    qualityLabel: r.quality?.quality?.name ?? '—',
    qualityWeight: r.qualityWeight ?? 0,
    ageMinutes: (r.ageMinutes ?? 0).round(),
    isRejected: r.rejected,
    rejections: r.rejections,
    downloadAllowed: r.downloadAllowed,
    seeders: r.seeders,
    leechers: r.leechers,
    releaseGroup: r.releaseGroup,
    customFormatScore: r.customFormatScore,
  );

  static ReleaseProtocol _protocol(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'torrent':
        return ReleaseProtocol.torrent;
      case 'usenet':
        return ReleaseProtocol.usenet;
      default:
        return ReleaseProtocol.unknown;
    }
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/release_search/release_candidate_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 5: analyze + format**

Run: `flutter analyze` then `dart format lib/features/release_search/models/release_candidate.dart test/features/release_search/release_candidate_test.dart`

- [ ] **Step 6: Commit**

```bash
git add lib/features/release_search/models/ test/features/release_search/release_candidate_test.dart
git commit -m "feat: add ReleaseCandidate view-model and per-service mappers

$COMMIT_FOOTER"
```

---

## Task 3: `ReleaseSort` + `applySort`

**Files:**
- Create: `lib/features/release_search/release_sort.dart`
- Test: `test/features/release_search/release_sort_test.dart`

**Interfaces:**
- Consumes: `ReleaseCandidate` (Task 2).
- Produces:
  - `enum ReleaseSort { peers, size, age, quality }`
  - `List<ReleaseCandidate> applySort(List<ReleaseCandidate> items, ReleaseSort sort)` — pure, returns a new list, input untouched.

- [ ] **Step 1: Write the failing test**

`test/features/release_search/release_sort_test.dart`:

```dart
// applySort orders the interactive-search results. Peers is high→low with
// seeder-less releases last; Size is small→large (avoid the 40 GB remux
// when you wanted a 2 GB web-dl); Age is new→old; Quality is best→worst.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate rc({
  String guid = 'g',
  int? seeders,
  int size = 0,
  int ageMinutes = 0,
  int qualityWeight = 0,
}) => ReleaseCandidate(
  guid: guid,
  indexerId: 1,
  indexerName: 'ix',
  title: guid,
  sizeBytes: size,
  protocol: ReleaseProtocol.torrent,
  qualityLabel: 'q',
  qualityWeight: qualityWeight,
  ageMinutes: ageMinutes,
  isRejected: false,
  rejections: const [],
  downloadAllowed: true,
  seeders: seeders,
);

void main() {
  group('applySort', () {
    test('peers: descending, null seeders last', () {
      final out = applySort([
        rc(guid: 'a', seeders: 5),
        rc(guid: 'b', seeders: null),
        rc(guid: 'c', seeders: 50),
      ], ReleaseSort.peers);

      expect(out.map((r) => r.guid), ['c', 'a', 'b']);
    });

    test('size: ascending', () {
      final out = applySort([
        rc(guid: 'big', size: 40000),
        rc(guid: 'small', size: 2000),
        rc(guid: 'mid', size: 8000),
      ], ReleaseSort.size);

      expect(out.map((r) => r.guid), ['small', 'mid', 'big']);
    });

    test('age: ascending (newest first)', () {
      final out = applySort([
        rc(guid: 'old', ageMinutes: 9000),
        rc(guid: 'new', ageMinutes: 30),
      ], ReleaseSort.age);

      expect(out.map((r) => r.guid), ['new', 'old']);
    });

    test('quality: descending by weight', () {
      final out = applySort([
        rc(guid: 'sd', qualityWeight: 1),
        rc(guid: 'uhd', qualityWeight: 20),
        rc(guid: 'hd', qualityWeight: 8),
      ], ReleaseSort.quality);

      expect(out.map((r) => r.guid), ['uhd', 'hd', 'sd']);
    });

    test('does not mutate the input list', () {
      final input = [rc(guid: 'a', seeders: 1), rc(guid: 'b', seeders: 9)];
      applySort(input, ReleaseSort.peers);
      expect(input.map((r) => r.guid), ['a', 'b']);
    });

    test('empty list returns empty', () {
      expect(applySort(const [], ReleaseSort.peers), isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/release_search/release_sort_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Create the sort module**

`lib/features/release_search/release_sort.dart`:

```dart
/// Sort options for the interactive-search results list and the pure
/// function that applies them.
library;

import 'package:arrstack/features/release_search/models/release_candidate.dart';

/// Active sort for the release list. `peers` is the default.
enum ReleaseSort { peers, size, age, quality }

/// Returns a new list of [items] ordered by [sort]. [items] is not mutated.
///
/// - [ReleaseSort.peers]: seeders high→low; seeder-less releases (`peersKey`
///   `-1`) sink to the bottom.
/// - [ReleaseSort.size]: bytes small→large.
/// - [ReleaseSort.age]: age in minutes small→large (newest first).
/// - [ReleaseSort.quality]: `qualityWeight` high→low.
List<ReleaseCandidate> applySort(
  List<ReleaseCandidate> items,
  ReleaseSort sort,
) {
  final sorted = [...items];
  switch (sort) {
    case ReleaseSort.peers:
      sorted.sort((a, b) => b.peersKey.compareTo(a.peersKey));
    case ReleaseSort.size:
      sorted.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
    case ReleaseSort.age:
      sorted.sort((a, b) => a.ageMinutes.compareTo(b.ageMinutes));
    case ReleaseSort.quality:
      sorted.sort((a, b) => b.qualityWeight.compareTo(a.qualityWeight));
  }
  return sorted;
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/release_search/release_sort_test.dart`
Expected: PASS (6 tests).

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/features/release_search/release_sort.dart test/features/release_search/release_sort_test.dart
git add lib/features/release_search/release_sort.dart test/features/release_search/release_sort_test.dart
git commit -m "feat: add ReleaseSort and applySort for release results

$COMMIT_FOOTER"
```

---

## Task 4: Sonarr client — `searchEpisodeReleases`, `grabRelease`

**Files:**
- Modify: `lib/services/sonarr/sonarr_client.dart` (two methods on `SonarrClient`)
- Test: `test/services/sonarr/sonarr_release_client_test.dart`

**Interfaces:**
- Consumes: `SonarrRelease` (Task 1); existing `dioCall`, `Result`, `developer.log` patterns in this file; `Options` from the already-imported `package:dio/dio.dart`.
- Produces (methods on `SonarrClient`):
  - `Future<Result<List<SonarrRelease>>> searchEpisodeReleases(int episodeId)` — `GET api/v3/release?episodeId={id}`, per-request `Options(receiveTimeout: const Duration(seconds: 90))`; maps a JSON list to `SonarrRelease`, guarding each element with try/catch + `developer.log` + skip.
  - `Future<Result<void>> grabRelease({required String guid, required int indexerId})` — `POST api/v3/release` with body `{'guid': guid, 'indexerId': indexerId}`.

- [ ] **Step 1: Write the failing test**

`test/services/sonarr/sonarr_release_client_test.dart`:

```dart
// SonarrClient interactive-search calls. searchEpisodeReleases must survive
// a malformed release in the array (skip it, keep the rest) the same way
// getSeries does; grabRelease must POST exactly {guid, indexerId}.

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = SonarrClient(dio);
  });

  test('searchEpisodeReleases parses releases and skips a malformed entry',
      () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(200, [
        {
          'guid': 'ix-1',
          'title': 'Good.Release-GRP',
          'size': 1000,
          'indexerId': 2,
          'indexer': 'ix',
          'seeders': 10,
          'protocol': 'torrent',
          'rejections': [],
        },
        'not a map', // forces the per-element guard to skip
        {
          'guid': 'ix-2',
          'title': 'Another.Release-GRP',
          'size': 2000,
          'indexerId': 2,
          'protocol': 'usenet',
          'rejections': ['Unknown quality'],
        },
      ]),
      queryParameters: {'episodeId': 55},
    );

    final result = await client.searchEpisodeReleases(55);

    expect(result.isOk, isTrue);
    final list = result.valueOrNull!;
    expect(list.map((r) => r.guid), ['ix-1', 'ix-2']);
    expect(list.first.seeders, 10);
    expect(list.last.rejections, ['Unknown quality']);
  });

  test('searchEpisodeReleases maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(503, {'message': 'indexers unavailable'}),
      queryParameters: {'episodeId': 55},
    );

    final result = await client.searchEpisodeReleases(55);

    expect(result.isErr, isTrue);
    expect(result.errorOrNull, isA<AppError>());
  });

  test('grabRelease posts exactly {guid, indexerId} and maps 201 to Ok',
      () async {
    RequestOptions? captured;
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(201, {'guid': 'ix-1'}),
      data: {'guid': 'ix-1', 'indexerId': 2},
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    final result = await client.grabRelease(guid: 'ix-1', indexerId: 2);

    expect(result.isOk, isTrue);
    expect(captured!.data, {'guid': 'ix-1', 'indexerId': 2});
    expect(captured!.queryParameters, isEmpty);
  });

  test('grabRelease maps a 4xx to an Err', () async {
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(400, {'message': 'unknown release'}),
      data: {'guid': 'bad', 'indexerId': 1},
    );

    final result = await client.grabRelease(guid: 'bad', indexerId: 1);

    expect(result.isErr, isTrue);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/services/sonarr/sonarr_release_client_test.dart`
Expected: FAIL — `searchEpisodeReleases` / `grabRelease` not defined.

- [ ] **Step 3: Add the client methods**

Add to `SonarrClient` in `lib/services/sonarr/sonarr_client.dart` (after `getEpisodes`):

```dart
  /// Interactive search: query every indexer for releases matching
  /// [episodeId]. Slow (multi-indexer, synchronous) — uses a 90s receive
  /// timeout instead of the client default.
  Future<Result<List<SonarrRelease>>> searchEpisodeReleases(int episodeId) {
    return dioCall(
      () => _dio.get(
        'api/v3/release',
        queryParameters: {'episodeId': episodeId},
        options: Options(receiveTimeout: const Duration(seconds: 90)),
      ),
      map: (data) {
        if (data is! List) return <SonarrRelease>[];
        return data
            .map((json) {
              try {
                return SonarrRelease.fromJson(json as Map<String, dynamic>);
              } catch (e, st) {
                developer.log(
                  'SonarrRelease parse error: $e',
                  name: 'arrstack.sonarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<SonarrRelease>()
            .toList();
      },
    );
  }

  /// Send a chosen release to the download client.
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

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/services/sonarr/sonarr_release_client_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/services/sonarr/sonarr_client.dart test/services/sonarr/sonarr_release_client_test.dart
git add lib/services/sonarr/sonarr_client.dart test/services/sonarr/sonarr_release_client_test.dart
git commit -m "feat: add Sonarr interactive release search and grab client calls

$COMMIT_FOOTER"
```

---

## Task 5: Radarr client — `searchMovieReleases`, `grabRelease`

**Files:**
- Modify: `lib/services/radarr/radarr_client.dart`
- Test: `test/services/radarr/radarr_release_client_test.dart`

**Interfaces:**
- Consumes: `RadarrRelease` (Task 1).
- Produces (methods on `RadarrClient`):
  - `Future<Result<List<RadarrRelease>>> searchMovieReleases(int movieId)` — `GET api/v3/release?movieId={id}`, 90s receive timeout, per-element guard.
  - `Future<Result<void>> grabRelease({required String guid, required int indexerId})` — `POST api/v3/release` body `{'guid': guid, 'indexerId': indexerId}`.

- [ ] **Step 1: Write the failing test**

`test/services/radarr/radarr_release_client_test.dart`:

```dart
// RadarrClient interactive-search calls: searchMovieReleases skips a malformed
// entry; grabRelease posts exactly {guid, indexerId}.

import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late RadarrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = RadarrClient(dio);
  });

  test('searchMovieReleases parses releases and skips a malformed entry',
      () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(200, [
        {
          'guid': 'ix-1',
          'title': 'Movie.2024.1080p.WEB-DL-GRP',
          'size': 1000,
          'indexerId': 2,
          'indexer': 'ix',
          'seeders': 10,
          'protocol': 'torrent',
          'rejections': [],
        },
        'not a map',
        {
          'guid': 'ix-2',
          'title': 'Movie.2024.2160p.BluRay-GRP',
          'size': 2000,
          'indexerId': 2,
          'protocol': 'torrent',
          'rejections': ['Quality not wanted'],
        },
      ]),
      queryParameters: {'movieId': 55},
    );

    final result = await client.searchMovieReleases(55);

    expect(result.isOk, isTrue);
    expect(result.valueOrNull!.map((r) => r.guid), ['ix-1', 'ix-2']);
  });

  test('searchMovieReleases maps a 5xx to an Err', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(503, {'message': 'down'}),
      queryParameters: {'movieId': 55},
    );
    final result = await client.searchMovieReleases(55);
    expect(result.isErr, isTrue);
    expect(result.errorOrNull, isA<AppError>());
  });

  test('grabRelease posts exactly {guid, indexerId}', () async {
    RequestOptions? captured;
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(201, {'guid': 'ix-1'}),
      data: {'guid': 'ix-1', 'indexerId': 2},
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );

    final result = await client.grabRelease(guid: 'ix-1', indexerId: 2);

    expect(result.isOk, isTrue);
    expect(captured!.data, {'guid': 'ix-1', 'indexerId': 2});
  });

  test('grabRelease maps a 4xx to an Err', () async {
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(400, {'message': 'bad'}),
      data: {'guid': 'bad', 'indexerId': 1},
    );
    final result = await client.grabRelease(guid: 'bad', indexerId: 1);
    expect(result.isErr, isTrue);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/services/radarr/radarr_release_client_test.dart`
Expected: FAIL — methods not defined.

- [ ] **Step 3: Add the client methods**

Add to `RadarrClient` in `lib/services/radarr/radarr_client.dart` (near `lookupMovie`):

```dart
  /// Interactive search: query every indexer for releases matching
  /// [movieId]. Slow — uses a 90s receive timeout instead of the default.
  Future<Result<List<RadarrRelease>>> searchMovieReleases(int movieId) {
    return dioCall(
      () => _dio.get(
        'api/v3/release',
        queryParameters: {'movieId': movieId},
        options: Options(receiveTimeout: const Duration(seconds: 90)),
      ),
      map: (data) {
        if (data is! List) return <RadarrRelease>[];
        return data
            .map((json) {
              try {
                return RadarrRelease.fromJson(json as Map<String, dynamic>);
              } catch (e, st) {
                developer.log(
                  'RadarrRelease parse error: $e',
                  name: 'arrstack.radarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<RadarrRelease>()
            .toList();
      },
    );
  }

  /// Send a chosen release to the download client.
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

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/services/radarr/radarr_release_client_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/services/radarr/radarr_client.dart test/services/radarr/radarr_release_client_test.dart
git add lib/services/radarr/radarr_client.dart test/services/radarr/radarr_release_client_test.dart
git commit -m "feat: add Radarr interactive release search and grab client calls

$COMMIT_FOOTER"
```

---

## Task 6: Repository methods (Sonarr + Radarr)

**Files:**
- Modify: `lib/services/sonarr/sonarr_repository.dart`
- Modify: `lib/services/radarr/radarr_repository.dart`
- Test: `test/services/sonarr/sonarr_release_repository_test.dart`, `test/services/radarr/radarr_release_repository_test.dart`

**Interfaces:**
- Consumes: client methods (Tasks 4, 5); `ReleaseCandidate.fromSonarr` / `.fromRadarr` (Task 2); `Result.map`.
- Produces:
  - `SonarrRepository`: `Future<Result<List<ReleaseCandidate>>> searchEpisodeReleases(int episodeId)`; `Future<Result<void>> grabRelease({required String guid, required int indexerId})`
  - `RadarrRepository`: `Future<Result<List<ReleaseCandidate>>> searchMovieReleases(int movieId)`; `Future<Result<void>> grabRelease({required String guid, required int indexerId})`

- [ ] **Step 1: Write the failing test**

`test/services/sonarr/sonarr_release_repository_test.dart`:

```dart
// SonarrRepository.searchEpisodeReleases maps the raw SonarrRelease list into
// the shared ReleaseCandidate view-model. Exercised end-to-end through the
// real SonarrClient against a mocked Dio.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SonarrRepository repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = SonarrRepository(SonarrClient(dio));
  });

  test('searchEpisodeReleases returns mapped ReleaseCandidates', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(200, [
        {
          'guid': 'ix-1',
          'title': 'Show.S01E01-GRP',
          'size': 1234,
          'indexerId': 3,
          'indexer': 'ix',
          'seeders': 12,
          'leechers': 1,
          'protocol': 'torrent',
          'qualityWeight': 6,
          'quality': {'quality': {'name': 'WEBDL-1080p'}},
          'rejected': true,
          'rejections': [{'reason': 'Wrong quality', 'type': 'permanent'}],
        },
      ]),
      queryParameters: {'episodeId': 9},
    );

    final result = await repo.searchEpisodeReleases(9);

    expect(result.isOk, isTrue);
    final c = result.valueOrNull!.single;
    expect(c, isA<ReleaseCandidate>());
    expect(c.guid, 'ix-1');
    expect(c.indexerName, 'ix');
    expect(c.protocol, ReleaseProtocol.torrent);
    expect(c.qualityLabel, 'WEBDL-1080p');
    expect(c.isRejected, isTrue);
    expect(c.rejections, ['Wrong quality']);
  });

  test('searchEpisodeReleases propagates an Err from the client', () async {
    adapter.onGet(
      'api/v3/release',
      (server) => server.reply(500, {'message': 'boom'}),
      queryParameters: {'episodeId': 9},
    );

    final result = await repo.searchEpisodeReleases(9);

    expect(result.isErr, isTrue);
  });

  test('grabRelease delegates to the client', () async {
    adapter.onPost(
      'api/v3/release',
      (server) => server.reply(201, {}),
      data: {'guid': 'ix-1', 'indexerId': 3},
    );

    final result = await repo.grabRelease(guid: 'ix-1', indexerId: 3);

    expect(result.isOk, isTrue);
  });
}
```

`test/services/radarr/radarr_release_repository_test.dart` — the same, with `RadarrRepository(RadarrClient(dio))`, `repo.searchMovieReleases(9)`, `queryParameters: {'movieId': 9}`, import `package:arrstack/services/radarr/...`.

- [ ] **Step 2: Run the tests to verify they fail**

Run: `flutter test test/services/sonarr/sonarr_release_repository_test.dart test/services/radarr/radarr_release_repository_test.dart`
Expected: FAIL — repository methods not defined.

- [ ] **Step 3: Add the repository methods**

`lib/services/sonarr/sonarr_repository.dart` — add import
`import 'package:arrstack/features/release_search/models/release_candidate.dart';`
and methods (after `listEpisodes`):

```dart
  Future<Result<List<ReleaseCandidate>>> searchEpisodeReleases(int episodeId) =>
      _client.searchEpisodeReleases(episodeId).then(
        (r) => r.map(
          (list) => list.map(ReleaseCandidate.fromSonarr).toList(),
        ),
      );

  Future<Result<void>> grabRelease({
    required String guid,
    required int indexerId,
  }) => _client.grabRelease(guid: guid, indexerId: indexerId);
```

`lib/services/radarr/radarr_repository.dart` — mirror with
`ReleaseCandidate.fromRadarr` and `_client.searchMovieReleases(movieId)`:

```dart
  Future<Result<List<ReleaseCandidate>>> searchMovieReleases(int movieId) =>
      _client.searchMovieReleases(movieId).then(
        (r) => r.map(
          (list) => list.map(ReleaseCandidate.fromRadarr).toList(),
        ),
      );

  Future<Result<void>> grabRelease({
    required String guid,
    required int indexerId,
  }) => _client.grabRelease(guid: guid, indexerId: indexerId);
```

> Note on layering: `lib/services/` importing from `lib/features/` is
> unusual, but `ReleaseCandidate` is deliberately a feature-owned
> view-model (like `lib/features/calendar/models/calendar_entry.dart`) and
> the repo is the correct mapping boundary per the spec. If a future lint
> forbids this direction, move `release_candidate.dart` to
> `lib/core/models/` — no change beyond imports.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `flutter test test/services/sonarr/sonarr_release_repository_test.dart test/services/radarr/radarr_release_repository_test.dart`
Expected: PASS (6 tests).

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/services/sonarr/sonarr_repository.dart lib/services/radarr/radarr_repository.dart test/services/sonarr/sonarr_release_repository_test.dart test/services/radarr/radarr_release_repository_test.dart
git add lib/services/sonarr/sonarr_repository.dart lib/services/radarr/radarr_repository.dart test/services/sonarr/sonarr_release_repository_test.dart test/services/radarr/radarr_release_repository_test.dart
git commit -m "feat: map Sonarr/Radarr releases to ReleaseCandidate in repositories

$COMMIT_FOOTER"
```

---

## Task 7: Providers — `releaseSearchResults`, `ReleaseSortController`

**Files:**
- Create: `lib/features/release_search/release_search_providers.dart` (+ generated `.g.dart`)
- Test: `test/features/release_search/release_search_providers_test.dart`

**Interfaces:**
- Consumes: `sonarrRepositoryProvider(String)` / `radarrRepositoryProvider(String)` (existing, family, positional arg); `ServiceType` (`package:arrstack/core/models/service_type.dart`); `SonarrRepository.searchEpisodeReleases`, `RadarrRepository.searchMovieReleases` (Task 6); `ReleaseCandidate` (Task 2); `ReleaseSort` (Task 3); `Result`, `UnknownError` (`package:arrstack/core/network/app_error.dart`).
- Produces:
  - `releaseSearchResultsProvider({required ServiceType service, required String instanceId, required int targetId})` → auto-dispose `FutureProvider<Result<List<ReleaseCandidate>>>` family.
  - `releaseSortControllerProvider` → `NotifierProvider<ReleaseSortController, ReleaseSort>`; `ReleaseSort build() => ReleaseSort.peers;` and `void select(ReleaseSort value)`.

- [ ] **Step 1: Write the failing test**

`test/features/release_search/release_search_providers_test.dart`:

```dart
// releaseSearchResults dispatches to the Sonarr or Radarr repository based on
// ServiceType; releaseSortController defaults to Peers and updates on select.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

ProviderContainer _container(List<Override> overrides) {
  final c = ProviderContainer(overrides: overrides);
  addTearDown(c.dispose);
  return c;
}

void main() {
  test('releaseSearchResults routes sonarr → SonarrRepository', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(dio: dio).onGet(
      'api/v3/release',
      (s) => s.reply(200, [
        {'guid': 'a', 'title': 'A', 'size': 1, 'indexerId': 1, 'protocol': 'torrent', 'rejections': []},
      ]),
      queryParameters: {'episodeId': 5},
    );

    final container = _container([
      sonarrRepositoryProvider('i1').overrideWith(
        (ref) async => SonarrRepository(SonarrClient(dio)),
      ),
    ]);

    final result = await container.read(
      releaseSearchResultsProvider(
        service: ServiceType.sonarr,
        instanceId: 'i1',
        targetId: 5,
      ).future,
    );

    expect(result, isA<Ok<List<ReleaseCandidate>>>());
    expect(result.valueOrNull!.single.guid, 'a');
  });

  test('releaseSearchResults routes radarr → RadarrRepository', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://r.test'));
    DioAdapter(dio: dio).onGet(
      'api/v3/release',
      (s) => s.reply(200, [
        {'guid': 'm', 'title': 'M', 'size': 1, 'indexerId': 1, 'protocol': 'torrent', 'rejections': []},
      ]),
      queryParameters: {'movieId': 9},
    );

    final container = _container([
      radarrRepositoryProvider('i2').overrideWith(
        (ref) async => RadarrRepository(RadarrClient(dio)),
      ),
    ]);

    final result = await container.read(
      releaseSearchResultsProvider(
        service: ServiceType.radarr,
        instanceId: 'i2',
        targetId: 9,
      ).future,
    );

    expect(result.valueOrNull!.single.guid, 'm');
  });

  test('releaseSearchResults returns Err for an unsupported service', () async {
    final container = _container(const []);

    final result = await container.read(
      releaseSearchResultsProvider(
        service: ServiceType.bazarr,
        instanceId: 'x',
        targetId: 1,
      ).future,
    );

    expect(result.isErr, isTrue);
  });

  test('releaseSortController defaults to peers and updates', () {
    final container = _container(const []);

    expect(container.read(releaseSortControllerProvider), ReleaseSort.peers);
    container
        .read(releaseSortControllerProvider.notifier)
        .select(ReleaseSort.size);
    expect(container.read(releaseSortControllerProvider), ReleaseSort.size);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/release_search/release_search_providers_test.dart`
Expected: FAIL — provider file not found.

- [ ] **Step 3: Create the providers**

`lib/features/release_search/release_search_providers.dart`:

```dart
/// Riverpod wiring for interactive release search: the results future
/// (dispatched to the Sonarr or Radarr repository) and the active sort.
library;

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'release_search_providers.g.dart';

/// Runs an interactive search for [targetId] (an episode id for Sonarr, a
/// movie id for Radarr) on the given [instanceId]. Not kept alive — a search
/// is an explicit, expensive action; refetch with `ref.invalidate`.
@riverpod
Future<Result<List<ReleaseCandidate>>> releaseSearchResults(
  Ref ref, {
  required ServiceType service,
  required String instanceId,
  required int targetId,
}) async {
  if (service == ServiceType.sonarr) {
    final repo = await ref.watch(
      sonarrRepositoryProvider(instanceId).future,
    );
    return repo.searchEpisodeReleases(targetId);
  }
  if (service == ServiceType.radarr) {
    final repo = await ref.watch(
      radarrRepositoryProvider(instanceId).future,
    );
    return repo.searchMovieReleases(targetId);
  }
  return const Err(
    UnknownError(
      userMessage:
          'Interactive search is only available for Sonarr and Radarr.',
    ),
  );
}

/// The active sort for the results list. Defaults to [ReleaseSort.peers].
@riverpod
class ReleaseSortController extends _$ReleaseSortController {
  @override
  ReleaseSort build() => ReleaseSort.peers;

  void select(ReleaseSort value) => state = value;
}
```

- [ ] **Step 4: Regenerate riverpod code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: creates `lib/features/release_search/release_search_providers.g.dart` with `releaseSearchResultsProvider` and `releaseSortControllerProvider`.

- [ ] **Step 5: Run the test to verify it passes**

Run: `flutter test test/features/release_search/release_search_providers_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 6: analyze + format, then commit**

```bash
flutter analyze
dart format lib/features/release_search/ test/features/release_search/release_search_providers_test.dart
git add lib/features/release_search/release_search_providers.dart lib/features/release_search/release_search_providers.g.dart test/features/release_search/release_search_providers_test.dart
git commit -m "feat: add release search + sort providers

$COMMIT_FOOTER"
```

---

## Task 8: `FormatUtils.formatReleaseAge`

**Files:**
- Modify: `lib/core/utils/format_utils.dart`
- Test: `test/core/utils/format_utils_test.dart` (create — no test file exists yet)

**Interfaces:**
- Produces: `static String formatReleaseAge(int minutes)` on `FormatUtils` — `<=0` → `"just now"`; `<60` → `"{m}m"`; `<1440` → `"{h}h"`; else `"{d}d"`.

- [ ] **Step 1: Write the failing test**

`test/core/utils/format_utils_test.dart`:

```dart
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormatUtils.formatReleaseAge', () {
    test('renders minutes under an hour', () {
      expect(FormatUtils.formatReleaseAge(42), '42m');
    });
    test('renders whole hours under a day', () {
      expect(FormatUtils.formatReleaseAge(200), '3h');
    });
    test('renders whole days beyond a day', () {
      expect(FormatUtils.formatReleaseAge(60 * 24 * 5), '5d');
    });
    test('renders "just now" for zero or negative', () {
      expect(FormatUtils.formatReleaseAge(0), 'just now');
      expect(FormatUtils.formatReleaseAge(-3), 'just now');
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/core/utils/format_utils_test.dart`
Expected: FAIL — `formatReleaseAge` not defined.

- [ ] **Step 3: Add the helper**

In `lib/core/utils/format_utils.dart`, inside `abstract final class FormatUtils`:

```dart
  /// Compact age for a search release: "42m", "3h", "5d". Non-positive
  /// values render as "just now".
  static String formatReleaseAge(int minutes) {
    if (minutes <= 0) return 'just now';
    if (minutes < 60) return '${minutes}m';
    if (minutes < 60 * 24) return '${minutes ~/ 60}h';
    return '${minutes ~/ (60 * 24)}d';
  }
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/core/utils/format_utils_test.dart`
Expected: PASS.

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/core/utils/format_utils.dart test/core/utils/format_utils_test.dart
git add lib/core/utils/format_utils.dart test/core/utils/format_utils_test.dart
git commit -m "feat: add FormatUtils.formatReleaseAge

$COMMIT_FOOTER"
```

---

## Task 9: `ReleaseDetailSheet` + grab flow

**Files:**
- Create: `lib/features/release_search/widgets/release_detail_sheet.dart`
- Test: `test/features/release_search/release_detail_sheet_test.dart`

**Interfaces:**
- Consumes: `ReleaseCandidate`, `ReleaseProtocol` (Task 2); `ServiceType`; `sonarrRepositoryProvider` / `radarrRepositoryProvider`; `SonarrRepository.grabRelease` / `RadarrRepository.grabRelease` (Task 6); `FormatUtils.formatBytes`, `FormatUtils.formatReleaseAge` (Task 8); `AppSpacing` / `AppInsets` (`package:arrstack/app/theme/design_tokens.dart`); `Result`, `Ok`, `Err`, `UnknownError`.
- Produces:
  - `Future<void> showReleaseDetailSheet(BuildContext context, {required ReleaseCandidate release, required ServiceType service, required String instanceId})` — shows a modal bottom sheet. On a successful grab it closes the sheet, pops the current route if possible, and shows a snackbar. Returns when dismissed.

- [ ] **Step 1: Write the failing test**

`test/features/release_search/release_detail_sheet_test.dart`:

```dart
// The detail sheet is the single confirmation step before a grab. Rejected
// releases get a "Force download" button; a failed grab keeps the sheet open
// and shows the error inline; a successful grab dismisses it.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/widgets/release_detail_sheet.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

ReleaseCandidate release({bool rejected = false}) => ReleaseCandidate(
  guid: 'ix-1',
  indexerId: 3,
  indexerName: 'MyIndexer',
  title: 'Show.S01E01.1080p.WEB-DL-GRP',
  sizeBytes: 2000000000,
  protocol: ReleaseProtocol.torrent,
  qualityLabel: 'WEBDL-1080p',
  qualityWeight: 6,
  ageMinutes: 120,
  isRejected: rejected,
  rejections: rejected ? const ['Wrong quality'] : const [],
  downloadAllowed: true,
  seeders: 25,
  leechers: 2,
);

Widget _host(Dio dio, ReleaseCandidate r) => ProviderScope(
  overrides: [
    sonarrRepositoryProvider('i1').overrideWith(
      (ref) async => SonarrRepository(SonarrClient(dio)),
    ),
  ],
  child: MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showReleaseDetailSheet(
            context,
            release: r,
            service: ServiceType.sonarr,
            instanceId: 'i1',
          ),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('shows release facts and a Download button', (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    await tester.pumpWidget(_host(dio, release()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('MyIndexer'), findsOneWidget);
    expect(find.text('WEBDL-1080p'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
  });

  testWidgets('rejected release shows reasons and a Force download button',
      (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    await tester.pumpWidget(_host(dio, release(rejected: true)));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('• Wrong quality'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Force download'), findsOneWidget);
  });

  testWidgets('a failed grab keeps the sheet open with an inline error',
      (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(dio: dio).onPost(
      'api/v3/release',
      (s) => s.reply(400, {'message': 'nope'}),
      data: {'guid': 'ix-1', 'indexerId': 3},
    );

    await tester.pumpWidget(_host(dio, release()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Download'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
    expect(find.textContaining('Could'), findsOneWidget);
  });

  testWidgets('a successful grab dismisses the sheet', (tester) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://s.test'));
    DioAdapter(dio: dio).onPost(
      'api/v3/release',
      (s) => s.reply(201, {}),
      data: {'guid': 'ix-1', 'indexerId': 3},
    );

    await tester.pumpWidget(_host(dio, release()));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Download'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Download'), findsNothing);
  });
}
```

(The failed-grab test asserts `find.textContaining('Could')` — the app's `dio_exception_mapper` renders 4xx as a message beginning "Could not …". If the actual text differs, adjust the matcher to a substring of the real `error.userMessage` observed in Step 2.)

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/release_search/release_detail_sheet_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Create the sheet**

`lib/features/release_search/widgets/release_detail_sheet.dart`:

```dart
/// Bottom sheet showing one release in full, with the single "Download"
/// (or "Force download") confirmation that grabs it.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the release detail sheet. On a successful grab: closes the sheet,
/// pops the current route if possible, and shows a confirmation snackbar.
Future<void> showReleaseDetailSheet(
  BuildContext context, {
  required ReleaseCandidate release,
  required ServiceType service,
  required String instanceId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReleaseDetailSheet(
      release: release,
      service: service,
      instanceId: instanceId,
    ),
  );
}

class _ReleaseDetailSheet extends ConsumerStatefulWidget {
  const _ReleaseDetailSheet({
    required this.release,
    required this.service,
    required this.instanceId,
  });

  final ReleaseCandidate release;
  final ServiceType service;
  final String instanceId;

  @override
  ConsumerState<_ReleaseDetailSheet> createState() => _ReleaseDetailSheetState();
}

class _ReleaseDetailSheetState extends ConsumerState<_ReleaseDetailSheet> {
  bool _grabbing = false;
  String? _error;

  ReleaseCandidate get r => widget.release;
  bool get _isForce => r.isRejected || !r.downloadAllowed;

  Future<void> _grab() async {
    setState(() {
      _grabbing = true;
      _error = null;
    });

    final Result<void> result;
    if (widget.service == ServiceType.sonarr) {
      final repo = await ref.read(
        sonarrRepositoryProvider(widget.instanceId).future,
      );
      result = await repo.grabRelease(guid: r.guid, indexerId: r.indexerId);
    } else if (widget.service == ServiceType.radarr) {
      final repo = await ref.read(
        radarrRepositoryProvider(widget.instanceId).future,
      );
      result = await repo.grabRelease(guid: r.guid, indexerId: r.indexerId);
    } else {
      result = const Err(UnknownError(userMessage: 'Unsupported service.'));
    }

    if (!mounted) return;

    switch (result) {
      case Ok():
        final messenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context);
        navigator.pop(); // close the sheet
        if (navigator.canPop()) navigator.pop(); // close the search page
        messenger.showSnackBar(
          SnackBar(
            content: Text('Sent to ${r.indexerName} — check Downloads'),
          ),
        );
      case Err(:final error):
        setState(() {
          _grabbing = false;
          _error = error.userMessage;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <(String, String)>[
      ('Indexer', r.indexerName),
      ('Quality', r.qualityLabel),
      ('Size', FormatUtils.formatBytes(r.sizeBytes)),
      if (r.protocol == ReleaseProtocol.torrent)
        ('Seeders / Leechers', '${r.seeders ?? '—'} / ${r.leechers ?? '—'}'),
      ('Age', FormatUtils.formatReleaseAge(r.ageMinutes)),
      ('Protocol', r.protocol.name),
      if (r.releaseGroup != null && r.releaseGroup!.isNotEmpty)
        ('Release group', r.releaseGroup!),
      if (r.customFormatScore != null)
        ('Custom format score', '${r.customFormatScore}'),
    ];

    return SafeArea(
      child: Padding(
        padding: AppInsets.pageMd,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(r.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.md),
                    for (final (label, value) in rows)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                label,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (r.rejections.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Rejected because',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      for (final reason in r.rejections)
                        Text(
                          '• $reason',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _grabbing ? null : _grab,
                style: _isForce
                    ? FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      )
                    : null,
                child: _grabbing
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isForce ? 'Force download' : 'Download'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/release_search/release_detail_sheet_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/features/release_search/widgets/release_detail_sheet.dart test/features/release_search/release_detail_sheet_test.dart
git add lib/features/release_search/widgets/release_detail_sheet.dart test/features/release_search/release_detail_sheet_test.dart
git commit -m "feat: add release detail sheet with grab flow

$COMMIT_FOOTER"
```

---

## Task 10: `ReleaseTile`

**Files:**
- Create: `lib/features/release_search/widgets/release_tile.dart`
- Test: `test/features/release_search/release_tile_test.dart`

**Interfaces:**
- Consumes: `ReleaseCandidate`, `ReleaseProtocol` (Task 2); `FormatUtils.formatBytes`, `FormatUtils.formatReleaseAge` (Task 8); `AppSpacing` (design tokens).
- Produces: `class ReleaseTile extends StatelessWidget` with `const ReleaseTile({required this.release, required this.onTap, super.key})`, `final ReleaseCandidate release;` `final VoidCallback onTap;`. Rejected releases render at `Opacity(0.55)` and show the first rejection reason (`+N more` when `rejections.length > 1`).

- [ ] **Step 1: Write the failing test**

`test/features/release_search/release_tile_test.dart`:

```dart
// The tile is the scannable row: title + a facts line (quality, size, peers,
// indexer, age). Rejected releases are dimmed and surface their first reason.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate release({
  bool rejected = false,
  List<String> rejections = const [],
  int? seeders = 25,
  ReleaseProtocol protocol = ReleaseProtocol.torrent,
}) => ReleaseCandidate(
  guid: 'g',
  indexerId: 1,
  indexerName: 'MyIndexer',
  title: 'Show.S01E01.1080p.WEB-DL-GRP',
  sizeBytes: 2000000000,
  protocol: protocol,
  qualityLabel: 'WEBDL-1080p',
  qualityWeight: 6,
  ageMinutes: 200,
  isRejected: rejected,
  rejections: rejections,
  downloadAllowed: true,
  seeders: seeders,
  leechers: 2,
);

Future<void> _pump(WidgetTester tester, ReleaseCandidate r,
    {VoidCallback? onTap}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: ReleaseTile(release: r, onTap: onTap ?? () {})),
    ),
  );
}

void main() {
  testWidgets('shows title, quality, indexer and a formatted size', (tester) async {
    await _pump(tester, release());
    expect(find.textContaining('Show.S01E01'), findsOneWidget);
    expect(find.textContaining('WEBDL-1080p'), findsOneWidget);
    expect(find.textContaining('MyIndexer'), findsOneWidget);
    expect(find.textContaining('GB'), findsOneWidget);
  });

  testWidgets('usenet release shows "usenet" instead of a peer count', (tester) async {
    await _pump(tester, release(protocol: ReleaseProtocol.usenet, seeders: null));
    expect(find.textContaining('usenet'), findsOneWidget);
  });

  testWidgets('rejected release is dimmed and shows its first reason', (tester) async {
    await _pump(
      tester,
      release(rejected: true, rejections: const ['Wrong quality', 'Too big']),
    );
    expect(find.textContaining('Wrong quality'), findsOneWidget);
    expect(find.textContaining('+1 more'), findsOneWidget);
    expect(find.byType(Opacity), findsWidgets);
  });

  testWidgets('tapping the tile invokes onTap', (tester) async {
    var tapped = false;
    await _pump(tester, release(), onTap: () => tapped = true);
    await tester.tap(find.byType(ReleaseTile));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/release_search/release_tile_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Create the tile**

`lib/features/release_search/widgets/release_tile.dart`:

```dart
/// One row in the interactive-search results list.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:flutter/material.dart';

class ReleaseTile extends StatelessWidget {
  const ReleaseTile({required this.release, required this.onTap, super.key});

  final ReleaseCandidate release;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    final peers = release.protocol == ReleaseProtocol.torrent
        ? '▲${release.seeders ?? '—'} ▼${release.leechers ?? '—'}'
        : 'usenet';

    final facts = <String>[
      release.qualityLabel,
      FormatUtils.formatBytes(release.sizeBytes),
      peers,
      release.indexerName,
      FormatUtils.formatReleaseAge(release.ageMinutes),
    ].join('  ·  ');

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            release.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            facts,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
          if (release.isRejected && release.rejections.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              release.rejections.length > 1
                  ? '${release.rejections.first}  +${release.rejections.length - 1} more'
                  : release.rejections.first,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: release.isRejected
          ? Opacity(opacity: 0.55, child: content)
          : content,
    );
  }
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/release_search/release_tile_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 5: analyze + format, then commit**

```bash
flutter analyze
dart format lib/features/release_search/widgets/release_tile.dart test/features/release_search/release_tile_test.dart
git add lib/features/release_search/widgets/release_tile.dart test/features/release_search/release_tile_test.dart
git commit -m "feat: add ReleaseTile row for search results

$COMMIT_FOOTER"
```

---

## Task 11: `ReleaseSearchPage`

**Files:**
- Create: `lib/features/release_search/release_search_page.dart`
- Test: `test/features/release_search/release_search_page_test.dart`

**Interfaces:**
- Consumes: `releaseSearchResultsProvider`, `releaseSortControllerProvider` (Task 7); `ReleaseSort`, `applySort` (Task 3); `ReleaseCandidate` (Task 2); `ReleaseTile` (Task 10); `showReleaseDetailSheet` (Task 9); `EmptyState` (`package:arrstack/core/widgets/empty_state.dart`); `ServiceType`; `Result` / `Ok` / `Err` pattern-match.
- Produces: `class ReleaseSearchPage extends ConsumerWidget` with
  `const ReleaseSearchPage({required this.service, required this.instanceId, required this.targetId, required this.title, super.key})` and final fields `ServiceType service`, `String instanceId`, `int targetId`, `String title`.

- [ ] **Step 1: Write the failing test**

`test/features/release_search/release_search_page_test.dart`:

```dart
// The page: a long "searching all indexers" wait, then a sorted list; the
// segmented control re-sorts in place; tapping a row opens the detail sheet.

import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_page.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate rc(String guid, {int? seeders, int size = 0}) =>
    ReleaseCandidate(
      guid: guid,
      indexerId: 1,
      indexerName: 'ix',
      title: guid,
      sizeBytes: size,
      protocol: ReleaseProtocol.torrent,
      qualityLabel: 'q',
      qualityWeight: 0,
      ageMinutes: 0,
      isRejected: false,
      rejections: const [],
      downloadAllowed: true,
      seeders: seeders,
    );

Widget _host(Object dataOrFuture) => ProviderScope(
  overrides: [
    if (dataOrFuture is Result<List<ReleaseCandidate>>)
      releaseSearchResultsProvider(
        service: ServiceType.sonarr,
        instanceId: 'i1',
        targetId: 5,
      ).overrideWith((ref) async => dataOrFuture)
    else
      releaseSearchResultsProvider(
        service: ServiceType.sonarr,
        instanceId: 'i1',
        targetId: 5,
      ).overrideWith(
        (ref) => dataOrFuture as Future<Result<List<ReleaseCandidate>>>,
      ),
  ],
  child: const MaterialApp(
    home: ReleaseSearchPage(
      service: ServiceType.sonarr,
      instanceId: 'i1',
      targetId: 5,
      title: 'S01E01',
    ),
  ),
);

void main() {
  testWidgets('shows the long-search hint while loading', (tester) async {
    final never = Completer<Result<List<ReleaseCandidate>>>().future;
    await tester.pumpWidget(_host(never));
    await tester.pump();
    expect(find.textContaining('Searching all indexers'), findsOneWidget);
  });

  testWidgets('renders results sorted by peers by default', (tester) async {
    await tester.pumpWidget(
      _host(Ok<List<ReleaseCandidate>>([rc('low', seeders: 2), rc('high', seeders: 99)])),
    );
    await tester.pumpAndSettle();

    final tiles =
        tester.widgetList<ReleaseTile>(find.byType(ReleaseTile)).toList();
    expect(tiles.first.release.guid, 'high');
    expect(tiles.last.release.guid, 'low');
  });

  testWidgets('switching sort to Size re-orders the list', (tester) async {
    await tester.pumpWidget(
      _host(Ok<List<ReleaseCandidate>>(
        [rc('big', seeders: 1, size: 900), rc('small', seeders: 1, size: 10)],
      )),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Size'));
    await tester.pumpAndSettle();

    final tiles =
        tester.widgetList<ReleaseTile>(find.byType(ReleaseTile)).toList();
    expect(tiles.first.release.guid, 'small');
  });

  testWidgets('error result shows an EmptyState with retry', (tester) async {
    await tester.pumpWidget(
      _host(const Err<List<ReleaseCandidate>>(
        UnknownError(userMessage: 'search failed'),
      )),
    );
    await tester.pumpAndSettle();
    expect(find.text('search failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('empty result shows "No releases found"', (tester) async {
    await tester.pumpWidget(
      _host(const Ok<List<ReleaseCandidate>>([])),
    );
    await tester.pumpAndSettle();
    expect(find.text('No releases found'), findsOneWidget);
  });

  testWidgets('tapping a row opens the detail sheet', (tester) async {
    await tester.pumpWidget(
      _host(Ok<List<ReleaseCandidate>>([rc('one', seeders: 5)])),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ReleaseTile).first);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
  });
}
```

Add `import 'dart:async';` for `Completer`.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/features/release_search/release_search_page_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Create the page**

`lib/features/release_search/release_search_page.dart`:

```dart
/// Interactive release-search screen: runs the search on open, shows the
/// results sorted (default Peers ↓), and lets the user open any release.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/features/release_search/widgets/release_detail_sheet.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReleaseSearchPage extends ConsumerWidget {
  const ReleaseSearchPage({
    required this.service,
    required this.instanceId,
    required this.targetId,
    required this.title,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final int targetId;

  /// Human label for the episode/movie being searched (app-bar subtitle).
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = releaseSearchResultsProvider(
      service: service,
      instanceId: instanceId,
      targetId: targetId,
    );
    final resultsAsync = ref.watch(provider);
    final sort = ref.watch(releaseSortControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Releases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Search again',
            onPressed: () => ref.invalidate(provider),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<ReleaseSort>(
                    segments: const [
                      ButtonSegment(
                        value: ReleaseSort.peers,
                        label: Text('Peers'),
                      ),
                      ButtonSegment(
                        value: ReleaseSort.size,
                        label: Text('Size'),
                      ),
                      ButtonSegment(
                        value: ReleaseSort.age,
                        label: Text('Age'),
                      ),
                      ButtonSegment(
                        value: ReleaseSort.quality,
                        label: Text('Quality'),
                      ),
                    ],
                    selected: {sort},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) => ref
                        .read(releaseSortControllerProvider.notifier)
                        .select(s.first),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const _SearchingState(),
        error: (err, _) => _ErrorState(
          message: '$err',
          onRetry: () => ref.invalidate(provider),
        ),
        data: (result) => switch (result) {
          Err(:final error) => _ErrorState(
            message: error.userMessage,
            onRetry: () => ref.invalidate(provider),
          ),
          Ok(:final value) when value.isEmpty => const EmptyState(
            icon: Icons.search_off,
            title: 'No releases found',
            message: 'No indexer returned a release for this item.',
          ),
          Ok(:final value) => _Results(
            releases: applySort(value, sort),
            service: service,
            instanceId: instanceId,
          ),
        },
      ),
    );
  }
}

class _SearchingState extends StatelessWidget {
  const _SearchingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppInsets.pageLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text(
              'Searching all indexers… this can take up to a minute.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Search failed',
      message: message,
      action: FilledButton(onPressed: onRetry, child: const Text('Retry')),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.releases,
    required this.service,
    required this.instanceId,
  });

  final List<ReleaseCandidate> releases;
  final ServiceType service;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: releases.length + 1,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              '${releases.length} release${releases.length == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          );
        }
        final release = releases[index - 1];
        return ReleaseTile(
          release: release,
          onTap: () => showReleaseDetailSheet(
            context,
            release: release,
            service: service,
            instanceId: instanceId,
          ),
        );
      },
    );
  }
}
```

If `flutter analyze` flags the `const [ ... ]` list containing non-const
`CircularProgressIndicator` + `Text` in `_SearchingState`, drop the `const`
on the list literal and keep `const` on each child.

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/features/release_search/release_search_page_test.dart`
Expected: PASS (6 tests).

- [ ] **Step 5: Full suite + analyze + format, then commit**

```bash
flutter test
flutter analyze
dart format lib/features/release_search/release_search_page.dart test/features/release_search/release_search_page_test.dart
git add lib/features/release_search/release_search_page.dart test/features/release_search/release_search_page_test.dart
git commit -m "feat: add ReleaseSearchPage

$COMMIT_FOOTER"
```

---

## Task 12: Routing + entry-point wiring

**Files:**
- Modify: `lib/app/route_paths.dart`
- Modify: `lib/app/router.dart`
- Modify: `lib/features/library/episode_detail_page.dart`
- Modify: `lib/features/library/movie_detail_page.dart`
- Test: `test/app/route_paths_test.dart` (create)

**Interfaces:**
- Consumes: `ReleaseSearchPage` (Task 11); `ServiceType`; existing `RoutePaths` string-builder conventions; existing nested `GoRoute` tree in `router.dart` (episode route path `'episode/:episodeId'` under `series/:seriesId`; movie route path `'radarr/:instanceId/movie/:movieId'` under `/library`).
- Produces:
  - `RoutePaths.episodeReleaseSearch(String instanceId, int seriesId, int episodeId, String title)` → `'/library/sonarr/$instanceId/series/$seriesId/episode/$episodeId/search?title=<encoded>'`
  - `RoutePaths.movieReleaseSearch(String instanceId, int movieId, String title)` → `'/library/radarr/$instanceId/movie/$movieId/search?title=<encoded>'`

- [ ] **Step 1: Write the failing test**

`test/app/route_paths_test.dart`:

```dart
// Release-search deep links carry the episode/movie label as an encoded
// query param so the page can show a subtitle without another fetch.

import 'package:arrstack/app/route_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('episodeReleaseSearch builds a nested path with an encoded title', () {
    final path =
        RoutePaths.episodeReleaseSearch('inst', 12, 345, 'S01E01 · Pilot');
    expect(
      path,
      '/library/sonarr/inst/series/12/episode/345/search'
      '?title=S01E01%20%C2%B7%20Pilot',
    );
  });

  test('movieReleaseSearch builds a nested path with an encoded title', () {
    final path = RoutePaths.movieReleaseSearch('inst', 99, 'Dune (2021)');
    expect(path, '/library/radarr/inst/movie/99/search?title=Dune%20%282021%29');
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test test/app/route_paths_test.dart`
Expected: FAIL — methods not defined.

- [ ] **Step 3: Add the path helpers**

In `lib/app/route_paths.dart`, in `abstract final class RoutePaths` (near `episodeDetail` / `movieDetail`):

```dart
  static String episodeReleaseSearch(
    String instanceId,
    int seriesId,
    int episodeId,
    String title,
  ) =>
      '/library/sonarr/$instanceId/series/$seriesId/episode/$episodeId/search'
      '?title=${Uri.encodeComponent(title)}';

  static String movieReleaseSearch(
    String instanceId,
    int movieId,
    String title,
  ) =>
      '/library/radarr/$instanceId/movie/$movieId/search'
      '?title=${Uri.encodeComponent(title)}';
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `flutter test test/app/route_paths_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Add the routes**

In `lib/app/router.dart`:
- add imports:
  `import 'package:arrstack/features/release_search/release_search_page.dart';`
  `import 'package:arrstack/core/models/service_type.dart';`
- the episode `GoRoute` (path `'episode/:episodeId'`) currently ends with a `routes:` list holding one child (`'episode/:episodeId'` itself is nested under `series/:seriesId` and already has `routes:` for the episode — re-check: the episode route is the one with `builder: (context, state) => EpisodeDetailPage(...)`). Add to **that** route's `routes:` list:

```dart
GoRoute(
  path: 'search',
  builder: (context, state) => ReleaseSearchPage(
    service: ServiceType.sonarr,
    instanceId: state.pathParameters['instanceId']!,
    targetId: int.parse(state.pathParameters['episodeId']!),
    title: state.uri.queryParameters['title'] ?? 'Episode',
  ),
),
```

If the episode `GoRoute` has no `routes:` yet, add `routes: [ <the GoRoute above> ],`.

- the movie `GoRoute` (path `'radarr/:instanceId/movie/:movieId'`, `builder: … MovieDetailPage(...)`) currently has no `routes:`. Add:

```dart
routes: [
  GoRoute(
    path: 'search',
    builder: (context, state) => ReleaseSearchPage(
      service: ServiceType.radarr,
      instanceId: state.pathParameters['instanceId']!,
      targetId: int.parse(state.pathParameters['movieId']!),
      title: state.uri.queryParameters['title'] ?? 'Movie',
    ),
  ),
],
```

- [ ] **Step 6: Wire the episode detail entry point**

In `lib/features/library/episode_detail_page.dart`:
- add imports: `import 'package:arrstack/app/route_paths.dart';` and `import 'package:go_router/go_router.dart';`
- in `_EpisodeDetailContentState.build`, replace the trailing search `IconButton` (the one whose `onPressed` currently shows `SnackBar(content: Text('Search command coming soon.'))`) with:

```dart
IconButton(
  icon: const Icon(Icons.search),
  tooltip: 'Search releases',
  onPressed: () => context.go(
    RoutePaths.episodeReleaseSearch(
      widget.instanceId,
      widget.seriesId,
      episode.id,
      '${episode.episodeCode} · ${episode.title ?? ''}'.trim(),
    ),
  ),
),
```

(`episode` is the local `final episode = widget.episode;` already in `build`.)

- [ ] **Step 7: Wire the movie detail entry point**

In `lib/features/library/movie_detail_page.dart`:
- add imports: `import 'package:arrstack/app/route_paths.dart';` and `import 'package:go_router/go_router.dart';`
- in `_onMenuSelected`, replace the `case 'search':` body (the `SnackBar(content: Text('Search command coming soon.'))`) with:

```dart
      case 'search':
        context.go(
          RoutePaths.movieReleaseSearch(
            widget.instanceId,
            movie.id!,
            '${movie.title} (${movie.year})',
          ),
        );
```

- [ ] **Step 8: Run the full suite + analyze + format**

Run: `flutter test`
Run: `flutter analyze` (expect no issues)
Run: `dart format lib/app/route_paths.dart lib/app/router.dart lib/features/library/episode_detail_page.dart lib/features/library/movie_detail_page.dart test/app/route_paths_test.dart`

- [ ] **Step 9: Manual smoke (optional — needs a device/emulator + a configured Sonarr and Radarr)**

Run `flutter run`. Open a monitored episode → tap the search icon → confirm: the "Searching all indexers…" state shows, results appear, default order is peers high→low, switching to Size re-orders, a tile opens the sheet, and tapping Download shows the "Sent to … check Downloads" snackbar and returns to the episode. Repeat from a movie via the overflow menu → "Search Movie".

- [ ] **Step 10: Commit + push + open PR**

```bash
git add lib/app/route_paths.dart lib/app/router.dart lib/features/library/episode_detail_page.dart lib/features/library/movie_detail_page.dart test/app/route_paths_test.dart
git commit -m "feat: wire interactive release search into episode and movie screens

$COMMIT_FOOTER"
git push -u origin feat/interactive-release-search
```

Open a PR to `main`: title `feat: interactive release search for Sonarr & Radarr`, body links `docs/superpowers/specs/2026-09-07-interactive-release-search-design.md`. CI `Analyze & test` must be green before merge.

---

## Self-Review

**1. Spec coverage**

| Spec section / requirement | Task(s) |
|---|---|
| Trigger search from an episode (Sonarr) | 4 (client), 6 (repo), 12 (entry point + route) |
| Trigger search from a movie (Radarr) | 5 (client), 6 (repo), 12 (entry point + route) |
| Results list: title, quality, size, peers, indexer, age | 10 (tile), 11 (page) |
| Rejection reasons visible | 1 (model `rejections`), 2 (mapper), 9 (sheet), 10 (tile) |
| Selectable sort; default Peers ↓; Peers/Size/Age/Quality | 3 (`applySort`), 7 (`ReleaseSortController`), 11 (`SegmentedButton`) |
| "Peers" = seeders; usenet/missing → `—`, sorts last | 2 (`peersKey`), 3 (peers branch), 10 (tile display) |
| Tap row → detail sheet → Download | 9 (`showReleaseDetailSheet`), 10 (`onTap`), 11 (`_Results`) |
| Rejected: dimmed + reason; force-grabbable | 9 (`_isForce` / "Force download"), 10 (`Opacity(0.55)`) |
| 90s per-request search timeout | 4, 5 (`Options(receiveTimeout:)`) |
| Partial indexer results tolerated | 4, 5 (200 with whatever came back — no special handling needed) |
| Malformed release item skipped | 4, 5 (per-element try/catch + `whereType`) |
| Grab failure inline in sheet, page stays | 9 (`Err` branch keeps sheet, sets `_error`) |
| `seeders` null → `—`, sorts last | 2, 3, 9, 10 |
| Provider auto-dispose on back-nav | 7 (`@riverpod` function provider default) |
| Unsupported `ServiceType` → `Err` | 7 (final `return const Err(...)`) |
| `formatReleaseAge` helper | 8 |
| Nested routes + `RoutePaths` helpers + `?title=` param | 12 |
| Testing matrix (models, mappers, sort, clients, repos, providers, sheet, tile, page, routes) | 1–12 |
| Coverage ≥ 80% new non-widget code | Tasks 1–8 are all unit-tested; widget tasks 9–11 additionally covered |

No gaps.

**2. Placeholder scan**

- No `TBD` / `TODO` / "implement later".
- No "add error handling" / "handle edge cases" hand-waves — each error path has explicit code (client guards, `Err` branches, `_ErrorState`).
- No "write tests for the above" — every task has full test source.
- No "similar to Task N" — Radarr tasks (5, 6, and the Radarr halves of 1, 2) repeat the code in full.
- The "if analyze flags X" / "if the text differs" notes in Tasks 4, 7, 9, 11 are concrete run-time fallbacks with exact alternative code, not deferred work.
- Task 12 Step 9 manual smoke is marked optional and fully spelled out.

**3. Type consistency**

- `ReleaseCandidate` field names identical across Tasks 2, 3, 9, 10, 11: `sizeBytes`, `qualityLabel`, `qualityWeight`, `ageMinutes`, `peersKey`, `isRejected`, `downloadAllowed`, `indexerName`, `rejections`.
- `ReleaseProtocol { torrent, usenet, unknown }` consistent Tasks 2, 9, 10.
- `ReleaseSort { peers, size, age, quality }` consistent Tasks 3, 7, 11.
- Provider names: `releaseSearchResultsProvider` (named params `service` / `instanceId` / `targetId`), `releaseSortControllerProvider` (+ `.notifier.select(...)`) consistent Tasks 7, 9 (indirect), 11.
- Client methods: `searchEpisodeReleases(int)`, `searchMovieReleases(int)`, `grabRelease({required String guid, required int indexerId})` consistent Tasks 4, 5, 6, 9.
- Repository methods reuse the client method names, consistent Tasks 6, 7, 9.
- `showReleaseDetailSheet(context, {required release, required service, required instanceId})` consistent Tasks 9, 10, 11.
- `RoutePaths.episodeReleaseSearch(instanceId, seriesId, episodeId, title)` / `movieReleaseSearch(instanceId, movieId, title)` consistent Task 12 Steps 3, 6, 7.
- `FormatUtils.formatReleaseAge(int)` consistent Tasks 8, 9, 10.

No mismatches.

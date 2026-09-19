# Nocturne Redesign Phase 5 — Library & Detail Screens Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restyle the Library page and series/episode/movie detail screens onto the Nocturne design system (README screens 2d–2g), including the poster-beside-title restructure, and root-cause the recurring dark-mode `onSurfaceVariant` bug.

**Architecture:** Extract shared, feature-local widgets (`MediaDetailHeader`, `SpecBlock`, `SeasonRow`, `LibraryRow`, `CollectionChips`, `ContinueWatchingRow`) plus one new core primitive (`FadingRule`), then rebuild the four pages on top of them. Two small new data capabilities: a calendar-derived "Continue watching" provider, and a Radarr bulk-search command. Existing interactive logic (monitor/delete/search/subtitles) is preserved; only presentation changes.

**Tech Stack:** Flutter, Riverpod (`riverpod_annotation` code-gen), `go_router`, `freezed`/`json_serializable`, `phosphor_icons`, `flutter_test` + `http_mock_adapter`.

**Spec:** `docs/superpowers/specs/2026-09-12-nocturne-redesign-phase5-library-detail-design.md`

## Global Constraints

- Never hardcode Nocturne colors/spacing/radii/type inline — use `AppColors`/`AppSpacing`/`AppRadius`/`AppTypography` from `lib/app/theme/design_tokens.dart`.
- Read `colorScheme.onSurfaceVariant` directly in all new code — no `isDark` branching (Task 1 fixes the root cause).
- `dart format` and `dart analyze` must stay clean after every task.
- After any change to a `@freezed`/`@riverpod` file, run `dart run build_runner build --delete-conflicting-outputs` and commit the regenerated `.g.dart`/`.freezed.dart` output alongside the source change.
- Package imports only (`package:arrstack/...`), never relative (`../`).
- Out of scope: `add_movie_page.dart`, `add_series_page.dart`, their `widgets/add_*_options.dart`, all `lib/features/activity/**` files, release-search pages.

---

### Task 1: Root-cause the dark-mode `onSurfaceVariant` fix

**Files:**
- Modify: `lib/app/theme/app_theme.dart:19-31`
- Test: `test/app/theme/app_theme_test.dart` (new)

**Interfaces:**
- Produces: `AppTheme.dark().colorScheme.onSurfaceVariant == AppColors.n400`, consumed by every widget task below.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:arrstack/app/theme/app_theme.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dark theme uses the Nocturne muted tone for onSurfaceVariant', () {
    final scheme = AppTheme.dark().colorScheme;
    expect(scheme.onSurfaceVariant, AppColors.n400);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/app/theme/app_theme_test.dart`
Expected: FAIL — actual value is Flutter's Material 3 default, not `AppColors.n400`.

- [ ] **Step 3: Add the explicit token**

In `lib/app/theme/app_theme.dart`, inside the `Brightness.dark` branch of `_buildTheme`:

```dart
final colorScheme = brightness == Brightness.dark
    ? const ColorScheme.dark(
        primary: AppColors.accent,
        onPrimary: AppColors.bg,
        secondary: AppColors.a300,
        onSecondary: AppColors.bg,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        onSurfaceVariant: AppColors.n400,
        error: AppColors.down,
        onError: AppColors.text,
        outline: AppColors.divider,
        outlineVariant: AppColors.divider,
      )
    : ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
      );
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/app/theme/app_theme_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/app/theme/app_theme.dart test/app/theme/app_theme_test.dart
git commit -m "fix(theme): set onSurfaceVariant explicitly in the dark ColorScheme"
```

---

### Task 2: `FadingRule` shared widget

**Files:**
- Create: `lib/core/widgets/fading_rule.dart`
- Test: `test/core/widgets/fading_rule_test.dart`

**Interfaces:**
- Produces: `class FadingRule extends StatelessWidget` — a 1px divider that fades to transparent at both ends. `const FadingRule({super.key})`. Consumed by Task 7 (`LibraryRow` separators) and Tasks 15–17 (detail-page section rules).

- [ ] **Step 1: Write the failing test**

```dart
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a 1px-tall gradient container', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: FadingRule())),
    );

    final size = tester.getSize(find.byType(FadingRule));
    expect(size.height, 1);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(FadingRule),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.gradient, isA<LinearGradient>());
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/fading_rule_test.dart`
Expected: FAIL with "FadingRule isn't defined" (file doesn't exist yet).

- [ ] **Step 3: Implement**

```dart
/// A 1px divider that fades to transparent at both ends (README "Shared
/// shell" -> "Fading rules"). Used between list rows and detail sections
/// instead of a solid Divider.
library;

import 'package:flutter/material.dart';

class FadingRule extends StatelessWidget {
  const FadingRule({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).colorScheme.outlineVariant;

    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            divider.withValues(alpha: 0),
            divider,
            divider,
            divider.withValues(alpha: 0),
          ],
          // Fixed stop fractions approximating the spec's fixed 48px
          // fade-in on this app's full-bleed row widths. Not meant to be
          // configurable — FadingRule is always used at consistent widths.
          stops: const [0, 0.14, 0.86, 1],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/fading_rule_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/fading_rule.dart test/core/widgets/fading_rule_test.dart
git commit -m "feat(core): add FadingRule shared divider widget"
```

---

### Task 3: `SpecBlock` shared widget

**Files:**
- Create: `lib/features/library/widgets/spec_block.dart`
- Test: `test/features/library/widgets/spec_block_test.dart`

**Interfaces:**
- Produces:
  ```dart
  class SpecBlock extends StatelessWidget {
    const SpecBlock({required this.kicker, required this.rows, super.key});
    final String kicker;
    final List<(String label, String value)> rows;
  }
  ```
  Consumed by Task 16 (episode FILE/SUBTITLES) and Task 17 (movie FILE).

- [ ] **Step 1: Write the failing test**

```dart
import 'package:arrstack/features/library/widgets/spec_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the kicker and each label/value row', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SpecBlock(
            kicker: 'FILE',
            rows: [
              ('Quality', 'WEBDL-1080p'),
              ('Size', '3.1 GB'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('FILE'), findsOneWidget);
    expect(find.text('Quality'), findsOneWidget);
    expect(find.text('WEBDL-1080p'), findsOneWidget);
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('3.1 GB'), findsOneWidget);
  });

  testWidgets('renders nothing when rows is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SpecBlock(kicker: 'FILE', rows: [])),
      ),
    );

    expect(find.byType(SpecBlock), findsOneWidget);
    expect(find.text('FILE'), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/library/widgets/spec_block_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 3: Implement**

```dart
/// A label/value spec block (README screens 2f/2g "FILE"/"SUBTITLES"):
/// an uppercase kicker, then rows of a muted label left and a tabular
/// value right that wraps and right-aligns.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class SpecBlock extends StatelessWidget {
  const SpecBlock({required this.kicker, required this.rows, super.key});

  final String kicker;
  final List<(String label, String value)> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(kicker, style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space4),
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.space2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.meta.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppSpacing.space6),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: AppTypography.meta.copyWith(
                      color: colorScheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/library/widgets/spec_block_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/library/widgets/spec_block.dart test/features/library/widgets/spec_block_test.dart
git commit -m "feat(library): add SpecBlock shared widget"
```

---

### Task 4: Extend Sonarr/Radarr file models with codec/audio/release fields

**Files:**
- Modify: `lib/services/sonarr/models/sonarr_models.dart:177-188` (`SonarrEpisodeFile`)
- Modify: `lib/services/radarr/models/radarr_models.dart:116-127` (`RadarrMovieFile`)
- Test: `test/services/sonarr/models/sonarr_models_test.dart` (new, or extend if one exists — check first)
- Test: `test/services/radarr/models/radarr_models_test.dart` (new, or extend if one exists)

**Interfaces:**
- Produces: `SonarrEpisodeFile.releaseGroup`, `SonarrEpisodeFile.mediaInfo` (`SonarrMediaInfo? {videoCodec, audioCodec, audioChannels}`); `RadarrMovieFile.releaseGroup`, `RadarrMovieFile.mediaInfo` (`RadarrMediaInfo? {videoCodec, audioCodec, audioChannels, resolution, videoDynamicRangeType}`). Consumed by Tasks 16–17's FILE `SpecBlock` rows.

This widens two already-fetched objects (Sonarr/Radarr already return `mediaInfo`/`releaseGroup` on episode/movie file objects from the same `episodeFile`/`movieFile` JSON the app already parses) — no new endpoint or client call.

- [ ] **Step 1: Check for existing model test files**

Run: `find test/services/sonarr test/services/radarr -iname "*model*"`
If a `sonarr_models_test.dart` / `radarr_models_test.dart` already exists, add to it instead of creating a new file; otherwise create the new files below.

- [ ] **Step 2: Write the failing tests**

`test/services/sonarr/models/sonarr_models_test.dart`:

```dart
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SonarrEpisodeFile parses releaseGroup and mediaInfo', () {
    final file = SonarrEpisodeFile.fromJson({
      'id': 1,
      'relativePath': 'Severance/Season 02/S02E05.mkv',
      'size': 3100000000,
      'releaseGroup': 'FLUX',
      'quality': {
        'quality': {'name': 'WEBDL-1080p'},
      },
      'mediaInfo': {
        'videoCodec': 'h264',
        'audioCodec': 'DDP',
        'audioChannels': 5.1,
      },
    });

    expect(file.releaseGroup, 'FLUX');
    expect(file.mediaInfo?.videoCodec, 'h264');
    expect(file.mediaInfo?.audioCodec, 'DDP');
    expect(file.mediaInfo?.audioChannels, 5.1);
  });

  test('SonarrEpisodeFile tolerates a missing mediaInfo/releaseGroup', () {
    final file = SonarrEpisodeFile.fromJson({'id': 1, 'size': 0});
    expect(file.releaseGroup, isNull);
    expect(file.mediaInfo, isNull);
  });
}
```

`test/services/radarr/models/radarr_models_test.dart`:

```dart
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RadarrMovieFile parses releaseGroup and mediaInfo', () {
    final file = RadarrMovieFile.fromJson({
      'id': 1,
      'relativePath': 'Movies/Dune Part Two (2024)/Dune.Part.Two.mkv',
      'size': 54200000000,
      'releaseGroup': 'TERMiNAL',
      'quality': {
        'quality': {'name': 'Bluray-2160p'},
      },
      'mediaInfo': {
        'videoCodec': 'x265',
        'audioCodec': 'TrueHD Atmos',
        'audioChannels': 7.1,
        'resolution': '2160p',
        'videoDynamicRangeType': 'HDR10',
      },
    });

    expect(file.releaseGroup, 'TERMiNAL');
    expect(file.mediaInfo?.videoCodec, 'x265');
    expect(file.mediaInfo?.audioCodec, 'TrueHD Atmos');
    expect(file.mediaInfo?.audioChannels, 7.1);
    expect(file.mediaInfo?.resolution, '2160p');
    expect(file.mediaInfo?.videoDynamicRangeType, 'HDR10');
  });

  test('RadarrMovieFile tolerates a missing mediaInfo/releaseGroup', () {
    final file = RadarrMovieFile.fromJson({'id': 1, 'size': 0});
    expect(file.releaseGroup, isNull);
    expect(file.mediaInfo, isNull);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/services/sonarr/models/sonarr_models_test.dart test/services/radarr/models/radarr_models_test.dart`
Expected: FAIL — `releaseGroup`/`mediaInfo` getters don't exist yet.

- [ ] **Step 4: Extend the models**

In `lib/services/sonarr/models/sonarr_models.dart`, replace the `SonarrEpisodeFile` class (currently lines 177–188) with:

```dart
@freezed
abstract class SonarrEpisodeFile with _$SonarrEpisodeFile {
  const factory SonarrEpisodeFile({
    required int id,
    String? relativePath,
    @Default(0) int size,
    DateTime? dateAdded,
    SonarrQualityInfo? quality,
    String? releaseGroup,
    SonarrMediaInfo? mediaInfo,
  }) = _SonarrEpisodeFile;

  factory SonarrEpisodeFile.fromJson(Map<String, dynamic> json) =>
      _$SonarrEpisodeFileFromJson(json);
}

/// Technical media details Sonarr extracts from the file (spec 2f "FILE").
@freezed
abstract class SonarrMediaInfo with _$SonarrMediaInfo {
  const factory SonarrMediaInfo({
    String? videoCodec,
    String? audioCodec,
    double? audioChannels,
  }) = _SonarrMediaInfo;

  factory SonarrMediaInfo.fromJson(Map<String, dynamic> json) =>
      _$SonarrMediaInfoFromJson(json);
}
```

In `lib/services/radarr/models/radarr_models.dart`, replace the `RadarrMovieFile` class (currently lines 116–127) with:

```dart
@freezed
abstract class RadarrMovieFile with _$RadarrMovieFile {
  const factory RadarrMovieFile({
    required int id,
    String? relativePath,
    int? size,
    DateTime? dateAdded,
    RadarrQualityInfo? quality,
    String? releaseGroup,
    RadarrMediaInfo? mediaInfo,
  }) = _RadarrMovieFile;

  factory RadarrMovieFile.fromJson(Map<String, dynamic> json) =>
      _$RadarrMovieFileFromJson(json);
}

/// Technical media details Radarr extracts from the file (spec 2g "FILE").
@freezed
abstract class RadarrMediaInfo with _$RadarrMediaInfo {
  const factory RadarrMediaInfo({
    String? videoCodec,
    String? audioCodec,
    double? audioChannels,
    String? resolution,
    String? videoDynamicRangeType,
  }) = _RadarrMediaInfo;

  factory RadarrMediaInfo.fromJson(Map<String, dynamic> json) =>
      _$RadarrMediaInfoFromJson(json);
}
```

- [ ] **Step 5: Regenerate code-gen**

Run: `dart run build_runner build --delete-conflicting-outputs`

- [ ] **Step 6: Run tests to verify they pass**

Run: `flutter test test/services/sonarr/models/sonarr_models_test.dart test/services/radarr/models/radarr_models_test.dart`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add lib/services/sonarr/models/sonarr_models.dart lib/services/sonarr/models/sonarr_models.g.dart lib/services/sonarr/models/sonarr_models.freezed.dart lib/services/radarr/models/radarr_models.dart lib/services/radarr/models/radarr_models.g.dart lib/services/radarr/models/radarr_models.freezed.dart test/services/sonarr/models/sonarr_models_test.dart test/services/radarr/models/radarr_models_test.dart
git commit -m "feat(services): parse releaseGroup/mediaInfo on episode and movie files"
```

---

### Task 5: `MediaDetailHeader` shared widget

**Files:**
- Create: `lib/features/library/widgets/media_detail_header.dart`
- Test: `test/features/library/widgets/media_detail_header_test.dart`

**Interfaces:**
- Consumes: `ResolvedPoster` (`lib/core/widgets/resolved_poster.dart`, `ServiceType service, String instanceId, String? relativeUrl, double width, double height, double radius`).
- Produces:
  ```dart
  class MediaDetailHeader extends StatelessWidget {
    const MediaDetailHeader({
      required this.service,
      required this.instanceId,
      required this.posterUrl,
      required this.title,
      required this.metaParts,
      required this.chips,
      required this.stats,
      super.key,
    });
    final ServiceType service;
    final String instanceId;
    final String? posterUrl;
    final String title;
    final List<String> metaParts;
    final List<Widget> chips;
    final List<(String value, String caption)> stats; // exactly 2 entries
  }
  ```
  Consumed by Task 15 (series detail) and Task 17 (movie detail).

- [ ] **Step 1: Write the failing test**

```dart
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title, meta, chips, and both stats', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaDetailHeader(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            posterUrl: null,
            title: 'Severance',
            metaParts: const ['2022', 'Apple TV+', 'TV-MA'],
            chips: const [Text('★ 8.7'), Text('Monitored')],
            stats: const [('19/19', 'EPISODES'), ('61 GB', 'ON DISK')],
          ),
        ),
      ),
    );

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('2022 · Apple TV+ · TV-MA'), findsOneWidget);
    expect(find.text('★ 8.7'), findsOneWidget);
    expect(find.text('Monitored'), findsOneWidget);
    expect(find.text('19/19'), findsOneWidget);
    expect(find.text('EPISODES'), findsOneWidget);
    expect(find.text('61 GB'), findsOneWidget);
    expect(find.text('ON DISK'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/library/widgets/media_detail_header_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 3: Implement**

```dart
/// The poster-beside-title detail header shared by series (2e) and movie
/// (2g) detail screens: a 104x156 poster left, then title/meta/chips/a
/// 2-up stat row right. Replaces the old centered-poster layout.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:flutter/material.dart';

class MediaDetailHeader extends StatelessWidget {
  const MediaDetailHeader({
    required this.service,
    required this.instanceId,
    required this.posterUrl,
    required this.title,
    required this.metaParts,
    required this.chips,
    required this.stats,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final String? posterUrl;
  final String title;
  final List<String> metaParts;
  final List<Widget> chips;

  /// Exactly two (value, caption) pairs, e.g. ("19/19", "EPISODES").
  final List<(String value, String caption)> stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResolvedPoster(
          service: service,
          instanceId: instanceId,
          relativeUrl: posterUrl,
          width: 104,
          height: 156,
          radius: AppRadius.md,
        ),
        const SizedBox(width: AppSpacing.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.sectionTitle),
              if (metaParts.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space2),
                Text(
                  metaParts.join(' · '),
                  style: AppTypography.meta.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (chips.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space3),
                Wrap(
                  spacing: AppSpacing.space2,
                  runSpacing: AppSpacing.space2,
                  children: chips,
                ),
              ],
              const SizedBox(height: AppSpacing.space4),
              Row(
                children: [
                  for (final (value, caption) in stats)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.space6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(value, style: AppTypography.statNumeral),
                          Text(caption, style: AppTypography.statCaption),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/library/widgets/media_detail_header_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/library/widgets/media_detail_header.dart test/features/library/widgets/media_detail_header_test.dart
git commit -m "feat(library): add MediaDetailHeader shared widget"
```

---

### Task 6: `SeasonRow` + `EpisodeRow` widgets

**Files:**
- Create: `lib/features/library/widgets/season_row.dart`
- Test: `test/features/library/widgets/season_row_test.dart`

**Interfaces:**
- Produces:
  ```dart
  class SeasonRow extends StatefulWidget {
    const SeasonRow({
      required this.label,
      required this.have,
      required this.total,
      required this.episodes,
      this.initiallyExpanded = false,
      super.key,
    });
    final String label;
    final int have;
    final int total;
    final Widget Function(BuildContext) episodes;
    final bool initiallyExpanded;
  }

  class EpisodeRow extends StatelessWidget {
    const EpisodeRow({
      required this.code,
      required this.title,
      required this.hasFile,
      required this.qualityLabel,
      super.key,
    });
    final String code;
    final String title;
    final bool hasFile;
    final String? qualityLabel; // shown as a tag-neutral chip when hasFile
  }
  ```
  Consumed by Task 15 (series detail).

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:arrstack/features/library/widgets/season_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeasonRow', () {
    testWidgets('shows label and have/total, collapsed by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeasonRow(
              label: 'Season 2',
              have: 10,
              total: 10,
              episodes: (_) => const Text('episode list'),
            ),
          ),
        ),
      );

      expect(find.text('Season 2'), findsOneWidget);
      expect(find.text('10/10'), findsOneWidget);
      expect(find.text('episode list'), findsNothing);
    });

    testWidgets('expands to show episodes on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SeasonRow(
              label: 'Season 2',
              have: 10,
              total: 10,
              episodes: (_) => const Text('episode list'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Season 2'));
      await tester.pumpAndSettle();

      expect(find.text('episode list'), findsOneWidget);
    });
  });

  group('EpisodeRow', () {
    testWidgets('shows code, title, and quality when downloaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EpisodeRow(
              code: 'S02E05',
              title: 'The You You Are',
              hasFile: true,
              qualityLabel: 'WEBDL-1080p',
            ),
          ),
        ),
      );

      expect(find.text('S02E05'), findsOneWidget);
      expect(find.text('The You You Are'), findsOneWidget);
      expect(find.text('WEBDL-1080p'), findsOneWidget);
      expect(find.text('Missing'), findsNothing);
    });

    testWidgets('shows "Missing" when not downloaded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EpisodeRow(
              code: 'S01E08',
              title: 'Unknown Episode',
              hasFile: false,
              qualityLabel: null,
            ),
          ),
        ),
      );

      expect(find.text('Missing'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/library/widgets/season_row_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 3: Implement**

```dart
/// Collapsible season row and its indented episode rows (spec 2e
/// "SEASONS"). Replaces the old `_SeasonTile`/`_SeasonEpisodes`/
/// `_EpisodeCard`/`_CountPill` private classes.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SeasonRow extends StatefulWidget {
  const SeasonRow({
    required this.label,
    required this.have,
    required this.total,
    required this.episodes,
    this.initiallyExpanded = false,
    super.key,
  });

  final String label;
  final int have;
  final int total;
  final Widget Function(BuildContext) episodes;
  final bool initiallyExpanded;

  @override
  State<SeasonRow> createState() => _SeasonRowState();
}

class _SeasonRowState extends State<SeasonRow> {
  late bool _expanded = widget.initiallyExpanded;

  Color _countColor() {
    if (widget.total > 0 && widget.have >= widget.total) return AppColors.up;
    if (widget.have == 0) return AppColors.down;
    return AppColors.a300;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = widget.total > 0 ? widget.have / widget.total : 0.0;
    final countColor = _countColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
            child: Row(
              children: [
                Icon(
                  _expanded
                      ? PhosphorIconsRegular.caretDown
                      : PhosphorIconsRegular.caretRight,
                  size: 12,
                  color: _expanded ? colorScheme.primary : AppColors.n500,
                ),
                const SizedBox(width: AppSpacing.space2),
                Expanded(
                  child: Text(
                    widget.label,
                    style: AppTypography.cardTitle.copyWith(
                      color: _expanded
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.n800,
                      valueColor: AlwaysStoppedAnimation(countColor),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space2),
                SizedBox(
                  width: 38,
                  child: Text(
                    '${widget.have}/${widget.total}',
                    textAlign: TextAlign.right,
                    style: AppTypography.meta.copyWith(
                      color: countColor,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Builder(builder: widget.episodes),
          ),
      ],
    );
  }
}

class EpisodeRow extends StatelessWidget {
  const EpisodeRow({
    required this.code,
    required this.title,
    required this.hasFile,
    required this.qualityLabel,
    super.key,
  });

  final String code;
  final String title;
  final bool hasFile;
  final String? qualityLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = hasFile ? colorScheme.onSurface : AppColors.n500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              code,
              style: AppTypography.meta.copyWith(
                color: hasFile ? colorScheme.primary : AppColors.n500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle.copyWith(color: textColor),
            ),
          ),
          if (hasFile && qualityLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.n900,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                qualityLabel!,
                style: AppTypography.meta.copyWith(color: AppColors.n300),
              ),
            )
          else if (!hasFile)
            Text(
              'Missing',
              style: AppTypography.meta.copyWith(color: AppColors.down),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/library/widgets/season_row_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/library/widgets/season_row.dart test/features/library/widgets/season_row_test.dart
git commit -m "feat(library): add SeasonRow and EpisodeRow widgets"
```

---

### Task 7: `LibraryRow` widget (replaces `MediaListTile`)

**Files:**
- Create: `lib/features/library/widgets/library_row.dart`
- Delete: `lib/features/library/widgets/media_list_tile.dart`
- Test: `test/features/library/widgets/library_row_test.dart`
- Delete-if-present: `test/features/library/widgets/media_list_tile_test.dart` (check first)

**Interfaces:**
- Consumes: `FadingRule` (Task 2), `ResolvedPoster`.
- Produces:
  ```dart
  enum LibraryRowTrailing { none, percent, progress, unmonitored }

  class LibraryRow extends StatelessWidget {
    const LibraryRow({
      required this.service,
      required this.instanceId,
      required this.title,
      required this.metaParts,
      required this.trailing,
      this.posterUrl,
      this.percent,      // 0-100, used when trailing == percent
      this.progress,     // 0.0-1.0, used when trailing == progress
      this.trailingText, // e.g. quality tag text for Movies rows
      this.onTap,
      this.showRule = true,
      super.key,
    });
  }
  ```
  Consumed by Tasks 13–14 (`SeriesList`/`MovieList`).

- [ ] **Step 1: Check for an existing test file to remove**

Run: `find test/features/library -iname "media_list_tile_test.dart"`
If found, delete it in Step 5 alongside the source file.

- [ ] **Step 2: Write the failing tests**

```dart
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('percent trailing shows the percentage in green', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            title: 'Severance',
            metaParts: const ['2022 · Apple TV+ · 19/19'],
            trailing: LibraryRowTrailing.percent,
            percent: 100,
          ),
        ),
      ),
    );

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('progress trailing shows a progress bar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            title: 'The Simpsons',
            metaParts: const ['30/296'],
            trailing: LibraryRowTrailing.progress,
            progress: 0.10,
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('unmonitored trailing dims the row and shows a bookmark', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.sonarr,
            instanceId: 'inst-1',
            title: 'Andor',
            metaParts: const ['Unmonitored'],
            trailing: LibraryRowTrailing.unmonitored,
          ),
        ),
      ),
    );

    expect(find.text('Unmonitored'), findsOneWidget);

    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 0.62);
  });

  testWidgets('renders a FadingRule separator by default', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LibraryRow(
            service: ServiceType.radarr,
            instanceId: 'inst-1',
            title: 'Dune: Part Two',
            metaParts: const ['54.2 GB'],
            trailing: LibraryRowTrailing.none,
            trailingText: '2160p',
          ),
        ),
      ),
    );

    expect(find.byType(FadingRule), findsOneWidget);
    expect(find.text('2160p'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/features/library/widgets/library_row_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 4: Implement**

```dart
/// A fading-rule-separated library row (spec 2d "ALL SHOWS"/"RECENTLY
/// ADDED"): 36x54 poster, title + tabular meta, and a state-aware
/// trailing indicator. Replaces `MediaListTile`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

enum LibraryRowTrailing { none, percent, progress, unmonitored }

class LibraryRow extends StatelessWidget {
  const LibraryRow({
    required this.service,
    required this.instanceId,
    required this.title,
    required this.metaParts,
    required this.trailing,
    this.posterUrl,
    this.percent,
    this.progress,
    this.trailingText,
    this.onTap,
    this.showRule = true,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final String? posterUrl;
  final String title;
  final List<String> metaParts;
  final LibraryRowTrailing trailing;
  final int? percent;
  final double? progress;
  final String? trailingText;
  final VoidCallback? onTap;
  final bool showRule;

  @override
  Widget build(BuildContext context) {
    final isUnmonitored = trailing == LibraryRowTrailing.unmonitored;
    final row = InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isUnmonitored)
              const SizedBox(
                width: 36,
                height: 54,
                child: Icon(
                  PhosphorIconsRegular.bookmarkSimple,
                  color: AppColors.n600,
                ),
              )
            else
              ResolvedPoster(
                service: service,
                instanceId: instanceId,
                relativeUrl: posterUrl,
                width: 36,
                height: 54,
                radius: AppRadius.sm,
              ),
            const SizedBox(width: AppSpacing.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle,
                  ),
                  if (metaParts.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      metaParts.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.meta.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            _Trailing(
              trailing: trailing,
              percent: percent,
              progress: progress,
              trailingText: trailingText,
            ),
          ],
        ),
      ),
    );

    final content = isUnmonitored ? Opacity(opacity: 0.62, child: row) : row;

    if (!showRule) return content;
    return Column(children: [content, const FadingRule()]);
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.trailing,
    required this.percent,
    required this.progress,
    required this.trailingText,
  });

  final LibraryRowTrailing trailing;
  final int? percent;
  final double? progress;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    switch (trailing) {
      case LibraryRowTrailing.percent:
        return Text(
          '${percent ?? 0}%',
          style: AppTypography.meta.copyWith(
            color: AppColors.up,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      case LibraryRowTrailing.progress:
        return SizedBox(
          width: 52,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress ?? 0,
              minHeight: 4,
              backgroundColor: AppColors.n800,
              valueColor: const AlwaysStoppedAnimation(AppColors.a300),
            ),
          ),
        );
      case LibraryRowTrailing.unmonitored:
        return Text(
          'Unmonitored',
          style: AppTypography.meta.copyWith(color: AppColors.n500),
        );
      case LibraryRowTrailing.none:
        if (trailingText == null) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.up.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Text(
            trailingText!,
            style: AppTypography.meta.copyWith(color: AppColors.up),
          ),
        );
    }
  }
}
```

- [ ] **Step 5: Run tests, then delete the old file**

Run: `flutter test test/features/library/widgets/library_row_test.dart`
Expected: PASS

```bash
git rm lib/features/library/widgets/media_list_tile.dart
# and the old test file too, if Step 1 found one:
# git rm test/features/library/widgets/media_list_tile_test.dart
```

- [ ] **Step 6: Commit**

```bash
git add lib/features/library/widgets/library_row.dart test/features/library/widgets/library_row_test.dart
git commit -m "feat(library): replace MediaListTile with LibraryRow"
```

---

### Task 8: `CollectionChips` widget (Shows/Movies switch)

**Files:**
- Create: `lib/features/library/widgets/collection_chips.dart`
- Test: `test/features/library/widgets/collection_chips_test.dart`

**Interfaces:**
- Consumes: `ActiveLibraryTab`/`activeLibraryTabProvider` (`lib/features/library/library_providers.dart`, already exists — `LibraryTab { tvShows, movies }`, `.select(tab)`).
- Produces: `class CollectionChips extends ConsumerWidget` — `const CollectionChips({required this.showsCount, required this.moviesCount, super.key})`. Consumed by Task 13 (`library_page.dart`).

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/collection_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows both chips with inline counts', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CollectionChips(showsCount: 68, moviesCount: 412),
          ),
        ),
      ),
    );

    expect(find.text('Shows 68'), findsOneWidget);
    expect(find.text('Movies 412'), findsOneWidget);
  });

  testWidgets('tapping Movies switches the active tab', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: CollectionChips(showsCount: 68, moviesCount: 412),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Movies 412'));
    await tester.pump();

    expect(container.read(activeLibraryTabProvider), LibraryTab.movies);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/library/widgets/collection_chips_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 3: Implement**

```dart
/// The Shows/Movies switch (README "Shared shell" -> "Lens chips", spec
/// 2d): built to the same visual spec as Activity's LensChips but kept
/// Library-local since LensChips is hardwired to Activity's own provider.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionChips extends ConsumerWidget {
  const CollectionChips({
    required this.showsCount,
    required this.moviesCount,
    super.key,
  });

  final int showsCount;
  final int moviesCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeLibraryTabProvider);

    return Row(
      children: [
        _Chip(
          label: 'Shows $showsCount',
          isActive: active == LibraryTab.tvShows,
          onTap: () => ref
              .read(activeLibraryTabProvider.notifier)
              .select(LibraryTab.tvShows),
        ),
        const SizedBox(width: AppSpacing.space2),
        _Chip(
          label: 'Movies $moviesCount',
          isActive: active == LibraryTab.movies,
          onTap: () => ref
              .read(activeLibraryTabProvider.notifier)
              .select(LibraryTab.movies),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isActive
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isActive ? Border.all(color: color) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/library/widgets/collection_chips_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/library/widgets/collection_chips.dart test/features/library/widgets/collection_chips_test.dart
git commit -m "feat(library): add CollectionChips Shows/Movies switch"
```

---

### Task 9: `RadarrRepository`/`RadarrClient.searchMovies` bulk command

**Files:**
- Modify: `lib/services/radarr/radarr_client.dart:246` (add method after `getQueue`, before the class's closing brace)
- Modify: `lib/services/radarr/radarr_repository.dart:29-31` (add method after `deleteMovie`)
- Test: `test/services/radarr/radarr_missing_search_test.dart` (new)

**Interfaces:**
- Produces: `RadarrRepository.searchMovies(List<int> movieIds) -> Future<Result<void>>`. Consumed by Task 14 (`MovieList`'s "Search all").

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:arrstack/services/radarr/radarr_client.dart';
import 'package:arrstack/services/radarr/radarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late RadarrRepository repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    repo = RadarrRepository(RadarrClient(dio));
  });

  test(
    'searchMovies posts a MoviesSearch command with the given IDs',
    () async {
      adapter.onPost(
        'api/v3/command',
        (server) => server.reply(201, <String, dynamic>{}),
        data: {
          'name': 'MoviesSearch',
          'movieIds': [1, 2, 3],
        },
      );

      final result = await repo.searchMovies([1, 2, 3]);

      expect(result.isOk, isTrue);
    },
  );

  test('searchMovies propagates an Err from the client', () async {
    adapter.onPost(
      'api/v3/command',
      (server) => server.reply(500, {'message': 'boom'}),
      data: {
        'name': 'MoviesSearch',
        'movieIds': [1],
      },
    );

    final result = await repo.searchMovies([1]);

    expect(result.isErr, isTrue);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/services/radarr/radarr_missing_search_test.dart`
Expected: FAIL — `searchMovies` isn't defined yet.

- [ ] **Step 3: Add the client method**

In `lib/services/radarr/radarr_client.dart`, add before the final closing `}` of the class (after `getQueue`):

```dart

  /// Triggers an automatic search for the given movies (spec 2d "Search
  /// all" on the Missing section).
  Future<Result<void>> searchMovies(List<int> movieIds) {
    return dioCall(
      () => _dio.post(
        'api/v3/command',
        data: {'name': 'MoviesSearch', 'movieIds': movieIds},
      ),
      map: (_) {},
    );
  }
```

- [ ] **Step 4: Add the repository method**

In `lib/services/radarr/radarr_repository.dart`, add after `deleteMovie`:

```dart

  Future<Result<void>> searchMovies(List<int> movieIds) =>
      _client.searchMovies(movieIds);
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/services/radarr/radarr_missing_search_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/services/radarr/radarr_client.dart lib/services/radarr/radarr_repository.dart test/services/radarr/radarr_missing_search_test.dart
git commit -m "feat(radarr): add bulk MoviesSearch command for missing movies"
```

---

### Task 10: `continueWatchingProvider` and caption helper

**Files:**
- Create: `lib/features/library/continue_watching.dart` (pure model + caption helper, no Riverpod — kept separate from `library_providers.dart` so the pure logic is trivially unit-testable)
- Modify: `lib/features/library/library_providers.dart` (add the `@riverpod` provider)
- Test: `test/features/library/continue_watching_test.dart`
- Test: `test/features/library/library_providers_test.dart` (new, or extend if one exists — check first)

**Interfaces:**
- Consumes: `sonarrRepositoryProvider(instanceId)` (`.future` -> `SonarrRepository`), `SonarrRepository.listCalendar(DateTime, DateTime) -> Future<Result<List<SonarrCalendarEpisode>>>`, `sonarrSeriesProvider(instanceId)` (`AsyncValue<Result<List<SonarrSeries>>>`).
- Produces:
  ```dart
  class ContinueWatchingEntry {
    const ContinueWatchingEntry({
      required this.series,
      required this.caption,
      required this.referenceDate,
    });
    final SonarrSeries series;
    final String caption;
    final DateTime referenceDate;
  }

  String continueWatchingCaption(DateTime episodeDate, DateTime now);

  @riverpod
  Future<List<ContinueWatchingEntry>> continueWatching(Ref ref, String instanceId);
  ```
  Consumed by Task 11 (`ContinueWatchingRow`) and Task 13 (`library_page.dart`).

- [ ] **Step 1: Check for an existing providers test file**

Run: `find test/features/library -iname "library_providers_test.dart"`
If found, add the new provider's test group to it instead of creating a new file.

- [ ] **Step 2: Write the failing test for the pure caption helper**

`test/features/library/continue_watching_test.dart`:

```dart
import 'package:arrstack/features/library/continue_watching.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('continueWatchingCaption', () {
    final now = DateTime(2026, 9, 12, 15, 0); // Saturday, 3 PM

    test('today, not yet aired -> hour label', () {
      final date = DateTime(2026, 9, 12, 21, 0); // 9 PM same day
      expect(continueWatchingCaption(date, now), '9 PM');
    });

    test('today, already aired -> "today"', () {
      final date = DateTime(2026, 9, 12, 9, 0); // 9 AM same day, already past
      expect(continueWatchingCaption(date, now), 'today');
    });

    test('tomorrow -> "tomorrow"', () {
      final date = DateTime(2026, 9, 13, 21, 0);
      expect(continueWatchingCaption(date, now), 'tomorrow');
    });

    test('within the next week -> "next <Weekday>"', () {
      final date = DateTime(2026, 9, 18, 21, 0); // following Friday
      expect(continueWatchingCaption(date, now), 'next Friday');
    });

    test('in the past -> relative "aired" label', () {
      final date = DateTime(2026, 9, 10, 21, 0); // 2 days ago
      expect(continueWatchingCaption(date, now), contains('ago'));
    });
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/library/continue_watching_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 4: Implement the pure helper and model**

```dart
/// Pure logic backing the Library "Continue watching" row (spec 2d):
/// which shows qualify, and how to caption the nearest episode. Kept
/// dependency-free so it's testable without Riverpod or a widget tree.
library;

import 'package:arrstack/services/sonarr/models/sonarr_models.dart';

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class ContinueWatchingEntry {
  const ContinueWatchingEntry({
    required this.series,
    required this.caption,
    required this.referenceDate,
  });

  final SonarrSeries series;
  final String caption;
  final DateTime referenceDate;
}

/// True for a series with some but not all episodes downloaded — the
/// "actively watching" state this row surfaces.
bool hasPartialProgress(SonarrSeries series) {
  final stats = series.statistics;
  final have = stats?.episodeFileCount ?? 0;
  final total = stats?.totalEpisodeCount ?? 0;
  return total > 0 && have > 0 && have < total;
}

/// "9 PM" (later today), "today" (already aired today), "tomorrow",
/// "next Friday" (2-6 days out), or a relative "aired Nd ago" label for
/// the past. [episodeDate] and [now] are both local time.
String continueWatchingCaption(DateTime episodeDate, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final entryDay = DateTime(
    episodeDate.year,
    episodeDate.month,
    episodeDate.day,
  );
  final dayDiff = entryDay.difference(today).inDays;

  if (dayDiff == 0) {
    if (episodeDate.isAfter(now)) return _hourLabel(episodeDate);
    return 'today';
  }
  if (dayDiff == 1) return 'tomorrow';
  if (dayDiff > 1 && dayDiff <= 6) {
    return 'next ${_weekdayNames[entryDay.weekday - 1]}';
  }
  if (dayDiff < 0) {
    final agoDays = -dayDiff;
    return agoDays == 1 ? 'aired yesterday' : 'aired ${agoDays}d ago';
  }
  return 'in ${dayDiff}d';
}

String _hourLabel(DateTime date) {
  final isPm = date.hour >= 12;
  var hour = date.hour % 12;
  if (hour == 0) hour = 12;
  return '$hour ${isPm ? 'PM' : 'AM'}';
}

/// Picks the calendar entry closest to [now] for one series: the nearest
/// future airing if any exists, else the most recent past one. Returns
/// null when [episodes] is empty (series has nothing in the window).
SonarrCalendarEpisode? nearestEpisode(
  List<SonarrCalendarEpisode> episodes,
  DateTime now,
) {
  if (episodes.isEmpty) return null;

  SonarrCalendarEpisode? bestFuture;
  SonarrCalendarEpisode? bestPast;
  for (final ep in episodes) {
    final date = ep.airDateUtc?.toLocal();
    if (date == null) continue;
    if (date.isAfter(now)) {
      if (bestFuture == null ||
          date.isBefore(bestFuture.airDateUtc!.toLocal())) {
        bestFuture = ep;
      }
    } else {
      if (bestPast == null || date.isAfter(bestPast.airDateUtc!.toLocal())) {
        bestPast = ep;
      }
    }
  }
  return bestFuture ?? bestPast;
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/library/continue_watching_test.dart`
Expected: PASS

- [ ] **Step 6: Write the failing provider test**

`test/features/library/library_providers_test.dart`:

```dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_client.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('continueWatching caps at 3, ordered soonest-airing first', () async {
    final dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    final adapter = DioAdapter(dio: dio);
    final repo = SonarrRepository(SonarrClient(dio));

    adapter.onGet(
      RegExp('api/v3/calendar.*'),
      (server) => server.reply(200, [
        {
          'id': 1,
          'seriesId': 10,
          'seasonNumber': 2,
          'episodeNumber': 5,
          'airDateUtc': DateTime.now()
              .add(const Duration(days: 2))
              .toUtc()
              .toIso8601String(),
          'hasFile': false,
          'monitored': true,
        },
      ]),
    );

    final container = ProviderContainer(
      overrides: [
        sonarrRepositoryProvider('inst-1').overrideWith((ref) async => repo),
        sonarrSeriesProvider('inst-1').overrideWith(
          (ref) async => Ok([
            SonarrSeries(
              id: 10,
              title: 'Severance',
              statistics: const SonarrStatistics(
                episodeFileCount: 10,
                totalEpisodeCount: 19,
              ),
            ),
            SonarrSeries(
              id: 11,
              title: 'Fully Downloaded Show',
              statistics: const SonarrStatistics(
                episodeFileCount: 5,
                totalEpisodeCount: 5,
              ),
            ),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);

    final entries = await container.read(
      continueWatchingProvider('inst-1').future,
    );

    expect(entries, hasLength(1));
    expect(entries.single.series.title, 'Severance');
  });
}
```

- [ ] **Step 7: Run test to verify it fails**

Run: `flutter test test/features/library/library_providers_test.dart`
Expected: FAIL — `continueWatchingProvider` isn't defined yet.

- [ ] **Step 8: Add the provider**

In `lib/features/library/library_providers.dart`, add the imports:

```dart
import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
```

and the provider itself:

```dart

/// Shows with partial download progress and an episode air date within
/// the window, nearest-airing first, capped at 3 (spec 2d "CONTINUE
/// WATCHING"). Omits a series with no calendar entry in the window
/// rather than erroring — this row is a convenience surface.
@riverpod
Future<List<ContinueWatchingEntry>> continueWatching(
  Ref ref,
  String instanceId,
) async {
  final seriesResult = await ref.watch(
    sonarrSeriesProvider(instanceId).future,
  );
  if (seriesResult is! Ok<List<SonarrSeries>>) return const [];
  final partial = seriesResult.value.where(hasPartialProgress).toList();
  if (partial.isEmpty) return const [];

  final repo = await ref.watch(sonarrRepositoryProvider(instanceId).future);
  final now = DateTime.now();
  final calendarResult = await repo.listCalendar(
    now.subtract(const Duration(days: 7)),
    now.add(const Duration(days: 14)),
  );
  if (calendarResult is! Ok<List<SonarrCalendarEpisode>>) return const [];

  final bySeriesId = <int, List<SonarrCalendarEpisode>>{};
  for (final ep in calendarResult.value) {
    final id = ep.seriesId;
    if (id != null) (bySeriesId[id] ??= []).add(ep);
  }

  final entries = <ContinueWatchingEntry>[];
  for (final series in partial) {
    final episodes = bySeriesId[series.id] ?? const [];
    final nearest = nearestEpisode(episodes, now);
    if (nearest?.airDateUtc == null) continue;
    final date = nearest!.airDateUtc!.toLocal();
    final code =
        nearest.seasonNumber != null && nearest.episodeNumber != null
        ? 'S${nearest.seasonNumber.toString().padLeft(2, '0')}'
              'E${nearest.episodeNumber.toString().padLeft(2, '0')} · '
        : '';
    entries.add(
      ContinueWatchingEntry(
        series: series,
        caption: '$code${continueWatchingCaption(date, now)}',
        referenceDate: date,
      ),
    );
  }

  entries.sort((a, b) => a.referenceDate.compareTo(b.referenceDate));
  return entries.take(3).toList();
}
```

- [ ] **Step 9: Regenerate code-gen and run tests**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/library/continue_watching_test.dart test/features/library/library_providers_test.dart`
Expected: PASS

- [ ] **Step 10: Commit**

```bash
git add lib/features/library/continue_watching.dart lib/features/library/library_providers.dart lib/features/library/library_providers.g.dart test/features/library/continue_watching_test.dart test/features/library/library_providers_test.dart
git commit -m "feat(library): add continueWatchingProvider from Sonarr calendar data"
```

---

### Task 11: `ContinueWatchingRow` widget

**Files:**
- Create: `lib/features/library/widgets/continue_watching_row.dart`
- Test: `test/features/library/widgets/continue_watching_row_test.dart`

**Interfaces:**
- Consumes: `ContinueWatchingEntry` (Task 10), `ResolvedPoster`.
- Produces: `class ContinueWatchingRow extends StatelessWidget` — `const ContinueWatchingRow({required this.instanceId, required this.entries, super.key})`. Renders nothing when `entries` is empty. Consumed by Task 13 (`library_page.dart`).

- [ ] **Step 1: Write the failing tests**

```dart
import 'package:arrstack/features/library/continue_watching.dart';
import 'package:arrstack/features/library/widgets/continue_watching_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a kicker and one card per entry', (tester) async {
    final entries = [
      ContinueWatchingEntry(
        series: const SonarrSeries(id: 1, title: 'Severance'),
        caption: 'S02E05 · next Fri',
        referenceDate: DateTime(2026, 9, 18),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ContinueWatchingRow(instanceId: 'inst-1', entries: entries),
        ),
      ),
    );

    expect(find.text('CONTINUE WATCHING'), findsOneWidget);
    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('S02E05 · next Fri'), findsOneWidget);
  });

  testWidgets('renders nothing when entries is empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ContinueWatchingRow(instanceId: 'inst-1', entries: []),
        ),
      ),
    );

    expect(find.text('CONTINUE WATCHING'), findsNothing);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/library/widgets/continue_watching_row_test.dart`
Expected: FAIL — file doesn't exist yet.

- [ ] **Step 3: Implement**

```dart
/// The "CONTINUE WATCHING" horizontal poster row (spec 2d): three 88px
/// cards with a 132px poster and a tabular status caption below the
/// title. Renders nothing when there's nothing to show.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:arrstack/features/library/continue_watching.dart';
import 'package:flutter/material.dart';

class ContinueWatchingRow extends StatelessWidget {
  const ContinueWatchingRow({
    required this.instanceId,
    required this.entries,
    super.key,
  });

  final String instanceId;
  final List<ContinueWatchingEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('CONTINUE WATCHING', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space4),
        SizedBox(
          height: 132 + AppSpacing.space2 + 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.space4),
            itemBuilder: (context, index) =>
                _Card(instanceId: instanceId, entry: entries[index]),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.instanceId, required this.entry});

  final String instanceId;
  final ContinueWatchingEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResolvedPoster(
            service: ServiceType.sonarr,
            instanceId: instanceId,
            relativeUrl: entry.series.posterUrl,
            width: 88,
            height: 132,
            radius: AppRadius.md,
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            entry.series.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle.copyWith(fontSize: 11.5),
          ),
          Text(
            entry.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.meta.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/features/library/widgets/continue_watching_row_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/features/library/widgets/continue_watching_row.dart test/features/library/widgets/continue_watching_row_test.dart
git commit -m "feat(library): add ContinueWatchingRow widget"
```

---

### Task 12: `ActiveLibrarySort` session state and the Shows-tab sort toggle

**Scope note:** this is the Library Shows tab's "Recently added ⌄" toggle
only (spec 2d, the "ALL SHOWS" row). Series detail's separate "Newest
first ⌄" toggle (spec 2e, ordering that page's own season list) is a
different, page-local concern with no shared state — it's added directly
in Task 15 as local widget state, not through this provider.

**Files:**
- Modify: `lib/features/library/library_providers.dart`
- Modify: `lib/features/library/widgets/series_list.dart` (apply the sort)
- Test: `test/features/library/library_providers_test.dart` (extend the file from Task 10)
- Test: `test/features/library/widgets/series_list_test.dart` (extend the file from Task 13 — write this task's series_list.dart changes after Task 13 lands; if executing in a fresh worktree per task, rebase/cherry-pick order must put Task 13 before Task 12's `series_list.dart` edit, or fold this task's `series_list.dart` change directly into Task 13 instead. Either ordering is fine — call out which one you used in the commit message.)

**Interfaces:**
- Produces:
  ```dart
  enum LibrarySort { recentlyAdded, title, year }

  @riverpod
  class ActiveLibrarySort extends _$ActiveLibrarySort {
    @override
    LibrarySort build() => LibrarySort.recentlyAdded;
    void select(LibrarySort sort);
  }
  ```
  Consumed by `SeriesList` (sort application) and `_SeriesTabBody` in `library_page.dart` (the tappable toggle label). If Task 13 already landed by the time this task runs, thread the sort in directly rather than re-deriving it — `SeriesList` gains a third optional constructor param `sort` (`LibrarySort`, default `LibrarySort.recentlyAdded`) alongside the `shrinkWrap`/`physics` params Task 13 added.

- [ ] **Step 1: Write the failing test**

Add to `test/features/library/library_providers_test.dart`:

```dart
test(
  'ActiveLibrarySort defaults to recentlyAdded and updates on select',
  () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(activeLibrarySortProvider),
      LibrarySort.recentlyAdded,
    );

    container
        .read(activeLibrarySortProvider.notifier)
        .select(LibrarySort.title);

    expect(container.read(activeLibrarySortProvider), LibrarySort.title);
  },
);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/library/library_providers_test.dart`
Expected: FAIL — `LibrarySort`/`activeLibrarySortProvider` don't exist yet.

- [ ] **Step 3: Implement**

Add to `lib/features/library/library_providers.dart`:

```dart

/// Sort order for the Shows/Movies row lists (spec 2d "Recently added
/// v" / "Newest first v" toggles and the sort/filter chip). Session-only,
/// no persistence — mirrors ActiveActivityLens's pattern.
enum LibrarySort { recentlyAdded, title, year }

@riverpod
class ActiveLibrarySort extends _$ActiveLibrarySort {
  @override
  LibrarySort build() => LibrarySort.recentlyAdded;

  void select(LibrarySort sort) => state = sort;
}
```

- [ ] **Step 4: Regenerate code-gen and run test**

Run: `dart run build_runner build --delete-conflicting-outputs`
Run: `flutter test test/features/library/library_providers_test.dart`
Expected: PASS

- [ ] **Step 5: Wire the sort into `SeriesList` and the Shows tab toggle**

Add a `sort` param to `SeriesList` (alongside `shrinkWrap`/`physics` from
Task 13) and apply it before building rows — in
`lib/features/library/widgets/series_list.dart`'s `_list` method, insert
right after `_filter`:

```dart
List<SonarrSeries> _sorted(List<SonarrSeries> series, LibrarySort sort) {
  final copy = [...series];
  switch (sort) {
    case LibrarySort.recentlyAdded:
      copy.sort((a, b) {
        final da = a.added;
        final db = b.added;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
    case LibrarySort.title:
      copy.sort((a, b) => a.title.compareTo(b.title));
    case LibrarySort.year:
      copy.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
  }
  return copy;
}
```

Add `this.sort = LibrarySort.recentlyAdded` to the constructor and a
`final LibrarySort sort;` field, then wrap the `_filter(value)` call
site: `_list(context, ref, _sorted(_filter(value), sort))`. Import
`package:arrstack/features/library/library_providers.dart` for
`LibrarySort`.

In `lib/features/library/library_page.dart`'s `_SeriesTabBody`, add the
toggle row above `SeriesList` and pass its value through:

```dart
Row(
  children: [
    const Expanded(child: Text('ALL SHOWS', style: AppTypography.kicker)),
    Consumer(
      builder: (context, ref, _) {
        final sort = ref.watch(activeLibrarySortProvider);
        return InkWell(
          onTap: () => ref
              .read(activeLibrarySortProvider.notifier)
              .select(
                switch (sort) {
                  LibrarySort.recentlyAdded => LibrarySort.title,
                  LibrarySort.title => LibrarySort.year,
                  LibrarySort.year => LibrarySort.recentlyAdded,
                },
              ),
          child: Text(
            switch (sort) {
              LibrarySort.recentlyAdded => 'Recently added ⌄',
              LibrarySort.title => 'Title ⌄',
              LibrarySort.year => 'Year ⌄',
            },
            style: AppTypography.meta.copyWith(fontWeight: FontWeight.w500),
          ),
        );
      },
    ),
  ],
),
const SizedBox(height: AppSpacing.space2),
Consumer(
  builder: (context, ref, _) => SeriesList(
    instanceId: instanceId,
    query: query,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    sort: ref.watch(activeLibrarySortProvider),
  ),
),
```

This replaces the plain `const Text('ALL SHOWS', ...)` +
`SeriesList(...)` pair Task 13 wrote in `_SeriesTabBody` — keep
everything else in that widget (the `ContinueWatchingRow` block above
it) as Task 13 left it.

- [ ] **Step 6: Add a test asserting the sort toggle changes row order**

Add to `test/features/library/widgets/series_list_test.dart`:

```dart
testWidgets('sort: title orders rows alphabetically', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sonarrSeriesProvider('inst-1').overrideWith(
          (ref) async => Ok([
            const SonarrSeries(id: 1, title: 'Zeta'),
            const SonarrSeries(id: 2, title: 'Alpha'),
          ]),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: SeriesList(instanceId: 'inst-1', sort: LibrarySort.title),
        ),
      ),
    ),
  );
  await tester.pump();

  final titles = tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.data)
      .whereType<String>()
      .where((t) => t == 'Zeta' || t == 'Alpha')
      .toList();
  expect(titles, ['Alpha', 'Zeta']);
});
```

(Add `import 'package:arrstack/features/library/library_providers.dart';`
for `LibrarySort` to this test file if not already present.)

- [ ] **Step 7: Run tests to verify they pass**

Run: `flutter test test/features/library/library_providers_test.dart test/features/library/widgets/series_list_test.dart`
Expected: PASS

- [ ] **Step 8: Commit**

```bash
git add lib/features/library/library_providers.dart lib/features/library/library_providers.g.dart lib/features/library/widgets/series_list.dart lib/features/library/library_page.dart test/features/library/library_providers_test.dart test/features/library/widgets/series_list_test.dart
git commit -m "feat(library): add ActiveLibrarySort and wire the Recently added toggle"
```

---

### Task 13: Rebuild `library_page.dart` + `SeriesList` (Shows tab)

**Files:**
- Modify: `lib/features/library/library_page.dart` (full rewrite of the header/body shell)
- Modify: `lib/features/library/widgets/series_list.dart` (full rewrite, adds `shrinkWrap`/`physics` params)
- Test: `test/features/library/library_page_test.dart` (new, or extend if one exists — check first)
- Test: `test/features/library/widgets/series_list_test.dart` (new, or extend if one exists — check first)

**Interfaces:**
- Consumes: `CollectionChips` (Task 8), `ContinueWatchingRow` (Task 11), `LibraryRow`/`LibraryRowTrailing` (Task 7), `continueWatchingProvider` (Task 10), `sonarrSeriesProvider`, `activeLibraryTabProvider`, `selectedLibraryInstanceIdProvider`.
- Produces: `LibraryPage` (unchanged public API — still a `ConsumerStatefulWidget` mounted at the same route). `SeriesList` gains two new optional constructor params, `shrinkWrap` (default `false`) and `physics` (default `null`), while keeping `{required instanceId, query}` unchanged for existing callers.

- [ ] **Step 1: Check for existing test files**

Run: `find test/features/library -maxdepth 1 -iname "library_page_test.dart"` and `find test/features/library/widgets -iname "series_list_test.dart"`. Extend whichever exist instead of creating new files.

- [ ] **Step 2: Write the failing tests**

`test/features/library/library_page_test.dart`:

```dart
import 'package:arrstack/features/library/library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the Library title without throwing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LibraryPage())),
    );
    await tester.pump();

    expect(find.text('Library'), findsOneWidget);
    expect(find.byType(LibraryPage), findsOneWidget);
  });
}
```

`test/features/library/widgets/series_list_test.dart`:

```dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/series_list.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders a LibraryRow per series with the right trailing state',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sonarrSeriesProvider('inst-1').overrideWith(
              (ref) async => Ok([
                const SonarrSeries(
                  id: 1,
                  title: 'Severance',
                  monitored: true,
                  statistics: SonarrStatistics(
                    episodeFileCount: 19,
                    totalEpisodeCount: 19,
                  ),
                ),
                const SonarrSeries(
                  id: 2,
                  title: 'The Simpsons',
                  monitored: true,
                  statistics: SonarrStatistics(
                    episodeFileCount: 30,
                    totalEpisodeCount: 296,
                  ),
                ),
                const SonarrSeries(id: 3, title: 'Andor', monitored: false),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: SeriesList(instanceId: 'inst-1')),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Severance'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Unmonitored'), findsOneWidget);
    },
  );
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/features/library/library_page_test.dart test/features/library/widgets/series_list_test.dart`
Expected: FAIL — current implementations don't render this way yet.

- [ ] **Step 4: Rewrite `series_list.dart`**

```dart
/// Vertical, fading-rule-separated list of Sonarr series (spec 2d "ALL
/// SHOWS"). Handles loading, empty, and error states for one instance.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeriesList extends ConsumerWidget {
  const SeriesList({
    required this.instanceId,
    this.query = '',
    this.shrinkWrap = false,
    this.physics,
    super.key,
  });

  final String instanceId;
  final String query;

  /// True when nested inside another scrollable (the Shows tab's outer
  /// list, which also hosts ContinueWatchingRow above this list).
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(sonarrSeriesProvider(instanceId));

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _list(context, ref, _filter(value)),
        Err(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load series',
          message: error.userMessage,
          action: FilledButton(
            onPressed: () => ref.invalidate(sonarrSeriesProvider(instanceId)),
            child: const Text('Retry'),
          ),
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  List<SonarrSeries> _filter(List<SonarrSeries> series) {
    if (query.isEmpty) return series;
    final q = query.toLowerCase();
    return series.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  Widget _list(
    BuildContext context,
    WidgetRef ref,
    List<SonarrSeries> series,
  ) {
    if (series.isEmpty) {
      return const EmptyState(
        icon: Icons.tv_off_outlined,
        title: 'No series found',
        message:
            'Your Sonarr library is empty or no titles match your search.',
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final show = series[index];
        final stats = show.statistics;
        final have = stats?.episodeFileCount ?? 0;
        final total = stats?.totalEpisodeCount ?? stats?.episodeCount ?? 0;

        final LibraryRowTrailing trailing;
        int? percent;
        double? progress;
        if (!show.monitored) {
          trailing = LibraryRowTrailing.unmonitored;
        } else if (total > 0 && have >= total) {
          trailing = LibraryRowTrailing.percent;
          percent = 100;
        } else if (total > 0) {
          trailing = LibraryRowTrailing.progress;
          progress = have / total;
        } else {
          trailing = LibraryRowTrailing.none;
        }

        return LibraryRow(
          service: ServiceType.sonarr,
          instanceId: instanceId,
          posterUrl: show.posterUrl,
          title: show.title,
          metaParts: [
            if (show.year != null) '${show.year}',
            if (show.network != null && show.network!.isNotEmpty)
              show.network!,
            '$have/$total',
          ],
          trailing: trailing,
          percent: percent,
          progress: progress,
          showRule: index < series.length - 1,
          onTap: show.id == null
              ? null
              : () =>
                    context.go(RoutePaths.seriesDetail(instanceId, show.id!)),
        );
      },
    );
  }
}
```

- [ ] **Step 5: Rewrite `library_page.dart`**

```dart
/// Main entry for the Library tab (spec 2d).
///
/// A Shows/Movies switch behind one chip row, matching the Nocturne
/// mockups. Sonarr drives Shows, Radarr drives Movies.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/features/library/widgets/collection_chips.dart';
import 'package:arrstack/features/library/widgets/continue_watching_row.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/features/library/widgets/series_list.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _searching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAdd(LibraryTab tab) {
    final type = tab == LibraryTab.movies
        ? ServiceType.radarr
        : ServiceType.sonarr;
    final instanceId = ref.read(selectedLibraryInstanceIdProvider(type)).value;
    if (instanceId != null) {
      context.go(
        type == ServiceType.radarr
            ? RoutePaths.addMovie(instanceId)
            : RoutePaths.addSeries(instanceId),
      );
    } else {
      final name = type == ServiceType.radarr ? 'Radarr' : 'Sonarr';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select or configure a $name instance first.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(activeLibraryTabProvider);
    ref.listen(activeLibraryTabProvider, (previous, next) {
      if (previous == null || previous == next) return;
      setState(() {
        _query = '';
        _searchController.clear();
        _searching = false;
      });
    });
    final isMovies = tab == LibraryTab.movies;

    final sonarrInstanceId =
        ref.watch(selectedLibraryInstanceIdProvider(ServiceType.sonarr)).value;
    final radarrInstanceId =
        ref.watch(selectedLibraryInstanceIdProvider(ServiceType.radarr)).value;

    final showsCount = sonarrInstanceId == null
        ? 0
        : ref.watch(sonarrSeriesProvider(sonarrInstanceId)).maybeWhen(
            data: (result) =>
                result is Ok<List<dynamic>> ? result.value.length : 0,
            orElse: () => 0,
          );
    final moviesCount = radarrInstanceId == null
        ? 0
        : ref.watch(radarrMoviesProvider(radarrInstanceId)).maybeWhen(
            data: (result) =>
                result is Ok<List<dynamic>> ? result.value.length : 0,
            orElse: () => 0,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 21),
            onPressed: () => setState(() => _searching = !_searching),
          ),
          TextButton.icon(
            onPressed: () => _onAdd(tab),
            icon: const Icon(PhosphorIconsRegular.plus, size: 11),
            label: const Text('Add'),
          ),
        ],
      ),
      body: Padding(
        padding: AppInsets.screenHorizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searching) ...[
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: isMovies ? 'Search movies' : 'Search TV shows',
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.space3),
            ],
            Row(
              children: [
                Expanded(
                  child: CollectionChips(
                    showsCount: showsCount,
                    moviesCount: moviesCount,
                  ),
                ),
                const Icon(PhosphorIconsRegular.slidersHorizontal, size: 17),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            Expanded(
              child: isMovies
                  ? _MoviesTab(query: _query)
                  : _SeriesTab(query: _query),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeriesTab extends ConsumerWidget {
  const _SeriesTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(
      selectedLibraryInstanceIdProvider(ServiceType.sonarr),
    );

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const _NoSonarrInstance()
          : _SeriesTabBody(instanceId: id, query: query),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _SeriesTabBody extends ConsumerWidget {
  const _SeriesTabBody({required this.instanceId, required this.query});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueWatchingAsync = ref.watch(
      continueWatchingProvider(instanceId),
    );

    return ListView(
      children: [
        continueWatchingAsync.maybeWhen(
          data: (entries) => entries.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space6),
                  child: ContinueWatchingRow(
                    instanceId: instanceId,
                    entries: entries,
                  ),
                ),
          orElse: () => const SizedBox.shrink(),
        ),
        const Text('ALL SHOWS', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space2),
        SeriesList(
          instanceId: instanceId,
          query: query,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}

class _MoviesTab extends ConsumerWidget {
  const _MoviesTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(
      selectedLibraryInstanceIdProvider(ServiceType.radarr),
    );

    return instanceIdAsync.when(
      data: (id) => id == null
          ? const _NoRadarrInstance()
          : MovieList(instanceId: id, query: query),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _NoSonarrInstance extends StatelessWidget {
  const _NoSonarrInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.tv_outlined,
      title: 'No Sonarr instance',
      message:
          'Configure a Sonarr service in Settings to browse your TV library.',
    );
  }
}

class _NoRadarrInstance extends StatelessWidget {
  const _NoRadarrInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.movie_outlined,
      title: 'No Radarr instance',
      message:
          'Configure a Radarr service in Settings to browse your movie library.',
    );
  }
}
```

- [ ] **Step 6: Run tests to verify they pass**

Run: `flutter test test/features/library/library_page_test.dart test/features/library/widgets/series_list_test.dart`
Expected: PASS

- [ ] **Step 7: Run the whole test suite and analyzer**

Run: `flutter test && dart analyze`
Expected: no new failures (this task touches the most call sites of any task so far — the removed `_InstanceSelector` multi-instance dropdown from the old `library_page.dart` is intentionally dropped from this rewrite since it has no home in the 2d spec; if any existing test asserts on it, that assertion should be removed as part of this task, not worked around).

- [ ] **Step 8: Commit**

```bash
git add lib/features/library/library_page.dart lib/features/library/widgets/series_list.dart test/features/library/library_page_test.dart test/features/library/widgets/series_list_test.dart
git commit -m "feat(library): rebuild Library page shell and Shows tab on Nocturne"
```

---

### Task 14: Rebuild `MovieList` (Movies tab with Missing section)

**Files:**
- Modify: `lib/features/library/widgets/movie_list.dart` (full rewrite)
- Test: `test/features/library/widgets/movie_list_test.dart` (new, or extend if one exists — check first)

**Interfaces:**
- Consumes: `LibraryRow`/`LibraryRowTrailing` (Task 7), `FadingRule` (Task 2), `RadarrRepository.searchMovies` (Task 9), `radarrMoviesProvider`, `radarrRepositoryProvider`.
- Produces: `MovieList` (unchanged constructor: `{required instanceId, query}`).

- [ ] **Step 1: Check for an existing test file**

Run: `find test/features/library/widgets -iname "movie_list_test.dart"`. Extend if found.

- [ ] **Step 2: Write the failing tests**

```dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/widgets/movie_list.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows a Missing section before Recently added, with a count',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            radarrMoviesProvider('inst-1').overrideWith(
              (ref) async => Ok([
                const RadarrMovie(
                  id: 1,
                  title: 'Mickey 17',
                  monitored: true,
                  hasFile: false,
                ),
                const RadarrMovie(
                  id: 2,
                  title: 'Dune: Part Two',
                  monitored: true,
                  hasFile: true,
                  sizeOnDisk: 54200000000,
                ),
              ]),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: MovieList(instanceId: 'inst-1')),
          ),
        ),
      );
      await tester.pump();

      expect(find.textContaining('MISSING'), findsOneWidget);
      expect(find.text('Mickey 17'), findsOneWidget);
      expect(find.text('Search all'), findsOneWidget);
      expect(find.text('Dune: Part Two'), findsOneWidget);

      final missingPos = tester
          .getTopLeft(find.textContaining('MISSING'))
          .dy;
      final recentPos = tester
          .getTopLeft(find.textContaining('RECENTLY ADDED'))
          .dy;
      expect(missingPos, lessThan(recentPos));
    },
  );

  testWidgets('omits the Missing section when nothing is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          radarrMoviesProvider('inst-1').overrideWith(
            (ref) async => Ok([
              const RadarrMovie(id: 1, title: 'Dune: Part Two', hasFile: true),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: MovieList(instanceId: 'inst-1')),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('MISSING'), findsNothing);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test test/features/library/widgets/movie_list_test.dart`
Expected: FAIL — current implementation has no Missing section.

- [ ] **Step 4: Rewrite `movie_list.dart`**

```dart
/// Vertical list of Radarr movies (spec 2d "Movies"): a Missing section
/// with a bulk-search action, then the recently-added library proper.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/library_row.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieList extends ConsumerWidget {
  const MovieList({required this.instanceId, this.query = '', super.key});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(radarrMoviesProvider(instanceId));

    return moviesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _body(context, ref, _filter(value)),
        Err(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load movies',
          message: error.userMessage,
          action: FilledButton(
            onPressed: () => ref.invalidate(radarrMoviesProvider(instanceId)),
            child: const Text('Retry'),
          ),
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Unexpected error',
        message: err.toString(),
      ),
    );
  }

  List<RadarrMovie> _filter(List<RadarrMovie> movies) {
    if (query.isEmpty) return movies;
    final q = query.toLowerCase();
    return movies.where((m) => m.title.toLowerCase().contains(q)).toList();
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    List<RadarrMovie> movies,
  ) {
    if (movies.isEmpty) {
      return const EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'No movies found',
        message:
            'Your Radarr library is empty or no titles match your search.',
      );
    }

    final missing = movies.where((m) => m.monitored && !m.hasFile).toList()
      ..sort((a, b) {
        final da = a.calendarDate;
        final db = b.calendarDate;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });
    final onDisk = movies.where((m) => m.hasFile).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.space4,
      ),
      children: [
        if (missing.isNotEmpty) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  'MISSING · ${missing.length}',
                  style: AppTypography.kicker,
                ),
              ),
              TextButton(
                onPressed: () => _searchAll(context, ref, missing),
                child: const Text('Search all'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          for (final movie in missing)
            LibraryRow(
              service: ServiceType.radarr,
              instanceId: instanceId,
              posterUrl: movie.posterUrl,
              title: movie.title,
              metaParts: [movie.status ?? 'Missing'],
              trailing: LibraryRowTrailing.none,
              onTap: movie.id == null
                  ? null
                  : () =>
                        context.go(RoutePaths.movieDetail(instanceId, movie.id!)),
            ),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
        ],
        Row(
          children: [
            const Expanded(
              child: Text('RECENTLY ADDED', style: AppTypography.kicker),
            ),
            Text(
              '${onDisk.length} on disk',
              style: AppTypography.meta.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space2),
        for (var i = 0; i < onDisk.length; i++)
          LibraryRow(
            service: ServiceType.radarr,
            instanceId: instanceId,
            posterUrl: onDisk[i].posterUrl,
            title: onDisk[i].title,
            metaParts: [FormatUtils.formatBytes(onDisk[i].sizeOnDisk)],
            trailing: LibraryRowTrailing.none,
            trailingText: onDisk[i].displayQuality,
            showRule: i < onDisk.length - 1,
            onTap: onDisk[i].id == null
                ? null
                : () => context.go(
                    RoutePaths.movieDetail(instanceId, onDisk[i].id!),
                  ),
          ),
      ],
    );
  }

  Future<void> _searchAll(
    BuildContext context,
    WidgetRef ref,
    List<RadarrMovie> missing,
  ) async {
    final repo = await ref.read(radarrRepositoryProvider(instanceId).future);
    final ids = missing.map((m) => m.id).whereType<int>().toList();
    final result = await repo.searchMovies(ids);

    if (!context.mounted) return;
    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Searching for missing movies...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: ${result.errorOrNull?.userMessage}'),
        ),
      );
    }
  }
}
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/library/widgets/movie_list_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/features/library/widgets/movie_list.dart test/features/library/widgets/movie_list_test.dart
git commit -m "feat(library): add Missing section and bulk search to Movies tab"
```

---

### Task 15: Rebuild `series_detail_page.dart`

**Files:**
- Modify: `lib/features/library/series_detail_page.dart` (full rewrite)
- Test: `test/features/library/series_detail_page_test.dart` (new, or extend if one exists — check first)

**Interfaces:**
- Consumes: `MediaDetailHeader` (Task 5), `SeasonRow`/`EpisodeRow` (Task 6), `FadingRule` (Task 2). Keeps `sonarrSingleSeriesProvider`, `sonarrRepositoryProvider`, `sonarrSeriesProvider`, `sonarrEpisodesProvider` unchanged.
- Produces: `SeriesDetailPage` (unchanged constructor: `{required instanceId, required seriesId}`).

- [ ] **Step 1: Check field type before writing the test/implementation**

Run: `grep -n "class SonarrRatings" -A 6 lib/services/sonarr/models/sonarr_models.dart`
Confirm `value`'s exact type (expected `double?`) and adjust the null-check pattern below if it differs.

- [ ] **Step 2: Check for an existing test file**

Run: `find test/features/library -maxdepth 1 -iname "series_detail_page_test.dart"`. Extend if found.

- [ ] **Step 3: Write the failing test**

```dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/series_detail_page.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title, stats, and a season row per season', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrSingleSeriesProvider(instanceId: 'inst-1', seriesId: 1)
              .overrideWith(
            (ref) async => const Ok(
              SonarrSeries(
                id: 1,
                title: 'Severance',
                year: 2022,
                network: 'Apple TV+',
                monitored: true,
                statistics: SonarrStatistics(
                  episodeFileCount: 19,
                  totalEpisodeCount: 19,
                  sizeOnDisk: 65498251264,
                ),
                seasons: [
                  SonarrSeason(
                    seasonNumber: 1,
                    statistics: SonarrStatistics(
                      episodeFileCount: 9,
                      totalEpisodeCount: 9,
                    ),
                  ),
                  SonarrSeason(
                    seasonNumber: 2,
                    statistics: SonarrStatistics(
                      episodeFileCount: 10,
                      totalEpisodeCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          sonarrEpisodesProvider(
            instanceId: 'inst-1',
            seriesId: 1,
          ).overrideWith((ref) async => const Ok([])),
        ],
        child: const MaterialApp(
          home: SeriesDetailPage(instanceId: 'inst-1', seriesId: 1),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Severance'), findsOneWidget);
    expect(find.text('19/19'), findsOneWidget);
    expect(find.text('EPISODES'), findsOneWidget);
    expect(find.text('ON DISK'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
    expect(find.text('Season 2'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Run test to verify it fails**

Run: `flutter test test/features/library/series_detail_page_test.dart`
Expected: FAIL — current page doesn't render `EPISODES`/`ON DISK` stat captions.

- [ ] **Step 5: Rewrite**

```dart
/// Series detail page (spec 2e): poster beside the title, a 2-up stat
/// row, and expandable season rows with progress bars.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:arrstack/features/library/widgets/season_row.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SeriesDetailPage extends ConsumerWidget {
  const SeriesDetailPage({
    required this.instanceId,
    required this.seriesId,
    super.key,
  });

  final String instanceId;
  final int seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(
      sonarrSingleSeriesProvider(instanceId: instanceId, seriesId: seriesId),
    );

    return seriesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _SeriesDetailContent(
          instanceId: instanceId,
          series: value,
        ),
        Err(:final error) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load series',
            message: error.userMessage,
          ),
        ),
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }
}

class _SeriesDetailContent extends ConsumerStatefulWidget {
  const _SeriesDetailContent({required this.instanceId, required this.series});

  final String instanceId;
  final SonarrSeries series;

  @override
  ConsumerState<_SeriesDetailContent> createState() =>
      _SeriesDetailContentState();
}

class _SeriesDetailContentState extends ConsumerState<_SeriesDetailContent> {
  bool _isProcessing = false;

  SonarrSeries get series => widget.series;

  @override
  Widget build(BuildContext context) {
    final stats = series.statistics;
    final have = stats?.episodeFileCount ?? 0;
    final total = stats?.totalEpisodeCount ?? stats?.episodeCount ?? 0;
    final seasons = [...?series.seasons]
      ..sort((a, b) => (a.seasonNumber ?? 0).compareTo(b.seasonNumber ?? 0));
    final rating = series.ratings?.value;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 17),
            tooltip: 'Search',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Search command coming soon.')),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'monitor',
                child: Text(series.monitored ? 'Unmonitor' : 'Monitor'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.screenHorizontal,
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.space4),
              child: LinearProgressIndicator(),
            ),
          MediaDetailHeader(
            service: ServiceType.sonarr,
            instanceId: widget.instanceId,
            posterUrl: series.posterUrl,
            title: series.title,
            metaParts: [
              if (series.year != null) '${series.year}',
              if (series.network != null && series.network!.isNotEmpty)
                series.network!,
              if (series.certification != null &&
                  series.certification!.isNotEmpty)
                series.certification!,
            ],
            chips: [
              if (rating != null && rating > 0)
                _tag('★ ${rating.toStringAsFixed(1)}', filled: true),
              if (series.monitored) _tag('Monitored', filled: false),
            ],
            stats: [
              ('$have/$total', 'EPISODES'),
              (
                stats?.sizeOnDisk != null && stats!.sizeOnDisk! > 0
                    ? FormatUtils.formatBytes(stats.sizeOnDisk!)
                    : '0 B',
                'ON DISK',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          if (series.overview != null && series.overview!.isNotEmpty)
            Text(series.overview!, style: AppTypography.body),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          Text('SEASONS · ${seasons.length}', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space2),
          for (final season in seasons)
            SeasonRow(
              label: (season.seasonNumber ?? 0) == 0
                  ? 'Specials'
                  : 'Season ${season.seasonNumber}',
              have: season.statistics?.episodeFileCount ?? 0,
              total: season.statistics?.totalEpisodeCount ?? 0,
              episodes: (context) => _SeasonEpisodes(
                instanceId: widget.instanceId,
                seriesId: series.id!,
                seasonNumber: season.seasonNumber ?? 0,
              ),
            ),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }

  Widget _tag(String label, {required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? AppColors.accent.withValues(alpha: 0.16) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.meta.copyWith(color: AppColors.accent),
      ),
    );
  }

  Future<void> _onMenuSelected(String value) async {
    switch (value) {
      case 'monitor':
        await _toggleMonitored();
      case 'delete':
        await _deleteSeries();
    }
  }

  Future<void> _toggleMonitored() async {
    setState(() => _isProcessing = true);
    final repo = await ref.read(
      sonarrRepositoryProvider(widget.instanceId).future,
    );
    final updated = series.copyWith(monitored: !series.monitored);
    final result = await repo.updateSeries(updated);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(
        sonarrSingleSeriesProvider(
          instanceId: widget.instanceId,
          seriesId: series.id!,
        ),
      );
      ref.invalidate(sonarrSeriesProvider(widget.instanceId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }

  Future<void> _deleteSeries() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Series?'),
        content: Text('Remove "${series.title}" from library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isProcessing = true);
    final repo = await ref.read(
      sonarrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repo.deleteSeries(series.id!);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(sonarrSeriesProvider(widget.instanceId));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }
}

class _SeasonEpisodes extends ConsumerWidget {
  const _SeasonEpisodes({
    required this.instanceId,
    required this.seriesId,
    required this.seasonNumber,
  });

  final String instanceId;
  final int seriesId;
  final int seasonNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(
      sonarrEpisodesProvider(instanceId: instanceId, seriesId: seriesId),
    );

    return episodesAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => Column(
          children: [
            for (final episode
                in value.where((e) => e.seasonNumber == seasonNumber).toList()
                  ..sort(
                    (a, b) =>
                        (a.episodeNumber ?? 0).compareTo(b.episodeNumber ?? 0),
                  ))
              InkWell(
                onTap: () => context.go(
                  RoutePaths.episodeDetail(instanceId, seriesId, episode.id),
                ),
                child: EpisodeRow(
                  code: episode.episodeCode,
                  title: episode.title ?? 'Unknown Episode',
                  hasFile: episode.hasFile,
                  qualityLabel: episode.qualityName,
                ),
              ),
          ],
        ),
        Err() => const Padding(
          padding: EdgeInsets.all(AppSpacing.space4),
          child: Text('Failed to load episodes'),
        ),
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.space4),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => const Padding(
        padding: EdgeInsets.all(AppSpacing.space4),
        child: Text('Failed to load episodes'),
      ),
    );
  }
}
```

- [ ] **Step 6: Add the local "Newest first ⌄" season-order toggle**

This is page-local state (spec 2e) — not the `ActiveLibrarySort` provider
from Task 12, which is scoped to the Library Shows tab only. Add a field
to `_SeriesDetailContentState`:

```dart
bool _newestFirst = true;
```

Replace the `Text('SEASONS · ${seasons.length}', ...)` line in the
`build` method (from Step 5 above) with:

```dart
Row(
  children: [
    Expanded(
      child: Text('SEASONS · ${seasons.length}', style: AppTypography.kicker),
    ),
    InkWell(
      onTap: () => setState(() => _newestFirst = !_newestFirst),
      child: Text(
        _newestFirst ? 'Newest first ⌄' : 'Oldest first ⌄',
        style: AppTypography.meta.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
  ],
),
```

And change the `for (final season in seasons)` loop right after it to
sort by the toggle:

```dart
for (final season in _newestFirst ? seasons.reversed.toList() : seasons)
```

(`seasons` is already sorted ascending earlier in `build` — reversing it
gives newest-first without a second sort pass.)

- [ ] **Step 7: Add a test for the toggle**

Add to `test/features/library/series_detail_page_test.dart` (reuse the
provider overrides from Step 3's test):

```dart
testWidgets('tapping the season-order toggle reverses season order', (
  tester,
) async {
  // ... pump the same widget tree as the test above ...
  await tester.pump();

  final seasonOneRect = tester.getTopLeft(find.text('Season 1'));
  final seasonTwoRect = tester.getTopLeft(find.text('Season 2'));
  expect(seasonOneRect.dy, greaterThan(seasonTwoRect.dy)); // newest first: 2 before 1

  await tester.tap(find.text('Newest first ⌄'));
  await tester.pump();

  final afterOne = tester.getTopLeft(find.text('Season 1'));
  final afterTwo = tester.getTopLeft(find.text('Season 2'));
  expect(afterOne.dy, lessThan(afterTwo.dy)); // oldest first: 1 before 2
});
```

- [ ] **Step 8: Run tests to verify they pass**

Run: `flutter test test/features/library/series_detail_page_test.dart`
Expected: PASS

- [ ] **Step 9: Commit**

```bash
git add lib/features/library/series_detail_page.dart test/features/library/series_detail_page_test.dart
git commit -m "feat(library): rebuild series detail with poster-beside-title layout"
```

---

### Task 16: Rebuild `episode_detail_page.dart`

**Files:**
- Modify: `lib/features/library/episode_detail_page.dart` (full rewrite)
- Test: `test/features/library/episode_detail_page_test.dart` (new, or extend if one exists — check first)

**Interfaces:**
- Consumes: `SpecBlock` (Task 3), `bazarrWantedProvider` / `primaryBazarrInstanceProvider` (existing, `lib/services/bazarr/bazarr_providers.dart`), `SonarrEpisodeFile.releaseGroup`/`.mediaInfo` (Task 4), `sonarrSingleSeriesProvider` (existing, for the header kicker).
- Produces: `EpisodeDetailPage` (unchanged constructor).

- [ ] **Step 1: Check for an existing test file**

Run: `find test/features/library -maxdepth 1 -iname "episode_detail_page_test.dart"`. Extend if found.

- [ ] **Step 2: Write the failing test**

```dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/episode_detail_page.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders primary Find release and secondary Subtitles buttons, and the FILE block',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sonarrEpisodeProvider(
              instanceId: 'inst-1',
              seriesId: 1,
              episodeId: 5,
            ).overrideWith(
              (ref) async => const Ok(
                SonarrEpisode(
                  id: 5,
                  seriesId: 1,
                  seasonNumber: 2,
                  episodeNumber: 5,
                  title: 'The You You Are',
                  hasFile: true,
                  monitored: true,
                  episodeFile: SonarrEpisodeFile(
                    id: 1,
                    size: 3100000000,
                    relativePath: 'Severance/Season 02/S02E05.mkv',
                    quality: SonarrQualityInfo(
                      quality: SonarrQuality(name: 'WEBDL-1080p'),
                    ),
                  ),
                ),
              ),
            ),
            sonarrSingleSeriesProvider(instanceId: 'inst-1', seriesId: 1)
                .overrideWith(
              (ref) async =>
                  const Ok(SonarrSeries(id: 1, title: 'Severance')),
            ),
          ],
          child: const MaterialApp(
            home: EpisodeDetailPage(
              instanceId: 'inst-1',
              seriesId: 1,
              episodeId: 5,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Find release'), findsOneWidget);
      expect(find.text('Subtitles'), findsOneWidget);
      expect(find.text('FILE'), findsOneWidget);
      expect(find.text('WEBDL-1080p'), findsOneWidget);
      expect(find.text('Severance'), findsOneWidget);
    },
  );
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/library/episode_detail_page_test.dart`
Expected: FAIL — current page has icon buttons in the header, not body buttons labeled "Find release"/"Subtitles", and no series-title kicker.

- [ ] **Step 4: Rewrite**

```dart
/// Episode detail page (spec 2f): real primary/secondary action buttons,
/// a FILE spec block, and a SUBTITLES spec block.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/library/widgets/spec_block.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EpisodeDetailPage extends ConsumerWidget {
  const EpisodeDetailPage({
    required this.instanceId,
    required this.seriesId,
    required this.episodeId,
    super.key,
  });

  final String instanceId;
  final int seriesId;
  final int episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeAsync = ref.watch(
      sonarrEpisodeProvider(
        instanceId: instanceId,
        seriesId: seriesId,
        episodeId: episodeId,
      ),
    );

    return episodeAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _EpisodeDetailContent(
          instanceId: instanceId,
          seriesId: seriesId,
          episode: value,
        ),
        Err(:final error) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load episode',
            message: error.userMessage,
          ),
        ),
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }
}

class _EpisodeDetailContent extends ConsumerStatefulWidget {
  const _EpisodeDetailContent({
    required this.instanceId,
    required this.seriesId,
    required this.episode,
  });

  final String instanceId;
  final int seriesId;
  final SonarrEpisode episode;

  @override
  ConsumerState<_EpisodeDetailContent> createState() =>
      _EpisodeDetailContentState();
}

class _EpisodeDetailContentState extends ConsumerState<_EpisodeDetailContent> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final episode = widget.episode;
    final file = episode.episodeFile;
    final airDate = episode.airDateUtc != null
        ? _formatDate(episode.airDateUtc!.toLocal())
        : 'Unknown air date';
    final seriesTitle = ref
        .watch(
          sonarrSingleSeriesProvider(
            instanceId: widget.instanceId,
            seriesId: widget.seriesId,
          ),
        )
        .maybeWhen(
          data: (result) => result is Ok<SonarrSeries> ? result.value.title : '',
          orElse: () => '',
        );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (seriesTitle.isNotEmpty)
              Text(seriesTitle, style: AppTypography.kicker),
            Text(
              episode.episodeCode,
              style: AppTypography.cardTitle.copyWith(
                color: theme.colorScheme.onSurface,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: AppInsets.screenHorizontal,
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.space4),
              child: LinearProgressIndicator(),
            ),
          Text(
            episode.title ?? 'Unknown Episode',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Aired $airDate'
            '${episode.runtime != null && episode.runtime! > 0 ? ' · ${episode.runtime} min' : ''}',
            style: AppTypography.meta.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          _ChipRow(episode: episode),
          const SizedBox(height: AppSpacing.space4),
          if (episode.overview != null && episode.overview!.isNotEmpty)
            Text(episode.overview!, style: AppTypography.body),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push(
                    RoutePaths.episodeReleaseSearch(
                      widget.instanceId,
                      widget.seriesId,
                      episode.id,
                      [
                        episode.episodeCode,
                        if (episode.title != null && episode.title!.isNotEmpty)
                          episode.title!,
                      ].join(' · '),
                    ),
                  ),
                  child: const Text('Find release'),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: OutlinedButton(
                  onPressed: _searchSubtitlesInBazarr,
                  child: const Text('Subtitles'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          if (file != null)
            SpecBlock(
              kicker: 'FILE',
              rows: [
                ('Quality', file.quality?.quality?.name ?? '—'),
                ('Size', FormatUtils.formatBytes(file.size)),
                if (file.mediaInfo?.videoCodec != null)
                  ('Codec', file.mediaInfo!.videoCodec!),
                if (_audioLabel(file.mediaInfo) != null)
                  ('Audio', _audioLabel(file.mediaInfo)!),
                if (file.relativePath != null) ('Path', file.relativePath!),
              ],
            ),
          const SizedBox(height: AppSpacing.space4),
          _SubtitlesBlock(episodeId: episode.id),
        ],
      ),
    );
  }

  String? _audioLabel(SonarrMediaInfo? mediaInfo) {
    if (mediaInfo == null) return null;
    final parts = [
      if (mediaInfo.audioCodec != null) mediaInfo.audioCodec!,
      if (mediaInfo.audioChannels != null) '${mediaInfo.audioChannels}',
    ];
    return parts.isEmpty ? null : parts.join(' ');
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  Future<void> _searchSubtitlesInBazarr() async {
    final bazarrInstance = await ref.read(primaryBazarrInstanceProvider.future);
    if (bazarrInstance == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Bazarr instance configured in the app.'),
          ),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    final episode = widget.episode;
    final repo = await ref.read(
      bazarrRepositoryProvider(bazarrInstance.id).future,
    );
    final result = await repo.searchSubtitle(
      BazarrWantedSubtitle(
        title: episode.title ?? 'Episode ${episode.episodeNumber}',
        type: 'episode',
        episodeId: episode.id,
        path: '',
      ),
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtitle search triggered in Bazarr for "${episode.title ?? 'Episode'}"',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bazarr search failed: ${result.errorOrNull?.userMessage}',
          ),
        ),
      );
    }
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.episode});

  final SonarrEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.space2,
      runSpacing: AppSpacing.space2,
      children: [
        if (episode.monitored) _tag('Monitored', filled: false, neutral: false),
        if (episode.hasFile) _tag('Downloaded', filled: true, neutral: false),
        if (episode.qualityName != null)
          _tag(episode.qualityName!, filled: false, neutral: true),
      ],
    );
  }

  Widget _tag(String label, {required bool filled, required bool neutral}) {
    final color = neutral ? AppColors.n400 : AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.16) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: AppTypography.meta.copyWith(color: color)),
    );
  }
}

/// Cross-references the episode against Bazarr's wanted-subtitle list
/// (spec decision 6): languages named there render "Wanted" in red;
/// this lighter approximation has no per-language downloaded/provider
/// data, so a "Downloaded" state isn't rendered per-language here — only
/// wanted languages are shown, and the block is omitted when there are
/// none.
class _SubtitlesBlock extends ConsumerWidget {
  const _SubtitlesBlock({required this.episodeId});

  final int episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bazarrInstanceAsync = ref.watch(primaryBazarrInstanceProvider);

    return bazarrInstanceAsync.when(
      data: (instance) {
        if (instance == null) return const SizedBox.shrink();
        final wantedAsync = ref.watch(bazarrWantedProvider(instance.id));
        return wantedAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _wantedLanguagesFor(value),
            Err() => const SizedBox.shrink(),
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _wantedLanguagesFor(List<BazarrWantedSubtitle> allWanted) {
    final wanted = allWanted
        .where((w) => w.episodeId == episodeId)
        .expand((w) => w.languages)
        .toSet();

    if (wanted.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUBTITLES', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space3),
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: [
            for (final lang in wanted)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.n900,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      lang.toUpperCase(),
                      style: AppTypography.meta.copyWith(color: AppColors.n300),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space2),
                  Text(
                    'Wanted',
                    style: AppTypography.meta.copyWith(color: AppColors.down),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/library/episode_detail_page_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/features/library/episode_detail_page.dart test/features/library/episode_detail_page_test.dart
git commit -m "feat(library): rebuild episode detail with real action buttons and FILE/SUBTITLES blocks"
```

---

### Task 17: Rebuild `movie_detail_page.dart`

**Files:**
- Modify: `lib/features/library/movie_detail_page.dart` (full rewrite)
- Test: `test/features/library/movie_detail_page_test.dart` (new, or extend if one exists — check first)

**Interfaces:**
- Consumes: `MediaDetailHeader` (Task 5), `SpecBlock` (Task 3), `FadingRule` (Task 2), `RadarrMovieFile.releaseGroup`/`.mediaInfo` (Task 4).
- Produces: `MovieDetailPage` (unchanged constructor).

- [ ] **Step 1: Check for an existing test file**

Run: `find test/features/library -maxdepth 1 -iname "movie_detail_page_test.dart"`. Extend if found.

- [ ] **Step 2: Write the failing test**

```dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/movie_detail_page.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'renders QUALITY/ON DISK stats, genre line, and three secondary buttons',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            radarrMovieProvider(instanceId: 'inst-1', movieId: 1).overrideWith(
              (ref) async => const Ok(
                RadarrMovie(
                  id: 1,
                  title: 'Dune: Part Two',
                  year: 2024,
                  monitored: true,
                  hasFile: true,
                  sizeOnDisk: 54200000000,
                  genres: ['Science Fiction', 'Adventure'],
                  imdbId: 'tt15239678',
                  tmdbId: 693134,
                  movieFile: RadarrMovieFile(
                    id: 1,
                    size: 54200000000,
                    quality: RadarrQualityInfo(
                      quality: RadarrQuality(name: 'Bluray-2160p'),
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: MovieDetailPage(instanceId: 'inst-1', movieId: 1),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dune: Part Two'), findsOneWidget);
      expect(find.text('ON DISK'), findsOneWidget);
      expect(find.text('QUALITY'), findsOneWidget);
      expect(find.text('Science Fiction · Adventure'), findsOneWidget);
      expect(find.text('IMDb'), findsOneWidget);
      expect(find.text('TMDB'), findsOneWidget);
      expect(find.text('Subtitles'), findsOneWidget);
    },
  );
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/library/movie_detail_page_test.dart`
Expected: FAIL — current page centers the poster and has no QUALITY/ON DISK stat row.

- [ ] **Step 4: Rewrite**

```dart
/// Movie detail page (spec 2g): same anatomy as series detail so the two
/// read as one product, with movie-specific stats, a genre line, and
/// IMDb/TMDB/Subtitles buttons.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:arrstack/features/library/widgets/spec_block.dart';
import 'package:arrstack/services/bazarr/bazarr_providers.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieDetailPage extends ConsumerWidget {
  const MovieDetailPage({
    required this.instanceId,
    required this.movieId,
    super.key,
  });

  final String instanceId;
  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(
      radarrMovieProvider(instanceId: instanceId, movieId: movieId),
    );

    return movieAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _MovieDetailContent(
          instanceId: instanceId,
          movie: value,
        ),
        Err(:final error) => Scaffold(
          appBar: AppBar(),
          body: EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load movie',
            message: error.userMessage,
          ),
        ),
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) =>
          Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $err'))),
    );
  }
}

class _MovieDetailContent extends ConsumerStatefulWidget {
  const _MovieDetailContent({required this.instanceId, required this.movie});

  final String instanceId;
  final RadarrMovie movie;

  @override
  ConsumerState<_MovieDetailContent> createState() =>
      _MovieDetailContentState();
}

class _MovieDetailContentState extends ConsumerState<_MovieDetailContent> {
  bool _isProcessing = false;

  RadarrMovie get movie => widget.movie;

  @override
  Widget build(BuildContext context) {
    final file = movie.movieFile;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'monitor',
                child: Text(movie.monitored ? 'Unmonitor' : 'Monitor'),
              ),
              const PopupMenuItem(value: 'search', child: Text('Search Movie')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.screenHorizontal,
        children: [
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.space4),
              child: LinearProgressIndicator(),
            ),
          MediaDetailHeader(
            service: ServiceType.radarr,
            instanceId: widget.instanceId,
            posterUrl: movie.posterUrl,
            title: movie.title,
            metaParts: [
              '${movie.year}',
              if (movie.studio != null && movie.studio!.isNotEmpty)
                movie.studio!,
              if (movie.certification != null &&
                  movie.certification!.isNotEmpty)
                movie.certification!,
            ],
            chips: [
              if ((movie.displayRating ?? 0) > 0)
                _tag('★ ${movie.displayRating!.toStringAsFixed(1)}', filled: true),
              if (movie.monitored) _tag('Monitored', filled: false),
            ],
            stats: [
              (movie.displayQuality ?? '—', 'QUALITY'),
              (
                movie.hasFile ? FormatUtils.formatBytes(movie.sizeOnDisk) : '0 B',
                'ON DISK',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          if (movie.overview != null && movie.overview!.isNotEmpty)
            Text(movie.overview!, style: AppTypography.body),
          if (movie.genres != null && movie.genres!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              movie.genres!.join(' · '),
              style: AppTypography.meta.copyWith(
                color: AppColors.n500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          if (file != null)
            SpecBlock(
              kicker: 'FILE',
              rows: [
                if (file.releaseGroup != null) ('Release', file.releaseGroup!),
                if (_videoLabel(file.mediaInfo) != null)
                  ('Video', _videoLabel(file.mediaInfo)!),
                if (_audioLabel(file.mediaInfo) != null)
                  ('Audio', _audioLabel(file.mediaInfo)!),
                if (movie.added != null) ('Added', _formatDate(movie.added!)),
                if (movie.path != null && movie.path!.isNotEmpty)
                  ('Path', movie.path!),
              ],
            ),
          const SizedBox(height: AppSpacing.space6),
          Row(
            children: [
              if (movie.imdbId != null && movie.imdbId!.isNotEmpty) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _copy('https://www.imdb.com/title/${movie.imdbId}', 'IMDb'),
                    child: const Text('IMDb'),
                  ),
                ),
                const SizedBox(width: AppSpacing.space3),
              ],
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _copy(
                    'https://www.themoviedb.org/movie/${movie.tmdbId}',
                    'TMDB',
                  ),
                  child: const Text('TMDB'),
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: OutlinedButton(
                  onPressed: _searchSubtitlesInBazarr,
                  child: const Text('Subtitles'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _videoLabel(RadarrMediaInfo? mediaInfo) {
    if (mediaInfo == null) return null;
    final parts = [
      if (mediaInfo.videoCodec != null) mediaInfo.videoCodec!,
      if (mediaInfo.videoDynamicRangeType != null)
        mediaInfo.videoDynamicRangeType!,
      if (mediaInfo.resolution != null) mediaInfo.resolution!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  String? _audioLabel(RadarrMediaInfo? mediaInfo) {
    if (mediaInfo == null) return null;
    final parts = [
      if (mediaInfo.audioCodec != null) mediaInfo.audioCodec!,
      if (mediaInfo.audioChannels != null) '${mediaInfo.audioChannels}',
    ];
    return parts.isEmpty ? null : parts.join(' ');
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  Widget _tag(String label, {required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? AppColors.accent.withValues(alpha: 0.16) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: AppTypography.meta.copyWith(color: AppColors.accent),
      ),
    );
  }

  Future<void> _copy(String url, String name) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name link copied to clipboard')));
  }

  Future<void> _onMenuSelected(String value) async {
    switch (value) {
      case 'monitor':
        await _toggleMonitored();
      case 'search':
        {
          final label = movie.year != null
              ? '${movie.title} (${movie.year})'
              : movie.title;
          context.push(
            RoutePaths.movieReleaseSearch(widget.instanceId, movie.id!, label),
          );
        }
      case 'delete':
        await _deleteMovie();
    }
  }

  Future<void> _searchSubtitlesInBazarr() async {
    final bazarrInstance = await ref.read(primaryBazarrInstanceProvider.future);
    if (bazarrInstance == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Bazarr instance configured in the app.'),
          ),
        );
      }
      return;
    }

    setState(() => _isProcessing = true);
    final repo = await ref.read(
      bazarrRepositoryProvider(bazarrInstance.id).future,
    );
    final result = await repo.searchSubtitle(
      BazarrWantedSubtitle(title: movie.title, type: 'movie', radarrId: movie.id, path: ''),
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result.isOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Subtitle search triggered in Bazarr for "${movie.title}"'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bazarr search failed: ${result.errorOrNull?.userMessage}'),
        ),
      );
    }
  }

  Future<void> _toggleMonitored() async {
    setState(() => _isProcessing = true);
    final repo = await ref.read(radarrRepositoryProvider(widget.instanceId).future);
    final updated = movie.copyWith(monitored: !movie.monitored);
    final result = await repo.updateMovie(updated);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(radarrMovieProvider(instanceId: widget.instanceId, movieId: movie.id!));
      ref.invalidate(radarrMoviesProvider(widget.instanceId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }

  Future<void> _deleteMovie() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Movie?'),
        content: Text('Remove "${movie.title}" from library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isProcessing = true);
    final repo = await ref.read(radarrRepositoryProvider(widget.instanceId).future);
    final result = await repo.deleteMovie(movie.id!);

    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (result is Ok) {
      ref.invalidate(radarrMoviesProvider(widget.instanceId));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${(result as Err).error.userMessage}')),
      );
    }
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/library/movie_detail_page_test.dart`
Expected: PASS

- [ ] **Step 6: Run the full suite, format, and analyze**

Run: `flutter test && dart format --set-exit-if-changed . && dart analyze --fatal-infos`
Expected: all green — this is the last task, so this is the final verification before whole-branch review.

- [ ] **Step 7: Commit**

```bash
git add lib/features/library/movie_detail_page.dart test/features/library/movie_detail_page_test.dart
git commit -m "feat(library): rebuild movie detail with poster-beside-title layout and FILE block"
```

---

## Post-plan: whole-branch review

After Task 17 lands, run a whole-branch review against `worktree-nocturne-redesign` (same closing pattern as Phases 3–4): diff every commit on `nocturne-redesign-phase5` since it branched, check both themes render correctly for all four screens (Library Shows/Movies tabs, series/episode/movie detail), verify `flutter test` and `dart analyze` are clean, then open the PR.

# Nocturne Redesign Phase 7: Seerr + Adding Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build Seerr discovery/requesting (README §3a–3c) and restyle the
add-to-library and manual-release-search flows (§3d–3e) onto Nocturne,
completing Phase 7 of the 8-phase redesign.

**Architecture:** New shared widgets (`MediaStatusBadge`, `LabeledDropdownField`,
`LabeledToggleRow`) and a pure status-presentation function back the new/restyled
screens. `MediaDetailHeader` gains a poster-widget slot so Seerr's
already-absolute TMDB poster URLs can reuse the same 2g header anatomy as
Radarr/Sonarr's relative-URL posters. The Seerr service layer gains
approve/decline, service-details (profiles/root-folders), and an
all-pages request fetch; a new pure bucketing module turns that flat request
list into the three Requests-queue sections without trusting an unverified
server-side filter vocabulary. `discover_page.dart`'s in-page Requests tab is
replaced by a standalone `/home/requests` route.

**Tech Stack:** Flutter, Riverpod (`riverpod_annotation` code-gen), `go_router`,
`phosphor_icons`, `freezed` (three new models), `http_mock_adapter` (new Seerr
client tests).

**Spec:** `docs/superpowers/specs/2026-09-14-nocturne-redesign-phase7-seerr-adding-design.md`

## Global Constraints

- Never hardcode Nocturne colors/spacing/type inline — use `AppColors`,
  `AppSpacing`, `AppRadius`, `AppTypography`, `AppInsets` from
  `lib/app/theme/design_tokens.dart`.
- No `isDark` branching in new code.
- Tabular numerals (`FontFeature.tabularFigures()`) on every numeric figure:
  counts, response fields, sizes, "N found".
- `dart format` and `dart analyze` must stay clean after every task — run both
  before each commit.
- Every new pure-logic file (no `flutter` import) gets a plain `test/`-style
  unit test; every new/rewritten widget gets a widget test using
  `ProviderScope` overrides, matching `test/features/library/` and
  `test/features/release_search/`'s existing patterns.
- **Every new async provider must show a distinct error/empty state, never a
  silent fallback to fabricated-looking data.** An `Err` result (profile
  fetch, service-details fetch, availability data) must render visibly as an
  error or be visibly omitted — never silently default to "the first item"
  or a fake zero that looks like a real answer. This was a real Phase 6
  post-hoc bug (Indexers/Settings folding a failed fetch into the same empty
  state as "genuinely empty"); Phase 7 must not repeat it.
- **Any new `copyWith`-style state class must not use the `field ?? this.field`
  pattern for a field that needs to become settable back to `null`.** That
  pattern silently no-ops a `copyWith(x: null)` call — a real Phase 6
  post-hoc bug (`InstanceFormState.copyWith` couldn't clear a stale test
  result). This phase's new state is mostly local `setState` widget state
  (no `copyWith` classes are introduced), but if any task's implementer adds
  one, use an explicit sentinel default instead of `??`.

---

### Task 1: `mediaStatusPresentation` pure function

**Files:**
- Create: `lib/services/seerr/models/seerr_status_presentation.dart`
- Test: `test/services/seerr/models/seerr_status_presentation_test.dart`

**Interfaces:**
- Consumes: `SeerrMediaStatus` constants from `lib/services/seerr/models/seerr_models.dart` (already exist: `pending`, `processing`, `partiallyAvailable`, `available`, `unknown`, `deleted`).
- Produces: `({String label, Color color})? mediaStatusPresentation(int status)`. Task 9 (`InProgressRow`) consumes this directly. Tasks 2 and 12's badge/chip do **not** consume it — they need different wording ("In library"/"Requested"/"Not in library" rather than the literal status name) and classify `status` directly; see this function's own doc comment for why.

- [ ] **Step 1: Write the failing test**

```dart
// test/services/seerr/models/seerr_status_presentation_test.dart
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/models/seerr_status_presentation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps pending to a warning-colored "Pending" label', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.pending)?.label, 'Pending');
  });

  test('maps processing to an accent-colored "Processing" label', () {
    expect(
      mediaStatusPresentation(SeerrMediaStatus.processing)?.label,
      'Processing',
    );
  });

  test('maps partiallyAvailable to an up-colored "Partially Available" label', () {
    expect(
      mediaStatusPresentation(SeerrMediaStatus.partiallyAvailable)?.label,
      'Partially Available',
    );
  });

  test('maps available to an up-colored "Available" label', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.available)?.label, 'Available');
  });

  test('returns null for unknown', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.unknown), isNull);
  });

  test('returns null for deleted', () {
    expect(mediaStatusPresentation(SeerrMediaStatus.deleted), isNull);
  });

  test('returns null for an unmapped int', () {
    expect(mediaStatusPresentation(999), isNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/seerr/models/seerr_status_presentation_test.dart`
Expected: FAIL — `Target of URI doesn't exist`.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/services/seerr/models/seerr_status_presentation.dart
/// Single source of truth for how a Seerr [SeerrMediaStatus] presents as a
/// literal label + color — replaces the label switch statements previously
/// duplicated across `discover_detail_page.dart`'s `_RequestStatusChip` and
/// `request_list_tile.dart`'s `_mediaStatusChip`. Consumed directly by the
/// Requests queue's in-progress trailing tag (README §3c), where the
/// literal status name is exactly what's wanted (Processing/Partially
/// Available/Available). The Discover poster badge (§3a) and the detail
/// page's "Not in library" chip (§3b) want different framing ("In
/// library"/"Requested"/"Not in library" rather than a literal status
/// name), so they classify `status` directly instead — see
/// `media_status_badge.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';

({String label, Color color})? mediaStatusPresentation(int status) {
  return switch (status) {
    SeerrMediaStatus.pending => (label: 'Pending', color: AppColors.warning),
    SeerrMediaStatus.processing => (
      label: 'Processing',
      color: AppColors.accent,
    ),
    SeerrMediaStatus.partiallyAvailable => (
      label: 'Partially Available',
      color: AppColors.up,
    ),
    SeerrMediaStatus.available => (label: 'Available', color: AppColors.up),
    _ => null,
  };
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/services/seerr/models/seerr_status_presentation_test.dart`
Expected: PASS (7 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/services/seerr/models/seerr_status_presentation.dart test/services/seerr/models/seerr_status_presentation_test.dart
dart analyze lib/services/seerr/models/seerr_status_presentation.dart
git add lib/services/seerr/models/seerr_status_presentation.dart test/services/seerr/models/seerr_status_presentation_test.dart
git commit -m "feat(seerr): add mediaStatusPresentation pure status-label mapping"
```

---

### Task 2: `MediaStatusBadge` widget

**Files:**
- Create: `lib/features/discover/widgets/media_status_badge.dart`
- Test: `test/features/discover/widgets/media_status_badge_test.dart`

**Interfaces:**
- Consumes: `SeerrMediaInfo`/`SeerrMediaStatus` from `seerr_models.dart`.
- Produces: `MediaStatusBadge({required SeerrMediaInfo? mediaInfo})`. Task 10 (Discover carousels) and Task 11 (genre grid) construct it in `PosterCard`'s existing `badge` slot.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/discover/widgets/media_status_badge_test.dart
import 'package:arrstack/features/discover/widgets/media_status_badge.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, SeerrMediaInfo? mediaInfo) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MediaStatusBadge(mediaInfo: mediaInfo)),
        ),
      );

  testWidgets('shows "In library" for an available item', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
    );
    expect(find.text('In library'), findsOneWidget);
  });

  testWidgets('shows "In library" for a partially available item', (
    tester,
  ) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.partiallyAvailable),
    );
    expect(find.text('In library'), findsOneWidget);
  });

  testWidgets('shows "Requested" for a pending item', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.pending),
    );
    expect(find.text('Requested'), findsOneWidget);
  });

  testWidgets('shows "Requested" for a processing item', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.processing),
    );
    expect(find.text('Requested'), findsOneWidget);
  });

  testWidgets('renders nothing for null mediaInfo', (tester) async {
    await pump(tester, null);
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('renders nothing for an unknown status', (tester) async {
    await pump(
      tester,
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.unknown),
    );
    expect(find.byType(Container), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/discover/widgets/media_status_badge_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/discover/widgets/media_status_badge.dart
/// The poster-corner badge answering "do I already have this?" before the
/// tap (README §3a) — a small **solid**-fill pill, 5px inset from the
/// poster's top-left corner via `PosterCard`'s existing `badge` slot (no
/// change needed there). Classifies `mediaInfo.status` directly rather than
/// through `mediaStatusPresentation` (seerr_status_presentation.dart)
/// because "In library"/"Requested" don't match that function's literal
/// media-status vocabulary.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';

class MediaStatusBadge extends StatelessWidget {
  const MediaStatusBadge({required this.mediaInfo, super.key});

  final SeerrMediaInfo? mediaInfo;

  @override
  Widget build(BuildContext context) {
    final status = mediaInfo?.status;
    if (status == null) return const SizedBox.shrink();

    final style = switch (status) {
      SeerrMediaStatus.available ||
      SeerrMediaStatus.partiallyAvailable => (
        label: 'In library',
        fill: AppColors.accent,
      ),
      SeerrMediaStatus.pending || SeerrMediaStatus.processing => (
        label: 'Requested',
        fill: AppColors.n900,
      ),
      _ => null,
    };
    if (style == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: style.fill,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        style.label,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/discover/widgets/media_status_badge_test.dart`
Expected: PASS (6 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/discover/widgets/media_status_badge.dart test/features/discover/widgets/media_status_badge_test.dart
dart analyze lib/features/discover/widgets/media_status_badge.dart
git add lib/features/discover/widgets/media_status_badge.dart test/features/discover/widgets/media_status_badge_test.dart
git commit -m "feat(discover): add MediaStatusBadge poster-corner badge widget"
```

---

### Task 3: `LabeledDropdownField<T>` shared widget

**Files:**
- Create: `lib/core/widgets/labeled_dropdown_field.dart`
- Test: `test/core/widgets/labeled_dropdown_field_test.dart`

**Interfaces:**
- Produces: `LabeledDropdownField<T>({required String label, required T? value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged, String? caption})`. Task 12 (3b request panel) and Task 13 (3d add sheets) construct it.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/widgets/labeled_dropdown_field_test.dart
import 'package:arrstack/core/widgets/labeled_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders label, selected value and caption', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledDropdownField<String>(
            label: 'Quality profile',
            value: 'HD-1080p',
            items: const [
              DropdownMenuItem(value: 'HD-1080p', child: Text('HD-1080p')),
              DropdownMenuItem(value: '4K', child: Text('4K')),
            ],
            onChanged: (_) {},
            caption: '2.4 TB free of 18 TB',
          ),
        ),
      ),
    );

    expect(find.text('Quality profile'), findsOneWidget);
    expect(find.text('HD-1080p'), findsOneWidget);
    expect(find.text('2.4 TB free of 18 TB'), findsOneWidget);
  });

  testWidgets('omits the caption row when none is given', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledDropdownField<String>(
            label: 'Root folder',
            value: '/data/media/movies',
            items: const [
              DropdownMenuItem(
                value: '/data/media/movies',
                child: Text('/data/media/movies'),
              ),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Root folder'), findsOneWidget);
    expect(find.byType(LabeledDropdownField<String>), findsOneWidget);
  });

  testWidgets('onChanged fires with the newly selected item', (tester) async {
    String? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledDropdownField<String>(
            label: 'Quality profile',
            value: 'HD-1080p',
            items: const [
              DropdownMenuItem(value: 'HD-1080p', child: Text('HD-1080p')),
              DropdownMenuItem(value: '4K', child: Text('4K')),
            ],
            onChanged: (v) => captured = v,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4K').last);
    await tester.pumpAndSettle();

    expect(captured, '4K');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/labeled_dropdown_field_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/core/widgets/labeled_dropdown_field.dart
/// A Nocturne-styled labeled dropdown (README §3b, §3d): label above a
/// surface-fill/divider-border/radius-md box, an optional caption below
/// (e.g. free-space text). Replaces the plain `DropdownButtonFormField`
/// (Material default chrome) used today in `add_movie_options.dart`/
/// `add_series_options.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class LabeledDropdownField<T> extends StatelessWidget {
  const LabeledDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.caption,
    super.key,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.meta.copyWith(color: AppColors.n400)),
        const SizedBox(height: AppSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: const Icon(
                PhosphorIconsRegular.caretDown,
                size: 14,
                color: AppColors.n400,
              ),
              dropdownColor: AppColors.surface,
              style: AppTypography.body.copyWith(color: AppColors.text),
            ),
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: AppSpacing.space2),
          Text(caption!, style: AppTypography.meta.copyWith(color: AppColors.n500)),
        ],
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/labeled_dropdown_field_test.dart`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/core/widgets/labeled_dropdown_field.dart test/core/widgets/labeled_dropdown_field_test.dart
dart analyze lib/core/widgets/labeled_dropdown_field.dart
git add lib/core/widgets/labeled_dropdown_field.dart test/core/widgets/labeled_dropdown_field_test.dart
git commit -m "feat(core): add LabeledDropdownField shared widget"
```

---

### Task 4: `LabeledToggleRow` shared widget

**Files:**
- Create: `lib/core/widgets/labeled_toggle_row.dart`
- Test: `test/core/widgets/labeled_toggle_row_test.dart`

**Interfaces:**
- Produces: `LabeledToggleRow({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged})`. Task 12 and Task 13 construct it.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/widgets/labeled_toggle_row_test.dart
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title and subtitle with the given switch value', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledToggleRow(
            title: 'Search immediately',
            subtitle: 'Otherwise it waits for the next RSS sweep',
            value: true,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Search immediately'), findsOneWidget);
    expect(
      find.text('Otherwise it waits for the next RSS sweep'),
      findsOneWidget,
    );
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
  });

  testWidgets('tapping the switch calls onChanged with the toggled value', (
    tester,
  ) async {
    bool? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LabeledToggleRow(
            title: 'Search for it now',
            subtitle: 'Uses your 3 enabled indexers',
            value: true,
            onChanged: (v) => captured = v,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(captured, isFalse);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/labeled_toggle_row_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/core/widgets/labeled_toggle_row.dart
/// Title/subtitle row with a trailing `Switch` (README §3b, §3d): "Search
/// immediately", "Search for it now". Replaces `SwitchListTile`'s default
/// `ListTile` chrome/padding; delegates to Flutter's `Switch` for the
/// toggle visuals themselves, which the app theme already colors.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class LabeledToggleRow extends StatelessWidget {
  const LabeledToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.cardTitle),
              const SizedBox(height: AppSpacing.space2),
              Text(
                subtitle,
                style: AppTypography.meta.copyWith(color: AppColors.n500),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/labeled_toggle_row_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/core/widgets/labeled_toggle_row.dart test/core/widgets/labeled_toggle_row_test.dart
dart analyze lib/core/widgets/labeled_toggle_row.dart
git add lib/core/widgets/labeled_toggle_row.dart test/core/widgets/labeled_toggle_row_test.dart
git commit -m "feat(core): add LabeledToggleRow shared widget"
```

---

### Task 5: `MediaDetailHeader` poster-slot extension

**Files:**
- Modify: `lib/features/library/widgets/media_detail_header.dart` (full rewrite)
- Modify: `lib/features/library/movie_detail_page.dart:111-141` (its `MediaDetailHeader(...)` call)
- Modify: `lib/features/library/series_detail_page.dart:120-147` (its `MediaDetailHeader(...)` call)
- Test: `test/features/library/widgets/media_detail_header_test.dart` (update to the new signature)

**Interfaces:**
- Produces: `MediaDetailHeader({required Widget poster, required String title, required List<String> metaParts, required List<Widget> chips, required List<(String value, String caption)> stats})` — **breaking change**: `posterUrl`/`service`/`instanceId` are removed; callers now construct their own poster widget, sized to 104×156 (the fixed 2e/2g poster size). Task 12 (3b) constructs a plain `CachedNetworkImage`-backed poster from Seerr's already-absolute TMDB URL; the two existing callers construct `ResolvedPoster(...)` explicitly.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/library/widgets/media_detail_header_test.dart
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders title, meta, chips, and both stats', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MediaDetailHeader(
            poster: SizedBox(width: 104, height: 156),
            title: 'Severance',
            metaParts: ['2022', 'Apple TV+', 'TV-MA'],
            chips: [Text('★ 8.7'), Text('Monitored')],
            stats: [('19/19', 'EPISODES'), ('61 GB', 'ON DISK')],
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

  testWidgets('renders the given poster widget directly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MediaDetailHeader(
            poster: Icon(Icons.movie, key: Key('custom-poster')),
            title: 'Dune',
            metaParts: [],
            chips: [],
            stats: [],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('custom-poster')), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/library/widgets/media_detail_header_test.dart`
Expected: FAIL — `posterUrl`/`service`/`instanceId` are required today, `poster` doesn't exist.

- [ ] **Step 3: Write minimal implementation**

Replace `lib/features/library/widgets/media_detail_header.dart` in full:

```dart
// lib/features/library/widgets/media_detail_header.dart
/// The poster-beside-title detail header shared by series (2e), movie (2g),
/// and Discover detail (3b): a poster left, then title/meta/chips/a 2-up
/// stat row right. The poster is caller-supplied (sized to 104×156) rather
/// than resolved internally — Radarr/Sonarr callers construct
/// `ResolvedPoster` (relative-URL-by-instance resolution); Seerr's Discover
/// detail page (3b) constructs a plain `CachedNetworkImage` from its
/// already-absolute TMDB URL, which `ResolvedPoster` has no branch for.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class MediaDetailHeader extends StatelessWidget {
  const MediaDetailHeader({
    required this.poster,
    required this.title,
    required this.metaParts,
    required this.chips,
    required this.stats,
    super.key,
  });

  final Widget poster;
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
        poster,
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

In `lib/features/library/movie_detail_page.dart`, add
`import 'package:arrstack/core/widgets/resolved_poster.dart';` and replace the
`MediaDetailHeader(...)` call's first four named arguments:

```dart
          MediaDetailHeader(
            poster: ResolvedPoster(
              service: ServiceType.radarr,
              instanceId: widget.instanceId,
              relativeUrl: movie.posterUrl,
              width: 104,
              height: 156,
              radius: AppRadius.md,
            ),
            title: movie.title,
```
(the rest of the call — `metaParts`, `chips`, `stats` — is unchanged).

In `lib/features/library/series_detail_page.dart`, add the same
`ResolvedPoster` import and replace the call's first four named arguments:

```dart
          MediaDetailHeader(
            poster: ResolvedPoster(
              service: ServiceType.sonarr,
              instanceId: widget.instanceId,
              relativeUrl: series.posterUrl,
              width: 104,
              height: 156,
              radius: AppRadius.md,
            ),
            title: series.title,
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/library/widgets/media_detail_header_test.dart
flutter test test/features/library/movie_detail_page_test.dart
flutter test test/features/library/series_detail_page_test.dart
```

Expected: all PASS. The movie/series detail page tests should pass
unmodified — `ResolvedPoster`'s provider dependencies are unchanged, just
relocated from inside `MediaDetailHeader` to each call site.

- [ ] **Step 5: Commit**

```bash
dart format lib/features/library/widgets/media_detail_header.dart lib/features/library/movie_detail_page.dart lib/features/library/series_detail_page.dart test/features/library/widgets/media_detail_header_test.dart
dart analyze lib/features/library/widgets/media_detail_header.dart lib/features/library/movie_detail_page.dart lib/features/library/series_detail_page.dart
git add lib/features/library/widgets/media_detail_header.dart lib/features/library/movie_detail_page.dart lib/features/library/series_detail_page.dart test/features/library/widgets/media_detail_header_test.dart
git commit -m "refactor(library): give MediaDetailHeader a caller-supplied poster slot"
```

---

### Task 6: Seerr service-details freezed models

**Files:**
- Modify: `lib/services/seerr/models/seerr_models.dart` (append three new models)
- Test: `test/services/seerr/models/seerr_models_test.dart` (create if it doesn't exist; check first — `find test/services/seerr -type f`)

**Interfaces:**
- Produces: `SeerrServiceProfile({required int id, required String name})`, `SeerrServiceRootFolder({required String path, int? freeSpace, int? totalSpace})`, `SeerrServiceDetails({List<SeerrServiceProfile> profiles = [], List<SeerrServiceRootFolder> rootFolders = []})`, each with the standard freezed `fromJson`/`toJson`. Task 7's client methods parse into `SeerrServiceDetails`; Task 12 consumes `profiles`/`rootFolders`.

Field names below match Overseerr/Jellyseerr's documented `/service/radarr/:id`
shape as best known — **verify against a live instance or the shipped
`openapi.json` during Step 3** and adjust field names/`@JsonKey` mappings if
they differ before moving on; Task 7's client test is what actually proves
the parse works end-to-end.

- [ ] **Step 1: Write the failing test**

```dart
// test/services/seerr/models/seerr_models_test.dart
// (append this group if the file already has other groups — check first)
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeerrServiceProfile', () {
    test('parses from json', () {
      final profile = SeerrServiceProfile.fromJson({'id': 6, 'name': 'HD-1080p'});
      expect(profile.id, 6);
      expect(profile.name, 'HD-1080p');
    });
  });

  group('SeerrServiceRootFolder', () {
    test('parses free/total space when present', () {
      final folder = SeerrServiceRootFolder.fromJson({
        'path': '/data/media/movies',
        'freeSpace': 2400000000000,
        'totalSpace': 18000000000000,
      });
      expect(folder.path, '/data/media/movies');
      expect(folder.freeSpace, 2400000000000);
      expect(folder.totalSpace, 18000000000000);
    });

    test('tolerates missing free/total space', () {
      final folder = SeerrServiceRootFolder.fromJson({'path': '/data/media/movies'});
      expect(folder.freeSpace, isNull);
      expect(folder.totalSpace, isNull);
    });
  });

  group('SeerrServiceDetails', () {
    test('parses nested profiles and rootFolders', () {
      final details = SeerrServiceDetails.fromJson({
        'profiles': [
          {'id': 6, 'name': 'HD-1080p'},
        ],
        'rootFolders': [
          {'path': '/data/media/movies', 'freeSpace': 100, 'totalSpace': 200},
        ],
      });
      expect(details.profiles, hasLength(1));
      expect(details.profiles.first.name, 'HD-1080p');
      expect(details.rootFolders, hasLength(1));
      expect(details.rootFolders.first.path, '/data/media/movies');
    });

    test('defaults to empty lists when both fields are absent', () {
      final details = SeerrServiceDetails.fromJson(const {});
      expect(details.profiles, isEmpty);
      expect(details.rootFolders, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/seerr/models/seerr_models_test.dart`
Expected: FAIL — the three classes don't exist yet.

- [ ] **Step 3: Add the models**

Append to `lib/services/seerr/models/seerr_models.dart`, after the existing
`SeerrGenre` class:

```dart
@freezed
abstract class SeerrServiceProfile with _$SeerrServiceProfile {
  const factory SeerrServiceProfile({
    required int id,
    required String name,
  }) = _SeerrServiceProfile;

  factory SeerrServiceProfile.fromJson(Map<String, dynamic> json) =>
      _$SeerrServiceProfileFromJson(json);
}

@freezed
abstract class SeerrServiceRootFolder with _$SeerrServiceRootFolder {
  const factory SeerrServiceRootFolder({
    required String path,
    int? freeSpace,
    int? totalSpace,
  }) = _SeerrServiceRootFolder;

  factory SeerrServiceRootFolder.fromJson(Map<String, dynamic> json) =>
      _$SeerrServiceRootFolderFromJson(json);
}

@freezed
abstract class SeerrServiceDetails with _$SeerrServiceDetails {
  const factory SeerrServiceDetails({
    @Default([]) List<SeerrServiceProfile> profiles,
    @Default([]) List<SeerrServiceRootFolder> rootFolders,
  }) = _SeerrServiceDetails;

  factory SeerrServiceDetails.fromJson(Map<String, dynamic> json) =>
      _$SeerrServiceDetailsFromJson(json);
}
```

Regenerate code-gen:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: `seerr_models.freezed.dart` and `seerr_models.g.dart` regenerate
with no errors, adding the three new classes' generated members.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/services/seerr/models/seerr_models_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/services/seerr/models/seerr_models.dart test/services/seerr/models/seerr_models_test.dart
dart analyze lib/services/seerr/models/seerr_models.dart
git add lib/services/seerr/models/seerr_models.dart lib/services/seerr/models/seerr_models.freezed.dart lib/services/seerr/models/seerr_models.g.dart test/services/seerr/models/seerr_models_test.dart
git commit -m "feat(seerr): add SeerrServiceProfile/RootFolder/Details models"
```

---

### Task 7: Seerr client/repository/provider additions

**Files:**
- Modify: `lib/services/seerr/seerr_client.dart` (add four methods, extend `request()`)
- Modify: `lib/services/seerr/seerr_repository.dart` (mirror each)
- Modify: `lib/services/seerr/seerr_providers.dart` (add three providers)
- Test: `test/services/seerr/seerr_client_test.dart` (new — no Seerr client tests exist today)

**Interfaces:**
- Consumes: `SeerrServiceDetails` (Task 6).
- Produces: `SeerrClient.getRadarrService(int serviceId)`, `.getSonarrService(int serviceId)`, `.approveRequest(int requestId)`, `.declineRequest(int requestId)` (all `Future<Result<...>>`); `request()` gains optional `int? serverId, int? profileId, String? rootFolder`. `SeerrRepository` mirrors all four plus `request()`. New providers: `seerrRadarrServiceProvider({required String instanceId, required int serviceId})`, `seerrSonarrServiceProvider({required String instanceId, required int serviceId})` (both `Future<Result<SeerrServiceDetails>>`), and `seerrAllRequestsProvider(String instanceId)` (`Future<Result<List<SeerrRequest>>>`, paginates `getRequests(filter: 'all')` to completion — see the doc comment for why). Task 9 (Requests page) consumes `seerrAllRequestsProvider` and the approve/decline repository methods; Task 12 (3b) consumes the service-detail providers and extended `request()`.

- [ ] **Step 1: Write the failing tests**

```dart
// test/services/seerr/seerr_client_test.dart
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SeerrClient client;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://example.test'));
    adapter = DioAdapter(dio: dio);
    client = SeerrClient(dio);
  });

  test('getRadarrService parses profiles and rootFolders', () async {
    adapter.onGet(
      'api/v1/service/radarr/3',
      (server) => server.reply(200, {
        'profiles': [
          {'id': 6, 'name': 'HD-1080p'},
        ],
        'rootFolders': [
          {'path': '/data/media/movies', 'freeSpace': 100, 'totalSpace': 200},
        ],
      }),
    );

    final result = await client.getRadarrService(3);

    expect(result.isOk, isTrue);
  });

  test('getSonarrService requests the service-detail endpoint', () async {
    adapter.onGet(
      'api/v1/service/sonarr/5',
      (server) => server.reply(200, {'profiles': [], 'rootFolders': []}),
    );

    final result = await client.getSonarrService(5);

    expect(result.isOk, isTrue);
  });

  test('approveRequest POSTs to the approve endpoint', () async {
    adapter.onPost(
      'api/v1/request/42/approve',
      (server) => server.reply(200, {'id': 42, 'status': 2}),
    );

    final result = await client.approveRequest(42);

    expect(result.isOk, isTrue);
  });

  test('declineRequest POSTs to the decline endpoint', () async {
    adapter.onPost(
      'api/v1/request/42/decline',
      (server) => server.reply(200, {'id': 42, 'status': 3}),
    );

    final result = await client.declineRequest(42);

    expect(result.isOk, isTrue);
  });

  test('request omits serverId/profileId/rootFolder from the body when null', () async {
    RequestOptions? captured;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );
    adapter.onPost(
      'api/v1/request',
      (server) => server.reply(200, {'id': 1, 'status': 1}),
      data: {'mediaType': 'movie', 'mediaId': 100},
    );

    await client.request(100, 'movie');

    expect(captured!.data, {'mediaType': 'movie', 'mediaId': 100});
  });

  test('request includes serverId/profileId/rootFolder when given', () async {
    RequestOptions? captured;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          captured = options;
          handler.next(options);
        },
      ),
    );
    adapter.onPost(
      'api/v1/request',
      (server) => server.reply(200, {'id': 1, 'status': 1}),
      data: {
        'mediaType': 'movie',
        'mediaId': 100,
        'serverId': 0,
        'profileId': 6,
        'rootFolder': '/data/media/movies',
      },
    );

    await client.request(
      100,
      'movie',
      serverId: 0,
      profileId: 6,
      rootFolder: '/data/media/movies',
    );

    expect(captured!.data, {
      'mediaType': 'movie',
      'mediaId': 100,
      'serverId': 0,
      'profileId': 6,
      'rootFolder': '/data/media/movies',
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/services/seerr/seerr_client_test.dart`
Expected: FAIL — none of the new methods exist; `request()` doesn't accept
the new named params.

- [ ] **Step 3: Write the implementation**

In `lib/services/seerr/seerr_client.dart`, replace the existing `request()`
method with:

```dart
  Future<Result<SeerrRequest>> request(
    int tmdbId,
    String mediaType, {
    List<int>? seasons,
    int? serverId,
    int? profileId,
    String? rootFolder,
  }) {
    return dioCall(
      () => _dio.post(
        'api/v1/request',
        data: {
          'mediaType': mediaType,
          'mediaId': tmdbId,
          'seasons': ?seasons,
          'serverId': ?serverId,
          'profileId': ?profileId,
          'rootFolder': ?rootFolder,
        },
      ),
      map: (data) => SeerrRequest.fromJson(data as Map<String, dynamic>),
    );
  }
```

Then add, after `deleteRequest`:

```dart
  Future<Result<SeerrServiceDetails>> getRadarrService(int serviceId) {
    return dioCall(
      () => _dio.get('api/v1/service/radarr/$serviceId'),
      map: (data) => SeerrServiceDetails.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<SeerrServiceDetails>> getSonarrService(int serviceId) {
    return dioCall(
      () => _dio.get('api/v1/service/sonarr/$serviceId'),
      map: (data) => SeerrServiceDetails.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<SeerrRequest>> approveRequest(int requestId) {
    return dioCall(
      () => _dio.post('api/v1/request/$requestId/approve'),
      map: (data) => SeerrRequest.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<SeerrRequest>> declineRequest(int requestId) {
    return dioCall(
      () => _dio.post('api/v1/request/$requestId/decline'),
      map: (data) => SeerrRequest.fromJson(data as Map<String, dynamic>),
    );
  }
```

In `lib/services/seerr/seerr_repository.dart`, replace `request()` and add
the four mirrors:

```dart
  Future<Result<SeerrRequest>> request(
    int tmdbId,
    String mediaType, {
    List<int>? seasons,
    int? serverId,
    int? profileId,
    String? rootFolder,
  }) => _client.request(
    tmdbId,
    mediaType,
    seasons: seasons,
    serverId: serverId,
    profileId: profileId,
    rootFolder: rootFolder,
  );

  Future<Result<SeerrServiceDetails>> getRadarrService(int serviceId) =>
      _client.getRadarrService(serviceId);

  Future<Result<SeerrServiceDetails>> getSonarrService(int serviceId) =>
      _client.getSonarrService(serviceId);

  Future<Result<SeerrRequest>> approveRequest(int requestId) =>
      _client.approveRequest(requestId);

  Future<Result<SeerrRequest>> declineRequest(int requestId) =>
      _client.declineRequest(requestId);
```

In `lib/services/seerr/seerr_providers.dart`, add after the existing
`seerrRequests` provider:

```dart
@riverpod
Future<Result<SeerrServiceDetails>> seerrRadarrService(
  Ref ref, {
  required String instanceId,
  required int serviceId,
}) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.getRadarrService(serviceId);
}

@riverpod
Future<Result<SeerrServiceDetails>> seerrSonarrService(
  Ref ref, {
  required String instanceId,
  required int serviceId,
}) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  return repository.getSonarrService(serviceId);
}

/// Every request across every status, fetched by paginating
/// `getRequests(filter: 'all')` to completion. The Requests queue (README
/// §3c) needs the *complete* set to bucket and count correctly — see
/// `requests_bucketing.dart` — so a single default-`take` page is not
/// enough once there are more requests than that page size.
@riverpod
Future<Result<List<SeerrRequest>>> seerrAllRequests(
  Ref ref,
  String instanceId,
) async {
  final repository = await ref.watch(
    seerrRepositoryProvider(instanceId).future,
  );
  final all = <SeerrRequest>[];
  var skip = 0;
  const pageSize = 50;

  while (true) {
    final result = await repository.getRequests(
      filter: 'all',
      take: pageSize,
      skip: skip,
    );
    switch (result) {
      case Err(:final error):
        return Err(error);
      case Ok(:final value):
        all.addAll(value.results);
        skip += value.results.length;
        if (value.results.isEmpty || all.length >= value.pageInfo.results) {
          return Ok(all);
        }
    }
  }
}
```

Regenerate code-gen:

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/services/seerr/
```

Expected: PASS (all new tests; no pre-existing Seerr tests to regress).

- [ ] **Step 5: Commit**

```bash
dart format lib/services/seerr/ test/services/seerr/
dart analyze lib/services/seerr/
git add lib/services/seerr/seerr_client.dart lib/services/seerr/seerr_repository.dart lib/services/seerr/seerr_providers.dart lib/services/seerr/seerr_providers.g.dart test/services/seerr/seerr_client_test.dart
git commit -m "feat(seerr): add approve/decline, service-details, and extended request()"
```

---

### Task 8: Requests bucketing pure logic

**Files:**
- Create: `lib/features/requests/requests_bucketing.dart`
- Test: `test/features/requests/requests_bucketing_test.dart`

This task establishes the new `lib/features/requests/` top-level feature
directory — matching this app's existing precedent of one top-level
directory per Home-reachable sub-screen (`uptime/`, `indexers/`, `settings/`,
`einthusan_import/`), rather than nesting under `discover/`.

**Interfaces:**
- Consumes: `SeerrRequest`, `SeerrRequestStatus`, `SeerrMediaStatus` from `seerr_models.dart`.
- Produces: `List<SeerrRequest> needsDecision(List<SeerrRequest> requests)`, `List<SeerrRequest> inProgress(List<SeerrRequest> requests)`, `List<SeerrRequest> availableRequests(List<SeerrRequest> requests)`, `class RequestStats { int pending, processing, available }`, `RequestStats requestStats(List<SeerrRequest> requests)`. Task 9 consumes all five.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/requests/requests_bucketing_test.dart
import 'package:arrstack/features/requests/requests_bucketing.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter_test/flutter_test.dart';

SeerrRequest req({
  required int id,
  required int status,
  int mediaStatus = SeerrMediaStatus.unknown,
}) => SeerrRequest(
  id: id,
  status: status,
  media: SeerrRequestMedia(id: id, status: mediaStatus),
);

void main() {
  group('needsDecision', () {
    test('includes only pending requests', () {
      final requests = [
        req(id: 1, status: SeerrRequestStatus.pending),
        req(id: 2, status: SeerrRequestStatus.approved),
      ];
      expect(needsDecision(requests).map((r) => r.id), [1]);
    });
  });

  group('inProgress', () {
    test(
      'an approved request whose media is still processing lands here, not dropped',
      () {
        final requests = [
          req(
            id: 1,
            status: SeerrRequestStatus.approved,
            mediaStatus: SeerrMediaStatus.processing,
          ),
        ];
        expect(inProgress(requests).map((r) => r.id), [1]);
      },
    );

    test('excludes pending requests (those need a decision, not progress)', () {
      final requests = [req(id: 1, status: SeerrRequestStatus.pending)];
      expect(inProgress(requests), isEmpty);
    });

    test('excludes requests whose media is already available', () {
      final requests = [
        req(
          id: 1,
          status: SeerrRequestStatus.approved,
          mediaStatus: SeerrMediaStatus.available,
        ),
      ];
      expect(inProgress(requests), isEmpty);
    });
  });

  group('declined and failed requests appear in no bucket', () {
    for (final status in [SeerrRequestStatus.declined, SeerrRequestStatus.failed]) {
      test('status $status', () {
        final requests = [
          req(id: 1, status: status, mediaStatus: SeerrMediaStatus.processing),
        ];
        expect(needsDecision(requests), isEmpty);
        expect(inProgress(requests), isEmpty);
        expect(availableRequests(requests), isEmpty);
      });
    }
  });

  group('availableRequests', () {
    test('includes completed requests whose media is available', () {
      final requests = [
        req(
          id: 1,
          status: SeerrRequestStatus.completed,
          mediaStatus: SeerrMediaStatus.available,
        ),
      ];
      expect(availableRequests(requests).map((r) => r.id), [1]);
    });
  });

  group('requestStats', () {
    test('counts each bucket independently', () {
      final requests = [
        req(id: 1, status: SeerrRequestStatus.pending),
        req(id: 2, status: SeerrRequestStatus.pending),
        req(
          id: 3,
          status: SeerrRequestStatus.approved,
          mediaStatus: SeerrMediaStatus.processing,
        ),
        req(
          id: 4,
          status: SeerrRequestStatus.completed,
          mediaStatus: SeerrMediaStatus.available,
        ),
      ];
      final stats = requestStats(requests);
      expect(stats.pending, 2);
      expect(stats.processing, 1);
      expect(stats.available, 1);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/requests/requests_bucketing_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/requests/requests_bucketing.dart
/// Pure bucketing for the Requests queue (README §3c). Splits by two
/// different status axes on purpose: "needs a decision" is driven by the
/// *request's* own approval status; "in progress" and "available" are
/// driven by the *media's* fulfillment status among non-declined/
/// non-failed requests. A request can be `approved` (request status) while
/// its media is still `processing` (media status) — that's an in-progress
/// row, not a dropped one. See the Phase 7 design spec, Decision 7.
library;

import 'package:arrstack/services/seerr/models/seerr_models.dart';

List<SeerrRequest> needsDecision(List<SeerrRequest> requests) =>
    requests.where((r) => r.status == SeerrRequestStatus.pending).toList();

List<SeerrRequest> inProgress(List<SeerrRequest> requests) => requests
    .where(
      (r) =>
          r.status != SeerrRequestStatus.pending &&
          r.status != SeerrRequestStatus.declined &&
          r.status != SeerrRequestStatus.failed &&
          (r.media?.status ?? SeerrMediaStatus.unknown) !=
              SeerrMediaStatus.available,
    )
    .toList();

List<SeerrRequest> availableRequests(List<SeerrRequest> requests) => requests
    .where(
      (r) =>
          r.status != SeerrRequestStatus.declined &&
          r.status != SeerrRequestStatus.failed &&
          r.media?.status == SeerrMediaStatus.available,
    )
    .toList();

class RequestStats {
  const RequestStats({
    required this.pending,
    required this.processing,
    required this.available,
  });

  final int pending;
  final int processing;
  final int available;
}

RequestStats requestStats(List<SeerrRequest> requests) => RequestStats(
  pending: needsDecision(requests).length,
  processing: inProgress(requests).length,
  available: availableRequests(requests).length,
);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/requests/requests_bucketing_test.dart`
Expected: PASS (8 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/requests/requests_bucketing.dart test/features/requests/requests_bucketing_test.dart
dart analyze lib/features/requests/requests_bucketing.dart
git add lib/features/requests/requests_bucketing.dart test/features/requests/requests_bucketing_test.dart
git commit -m "feat(requests): add pure request-bucketing and stat logic"
```

---

### Task 9: `RequestCard` and `InProgressRow` widgets

**Files:**
- Create: `lib/features/requests/widgets/request_card.dart`
- Create: `lib/features/requests/widgets/in_progress_row.dart`
- Test: `test/features/requests/widgets/request_card_test.dart`
- Test: `test/features/requests/widgets/in_progress_row_test.dart`

**Interfaces:**
- Consumes: `mediaStatusPresentation` (Task 1), `seerrDetailProvider`, `seerrRepositoryProvider` (existing), `SeerrClient`/`SeerrRepository.approveRequest`/`.declineRequest` (Task 7), `formatRelativeTime` from `lib/features/discover/utils/relative_time.dart` (existing).
- Produces: `RequestCard({required String instanceId, required SeerrRequest request, required VoidCallback onDecided})`, `InProgressRow({required String instanceId, required SeerrRequest request})`. Task 10 (`RequestsPage`) constructs both.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/requests/widgets/request_card_test.dart
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/requests/widgets/request_card.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_client.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:arrstack/services/seerr/seerr_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

SeerrRequest pendingRequest({int id = 1}) => SeerrRequest(
  id: id,
  status: SeerrRequestStatus.pending,
  media: const SeerrRequestMedia(id: 1, tmdbId: 100, mediaType: 'movie'),
  requestedBy: const SeerrRequestUser(displayName: 'harivin'),
);

class _FakeRepository extends SeerrRepository {
  _FakeRepository({this.approveError, this.declineError})
    : super(SeerrClient(Dio()));

  final AppError? approveError;
  final AppError? declineError;
  int approveCalls = 0;
  int declineCalls = 0;

  @override
  Future<Result<SeerrRequest>> approveRequest(int requestId) async {
    approveCalls++;
    final error = approveError;
    if (error != null) return Err(error);
    return Ok(pendingRequest(id: requestId));
  }

  @override
  Future<Result<SeerrRequest>> declineRequest(int requestId) async {
    declineCalls++;
    final error = declineError;
    if (error != null) return Err(error);
    return Ok(pendingRequest(id: requestId));
  }
}

Widget host(_FakeRepository repo, {VoidCallback? onDecided}) {
  return ProviderScope(
    overrides: [
      seerrRepositoryProvider(instanceId).overrideWith((ref) async => repo),
      seerrDetailProvider(instanceId: instanceId, id: 100, mediaType: 'movie')
          .overrideWith(
            (ref) async =>
                const Ok(SeerrResult(id: 100, title: 'Mickey 17')),
          ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: RequestCard(
          instanceId: instanceId,
          request: pendingRequest(),
          onDecided: onDecided ?? () {},
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the title, a Pending tag, and Approve/Deny buttons', (
    tester,
  ) async {
    await tester.pumpWidget(host(_FakeRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Mickey 17'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
  });

  testWidgets(
    'tapping Approve calls the repository, disables both buttons, and notifies onDecided',
    (tester) async {
      final repo = _FakeRepository();
      var decided = false;
      await tester.pumpWidget(host(repo, onDecided: () => decided = true));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(OutlinedButton, 'Approve'));
      await tester.pump();

      expect(repo.approveCalls, 1);
      final denyButton = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Deny'),
      );
      expect(denyButton.onPressed, isNull);

      await tester.pumpAndSettle();
      expect(decided, isTrue);
    },
  );

  testWidgets('a failed decline shows an error and re-enables both buttons', (
    tester,
  ) async {
    final repo = _FakeRepository(
      declineError: const UnknownError(userMessage: 'boom'),
    );
    await tester.pumpWidget(host(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Deny'));
    await tester.pumpAndSettle();

    expect(find.text('boom'), findsOneWidget);
    final approveButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Approve'),
    );
    expect(approveButton.onPressed, isNotNull);
  });
}
```

```dart
// test/features/requests/widgets/in_progress_row_test.dart
import 'package:arrstack/features/requests/widgets/in_progress_row.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

Widget host(SeerrRequest request) {
  return ProviderScope(
    overrides: [
      seerrDetailProvider(instanceId: instanceId, id: 200, mediaType: 'tv')
          .overrideWith(
            (ref) async => const Ok(SeerrResult(id: 200, name: 'Andor')),
          ),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: InProgressRow(instanceId: instanceId, request: request),
      ),
    ),
  );
}

void main() {
  testWidgets('a processing movie shows "searching indexers" and a Processing tag', (
    tester,
  ) async {
    final request = SeerrRequest(
      id: 1,
      status: SeerrRequestStatus.approved,
      media: const SeerrRequestMedia(
        id: 200,
        tmdbId: 200,
        mediaType: 'tv',
        status: SeerrMediaStatus.processing,
      ),
      requestedBy: const SeerrRequestUser(displayName: 'harivin'),
    );

    await tester.pumpWidget(host(request));
    await tester.pumpAndSettle();

    expect(find.text('Andor'), findsOneWidget);
    expect(find.textContaining('searching indexers'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);
  });

  testWidgets(
    'a partially available series shows the season list and a Partial tag',
    (tester) async {
      final request = SeerrRequest(
        id: 1,
        status: SeerrRequestStatus.approved,
        media: const SeerrRequestMedia(
          id: 200,
          tmdbId: 200,
          mediaType: 'tv',
          status: SeerrMediaStatus.partiallyAvailable,
        ),
        requestedBy: const SeerrRequestUser(displayName: 'devon'),
        seasons: const [
          SeerrRequestSeason(id: 1, seasonNumber: 1),
          SeerrRequestSeason(id: 2, seasonNumber: 2),
        ],
      );

      await tester.pumpWidget(host(request));
      await tester.pumpAndSettle();

      expect(find.textContaining('seasons 1, 2'), findsOneWidget);
      expect(find.text('Partial'), findsOneWidget);
    },
  );
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/requests/widgets/
```

Expected: FAIL — neither file exists.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/requests/widgets/request_card.dart
/// A "needs a decision" card (README §3c): poster, title, a type tag + a
/// fixed "Pending" tag, an attribution line, and inline Approve/Deny — no
/// overflow menu. Every request rendered here is pending by construction
/// (this page only places it in the "needs a decision" section), so
/// "Pending" is a fixed style rather than derived from
/// `mediaStatusPresentation`. The attribution line omits any quality-profile
/// fragment — `SeerrRequest` doesn't carry a profile name (Phase 7 design
/// spec, Decision 10) — rather than fabricating one.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/discover/utils/relative_time.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class RequestCard extends ConsumerStatefulWidget {
  const RequestCard({
    required this.instanceId,
    required this.request,
    required this.onDecided,
    super.key,
  });

  final String instanceId;
  final SeerrRequest request;
  final VoidCallback onDecided;

  @override
  ConsumerState<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<RequestCard> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final media = widget.request.media;
    final tmdbId = media?.tmdbId;
    final detailAsync = tmdbId == null
        ? null
        : ref.watch(
            seerrDetailProvider(
              instanceId: widget.instanceId,
              id: tmdbId,
              mediaType: media!.mediaType,
            ),
          );
    final detail = switch (detailAsync?.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final title = detail?.displayTitle ?? 'Request #${widget.request.id}';
    final posterUrl = detail?.posterUrl;
    final isTv = media?.mediaType == 'tv';

    return Container(
      padding: AppInsets.pageMd,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: posterUrl != null
                    ? Image.network(
                        posterUrl,
                        width: 44,
                        height: 66,
                        fit: BoxFit.cover,
                      )
                    : Container(width: 44, height: 66, color: AppColors.n800),
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.cardTitle),
                    const SizedBox(height: AppSpacing.space2),
                    Wrap(
                      spacing: AppSpacing.space2,
                      children: [
                        _tag(
                          isTv ? 'TV' : 'Movie',
                          fill: AppColors.n900,
                          text: AppColors.n300,
                        ),
                        _tag('Pending', fill: AppColors.a800, text: AppColors.warning),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      _attribution(widget.request),
                      style: AppTypography.meta.copyWith(color: AppColors.n500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          if (_error != null) ...[
            Text(
              _error!,
              style: AppTypography.meta.copyWith(color: AppColors.down),
            ),
            const SizedBox(height: AppSpacing.space2),
          ],
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _decide(approve: true),
                icon: _busy
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        PhosphorIconsRegular.check,
                        size: 15,
                        color: AppColors.accent,
                      ),
                label: const Text('Approve'),
              ),
              const SizedBox(width: AppSpacing.space3),
              OutlinedButton(
                onPressed: _busy ? null : () => _decide(approve: false),
                child: const Text('Deny'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _attribution(SeerrRequest request) {
    final name = request.requestedBy?.displayName ?? 'unknown';
    final createdAt = request.createdAt;
    if (createdAt == null) return 'by $name';
    return 'by $name · ${formatRelativeTime(createdAt)}';
  }

  Widget _tag(String label, {required Color fill, required Color text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _decide({required bool approve}) async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final repository = await ref.read(
      seerrRepositoryProvider(widget.instanceId).future,
    );
    final result = approve
        ? await repository.approveRequest(widget.request.id)
        : await repository.declineRequest(widget.request.id);

    if (!mounted) return;
    switch (result) {
      case Ok():
        widget.onDecided();
      case Err(:final error):
        setState(() {
          _busy = false;
          _error = error.userMessage;
        });
    }
  }
}
```

```dart
// lib/features/requests/widgets/in_progress_row.dart
/// A compact "in progress" row (README §3c): poster, title, a status line,
/// and a trailing tag. `processing` → "searching indexers" for both movies
/// and TV, since Overseerr's request API exposes no per-episode download
/// detail (Phase 7 design spec, Decision 9); `partiallyAvailable` → a
/// season-list line plus a green "Partial" tag, shortened from
/// `mediaStatusPresentation`'s literal "Partially Available" label.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/models/seerr_status_presentation.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InProgressRow extends ConsumerWidget {
  const InProgressRow({
    required this.instanceId,
    required this.request,
    super.key,
  });

  final String instanceId;
  final SeerrRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = request.media;
    final tmdbId = media?.tmdbId;
    final detailAsync = tmdbId == null
        ? null
        : ref.watch(
            seerrDetailProvider(
              instanceId: instanceId,
              id: tmdbId,
              mediaType: media!.mediaType,
            ),
          );
    final detail = switch (detailAsync?.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final title = detail?.displayTitle ?? 'Request #${request.id}';
    final posterUrl = detail?.posterUrl;
    final mediaStatus = media?.status ?? SeerrMediaStatus.unknown;
    final presentation = mediaStatusPresentation(mediaStatus);
    final isPartial = mediaStatus == SeerrMediaStatus.partiallyAvailable;
    final tagLabel = isPartial ? 'Partial' : (presentation?.label ?? 'Processing');
    final tagColor = isPartial ? AppColors.up : (presentation?.color ?? AppColors.accent);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: posterUrl != null
                ? Image.network(posterUrl, width: 32, height: 48, fit: BoxFit.cover)
                : Container(width: 32, height: 48, color: AppColors.n800),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.cardTitle),
                Text(
                  _statusLine(isPartial),
                  style: AppTypography.meta.copyWith(color: AppColors.n500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              tagLabel,
              style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLine(bool isPartial) {
    final by = 'by ${request.requestedBy?.displayName ?? 'unknown'}';
    if (isPartial && request.seasons.isNotEmpty) {
      final seasons = request.seasons.map((s) => s.seasonNumber).join(', ');
      return '$by · seasons $seasons';
    }
    return '$by · searching indexers';
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/requests/widgets/
```

Expected: PASS (3 + 2 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/requests/widgets/ test/features/requests/widgets/
dart analyze lib/features/requests/widgets/
git add lib/features/requests/widgets/request_card.dart lib/features/requests/widgets/in_progress_row.dart test/features/requests/widgets/request_card_test.dart test/features/requests/widgets/in_progress_row_test.dart
git commit -m "feat(requests): add RequestCard and InProgressRow widgets"
```

---

### Task 10: `RequestsPage` and the `/home/requests` route

**Files:**
- Create: `lib/features/requests/requests_page.dart`
- Modify: `lib/app/route_paths.dart` (add `homeRequests`)
- Modify: `lib/app/router.dart` (register the route)
- Test: `test/features/requests/requests_page_test.dart`

**Interfaces:**
- Consumes: `needsDecision`/`inProgress`/`availableRequests`/`requestStats` (Task 8), `RequestCard`/`InProgressRow` (Task 9), `seerrAllRequestsProvider` (Task 7), `selectedSeerrInstanceIdProvider` (existing), `SubPageHeader` (existing).
- Produces: `RequestsPage({RequestsFilter initialFilter = RequestsFilter.all})`, `enum RequestsFilter { all, pendingOnly, availableOnly }`, `RoutePaths.homeRequests`. Task 11 (Discover page) constructs a navigation to `RoutePaths.homeRequests`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/requests/requests_page_test.dart
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/requests/requests_page.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

SeerrRequest req({
  required int id,
  required int status,
  int mediaStatus = SeerrMediaStatus.unknown,
}) => SeerrRequest(id: id, status: status, media: SeerrRequestMedia(id: id, status: mediaStatus));

class _FakeSelectedInstance extends SelectedSeerrInstanceId {
  @override
  Future<String?> build() async => instanceId;
}

Widget host(List<SeerrRequest> requests, {RequestsFilter filter = RequestsFilter.all}) {
  return ProviderScope(
    overrides: [
      selectedSeerrInstanceIdProvider.overrideWith(() => _FakeSelectedInstance()),
      seerrAllRequestsProvider(instanceId).overrideWith((ref) async => Ok(requests)),
    ],
    child: MaterialApp(home: RequestsPage(initialFilter: filter)),
  );
}

void main() {
  testWidgets('shows the pending/processing/available stat counts', (tester) async {
    final requests = [
      req(id: 1, status: SeerrRequestStatus.pending),
      req(id: 2, status: SeerrRequestStatus.approved, mediaStatus: SeerrMediaStatus.processing),
      req(id: 3, status: SeerrRequestStatus.completed, mediaStatus: SeerrMediaStatus.available),
    ];
    await tester.pumpWidget(host(requests));
    await tester.pumpAndSettle();

    expect(find.text('PENDING'), findsOneWidget);
    expect(find.text('PROCESSING'), findsOneWidget);
    expect(find.text('AVAILABLE'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(3));
  });

  testWidgets('a pending request renders under "NEEDS A DECISION"', (tester) async {
    await tester.pumpWidget(host([req(id: 1, status: SeerrRequestStatus.pending)]));
    await tester.pumpAndSettle();

    expect(find.textContaining('NEEDS A DECISION'), findsOneWidget);
  });

  testWidgets('an in-progress request renders under "IN PROGRESS"', (tester) async {
    final requests = [
      req(id: 1, status: SeerrRequestStatus.approved, mediaStatus: SeerrMediaStatus.processing),
    ];
    await tester.pumpWidget(host(requests));
    await tester.pumpAndSettle();

    expect(find.textContaining('IN PROGRESS'), findsOneWidget);
  });

  testWidgets('a failed fetch shows a distinct error, not an empty list', (tester) async {
    final scope = ProviderScope(
      overrides: [
        selectedSeerrInstanceIdProvider.overrideWith(() => _FakeSelectedInstance()),
        seerrAllRequestsProvider(instanceId).overrideWith(
          (ref) async => const Err(UnknownError(userMessage: 'Could not reach Seerr')),
        ),
      ],
      child: const MaterialApp(home: RequestsPage()),
    );
    await tester.pumpWidget(scope);
    await tester.pumpAndSettle();

    expect(find.text('Could not reach Seerr'), findsOneWidget);
    expect(find.text('No requests'), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/requests/requests_page_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/requests/requests_page.dart
/// The Requests queue (README §3c): pending/processing/available stats,
/// "needs a decision" cards with inline Approve/Deny, and a compact
/// in-progress list. Fetches every request via `seerrAllRequestsProvider`
/// and buckets client-side (`requests_bucketing.dart`) rather than relying
/// on an unverified server-side filter vocabulary — Phase 7 design spec,
/// Decision 7.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/requests/requests_bucketing.dart';
import 'package:arrstack/features/requests/widgets/in_progress_row.dart';
import 'package:arrstack/features/requests/widgets/request_card.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

enum RequestsFilter { all, pendingOnly, availableOnly }

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({this.initialFilter = RequestsFilter.all, super.key});

  final RequestsFilter initialFilter;

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  late RequestsFilter _filter = widget.initialFilter;

  @override
  Widget build(BuildContext context) {
    final instanceIdAsync = ref.watch(selectedSeerrInstanceIdProvider);

    return Scaffold(
      appBar: SubPageHeader(
        kicker: 'SEERR',
        title: 'Requests',
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIconsRegular.funnel,
              size: 17,
              color: _filter == RequestsFilter.pendingOnly ? AppColors.accent : null,
            ),
            tooltip: 'Show pending only',
            onPressed: () => setState(() {
              _filter = _filter == RequestsFilter.pendingOnly
                  ? RequestsFilter.all
                  : RequestsFilter.pendingOnly;
            }),
          ),
        ],
      ),
      body: instanceIdAsync.when(
        data: (id) => id == null
            ? const EmptyState(icon: Icons.error_outline, title: 'No instance selected')
            : _RequestsBody(instanceId: id, filter: _filter),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _RequestsBody extends ConsumerWidget {
  const _RequestsBody({required this.instanceId, required this.filter});

  final String instanceId;
  final RequestsFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(seerrAllRequestsProvider(instanceId));

    return requestsAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _RequestsList(instanceId: instanceId, requests: value, filter: filter),
        Err(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load requests',
          message: error.userMessage,
        ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Unexpected error: $err')),
    );
  }
}

class _RequestsList extends ConsumerWidget {
  const _RequestsList({
    required this.instanceId,
    required this.requests,
    required this.filter,
  });

  final String instanceId;
  final List<SeerrRequest> requests;
  final RequestsFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = requestStats(requests);
    final pending = filter == RequestsFilter.availableOnly
        ? const <SeerrRequest>[]
        : needsDecision(requests);
    final progress = filter == RequestsFilter.all ? inProgress(requests) : const <SeerrRequest>[];
    final available = filter == RequestsFilter.availableOnly ? availableRequests(requests) : const <SeerrRequest>[];

    void refresh() => ref.invalidate(seerrAllRequestsProvider(instanceId));

    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: ListView(
        padding: AppInsets.pageMd,
        children: [
          if (filter != RequestsFilter.availableOnly) ...[
            Row(
              children: [
                _Stat(value: '${stats.pending}', label: 'PENDING', color: AppColors.warning),
                const SizedBox(width: AppSpacing.space8),
                _Stat(value: '${stats.processing}', label: 'PROCESSING', color: AppColors.accent),
                const SizedBox(width: AppSpacing.space8),
                _Stat(value: '${stats.available}', label: 'AVAILABLE', color: AppColors.up),
              ],
            ),
            const SizedBox(height: AppSpacing.space6),
          ],
          if (pending.isEmpty && progress.isEmpty && available.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.space8),
              child: EmptyState(icon: Icons.inbox_outlined, title: 'No requests'),
            ),
          if (pending.isNotEmpty) ...[
            Text('NEEDS A DECISION · ${pending.length}', style: AppTypography.kicker),
            const SizedBox(height: AppSpacing.space4),
            for (final request in pending)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: RequestCard(instanceId: instanceId, request: request, onDecided: refresh),
              ),
            const SizedBox(height: AppSpacing.space6),
          ],
          if (progress.isNotEmpty) ...[
            Text('IN PROGRESS · ${progress.length}', style: AppTypography.kicker),
            const SizedBox(height: AppSpacing.space4),
            for (final request in progress)
              InProgressRow(instanceId: instanceId, request: request),
            const SizedBox(height: AppSpacing.space6),
          ],
          if (available.isNotEmpty) ...[
            for (final request in available)
              InProgressRow(instanceId: instanceId, request: request),
          ],
          if (filter == RequestsFilter.all && stats.available > 0)
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RequestsPage(initialFilter: RequestsFilter.availableOnly),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${stats.available} available requests', style: AppTypography.body),
                    const Icon(PhosphorIconsRegular.caretRight, size: 14),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.statNumeral.copyWith(color: color)),
        Text(label, style: AppTypography.statCaption),
      ],
    );
  }
}
```

In `lib/app/route_paths.dart`, add alongside `homeDiscover`:

```dart
  static const String homeRequests = '/home/requests';
```

In `lib/app/router.dart`, add `import 'package:arrstack/features/requests/requests_page.dart';`
and a sibling `GoRoute` next to the `discover` route (inside the Home branch's
`routes:` list):

```dart
                GoRoute(
                  path: 'requests',
                  builder: (context, state) => const RequestsPage(),
                ),
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/requests/requests_page_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/requests/requests_page.dart lib/app/route_paths.dart lib/app/router.dart test/features/requests/requests_page_test.dart
dart analyze lib/features/requests/requests_page.dart lib/app/route_paths.dart lib/app/router.dart
git add lib/features/requests/requests_page.dart lib/app/route_paths.dart lib/app/router.dart test/features/requests/requests_page_test.dart
git commit -m "feat(requests): add RequestsPage and register /home/requests route"
```

---

### Task 11: Discover page rewrite — remove Requests tab, restyle, wire badges

**Files:**
- Modify: `lib/features/discover/discover_page.dart` (full rewrite)
- Modify: `lib/features/discover/widgets/poster_carousel_section.dart` (swap the ad hoc `Available`-only badge for `MediaStatusBadge`)
- Delete: `lib/features/discover/widgets/requests_tab_view.dart`
- Delete: `lib/features/discover/widgets/request_list_tile.dart`
- Test: `test/features/discover/discover_page_test.dart` (new)

This task does the tab-removal and the visual restyle together — both
rewrite the same file back-to-back, and a reviewer needs the coherent
before/after diff rather than two partial passes over `discover_page.dart`.

**Interfaces:**
- Consumes: `MediaStatusBadge` (Task 2), `RoutePaths.homeRequests` (Task 10), existing discover providers (`discover_providers.dart`, `seerr_providers.dart`), `SubPageHeader`.
- Produces: `DiscoverPage` — unchanged public constructor (`{String? instanceId}`), still routed at `/home/discover`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/discover/discover_page_test.dart
import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/discover/discover_page.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const instanceId = 'seerr-1';

class _FakeSelectedInstance extends SelectedSeerrInstanceId {
  @override
  Future<String?> build() async => instanceId;
}

List<Override> _emptyDiscoverOverrides() => [
  hasSeerrInstanceProvider.overrideWith((ref) async => true),
  selectedSeerrInstanceIdProvider.overrideWith(() => _FakeSelectedInstance()),
  instancesProvider.overrideWith((ref) async => const Ok(<ServiceInstance>[])),
  seerrMovieGenresProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrTvGenresProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrTrendingProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrDiscoverMoviesProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrUpcomingMoviesProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrDiscoverTvProvider(instanceId).overrideWith((ref) async => const Ok([])),
  seerrUpcomingTvProvider(instanceId).overrideWith((ref) async => const Ok([])),
];

void main() {
  testWidgets('shows the SEERR kicker, Discover title, and a search field', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: _emptyDiscoverOverrides(),
        child: const MaterialApp(home: DiscoverPage(instanceId: instanceId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SEERR'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Search movies and TV'), findsOneWidget);
  });

  testWidgets('the receipt button navigates to Requests', (tester) async {
    final router = GoRouter(
      initialLocation: '/discover',
      routes: [
        GoRoute(
          path: '/discover',
          builder: (context, state) => const DiscoverPage(instanceId: instanceId),
        ),
        GoRoute(
          path: RoutePaths.homeRequests,
          builder: (context, state) => const Scaffold(body: Text('Requests screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: _emptyDiscoverOverrides(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Requests'));
    await tester.pumpAndSettle();

    expect(find.text('Requests screen'), findsOneWidget);
  });

  testWidgets('a trending item already in the library shows an "In library" badge', (
    tester,
  ) async {
    final trending = [
      const SeerrResult(
        id: 1,
        title: 'Sinners',
        mediaInfo: SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ..._emptyDiscoverOverrides(),
          seerrTrendingProvider(instanceId).overrideWith((ref) async => Ok(trending)),
        ],
        child: const MaterialApp(home: DiscoverPage(instanceId: instanceId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('In library'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/discover/discover_page_test.dart`
Expected: FAIL — today's header is a plain `AppBar` with a `SegmentedButton`,
not a kicker/title; there's no `Requests` tooltip button; the carousel badge
only ever shows "Available", never "In library".

- [ ] **Step 3: Write minimal implementation**

Delete `lib/features/discover/widgets/requests_tab_view.dart` and
`lib/features/discover/widgets/request_list_tile.dart`.

Replace `lib/features/discover/discover_page.dart` in full:

```dart
// lib/features/discover/discover_page.dart
/// Discover (README §3a): search, alternating genre-pill rows and poster
/// carousels, each poster badged with its library/request status before
/// the tap. The Requests queue is its own route (`/home/requests`) reached
/// via the header's receipt button, not an in-page tab (Phase 7 design
/// spec, Decision 4).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/discover/widgets/genre_pill_row.dart';
import 'package:arrstack/features/discover/widgets/poster_carousel_section.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({this.instanceId, super.key});

  final String? instanceId;

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instanceIdAsync = ref.watch(selectedSeerrInstanceIdProvider);
    final hasSeerrAsync = ref.watch(hasSeerrInstanceProvider);

    return hasSeerrAsync.when(
      data: (enabled) {
        if (!enabled) {
          return Scaffold(
            appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
            body: const EmptyState(
              icon: Icons.search_off_outlined,
              title: 'Seerr not configured',
              message: 'Add a Seerr instance in Settings to enable discovery.',
            ),
          );
        }

        return instanceIdAsync.when(
          data: (id) {
            final finalId = widget.instanceId ?? id;
            if (finalId == null) {
              return const Scaffold(
                body: Center(child: Text('No instance selected')),
              );
            }

            return Scaffold(
              appBar: SubPageHeader(
                kicker: 'SEERR',
                title: 'Discover',
                actions: [
                  IconButton(
                    icon: const Icon(PhosphorIconsRegular.receipt, size: 17),
                    tooltip: 'Requests',
                    onPressed: () => context.push(RoutePaths.homeRequests),
                  ),
                ],
              ),
              body: Column(
                children: [
                  const _InstanceSelector(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.space6,
                      AppSpacing.space4,
                      AppSpacing.space6,
                      AppSpacing.space4,
                    ),
                    child: _SearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ),
                  Expanded(
                    child: _DiscoverContent(instanceId: finalId, query: _query),
                  ),
                ],
              ),
            );
          },
          loading: () => Scaffold(
            appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
            body: Center(child: Text('Error: $err')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: const SubPageHeader(kicker: 'SEERR', title: 'Discover'),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: [
          const Icon(PhosphorIconsRegular.magnifyingGlass, size: 17, color: AppColors.n500),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.body.copyWith(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Search movies and TV',
                hintStyle: TextStyle(color: AppColors.n500),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverContent extends ConsumerWidget {
  const _DiscoverContent({required this.instanceId, required this.query});

  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.isNotEmpty) {
      return _SearchList(instanceId: instanceId, query: query);
    }
    return _DiscoverSections(instanceId: instanceId);
  }
}

/// The sectioned "home" view: genre pill rows + poster carousels. Each
/// section watches its own provider independently — if one section's
/// endpoint fails, the rest of the page still renders rather than sinking
/// the whole screen.
class _DiscoverSections extends ConsumerWidget {
  const _DiscoverSections({required this.instanceId});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(seerrMovieGenresProvider(instanceId))
          ..invalidate(seerrTvGenresProvider(instanceId))
          ..invalidate(seerrTrendingProvider(instanceId))
          ..invalidate(seerrDiscoverMoviesProvider(instanceId))
          ..invalidate(seerrUpcomingMoviesProvider(instanceId))
          ..invalidate(seerrDiscoverTvProvider(instanceId))
          ..invalidate(seerrUpcomingTvProvider(instanceId));
      },
      child: ListView(
        children: [
          const SizedBox(height: AppSpacing.space2),
          _GenreRow(
            instanceId: instanceId,
            label: 'Movie Genres',
            mediaType: 'movie',
            async: ref.watch(seerrMovieGenresProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.space4),
          _Carousel(
            instanceId: instanceId,
            label: 'Trending',
            async: ref.watch(seerrTrendingProvider(instanceId)),
          ),
          _Carousel(
            instanceId: instanceId,
            label: 'Popular Movies',
            async: ref.watch(seerrDiscoverMoviesProvider(instanceId)),
          ),
          _Carousel(
            instanceId: instanceId,
            label: 'Upcoming Movies',
            async: ref.watch(seerrUpcomingMoviesProvider(instanceId)),
          ),
          _GenreRow(
            instanceId: instanceId,
            label: 'Series Genres',
            mediaType: 'tv',
            async: ref.watch(seerrTvGenresProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.space4),
          _Carousel(
            instanceId: instanceId,
            label: 'Popular Series',
            async: ref.watch(seerrDiscoverTvProvider(instanceId)),
          ),
          _Carousel(
            instanceId: instanceId,
            label: 'Upcoming Series',
            async: ref.watch(seerrUpcomingTvProvider(instanceId)),
          ),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }
}

class _Carousel extends StatelessWidget {
  const _Carousel({required this.instanceId, required this.label, required this.async});

  final String instanceId;
  final String label;
  final AsyncValue<Result<List<SeerrResult>>> async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      data: (result) => switch (result) {
        Ok(:final value) => PosterCarouselSection(
          label: label,
          items: value,
          instanceId: instanceId,
        ),
        Err() => const SizedBox.shrink(),
      },
      loading: () => Padding(
        padding: AppInsets.screenHorizontal,
        child: Row(
          children: [
            Text(label.toUpperCase(), style: AppTypography.kicker),
            const SizedBox(width: AppSpacing.space3),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _GenreRow extends StatelessWidget {
  const _GenreRow({
    required this.instanceId,
    required this.label,
    required this.mediaType,
    required this.async,
  });

  final String instanceId;
  final String label;
  final String mediaType;
  final AsyncValue<Result<List<SeerrGenre>>> async;

  @override
  Widget build(BuildContext context) {
    return async.when(
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppInsets.screenHorizontal,
                      child: Text(label.toUpperCase(), style: AppTypography.kicker),
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    GenrePillRow(
                      genres: value,
                      onTap: (genre) => context.go(
                        RoutePaths.homeDiscoverGenre(mediaType, genre.id, genre.name),
                      ),
                    ),
                  ],
                ),
        Err() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
    );
  }
}

class _SearchList extends ConsumerWidget {
  const _SearchList({required this.instanceId, required this.query});
  final String instanceId;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(
      seerrSearchProvider(instanceId: instanceId, query: query),
    );

    return results.when(
      data: (result) => switch (result) {
        Ok(:final value) =>
          value.isEmpty
              ? const EmptyState(icon: Icons.search_off, title: 'No results')
              : ListView.builder(
                  padding: AppInsets.pageMd,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final item = value[index];
                    return ListTile(
                      leading: item.posterUrl != null
                          ? Image.network(item.posterUrl!, width: 40)
                          : const Icon(Icons.movie_outlined),
                      title: Text(item.displayTitle ?? 'Unknown'),
                      subtitle: Text(item.displayDate ?? ''),
                      onTap: () => context.go(
                        RoutePaths.homeDiscoverDetail(item.id, item.mediaType),
                      ),
                    );
                  },
                ),
        Err(:final error) => Center(child: Text(error.userMessage)),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _InstanceSelector extends ConsumerWidget {
  const _InstanceSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instances = ref.watch(instancesProvider);
    final selectedIdAsync = ref.watch(selectedSeerrInstanceIdProvider);

    return instances.when(
      data: (result) => switch (result) {
        Ok<List<ServiceInstance>>(:final value) => () {
          final seerrInstances = value
              .where((i) => i.serviceType == ServiceType.seerr)
              .toList();
          if (seerrInstances.length <= 1) return const SizedBox.shrink();

          return Container(
            height: 48,
            padding: AppInsets.screenHorizontal,
            child: Row(
              children: [
                Text('Instance: ', style: AppTypography.meta),
                DropdownButton<String>(
                  value: selectedIdAsync.asData?.value ?? seerrInstances.first.id,
                  items: seerrInstances
                      .map((i) => DropdownMenuItem(value: i.id, child: Text(i.name)))
                      .toList(),
                  onChanged: (id) => id != null
                      ? ref.read(selectedSeerrInstanceIdProvider.notifier).selectInstance(id)
                      : null,
                ),
              ],
            ),
          );
        }(),
        Err() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
```

In `lib/features/discover/widgets/poster_carousel_section.dart`, replace the
`badge:` argument passed to `PosterCard`:

```dart
                    badge: MediaStatusBadge(mediaInfo: item.mediaInfo),
```

(remove the `import 'package:arrstack/core/widgets/status_chip.dart';` line
if `StatusChip` is no longer referenced elsewhere in that file, and add
`import 'package:arrstack/features/discover/widgets/media_status_badge.dart';`).

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/discover/discover_page_test.dart
```

Expected: PASS (3 tests)

- [ ] **Step 5: Confirm nothing else referenced the deleted tab widgets**

```bash
grep -rn "RequestsTabView\|RequestListTile" lib/ test/
```

Expected: no matches.

- [ ] **Step 6: Commit**

```bash
dart format lib/features/discover/ test/features/discover/discover_page_test.dart
dart analyze lib/features/discover/
git add lib/features/discover/discover_page.dart lib/features/discover/widgets/poster_carousel_section.dart test/features/discover/discover_page_test.dart
git rm lib/features/discover/widgets/requests_tab_view.dart lib/features/discover/widgets/request_list_tile.dart
git commit -m "feat(discover): rewrite Discover page onto Nocturne, drop in-page Requests tab"
```

---

### Task 12: `genre_results_page.dart` restyle

**Files:**
- Modify: `lib/features/discover/genre_results_page.dart` (full rewrite)
- Test: `test/features/discover/genre_results_page_test.dart` (new)

**Interfaces:**
- Consumes: `MediaStatusBadge` (Task 2), `SubPageHeader` (existing).
- Produces: `GenreResultsPage` — unchanged public constructor.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/discover/genre_results_page_test.dart
import 'package:arrstack/features/discover/genre_results_page.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

void main() {
  testWidgets('shows a Nocturne header and a badge on an in-library result', (
    tester,
  ) async {
    final results = [
      const SeerrResult(
        id: 1,
        title: 'Sinners',
        mediaInfo: SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          seerrMoviesByGenreProvider(
            instanceId: instanceId,
            genreId: 5,
          ).overrideWith((ref) async => Ok(results)),
        ],
        child: const MaterialApp(
          home: GenreResultsPage(
            instanceId: instanceId,
            genreId: 5,
            genreName: 'Action',
            mediaType: 'movie',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Action'), findsOneWidget);
    expect(find.text('In library'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/discover/genre_results_page_test.dart`
Expected: FAIL — today's grid has no badge at all.

- [ ] **Step 3: Write minimal implementation**

Replace `lib/features/discover/genre_results_page.dart` in full:

```dart
// lib/features/discover/genre_results_page.dart
/// Grid of results for a single tapped genre pill — the "All →"
/// destination from Discover's genre rows (README §3a). Not its own
/// screen ID in the design doc, but restyled alongside 3a for visual
/// consistency.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/discover/widgets/media_status_badge.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GenreResultsPage extends ConsumerWidget {
  const GenreResultsPage({
    required this.instanceId,
    required this.genreId,
    required this.genreName,
    required this.mediaType,
    super.key,
  });

  final String instanceId;
  final int genreId;
  final String genreName;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveIdAsync = instanceId.isNotEmpty
        ? AsyncData(instanceId)
        : ref.watch(selectedSeerrInstanceIdProvider);

    return effectiveIdAsync.when(
      data: (finalId) {
        if (finalId == null) {
          return const Scaffold(
            body: Center(child: Text('No instance selected')),
          );
        }
        return _GenreResultsBody(
          instanceId: finalId,
          genreId: genreId,
          genreName: genreName,
          mediaType: mediaType,
        );
      },
      loading: () => Scaffold(
        appBar: SubPageHeader(title: genreName),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: SubPageHeader(title: genreName),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _GenreResultsBody extends ConsumerWidget {
  const _GenreResultsBody({
    required this.instanceId,
    required this.genreId,
    required this.genreName,
    required this.mediaType,
  });

  final String instanceId;
  final int genreId;
  final String genreName;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = mediaType == 'tv'
        ? ref.watch(seerrTvByGenreProvider(instanceId: instanceId, genreId: genreId))
        : ref.watch(seerrMoviesByGenreProvider(instanceId: instanceId, genreId: genreId));

    return Scaffold(
      appBar: SubPageHeader(title: genreName),
      body: resultsAsync.when(
        data: (result) => switch (result) {
          Ok(:final value) =>
            value.isEmpty
                ? const EmptyState(icon: Icons.search_off, title: 'No results')
                : GridView.builder(
                    padding: AppInsets.pageMd,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisSpacing: AppSpacing.space4,
                      crossAxisSpacing: AppSpacing.space4,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final item = value[index];
                      return PosterCard(
                        imageUrl: item.posterUrl ?? '',
                        title: item.displayTitle ?? '',
                        badge: MediaStatusBadge(mediaInfo: item.mediaInfo),
                        onTap: () => context.go(
                          RoutePaths.homeDiscoverDetail(item.id, item.mediaType),
                        ),
                      );
                    },
                  ),
          Err(:final error) => EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to load genre',
            message: error.userMessage,
          ),
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/discover/genre_results_page_test.dart`
Expected: PASS (1 test)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/discover/genre_results_page.dart test/features/discover/genre_results_page_test.dart
dart analyze lib/features/discover/genre_results_page.dart
git add lib/features/discover/genre_results_page.dart test/features/discover/genre_results_page_test.dart
git commit -m "feat(discover): restyle genre results grid, wire MediaStatusBadge"
```

---

### Task 13: Discover detail / request page rewrite (README §3b)

**Files:**
- Create: `lib/features/discover/availability_lines.dart`
- Modify: `lib/features/discover/discover_detail_page.dart` (full rewrite)
- Test: `test/features/discover/availability_lines_test.dart`
- Test: `test/features/discover/discover_detail_page_test.dart`

**Interfaces:**
- Consumes: `MediaDetailHeader` (Task 5), `LabeledDropdownField`/`LabeledToggleRow` (Tasks 3–4), `seerrRadarrServiceProvider`/`seerrSonarrServiceProvider`/extended `request()` (Task 7), `DetailChip`, `FadingRule` (existing).
- Produces: `List<(String label, String value)> availabilityLines(SeerrMediaInfo? mediaInfo)`. `DiscoverDetailPage` keeps its existing public constructor.

`SeerrMediaInfo` today carries only `status` (no release date, indexer-hit
count, or best-available quality/size) — so `availabilityLines` can honestly
say very little. This is the correct, honest consequence of Decision 2
("omit rather than fabricate"), not a bug: the AVAILABILITY block will only
ever show a one-line "Already available"/"Partially available" note, or
nothing at all, until Seerr's API is found to expose more.

The "Browse releases" secondary action described in the design spec is
**not implemented in this task** — it requires a Radarr/Sonarr-side
`movieId`/`episodeId` that `SeerrMediaInfo` doesn't carry, and
`ReleaseSearchPage` has no "look it up for me" fallback. Shipping a button
that leads nowhere working would be worse than omitting it; this is called
out again in Self-Review Notes and the plan's Out-of-scope section.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/discover/availability_lines_test.dart
import 'package:arrstack/features/discover/availability_lines.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns nothing when mediaInfo is null', () {
    expect(availabilityLines(null), isEmpty);
  });

  test('returns nothing for a pending/processing/unknown status', () {
    for (final status in [
      SeerrMediaStatus.unknown,
      SeerrMediaStatus.pending,
      SeerrMediaStatus.processing,
    ]) {
      expect(
        availabilityLines(SeerrMediaInfo(id: 1, status: status)),
        isEmpty,
        reason: 'status $status',
      );
    }
  });

  test('returns a single "Already available" line for available', () {
    final lines = availabilityLines(
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.available),
    );
    expect(lines, [('Status', 'Already available')]);
  });

  test('returns a single "Partially available" line for partiallyAvailable', () {
    final lines = availabilityLines(
      const SeerrMediaInfo(id: 1, status: SeerrMediaStatus.partiallyAvailable),
    );
    expect(lines, [('Status', 'Partially available')]);
  });
}
```

```dart
// test/features/discover/discover_detail_page_test.dart
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/features/discover/discover_detail_page.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'seerr-1';

SeerrResult notInLibraryMovie() => const SeerrResult(
  id: 100,
  title: 'Nosferatu',
  mediaType: 'movie',
  voteAverage: 7.1,
);

Widget host(List<Override> overrides) {
  return ProviderScope(
    overrides: [
      seerrDetailProvider(instanceId: instanceId, id: 100, mediaType: 'movie')
          .overrideWith((ref) async => Ok(notInLibraryMovie())),
      ...overrides,
    ],
    child: const MaterialApp(
      home: DiscoverDetailPage(instanceId: instanceId, id: 100, mediaType: 'movie'),
    ),
  );
}

void main() {
  testWidgets('shows the title, a "Not in library" chip, and request fields on success', (
    tester,
  ) async {
    await tester.pumpWidget(
      host([
        seerrRadarrServiceProvider(instanceId: instanceId, serviceId: 0).overrideWith(
          (ref) async => const Ok(
            SeerrServiceDetails(
              profiles: [SeerrServiceProfile(id: 6, name: 'HD-1080p')],
              rootFolders: [
                SeerrServiceRootFolder(
                  path: '/data/media/movies',
                  freeSpace: 2400000000000,
                  totalSpace: 18000000000000,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nosferatu'), findsOneWidget);
    expect(find.text('Not in library'), findsOneWidget);
    expect(find.text('HD-1080p'), findsOneWidget);
    expect(find.text('/data/media/movies'), findsOneWidget);
    expect(find.textContaining('free of'), findsOneWidget);
  });

  testWidgets('a failed profile fetch disables Request and shows a visible error, not a silent fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      host([
        seerrRadarrServiceProvider(instanceId: instanceId, serviceId: 0).overrideWith(
          (ref) async => const Err(UnknownError(userMessage: 'Could not reach Seerr')),
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not reach Seerr'), findsOneWidget);
    final requestButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Request'),
    );
    expect(requestButton.onPressed, isNull);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/discover/availability_lines_test.dart test/features/discover/discover_detail_page_test.dart
```

Expected: FAIL — `availability_lines.dart` doesn't exist; today's detail
page has no request-panel fields, no chip, no wired providers.

- [ ] **Step 3: Write the implementation**

```dart
// lib/features/discover/availability_lines.dart
/// Best-effort AVAILABILITY lines for the Discover detail/request page
/// (README §3b), built only from data Seerr's `MediaInfo` actually carries.
/// Today that's only `status` — no digital-release date, indexer-hit
/// count, or best-available quality/size exist on this model. Per the
/// Phase 7 design spec, Decision 2: omit rather than fabricate, so this
/// returns at most one line and an empty list when there's nothing honest
/// to say.
library;

import 'package:arrstack/services/seerr/models/seerr_models.dart';

List<(String label, String value)> availabilityLines(SeerrMediaInfo? mediaInfo) {
  return switch (mediaInfo?.status) {
    SeerrMediaStatus.available => const [('Status', 'Already available')],
    SeerrMediaStatus.partiallyAvailable => const [
      ('Status', 'Partially available'),
    ],
    _ => const [],
  };
}
```

Replace `lib/features/discover/discover_detail_page.dart` in full:

```dart
// lib/features/discover/discover_detail_page.dart
/// Discover detail / request (README §3b): the 2g header anatomy, a
/// request panel (quality profile, root folder with free space, search-
/// immediately toggle), and a best-effort AVAILABILITY block.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/labeled_dropdown_field.dart';
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:arrstack/features/discover/availability_lines.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Both Radarr/Sonarr calls default to Seerr's first configured server.
/// A server picker for multi-server Seerr setups is out of scope (Phase 7
/// design spec, Out of scope).
const _defaultServiceId = 0;

class DiscoverDetailPage extends ConsumerWidget {
  const DiscoverDetailPage({
    required this.instanceId,
    required this.id,
    required this.mediaType,
    super.key,
  });

  final String instanceId;
  final int id;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveIdAsync = instanceId.isNotEmpty
        ? AsyncData(instanceId)
        : ref.watch(selectedSeerrInstanceIdProvider);

    return effectiveIdAsync.when(
      data: (finalId) {
        if (finalId == null) {
          return const Scaffold(body: Center(child: Text('No instance selected')));
        }

        final detailAsync = ref.watch(
          seerrDetailProvider(instanceId: finalId, id: id, mediaType: mediaType),
        );

        return detailAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _DetailContent(instanceId: finalId, item: value),
            Err(:final error) => Scaffold(
              appBar: AppBar(),
              body: EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load details',
                message: error.userMessage,
              ),
            ),
          },
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: $err')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({required this.instanceId, required this.item});

  final String instanceId;
  final SeerrResult item;

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  int? _selectedProfileId;
  String? _selectedRootFolder;
  bool _searchImmediately = true;
  bool _requesting = false;
  String? _requestError;

  bool get _isTv => widget.item.mediaType == 'tv';

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final serviceAsync = _isTv
        ? ref.watch(
            seerrSonarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          )
        : ref.watch(
            seerrRadarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          );
    final serviceDetails = switch (serviceAsync.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final lines = availabilityLines(item.mediaInfo);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowSquareOut, size: 17),
            tooltip: 'Open in TMDB',
            onPressed: () => _openTmdb(item),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          MediaDetailHeader(
            poster: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: item.posterUrl != null
                  ? Image.network(item.posterUrl!, width: 104, height: 156, fit: BoxFit.cover)
                  : Container(width: 104, height: 156, color: AppColors.n800),
            ),
            title: item.displayTitle ?? '',
            metaParts: [if (item.displayYear != null) item.displayYear!],
            chips: [
              if ((item.voteAverage ?? 0) > 0)
                DetailChip(
                  label: '★ ${item.voteAverage!.toStringAsFixed(1)}',
                  color: AppColors.accent,
                ),
              DetailChip(
                label: _libraryChipLabel(item.mediaInfo),
                color: _isInLibrary(item.mediaInfo) ? AppColors.accent : AppColors.n500,
              ),
            ],
            stats: const [],
          ),
          const SizedBox(height: AppSpacing.space6),
          Text(item.overview ?? 'No overview available.', style: AppTypography.body),
          if (_canRequest(item.mediaInfo)) ...[
            const SizedBox(height: AppSpacing.space6),
            const FadingRule(),
            const SizedBox(height: AppSpacing.space4),
            Text('REQUEST TO ${_isTv ? 'SONARR' : 'RADARR'}', style: AppTypography.kicker),
            const SizedBox(height: AppSpacing.space4),
            serviceAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) => _RequestFields(
                  details: value,
                  selectedProfileId: _selectedProfileId,
                  selectedRootFolder: _selectedRootFolder,
                  onProfileChanged: (v) => setState(() => _selectedProfileId = v),
                  onRootFolderChanged: (v) => setState(() => _selectedRootFolder = v),
                ),
                Err(:final error) => Text(
                  'Error loading profiles: ${error.userMessage}',
                  style: AppTypography.meta.copyWith(color: AppColors.down),
                ),
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text(
                'Error loading profiles: $err',
                style: AppTypography.meta.copyWith(color: AppColors.down),
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            LabeledToggleRow(
              title: 'Search immediately',
              subtitle: 'Otherwise it waits for the next RSS sweep',
              value: _searchImmediately,
              onChanged: (v) => setState(() => _searchImmediately = v),
            ),
            if (lines.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.space4),
              const FadingRule(),
              const SizedBox(height: AppSpacing.space4),
              Text('AVAILABILITY', style: AppTypography.kicker),
              const SizedBox(height: AppSpacing.space3),
              for (final (label, value) in lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: AppTypography.meta),
                      Text(value, style: AppTypography.meta),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: AppSpacing.space6),
            if (_requestError != null) ...[
              Text(_requestError!, style: AppTypography.meta.copyWith(color: AppColors.down)),
              const SizedBox(height: AppSpacing.space2),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: (_requesting || serviceDetails == null) ? null : _handleRequest,
                icon: _requesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(PhosphorIconsRegular.plus, size: 15),
                label: const Text('Request'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isInLibrary(SeerrMediaInfo? info) =>
      info?.status == SeerrMediaStatus.available ||
      info?.status == SeerrMediaStatus.partiallyAvailable;

  bool _isRequested(SeerrMediaInfo? info) =>
      info?.status == SeerrMediaStatus.pending ||
      info?.status == SeerrMediaStatus.processing;

  String _libraryChipLabel(SeerrMediaInfo? info) {
    if (_isInLibrary(info)) return 'In library';
    if (_isRequested(info)) return 'Requested';
    return 'Not in library';
  }

  /// Matches today's exact gate — only a fully `available` item has
  /// nothing left to request; `partiallyAvailable` TV can still request
  /// more seasons.
  bool _canRequest(SeerrMediaInfo? info) =>
      info == null || info.status != SeerrMediaStatus.available;

  Future<void> _openTmdb(SeerrResult item) async {
    final path = item.mediaType == 'tv' ? 'tv' : 'movie';
    final uri = Uri.parse('https://www.themoviedb.org/$path/${item.id}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleRequest() async {
    final serviceAsync = _isTv
        ? ref.read(
            seerrSonarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          )
        : ref.read(
            seerrRadarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          );
    final details = switch (serviceAsync.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    if (details == null) return;

    final profileId =
        _selectedProfileId ??
        (details.profiles.isNotEmpty ? details.profiles.first.id : null);
    final rootFolder =
        _selectedRootFolder ??
        (details.rootFolders.isNotEmpty ? details.rootFolders.first.path : null);

    setState(() {
      _requesting = true;
      _requestError = null;
    });

    final repository = await ref.read(
      seerrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repository.request(
      widget.item.id,
      widget.item.mediaType,
      serverId: _defaultServiceId,
      profileId: profileId,
      rootFolder: rootFolder,
    );

    if (!mounted) return;
    switch (result) {
      case Ok():
        setState(() => _requesting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        ref.invalidate(
          seerrDetailProvider(
            instanceId: widget.instanceId,
            id: widget.item.id,
            mediaType: widget.item.mediaType,
          ),
        );
      case Err(:final error):
        setState(() {
          _requesting = false;
          _requestError = 'Request failed: ${error.userMessage}';
        });
    }
  }
}

class _RequestFields extends StatelessWidget {
  const _RequestFields({
    required this.details,
    required this.selectedProfileId,
    required this.selectedRootFolder,
    required this.onProfileChanged,
    required this.onRootFolderChanged,
  });

  final SeerrServiceDetails details;
  final int? selectedProfileId;
  final String? selectedRootFolder;
  final ValueChanged<int?> onProfileChanged;
  final ValueChanged<String?> onRootFolderChanged;

  @override
  Widget build(BuildContext context) {
    final profileValue =
        selectedProfileId ??
        (details.profiles.isNotEmpty ? details.profiles.first.id : null);
    final folder = details.rootFolders.isEmpty
        ? null
        : details.rootFolders.firstWhere(
            (f) => f.path == selectedRootFolder,
            orElse: () => details.rootFolders.first,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledDropdownField<int>(
          label: 'Quality profile',
          value: profileValue,
          items: [
            for (final profile in details.profiles)
              DropdownMenuItem(value: profile.id, child: Text(profile.name)),
          ],
          onChanged: onProfileChanged,
        ),
        const SizedBox(height: AppSpacing.space4),
        LabeledDropdownField<String>(
          label: 'Root folder',
          value: folder?.path,
          items: [
            for (final rootFolder in details.rootFolders)
              DropdownMenuItem(value: rootFolder.path, child: Text(rootFolder.path)),
          ],
          onChanged: onRootFolderChanged,
          caption: folder == null ? null : _freeSpaceCaption(folder),
        ),
      ],
    );
  }

  String? _freeSpaceCaption(SeerrServiceRootFolder folder) {
    final free = folder.freeSpace;
    final total = folder.totalSpace;
    if (free == null || total == null) return null;
    return '${FormatUtils.formatBytes(free)} free of ${FormatUtils.formatBytes(total)}';
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/discover/availability_lines_test.dart test/features/discover/discover_detail_page_test.dart
```

Expected: PASS (4 + 2 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/discover/availability_lines.dart lib/features/discover/discover_detail_page.dart test/features/discover/availability_lines_test.dart test/features/discover/discover_detail_page_test.dart
dart analyze lib/features/discover/availability_lines.dart lib/features/discover/discover_detail_page.dart
git add lib/features/discover/availability_lines.dart lib/features/discover/discover_detail_page.dart test/features/discover/availability_lines_test.dart test/features/discover/discover_detail_page_test.dart
git commit -m "feat(discover): rewrite Discover detail with a real request panel (README §3b)"
```

---

### Task 14: Add movie/series restyle (README §3d)

**Files:**
- Modify: `lib/features/library/add_movie_page.dart` (full rewrite)
- Modify: `lib/features/library/add_series_page.dart` (full rewrite)
- Modify: `lib/features/library/widgets/add_movie_options.dart` (swap dropdowns/toggle for shared widgets)
- Modify: `lib/features/library/widgets/add_series_options.dart` (swap dropdowns/toggle for shared widgets)
- Test: `test/features/library/add_movie_page_test.dart` (new)
- Test: `test/features/library/add_series_page_test.dart` (new)

Existing logic is already correct (the `movie.id != null` dedupe check, the
working "search now" toggle) — this is a styling pass, not new logic. Per
the design tokens' own Buttons rule ("Primary is an accent outline on
transparent, never a fill"), the primary/secondary add-button hierarchy is
an accent-bordered vs. divider-bordered outline, not filled-vs-outline.

**Interfaces:**
- Consumes: `LabeledDropdownField`, `LabeledToggleRow` (Tasks 3–4).
- Produces: no new public API — `AddMoviePage`/`AddSeriesPage`/`AddMovieOptionsSheet`/`AddSeriesOptionsSheet` constructors are unchanged.

- [ ] **Step 1: Write the failing tests**

```dart
// test/features/library/add_movie_page_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/add_movie_page.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'radarr-1';

void main() {
  testWidgets(
    'shows a result-count caption and dims an already-added result with a check',
    (tester) async {
      final movies = [
        const RadarrMovie(title: 'Nosferatu', year: 2024, tmdbId: 1),
        const RadarrMovie(id: 9, title: 'Nosferatu the Vampyre', year: 1979, tmdbId: 2),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            radarrLookupProvider(instanceId: instanceId, term: 'nosferatu')
                .overrideWith((ref) async => Ok(movies)),
          ],
          child: const MaterialApp(home: AddMoviePage(instanceId: instanceId)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'nosferatu');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(find.textContaining('results from TMDB'), findsOneWidget);
      expect(find.textContaining('already in library'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      final dimmedRow = tester.widget<Opacity>(
        find
            .ancestor(
              of: find.text('Nosferatu the Vampyre'),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(dimmedRow.opacity, 0.6);
    },
  );
}
```

```dart
// test/features/library/add_series_page_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/library/add_series_page.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const instanceId = 'sonarr-1';

void main() {
  testWidgets('shows a result-count caption and an add button for a new series', (
    tester,
  ) async {
    final series = [const SonarrSeries(title: 'Severance', year: 2022, tvdbId: 1)];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sonarrLookupProvider(instanceId: instanceId, term: 'severance')
              .overrideWith((ref) async => Ok(series)),
        ],
        child: const MaterialApp(home: AddSeriesPage(instanceId: instanceId)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'severance');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.textContaining('results from TMDB'), findsOneWidget);
    expect(find.text('Severance'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/library/add_movie_page_test.dart test/features/library/add_series_page_test.dart
```

Expected: FAIL — today's page has no result-count caption text and no
`Opacity`-dimmed already-in-library row (`find.byIcon(Icons.check_circle)`
already exists but without the 0.6-opacity row or the "already in library"
meta text).

- [ ] **Step 3: Write the implementation**

Check the exact provider names first — this app names Sonarr's lookup
provider consistently with Radarr's; confirm with
`grep -n "Lookup" lib/services/sonarr/sonarr_providers.dart` and adjust the
import/usage below only if the name differs from `sonarrLookupProvider`.

Replace `lib/features/library/add_movie_page.dart` in full:

```dart
// lib/features/library/add_movie_page.dart
/// Add movie (README §3d): TMDB lookup via Radarr, a primary/secondary
/// add-button hierarchy, and already-in-library rows dimmed with a check
/// instead of an add button so a duplicate can't be added by accident.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/features/library/widgets/add_movie_options.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AddMoviePage extends ConsumerStatefulWidget {
  const AddMoviePage({required this.instanceId, super.key});

  final String instanceId;

  @override
  ConsumerState<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends ConsumerState<AddMoviePage> {
  final _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lookupAsync = ref.watch(
      radarrLookupProvider(instanceId: widget.instanceId, term: _searchTerm),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add movie'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space6,
              0,
              AppSpacing.space6,
              AppSpacing.space4,
            ),
            child: _ActiveSearchField(
              controller: _searchController,
              onSubmitted: (value) => setState(() => _searchTerm = value),
              onClear: () => setState(() => _searchTerm = ''),
            ),
          ),
        ),
      ),
      body: _searchTerm.isEmpty
          ? const EmptyState(
              icon: Icons.movie_filter_outlined,
              title: 'Search for a movie',
              message: 'Lookup movies by title to add them to your library.',
            )
          : lookupAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) =>
                  value.isEmpty
                      ? const EmptyState(icon: Icons.search_off, title: 'No results')
                      : _SearchResults(movies: value, instanceId: widget.instanceId),
                Err(:final error) => EmptyState(
                  icon: Icons.error_outline,
                  title: 'Lookup failed',
                  message: error.userMessage,
                ),
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
    );
  }
}

class _ActiveSearchField extends StatelessWidget {
  const _ActiveSearchField({
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.accent),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: [
          const Icon(PhosphorIconsRegular.magnifyingGlass, size: 17, color: AppColors.accent),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: AppTypography.body.copyWith(color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Search movies to add',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(PhosphorIconsRegular.x, size: 15, color: AppColors.n500),
              onPressed: () {
                controller.clear();
                onClear();
              },
            ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.movies, required this.instanceId});

  final List<RadarrMovie> movies;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space6,
            AppSpacing.space3,
            AppSpacing.space6,
            0,
          ),
          child: Text(
            '${movies.length} results from TMDB via Radarr',
            style: AppTypography.meta.copyWith(
              color: AppColors.n500,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: AppInsets.pageMd,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return _SearchResultTile(
                movie: movies[index],
                instanceId: instanceId,
                isPrimary: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  const _SearchResultTile({
    required this.movie,
    required this.instanceId,
    required this.isPrimary,
  });

  final RadarrMovie movie;
  final String instanceId;
  final bool isPrimary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relativeUrl = movie.posterUrl;
    final fullUrlAsync = relativeUrl != null
        ? ref.watch(
            radarrFullImageUrlProvider(instanceId: instanceId, relativeUrl: relativeUrl),
          )
        : const AsyncData<String?>(null);
    final alreadyAdded = movie.id != null;

    final row = ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      leading: SizedBox(
        width: 40,
        child: fullUrlAsync.when(
          data: (url) => PosterCard(imageUrl: url ?? '', monitored: true),
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, _) => const Icon(Icons.movie_outlined),
        ),
      ),
      title: Text(movie.title),
      subtitle: Text(
        alreadyAdded ? '${movie.year} · already in library' : '${movie.year}',
      ),
      trailing: alreadyAdded
          ? const Icon(Icons.check_circle, color: AppColors.up)
          : _AddButton(
              primary: isPrimary,
              onPressed: () => _showAddOptions(context, ref, movie),
            ),
    );

    return alreadyAdded ? Opacity(opacity: 0.6, child: row) : row;
  }

  void _showAddOptions(BuildContext context, WidgetRef ref, RadarrMovie movie) async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddMovieOptionsSheet(instanceId: instanceId, movie: movie),
      ),
    );

    if (added == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.primary, required this.onPressed});

  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(PhosphorIconsRegular.plus, size: 15),
      color: primary ? AppColors.accent : AppColors.n400,
      style: IconButton.styleFrom(
        side: BorderSide(color: primary ? AppColors.accent : AppColors.divider),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      onPressed: onPressed,
    );
  }
}
```

Replace `lib/features/library/add_series_page.dart` in full, mirroring
`add_movie_page.dart` exactly for series (`sonarrLookupProvider`, `SonarrSeries`,
`AddSeriesOptionsSheet`, caption text "results from TMDB via Sonarr").

In `lib/features/library/widgets/add_movie_options.dart`, replace the
`DropdownButtonFormField<int>` for quality profile and the
`DropdownButtonFormField<String>` for root folder with
`LabeledDropdownField<int>`/`LabeledDropdownField<String>` (same
`value`/`items`/`onChanged`, dropping the `InputDecoration` wrapper), and
replace the `SwitchListTile` with:

```dart
          LabeledToggleRow(
            title: 'Search for it now',
            subtitle: 'Uses your enabled indexers',
            value: _searchNow,
            onChanged: (val) => setState(() => _searchNow = val),
          ),
```

Apply the identical three swaps to
`lib/features/library/widgets/add_series_options.dart`.

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/library/add_movie_page_test.dart test/features/library/add_series_page_test.dart
```

Expected: PASS (1 + 1 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/library/add_movie_page.dart lib/features/library/add_series_page.dart lib/features/library/widgets/add_movie_options.dart lib/features/library/widgets/add_series_options.dart test/features/library/add_movie_page_test.dart test/features/library/add_series_page_test.dart
dart analyze lib/features/library/add_movie_page.dart lib/features/library/add_series_page.dart lib/features/library/widgets/add_movie_options.dart lib/features/library/widgets/add_series_options.dart
git add lib/features/library/add_movie_page.dart lib/features/library/add_series_page.dart lib/features/library/widgets/add_movie_options.dart lib/features/library/widgets/add_series_options.dart test/features/library/add_movie_page_test.dart test/features/library/add_series_page_test.dart
git commit -m "feat(library): restyle Add movie/series onto Nocturne (README §3d)"
```

---

### Task 15: Trim `ReleaseSort` to the three spec'd chips (README §3e)

**Files:**
- Modify: `lib/features/release_search/release_sort.dart` (full rewrite)
- Modify: `test/features/release_search/release_sort_test.dart` (full rewrite)

**Interfaces:**
- Produces: `enum ReleaseSort { best, size, seeders }` (was `{ peers, size, age, quality }`). Task 16 consumes the trimmed enum for the sort-chip row.

`best` and `seeders` currently sort identically — both use
`peersKey` (seeders descending, unknown-seeder releases sunk to the bottom)
because that is the only ranking signal this app currently computes;
there's no separate "match score" field on `ReleaseCandidate` to make
"Best match" mean something distinct from "Seeders" yet. Documented in
code rather than silently duplicated logic with no explanation.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/release_search/release_sort_test.dart
// applySort orders the interactive-search results. Best match and Seeders
// both rank by seeders (high→low, unknown last) — see release_sort.dart's
// doc comment for why they're currently identical. Size is small→large.

import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseCandidate rc({
  String guid = 'g',
  int? seeders,
  int size = 0,
}) => ReleaseCandidate(
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

void main() {
  group('applySort', () {
    test('best: descending by seeders, null seeders last', () {
      final out = applySort([
        rc(guid: 'a', seeders: 5),
        rc(guid: 'b', seeders: null),
        rc(guid: 'c', seeders: 50),
      ], ReleaseSort.best);

      expect(out.map((r) => r.guid), ['c', 'a', 'b']);
    });

    test('seeders: descending by seeders, null seeders last', () {
      final out = applySort([
        rc(guid: 'a', seeders: 5),
        rc(guid: 'b', seeders: null),
        rc(guid: 'c', seeders: 50),
      ], ReleaseSort.seeders);

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

    test('does not mutate the input list', () {
      final input = [rc(guid: 'a', seeders: 1), rc(guid: 'b', seeders: 9)];
      applySort(input, ReleaseSort.best);
      expect(input.map((r) => r.guid), ['a', 'b']);
    });

    test('empty list returns empty', () {
      expect(applySort(const [], ReleaseSort.best), isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/release_search/release_sort_test.dart`
Expected: FAIL — `ReleaseSort.best`/`.seeders` don't exist yet (`.peers`/`.age`/`.quality` do).

- [ ] **Step 3: Write minimal implementation**

Replace `lib/features/release_search/release_sort.dart` in full:

```dart
// lib/features/release_search/release_sort.dart
/// Sort options for the interactive-search results list (README §3e: Best
/// match / Size / Seeders) and the pure function that applies them.
library;

import 'package:arrstack/features/release_search/models/release_candidate.dart';

/// Active sort for the release list. `best` is the default.
///
/// `best` and `seeders` currently produce identical orderings — both rank
/// by `peersKey` (seeders high→low, unknown last), the only ranking signal
/// `ReleaseCandidate` exposes today. There's no separate match-quality
/// score to make "Best match" mean something distinct from "Seeders" yet;
/// this is an honest limitation, not an oversight.
enum ReleaseSort { best, size, seeders }

/// Returns a new list of [items] ordered by [sort]. [items] is not mutated.
List<ReleaseCandidate> applySort(
  List<ReleaseCandidate> items,
  ReleaseSort sort,
) {
  final sorted = [...items];
  switch (sort) {
    case ReleaseSort.best:
    case ReleaseSort.seeders:
      sorted.sort((a, b) => b.peersKey.compareTo(a.peersKey));
    case ReleaseSort.size:
      sorted.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
  }
  return sorted;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/release_search/release_sort_test.dart`
Expected: PASS (5 tests)

- [ ] **Step 5: Confirm no dangling references to the removed enum values**

```bash
grep -rn "ReleaseSort.peers\|ReleaseSort.age\|ReleaseSort.quality" lib/ test/
```

Expected: no matches (Task 16 updates `release_search_page.dart`'s
`SegmentedButton` in the same pass this task's commit precedes — if this
grep finds matches after Task 16, fix them there).

- [ ] **Step 6: Commit**

```bash
dart format lib/features/release_search/release_sort.dart test/features/release_search/release_sort_test.dart
dart analyze lib/features/release_search/release_sort.dart
git add lib/features/release_search/release_sort.dart test/features/release_search/release_sort_test.dart
git commit -m "feat(release_search): trim ReleaseSort to Best match/Size/Seeders"
```

---

### Task 16: Release search page/tile restyle (README §3e)

**Files:**
- Modify: `lib/features/release_search/release_search_page.dart` (full rewrite)
- Modify: `lib/features/release_search/widgets/release_tile.dart` (full rewrite)
- Modify: `test/features/release_search/release_search_page_test.dart` (update for the trimmed enum and the relocated count)
- Modify: `test/features/release_search/release_tile_test.dart` (add icon-state assertions)

**Interfaces:**
- Consumes: the trimmed `ReleaseSort` (Task 15).
- Produces: no constructor changes to `ReleaseSearchPage`/`ReleaseTile`.

- [ ] **Step 1: Write the failing tests**

Update `test/features/release_search/release_tile_test.dart` by appending
these two cases (keep the file's existing `release(...)` helper and
existing tests):

```dart
  testWidgets('an allowed release shows an accent download icon', (
    tester,
  ) async {
    await _pump(tester, release(rejected: false));
    final icon = tester.widget<Icon>(find.byIcon(PhosphorIconsRegular.downloadSimple));
    expect(icon.color, AppColors.accent);
  });

  testWidgets('a rejected release shows a red prohibit icon instead', (
    tester,
  ) async {
    await _pump(
      tester,
      release(rejected: true, rejections: const ['Below quality cutoff']),
    );
    expect(find.byIcon(PhosphorIconsRegular.downloadSimple), findsNothing);
    final icon = tester.widget<Icon>(find.byIcon(PhosphorIconsRegular.prohibit));
    expect(icon.color, AppColors.down);
  });
```

Add the two new imports this needs to the top of the file:
`import 'package:arrstack/app/theme/design_tokens.dart';` and
`import 'package:phosphor_icons/phosphor_icons.dart';`.

Replace `test/features/release_search/release_search_page_test.dart`'s
`_host` helper's `home:` body is unaffected, but any assertion referencing
`ReleaseSort.peers`/`.age`/`.quality` or the old `SegmentedButton` must be
updated — check the file for `find.byType(SegmentedButton` or `ReleaseSort.`
and replace with the trimmed enum / new chip row. If the existing file has
no such direct references (it may only assert on rendered text), no change
is needed there beyond re-running it after Step 3.

- [ ] **Step 2: Run tests to verify they fail**

```bash
flutter test test/features/release_search/
```

Expected: FAIL — today's `ReleaseTile` has no trailing icon at all.

- [ ] **Step 3: Write the implementation**

Replace `lib/features/release_search/widgets/release_tile.dart` in full:

```dart
// lib/features/release_search/widgets/release_tile.dart
/// One row in the interactive-search results list (README §3e): a
/// regular-weight release name over a tabular spec line, with a trailing
/// download icon (allowed) or a red prohibit icon (rejected) instead of
/// leaving rejected rows with no icon at all.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class ReleaseTile extends StatelessWidget {
  const ReleaseTile({required this.release, required this.onTap, super.key});

  final ReleaseCandidate release;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.n500;

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

    final textColumn = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            release.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: release.isRejected ? AppColors.n500 : AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            facts,
            style: AppTypography.meta.copyWith(
              color: muted,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          if (release.isRejected && release.rejections.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(
              release.rejections.length > 1
                  ? '${release.rejections.first}  +${release.rejections.length - 1} more'
                  : release.rejections.first,
              style: AppTypography.meta.copyWith(color: AppColors.down),
            ),
          ],
        ],
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space6,
        vertical: AppSpacing.space3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textColumn,
          const SizedBox(width: AppSpacing.space3),
          Icon(
            release.isRejected ? PhosphorIconsRegular.prohibit : PhosphorIconsRegular.downloadSimple,
            size: 15,
            color: release.isRejected ? AppColors.down : AppColors.accent,
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: release.isRejected ? Opacity(opacity: 0.55, child: content) : content,
    );
  }
}
```

Replace `lib/features/release_search/release_search_page.dart` in full:

```dart
// lib/features/release_search/release_search_page.dart
/// Interactive release-search screen (README §3e): runs the search on
/// open, shows the results sorted (default Best match), and lets the user
/// open any release. Rejected releases stay in the list, dimmed with the
/// reason spelled out in red.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/app_error.dart';
import 'package:arrstack/core/network/result.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/release_search/models/release_candidate.dart';
import 'package:arrstack/features/release_search/release_search_providers.dart';
import 'package:arrstack/features/release_search/release_sort.dart';
import 'package:arrstack/features/release_search/widgets/release_detail_sheet.dart';
import 'package:arrstack/features/release_search/widgets/release_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

const _sortLabels = {
  ReleaseSort.best: 'Best match',
  ReleaseSort.size: 'Size',
  ReleaseSort.seeders: 'Seeders',
};

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

  /// Human label for the episode/movie being searched (header kicker).
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title.toUpperCase(), style: AppTypography.kicker),
            const Text('Releases', style: AppTypography.sectionTitle),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 17),
            tooltip: 'Search again',
            onPressed: () => ref.invalidate(provider),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.space6,
              0,
              AppSpacing.space6,
              AppSpacing.space3,
            ),
            child: Row(
              children: [
                for (final option in ReleaseSort.values) ...[
                  _SortChip(
                    label: _sortLabels[option]!,
                    active: option == sort,
                    onTap: () => ref.read(releaseSortControllerProvider.notifier).select(option),
                  ),
                  const SizedBox(width: AppSpacing.space2),
                ],
                const Spacer(),
                resultsAsync.maybeWhen(
                  data: (result) => switch (result) {
                    Ok(:final value) => Text(
                      '${value.length} found',
                      style: AppTypography.meta.copyWith(
                        color: AppColors.n500,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    Err() => const SizedBox.shrink(),
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const _SearchingState(),
        error: (err, _) => _ErrorState(
          message: err is AppError ? err.userMessage : '$err',
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

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: active ? Border.all(color: AppColors.accent, width: 1) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: active ? AppColors.accent : AppColors.n400,
          ),
        ),
      ),
    );
  }
}

class _SearchingState extends StatelessWidget {
  const _SearchingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: AppInsets.pageLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.space4),
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
  const _Results({required this.releases, required this.service, required this.instanceId});

  final List<ReleaseCandidate> releases;
  final ServiceType service;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: releases.length + 1,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == releases.length) {
          return const Padding(
            padding: AppInsets.pageMd,
            child: Text(
              'Rejected releases stay listed — tapping one downloads it anyway, '
              'overriding the profile.',
              style: AppTypography.meta,
            ),
          );
        }
        final release = releases[index];
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

- [ ] **Step 4: Run tests to verify they pass**

```bash
flutter test test/features/release_search/
```

Expected: PASS. If `release_search_page_test.dart` still asserts on the
removed `SegmentedButton` or a `ReleaseSort.peers`-style value, update
those assertions to the new `_SortChip` row / trimmed enum before this
passes.

- [ ] **Step 5: Commit**

```bash
dart format lib/features/release_search/ test/features/release_search/
dart analyze lib/features/release_search/
git add lib/features/release_search/release_search_page.dart lib/features/release_search/widgets/release_tile.dart test/features/release_search/release_search_page_test.dart test/features/release_search/release_tile_test.dart
git commit -m "feat(release_search): restyle page/tile onto Nocturne (README §3e)"
```

---

### Task 17: Full-branch verification pass

**Files:** none created — verification and any small fixes surfaced by it.

- [ ] **Step 1: Run the full test suite**

```bash
flutter test
```

Expected: all tests pass, including every test added in Tasks 1–16 and
every pre-existing test (Phases 1–6's Home/Library/Activity/Uptime/
Indexers/Settings suites must not have regressed — `MediaDetailHeader`'s
Task 5 signature change is the one edit in this phase that touches
pre-existing, unrelated screens).

- [ ] **Step 2: Run static analysis and formatting across the whole repo**

```bash
dart analyze
dart format --set-exit-if-changed .
```

Expected: zero issues. Fix any that appear (unused imports from the
`requests_tab_view.dart`/`request_list_tile.dart` deletion, missing
`const`, etc.) and re-run until clean.

- [ ] **Step 3: Confirm no dangling references to deleted/renamed symbols**

```bash
grep -rn "RequestsTabView\|RequestListTile\|ReleaseSort.peers\|ReleaseSort.age\|ReleaseSort.quality" lib/ test/
grep -rn "MediaDetailHeader(" lib/ | grep -v "poster:"
```

Expected: no matches for the first grep; the second grep should only match
`media_detail_header.dart`'s own class declaration line, confirming every
call site was updated to the new `poster:`-based signature.

- [ ] **Step 4: Manually cross-check each screen against the spec**

Walk `docs/superpowers/specs/2026-09-14-nocturne-redesign-phase7-seerr-adding-design.md`
§3a–3e one more time against the rewritten pages, confirming: no `isDark`
branching was introduced (`grep -rn "isDark" lib/features/discover
lib/features/requests lib/features/library/add_movie_page.dart
lib/features/library/add_series_page.dart lib/features/release_search`
should return nothing new from this phase), tabular figures on every
numeric figure ("N found", free-space captions, request-card
attribution timestamps via the existing `formatRelativeTime`), and that
`AppColors`/`AppSpacing`/`AppTypography` tokens are used throughout with no
hardcoded hex colors or raw pixel literals introduced by this phase (the
9px/5px/1px badge dimensions in `media_status_badge.dart` are a documented,
spec-mandated exception, matching the precedent set by Phase 6's 1px
heartbeat-bar radius).

- [ ] **Step 5: Commit any fixes from Steps 1–3**

```bash
git add -A
git commit -m "fix(nocturne): address analyze/format/regression findings from Phase 7 verification"
```

(Skip this commit entirely if Steps 1–3 found nothing to fix.)

## Self-Review Notes

- **Spec coverage:** §3a (Discover) → Tasks 1, 2, 11; §3a's "All →" genre
  grid → Task 12; §3b (Discover detail/request) → Tasks 3, 4, 5, 6, 7, 13;
  §3c (Requests queue) → Tasks 1, 7, 8, 9, 10; §3d (Add to library) →
  Tasks 3, 4, 14; §3e (Manual release search) → Tasks 15, 16. All ten
  numbered "Decisions locked" items from the design spec are implemented:
  Decision 1 (service-details API) → Task 7; Decision 2 (best-effort
  availability, omit not fabricate) → Task 13's `availabilityLines`;
  Decision 3 (trimmed sort chips) → Task 15; Decision 4 (standalone
  Requests route) → Tasks 10–11; Decision 5 (`MediaDetailHeader` poster
  slot) → Task 5; Decision 6 (unified status presentation) → Task 1, with
  the documented refinement that Tasks 2/12/13's badge/chip classify
  `status` directly rather than consuming Task 1's literal-label function,
  since their wording ("In library"/"Requested"/"Not in library") diverges
  from the literal media-status vocabulary that function unifies — only
  Task 9's `InProgressRow` consumes it directly, as that context wants the
  literal status names; Decision 7 (dual-axis bucketing, pagination
  correctness) → Task 8's bucketing plus Task 7's `seerrAllRequestsProvider`,
  which **takes the safe fallback path unconditionally** (paginating
  `filter: 'all'` and bucketing client-side) rather than gating on live
  verification of Overseerr's filter vocabulary that this plan has no way
  to perform — a deliberate, more conservative choice than the spec's
  "verify first, fall back if needed" framing, documented in Task 7's own
  code comment; Decision 8 (disable-then-refetch approve/deny) → Task 9;
  Decision 9 (generic in-progress status text) → Task 9's `InProgressRow`;
  Decision 10 (omit fabricated profile-name attribution) → Task 9's
  `RequestCard`.
- **One spec-to-plan deviation, called out explicitly:** the design spec's
  3b section describes a secondary "Browse releases" action alongside
  "Request", gated on the title already existing in Radarr/Sonarr. Task 13
  does not implement this button at all — `SeerrMediaInfo` has no
  Radarr/Sonarr-side `movieId`/`episodeId` field for `ReleaseSearchPage`'s
  required `targetId`, so the gating condition the spec describes is
  actually unsatisfiable with today's data model, not merely "usually
  false." Shipping a visible button with no working destination would be
  worse than omitting it (the same "no fake-confident UI" principle behind
  Decision 2). This is out of scope for Phase 7, not deferred silently —
  see Task 13's own note and the Out-of-scope section below.
- **Placeholder scan:** no "TBD"/"TODO" markers; every code step is a
  complete file or complete method body, not a description of one.
- **Type consistency checked:** `MediaStatusBadge({required SeerrMediaInfo?
  mediaInfo})` (Task 2) matches every construction site in Tasks 11–12;
  `LabeledDropdownField<T>`/`LabeledToggleRow` (Tasks 3–4) signatures match
  their usage in Tasks 13–14; `MediaDetailHeader({required Widget poster,
  ...})` (Task 5) matches Task 13's construction and the two pre-existing
  call sites Task 5 itself updates; `needsDecision`/`inProgress`/
  `availableRequests`/`requestStats`/`RequestStats` (Task 8) match Task
  10's usage exactly; `RequestCard`/`InProgressRow` (Task 9) constructor
  params match Task 10's construction; `seerrRadarrServiceProvider`/
  `seerrSonarrServiceProvider`/`seerrAllRequestsProvider` (Task 7) match
  their family-provider call shape in Tasks 9–10 and 13;
  `availabilityLines` (Task 13) is self-contained within that task, no
  cross-task signature risk.
- **Testing section mapping:** every "Testing" bullet promised in the
  design spec has a concrete test in the task that implements it — the
  spec's `mediaStatusPresentation` unit tests, `MediaStatusBadge` states,
  shared-widget tests, Seerr repository/client tests including the
  null-omission case, the 3b profile-failure/availability-omission tests,
  the 3c bucketing-trap and approve/deny-disable tests, and the 3e
  sort/icon tests are all present in Tasks 1, 2, 3–4, 6–7, 13, 8–10, and
  15–16 respectively. The spec's suggested golden/screenshot check against
  the reference screenshots is not included as an automated task — this
  app's existing test suite (Phases 1–6) has no golden-image tests
  anywhere to extend that pattern from; a manual visual pass against
  `design_handoff_arrstack_hub/screenshots/3a.png`–`3e.png` during Task 17
  Step 4 covers this instead.

## Out of scope

- §3f (empty/loading/offline) and §3g (destructive confirm) — Phase 8, per
  the design spec.
- A Radarr/Sonarr server picker on 3b when Seerr has more than one
  configured server of that type (Task 13 hardcodes `serviceId: 0`).
- Literal per-episode "downloading SxxEyy" status text on 3c's in-progress
  rows — not available from Overseerr's request API (Task 9, Decision 9).
- The 3b "Browse releases" secondary action — no Radarr/Sonarr-side id to
  wire it to (see Self-Review Notes above).
- TV season selection on the 3b request panel — unchanged from today's
  behavior (Seerr defaults to all seasons when `seasons` is omitted); the
  design spec's 3b section doesn't call for season-picking UI either.
- Rebuilding `requests_tab_view.dart`'s approved/declined filter options —
  3c's funnel only toggles all-vs-pending-vs-available (Task 10).


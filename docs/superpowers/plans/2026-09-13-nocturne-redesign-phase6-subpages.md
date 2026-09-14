# Nocturne Redesign Phase 6: Sub-pages Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild Uptime, Indexers, Settings, and the error-first Edit-instance
variant onto the Nocturne design system (README §2k–2n), completing Phase 6 of
the 8-phase redesign.

**Architecture:** Two new shared widgets (`SubPageHeader`, `HeartbeatStrip`)
back all four screens. Each screen's page file is rewritten in place against
existing providers — no new routes, no new persisted state, except one narrow
addition to `ProwlarrClient` for date-scoped indexer stats. Pure calculation
logic (monitor classification, duration labels, slow-indexer thresholds, stat
aggregation) is extracted into plain-Dart files so it's unit-testable without
pumping widgets.

**Tech Stack:** Flutter, Riverpod (`riverpod_annotation` code-gen), `go_router`,
`phosphor_icons`, `freezed` (existing models only — no new freezed models this
phase).

**Spec:** `docs/superpowers/specs/2026-09-13-nocturne-redesign-phase6-subpages-design.md`

## Global Constraints

- Never hardcode Nocturne colors/spacing/type inline — use `AppColors`,
  `AppSpacing`, `AppRadius`, `AppTypography`, `AppInsets` from
  `lib/app/theme/design_tokens.dart`.
- No `isDark` branching in new code — the theme-level `onSurfaceVariant` fix
  from Phase 5 means Nocturne tokens work directly in both themes.
- Tabular numerals (`FontFeature.tabularFigures()`) on every numeric figure:
  counts, latencies, response times, durations.
- `dart format` and `dart analyze` must stay clean after every task — run both
  before each commit.
- Every new pure-logic file (no `flutter` import) gets a plain `test/unit/`
  test; every new/rewritten widget gets a `test/widget/` test using
  `ProviderScope` overrides, matching the existing test patterns in
  `test/features/library/` from Phase 5.

---

### Task 1: `SubPageHeader` shared header widget

**Files:**
- Create: `lib/core/widgets/sub_page_header.dart`
- Test: `test/core/widgets/sub_page_header_test.dart`

**Interfaces:**
- Produces: `SubPageHeader({String? kicker, required String title, List<Widget>? actions})`, a `StatelessWidget` implementing `PreferredSizeWidget`, usable as `Scaffold.appBar`. Later tasks (Uptime, Indexers, Settings, Edit-instance pages) construct it directly.

- [ ] **Step 1: Write the failing test**

```dart
// test/core/widgets/sub_page_header_test.dart
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders kicker over title when kicker is provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: SubPageHeader(kicker: 'UPTIME KUMA', title: 'Monitors'),
        ),
      ),
    );

    expect(find.text('UPTIME KUMA'), findsOneWidget);
    expect(find.text('Monitors'), findsOneWidget);
  });

  testWidgets('renders only the title when kicker is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: SubPageHeader(title: 'Settings')),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('renders provided actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: SubPageHeader(
            title: 'Indexers',
            actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  test('preferredSize matches the standard toolbar height', () {
    const header = SubPageHeader(title: 'Settings');
    expect(header.preferredSize, const Size.fromHeight(kToolbarHeight));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/sub_page_header_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:arrstack/core/widgets/sub_page_header.dart'`

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/core/widgets/sub_page_header.dart
/// Shared "back + kicker/title" header for sub-pages reached from Home
/// (Uptime, Indexers, Settings, Edit instance) — README "Shared shell" →
/// Header → Sub-pages. The back chevron comes from `AppBar`'s default
/// leading-back behavior; GoRouter supplies it automatically when there's a
/// route to pop.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:flutter/material.dart';

class SubPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const SubPageHeader({required this.title, this.kicker, this.actions, super.key});

  final String? kicker;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final kickerText = kicker;
    return AppBar(
      actions: actions,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (kickerText != null) Text(kickerText, style: AppTypography.kicker),
          Text(title, style: AppTypography.sectionTitle),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/sub_page_header_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/core/widgets/sub_page_header.dart test/core/widgets/sub_page_header_test.dart
dart analyze lib/core/widgets/sub_page_header.dart
git add lib/core/widgets/sub_page_header.dart test/core/widgets/sub_page_header_test.dart
git commit -m "feat(core): add SubPageHeader shared sub-page header widget"
```

---

### Task 2: `HeartbeatStrip` shared widget

**Files:**
- Create: `lib/features/uptime/widgets/heartbeat_strip.dart`
- Test: `test/features/uptime/widgets/heartbeat_strip_test.dart`
- Delete (this task): none yet — `monitor_tile.dart` (which contains the private `_HeartbeatBar` this replaces) is deleted in Task 6 when the page is rewritten, to avoid breaking `uptime_page.dart` mid-task.

**Interfaces:**
- Consumes: `KumaHeartbeat` from `package:arrstack/services/uptimekuma/models/kuma_models.dart` (fields used: `status` (`int`, 1 = up), nothing else).
- Produces: `HeartbeatStrip({required List<KumaHeartbeat> heartbeats, required int beatCount, required double height, required Color upColor})`. Tasks 4 and 5 (`DownMonitorCard`, `HealthyMonitorRow`) construct it directly.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/uptime/widgets/heartbeat_strip_test.dart
import 'package:arrstack/features/uptime/widgets/heartbeat_strip.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

KumaHeartbeat _hb(int status) => KumaHeartbeat(
  monitorId: 1,
  status: status,
  time: DateTime(2026),
  ping: 20,
  important: false,
);

void main() {
  testWidgets('renders beatCount bars total, padding with empty slots first', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeartbeatStrip(
            heartbeats: [_hb(1), _hb(1)],
            beatCount: 5,
            height: 22,
            upColor: Colors.green,
          ),
        ),
      ),
    );

    expect(find.byType(Container), findsNWidgets(5));
  });

  testWidgets('colors a down heartbeat with the down color, not upColor', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeartbeatStrip(
            heartbeats: [_hb(0)],
            beatCount: 1,
            height: 22,
            upColor: Colors.green,
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, isNot(Colors.green));
  });

  testWidgets('sizes the strip to the given height', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeartbeatStrip(
            heartbeats: [_hb(1)],
            beatCount: 1,
            height: 14,
            upColor: Colors.green,
          ),
        ),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
    expect(sizedBox.height, 14);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/uptime/widgets/heartbeat_strip_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/uptime/widgets/heartbeat_strip.dart
/// A row of heartbeat bars, oldest→newest left→right, for Uptime Kuma
/// monitors (README §2k): 24 beats/22px for a down monitor's hero card, 12
/// beats/14px for a healthy monitor's compact row.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class HeartbeatStrip extends StatelessWidget {
  const HeartbeatStrip({
    required this.heartbeats,
    required this.beatCount,
    required this.height,
    required this.upColor,
    super.key,
  });

  final List<KumaHeartbeat> heartbeats;
  final int beatCount;
  final double height;
  final Color upColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = heartbeats.take(beatCount).toList().reversed.toList();
    final empty = beatCount - recent.length;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (var i = 0; i < empty; i++)
            _bar(theme.colorScheme.surfaceContainerHighest),
          for (final hb in recent) _bar(hb.status == 1 ? upColor : AppColors.down),
        ],
      ),
    );
  }

  Widget _bar(Color color) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.75),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(1)),
    ),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/uptime/widgets/heartbeat_strip_test.dart`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/uptime/widgets/heartbeat_strip.dart test/features/uptime/widgets/heartbeat_strip_test.dart
dart analyze lib/features/uptime/widgets/heartbeat_strip.dart
git add lib/features/uptime/widgets/heartbeat_strip.dart test/features/uptime/widgets/heartbeat_strip_test.dart
git commit -m "feat(uptime): add HeartbeatStrip shared widget"
```

---

### Task 3: Uptime monitor-status pure logic

**Files:**
- Create: `lib/features/uptime/monitor_status.dart`
- Test: `test/features/uptime/monitor_status_test.dart`

**Interfaces:**
- Consumes: `KumaMonitor` (fields: `active` (`bool`), `status` (`int`), `heartbeats` (`List<KumaHeartbeat>`, newest-first), `uptime` (`double`)); `KumaHeartbeat` (fields: `status`, `time`); `FormatUtils.formatReleaseAge(int minutes)` from `lib/core/utils/format_utils.dart` (existing — returns `"just now"`/`"{m}m"`/`"{h}h"`/`"{d}d"`).
- Produces: `bool isMonitorUp(KumaMonitor)`, `bool isMonitorDown(KumaMonitor)`, `bool isMonitorPaused(KumaMonitor)`, `String downDurationLabel(KumaMonitor, {DateTime? now})`, `String pausedDurationLabel(KumaMonitor, {DateTime? now})`. Tasks 4, 5, 6 (`DownMonitorCard`, `HealthyMonitorRow`, `uptime_page.dart`) call these directly.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/uptime/monitor_status_test.dart
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter_test/flutter_test.dart';

KumaMonitor _monitor({
  required bool active,
  required int status,
  List<KumaHeartbeat> heartbeats = const [],
}) => KumaMonitor(
  id: 1,
  name: 'Test',
  type: 'http',
  active: active,
  interval: 60,
  status: status,
  heartbeats: heartbeats,
);

KumaHeartbeat _hb(int status, DateTime time) => KumaHeartbeat(
  monitorId: 1,
  status: status,
  time: time,
  ping: 10,
  important: false,
);

void main() {
  group('classification', () {
    test('isMonitorUp is true only when active and status is up', () {
      expect(isMonitorUp(_monitor(active: true, status: 1)), isTrue);
      expect(isMonitorUp(_monitor(active: false, status: 1)), isFalse);
      expect(isMonitorUp(_monitor(active: true, status: 0)), isFalse);
    });

    test('isMonitorDown is true only when active and status is down', () {
      expect(isMonitorDown(_monitor(active: true, status: 0)), isTrue);
      expect(isMonitorDown(_monitor(active: false, status: 0)), isFalse);
    });

    test('isMonitorPaused is true whenever the monitor is inactive', () {
      expect(isMonitorPaused(_monitor(active: false, status: 1)), isTrue);
      expect(isMonitorPaused(_monitor(active: true, status: 1)), isFalse);
    });
  });

  group('downDurationLabel', () {
    test('measures back to the oldest heartbeat in the current down run', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final monitor = _monitor(
        active: true,
        status: 0,
        heartbeats: [
          _hb(0, now.subtract(const Duration(minutes: 5))),
          _hb(0, now.subtract(const Duration(minutes: 38))),
          _hb(1, now.subtract(const Duration(minutes: 90))),
        ],
      );

      expect(downDurationLabel(monitor, now: now), '38m');
    });

    test('falls back to "just now" when there is no heartbeat history', () {
      final monitor = _monitor(active: true, status: 0);
      expect(downDurationLabel(monitor), 'just now');
    });

    test('falls back to "just now" when the newest heartbeat is not down', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final monitor = _monitor(
        active: true,
        status: 0,
        heartbeats: [_hb(1, now)],
      );
      expect(downDurationLabel(monitor, now: now), 'just now');
    });
  });

  group('pausedDurationLabel', () {
    test('measures from the most recent heartbeat before pausing', () {
      final now = DateTime(2026, 1, 1, 12, 0);
      final monitor = _monitor(
        active: false,
        status: 1,
        heartbeats: [_hb(1, now.subtract(const Duration(days: 4)))],
      );
      expect(pausedDurationLabel(monitor, now: now), 'paused 4d');
    });

    test('falls back to "paused" with no duration when there is no history', () {
      final monitor = _monitor(active: false, status: 1);
      expect(pausedDurationLabel(monitor), 'paused');
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/uptime/monitor_status_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/uptime/monitor_status.dart
/// Pure helpers for classifying and describing Uptime Kuma monitors
/// (README §2k): up/down/paused counts and human-readable down/paused
/// durations. Kept free of Flutter imports so they're unit-testable without
/// pumping widgets.
library;

import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';

bool isMonitorUp(KumaMonitor monitor) => monitor.active && monitor.status == 1;

bool isMonitorDown(KumaMonitor monitor) => monitor.active && monitor.status == 0;

bool isMonitorPaused(KumaMonitor monitor) => !monitor.active;

/// How long [monitor] has been down, as a compact string ("38m", "2h", "3d"),
/// or "just now" if the down-transition can't be determined from the
/// (newest-first) heartbeat history.
String downDurationLabel(KumaMonitor monitor, {DateTime? now}) {
  final heartbeats = monitor.heartbeats;
  if (heartbeats.isEmpty || heartbeats.first.status != 0) return 'just now';

  var last = heartbeats.first;
  for (final hb in heartbeats) {
    if (hb.status != 0) break;
    last = hb;
  }
  final reference = now ?? DateTime.now();
  return FormatUtils.formatReleaseAge(reference.difference(last.time).inMinutes);
}

/// How long [monitor] has been paused, as "paused {duration}", or just
/// "paused" if there's no heartbeat history to measure from.
String pausedDurationLabel(KumaMonitor monitor, {DateTime? now}) {
  if (monitor.heartbeats.isEmpty) return 'paused';
  final reference = now ?? DateTime.now();
  final minutes = reference.difference(monitor.heartbeats.first.time).inMinutes;
  return 'paused ${FormatUtils.formatReleaseAge(minutes)}';
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/uptime/monitor_status_test.dart`
Expected: PASS (8 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/uptime/monitor_status.dart test/features/uptime/monitor_status_test.dart
dart analyze lib/features/uptime/monitor_status.dart
git add lib/features/uptime/monitor_status.dart test/features/uptime/monitor_status_test.dart
git commit -m "feat(uptime): add pure monitor classification and duration helpers"
```

---

### Task 4: `DownMonitorCard` widget

**Files:**
- Create: `lib/features/uptime/widgets/down_monitor_card.dart`
- Test: `test/features/uptime/widgets/down_monitor_card_test.dart`

**Interfaces:**
- Consumes: `KumaMonitor` (fields: `name`, `type`, `url`, `heartbeats`, `uptime`); `HeartbeatStrip` (Task 2); `downDurationLabel` (Task 3); `DetailChip` from `lib/core/widgets/detail_chip.dart` (existing — `DetailChip({required String label, required Color color, VoidCallback? onTap})`).
- Produces: `DownMonitorCard({required KumaMonitor monitor, required VoidCallback onRetest})`. Task 6 (`uptime_page.dart`) constructs one per down monitor.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/uptime/widgets/down_monitor_card_test.dart
import 'package:arrstack/features/uptime/widgets/down_monitor_card.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

KumaMonitor _downMonitor() => KumaMonitor(
  id: 1,
  name: 'Bazarr',
  type: 'http',
  url: 'http://192.168.1.10:6767',
  active: true,
  interval: 60,
  status: 0,
  uptime: 0.6842,
  heartbeats: [
    KumaHeartbeat(
      monitorId: 1,
      status: 0,
      time: DateTime.now().subtract(const Duration(minutes: 38)),
      ping: 0,
      important: true,
    ),
  ],
);

void main() {
  testWidgets('shows the monitor name, type, and url', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DownMonitorCard(monitor: _downMonitor(), onRetest: () {}),
        ),
      ),
    );

    expect(find.text('Bazarr'), findsOneWidget);
    expect(find.text('HTTP'), findsOneWidget);
    expect(find.text('http://192.168.1.10:6767'), findsOneWidget);
  });

  testWidgets('shows the down duration and 24h uptime', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DownMonitorCard(monitor: _downMonitor(), onRetest: () {}),
        ),
      ),
    );

    expect(find.textContaining('Down 38m'), findsOneWidget);
    expect(find.textContaining('68.42% 24h'), findsOneWidget);
  });

  testWidgets('calls onRetest when the Retest button is tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DownMonitorCard(
            monitor: _downMonitor(),
            onRetest: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Retest'));
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/uptime/widgets/down_monitor_card_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/uptime/widgets/down_monitor_card.dart
/// The down-monitor hero card in Uptime (README §2k): red inset ring, a
/// glowing status dot, the monitor's type and URL, a 24-beat heartbeat
/// strip, and a footer with the down duration, 24h uptime, and Retest.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/features/uptime/widgets/heartbeat_strip.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class DownMonitorCard extends StatelessWidget {
  const DownMonitorCard({required this.monitor, required this.onRetest, super.key});

  final KumaMonitor monitor;
  final VoidCallback onRetest;

  @override
  Widget build(BuildContext context) {
    final uptimePercent = (monitor.uptime * 100).toStringAsFixed(2);
    final url = monitor.url;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.space4),
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.down.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.down,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.down.withValues(alpha: 0.9),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space3),
              Expanded(
                child: Text(
                  monitor.name,
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DetailChip(label: monitor.type.toUpperCase(), color: AppColors.n400),
            ],
          ),
          if (url != null && url.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space2),
            Text(url, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.meta),
          ],
          const SizedBox(height: AppSpacing.space4),
          HeartbeatStrip(
            heartbeats: monitor.heartbeats,
            beatCount: 24,
            height: 22,
            upColor: AppColors.up,
          ),
          const SizedBox(height: AppSpacing.space3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Down ${downDurationLabel(monitor)} · $uptimePercent% 24h',
                  style: AppTypography.meta.copyWith(
                    color: AppColors.down,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onRetest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                ),
                child: const Text('Retest'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/uptime/widgets/down_monitor_card_test.dart`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/uptime/widgets/down_monitor_card.dart test/features/uptime/widgets/down_monitor_card_test.dart
dart analyze lib/features/uptime/widgets/down_monitor_card.dart
git add lib/features/uptime/widgets/down_monitor_card.dart test/features/uptime/widgets/down_monitor_card_test.dart
git commit -m "feat(uptime): add DownMonitorCard widget"
```

---

### Task 5: `HealthyMonitorRow` widget

**Files:**
- Create: `lib/features/uptime/widgets/healthy_monitor_row.dart`
- Test: `test/features/uptime/widgets/healthy_monitor_row_test.dart`

**Interfaces:**
- Consumes: `KumaMonitor` (fields: `name`, `heartbeats`); `HeartbeatStrip` (Task 2).
- Produces: `HealthyMonitorRow({required KumaMonitor monitor})`. Task 6 constructs one per up monitor.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/uptime/widgets/healthy_monitor_row_test.dart
import 'package:arrstack/features/uptime/widgets/healthy_monitor_row.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

KumaMonitor _upMonitor() => KumaMonitor(
  id: 2,
  name: 'Radarr',
  type: 'http',
  active: true,
  interval: 60,
  status: 1,
  heartbeats: [
    KumaHeartbeat(monitorId: 2, status: 1, time: DateTime.now(), ping: 18, important: false),
  ],
);

void main() {
  testWidgets('shows the monitor name and latest latency', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: HealthyMonitorRow(monitor: _upMonitor()))),
    );

    expect(find.text('Radarr'), findsOneWidget);
    expect(find.text('18 ms'), findsOneWidget);
  });

  testWidgets('shows no latency text when there are no heartbeats', (tester) async {
    final monitor = KumaMonitor(
      id: 3,
      name: 'NoHeartbeats',
      type: 'http',
      active: true,
      interval: 60,
      status: 1,
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: HealthyMonitorRow(monitor: monitor))),
    );

    expect(find.textContaining('ms'), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/uptime/widgets/healthy_monitor_row_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/uptime/widgets/healthy_monitor_row.dart
/// A compact healthy-monitor row in Uptime (README §2k): a small status dot,
/// name, a 12-beat heartbeat strip, and trailing latency.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/uptime/widgets/heartbeat_strip.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';

class HealthyMonitorRow extends StatelessWidget {
  const HealthyMonitorRow({required this.monitor, super.key});

  final KumaMonitor monitor;

  @override
  Widget build(BuildContext context) {
    final latestPing = monitor.heartbeats.isNotEmpty ? monitor.heartbeats.first.ping : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: AppColors.up, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              monitor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          SizedBox(
            width: 74,
            child: HeartbeatStrip(
              heartbeats: monitor.heartbeats,
              beatCount: 12,
              height: 14,
              upColor: AppColors.up,
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          if (latestPing != null)
            Text(
              '$latestPing ms',
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

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/uptime/widgets/healthy_monitor_row_test.dart`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/uptime/widgets/healthy_monitor_row.dart test/features/uptime/widgets/healthy_monitor_row_test.dart
dart analyze lib/features/uptime/widgets/healthy_monitor_row.dart
git add lib/features/uptime/widgets/healthy_monitor_row.dart test/features/uptime/widgets/healthy_monitor_row_test.dart
git commit -m "feat(uptime): add HealthyMonitorRow widget"
```

---

### Task 6: Rewrite `uptime_page.dart`, delete superseded widgets

**Files:**
- Modify: `lib/features/uptime/uptime_page.dart` (full rewrite)
- Delete: `lib/features/uptime/widgets/monitor_tile.dart` (superseded by Tasks 2, 4, 5)
- Modify: `lib/features/uptime/uptime_providers.dart:12-27` — keep `SelectedUptimeInstanceId` as-is (still needed to resolve the default instance); no change required here, confirm by reading before editing.
- Test: `test/features/uptime/uptime_page_test.dart`

**Interfaces:**
- Consumes: `SubPageHeader` (Task 1), `HeartbeatStrip` (Task 2), `isMonitorUp`/`isMonitorDown`/`isMonitorPaused`/`pausedDurationLabel` (Task 3), `DownMonitorCard` (Task 4), `HealthyMonitorRow` (Task 5), `selectedUptimeInstanceIdProvider`, `kumaMonitorsProvider(String instanceId)`, `EmptyState`, `FadingRule`.
- Produces: `UptimePage` (no constructor params — unchanged public surface, still routed at `/home/uptime`).

- [ ] **Step 1: Write the failing test**

```dart
// test/features/uptime/uptime_page_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/uptime/uptime_page.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows UP/DOWN/PAUSED counts and no instance dropdown', (
    tester,
  ) async {
    const instanceId = 'kuma-1';
    final monitors = [
      KumaMonitor(id: 1, name: 'Up1', type: 'http', active: true, interval: 60, status: 1),
      KumaMonitor(id: 2, name: 'Down1', type: 'http', active: true, interval: 60, status: 0),
      KumaMonitor(id: 3, name: 'Paused1', type: 'http', active: false, interval: 60, status: 1),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedUptimeInstanceIdProvider.overrideWith(
            () => _FakeSelectedUptimeInstanceId(instanceId),
          ),
          kumaMonitorsProvider(
            instanceId,
          ).overrideWith(() => _FakeKumaMonitors(monitors)),
        ],
        child: const MaterialApp(home: UptimePage()),
      ),
    );
    await tester.pump();

    expect(find.text('1'), findsNWidgets(3)); // UP, DOWN, PAUSED all count 1
    expect(find.text('UP'), findsOneWidget);
    expect(find.text('DOWN'), findsOneWidget);
    expect(find.text('PAUSED'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsNothing);
    expect(find.text('Down1'), findsOneWidget);
    expect(find.textContaining('HEALTHY'), findsOneWidget);
    expect(find.text('Up1'), findsOneWidget);
  });
}

class _FakeSelectedUptimeInstanceId extends SelectedUptimeInstanceId {
  _FakeSelectedUptimeInstanceId(this._id);
  final String _id;

  @override
  Future<String?> build() async => _id;
}

class _FakeKumaMonitors extends KumaMonitors {
  _FakeKumaMonitors(this._monitors);
  final List<KumaMonitor> _monitors;

  @override
  Stream<Result<List<KumaMonitor>>> build(String instanceId) async* {
    yield Ok(_monitors);
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/uptime/uptime_page_test.dart`
Expected: FAIL — today's page still shows the 2×2 admin grid and an instance
dropdown when there's more than one instance; `find.byType(DropdownButton<String>)`
won't itself fail on a single instance, but `find.text('DOWN')`/`'PAUSED'` fail
since the current page uses "MONITORS"/"DOWN"/"PAUSED"/"MAINTENANCE" 2×2 labels,
not this stat-row shape, and has no "HEALTHY" kicker.

- [ ] **Step 3: Write minimal implementation**

First, read `lib/features/uptime/uptime_providers.dart` in full to confirm
`SelectedUptimeInstanceId` is untouched (it is — this task only touches the page
and deletes `monitor_tile.dart`).

Delete `lib/features/uptime/widgets/monitor_tile.dart`.

Replace `lib/features/uptime/uptime_page.dart` in full:

```dart
// lib/features/uptime/uptime_page.dart
/// Uptime tab: Uptime Kuma monitors and real-time status (README §2k).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/uptime/monitor_status.dart';
import 'package:arrstack/features/uptime/uptime_providers.dart';
import 'package:arrstack/features/uptime/widgets/down_monitor_card.dart';
import 'package:arrstack/features/uptime/widgets/healthy_monitor_row.dart';
import 'package:arrstack/services/uptimekuma/kuma_providers.dart';
import 'package:arrstack/services/uptimekuma/models/kuma_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class UptimePage extends ConsumerWidget {
  const UptimePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instanceIdAsync = ref.watch(selectedUptimeInstanceIdProvider);
    final instanceId = instanceIdAsync.asData?.value;

    return Scaffold(
      appBar: SubPageHeader(
        kicker: 'UPTIME KUMA',
        title: 'Monitors',
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 17),
            tooltip: 'Refresh',
            onPressed: instanceId == null
                ? null
                : () => ref.invalidate(kumaMonitorsProvider(instanceId)),
          ),
        ],
      ),
      body: instanceIdAsync.when(
        data: (id) => id == null ? const _NoKumaInstance() : _MonitorList(instanceId: id),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _MonitorList extends ConsumerWidget {
  const _MonitorList({required this.instanceId});
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monitorsAsync = ref.watch(kumaMonitorsProvider(instanceId));

    return monitorsAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => value.isEmpty
            ? const EmptyState(
                icon: Icons.monitor_heart_outlined,
                title: 'No monitors found',
                message: 'Your Uptime Kuma has no monitors configured.',
              )
            : _MonitorContent(instanceId: instanceId, monitors: value),
        Err(:final error) => EmptyState(
            icon: Icons.error_outline,
            title: 'Failed to connect',
            message: error.userMessage,
            action: FilledButton(
              onPressed: () => ref.invalidate(kumaMonitorsProvider(instanceId)),
              child: const Text('Retry'),
            ),
          ),
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Socket error: $err')),
    );
  }
}

class _MonitorContent extends ConsumerWidget {
  const _MonitorContent({required this.instanceId, required this.monitors});

  final String instanceId;
  final List<KumaMonitor> monitors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final down = monitors.where(isMonitorDown).toList();
    final up = monitors.where(isMonitorUp).toList();
    final paused = monitors.where(isMonitorPaused).toList();

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        _StatRow(up: up.length, down: down.length, paused: paused.length),
        const SizedBox(height: AppSpacing.space6),
        for (final monitor in down)
          DownMonitorCard(
            monitor: monitor,
            onRetest: () => ref.invalidate(kumaMonitorsProvider(instanceId)),
          ),
        if (up.isNotEmpty) ...[
          Text('HEALTHY · ${up.length}', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space4),
          for (final monitor in up) HealthyMonitorRow(monitor: monitor),
        ],
        if (paused.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.space4),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space4),
          for (final monitor in paused) _PausedMonitorRow(monitor: monitor),
        ],
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.up, required this.down, required this.paused});

  final int up;
  final int down;
  final int paused;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(value: up, label: 'UP', color: AppColors.up),
        const SizedBox(width: AppSpacing.space8),
        _Stat(value: down, label: 'DOWN', color: AppColors.down),
        const SizedBox(width: AppSpacing.space8),
        _Stat(value: paused, label: 'PAUSED', color: AppColors.n500),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$value', style: AppTypography.statNumeral.copyWith(color: color)),
        Text(label, style: AppTypography.statCaption),
      ],
    );
  }
}

class _PausedMonitorRow extends StatelessWidget {
  const _PausedMonitorRow({required this.monitor});
  final KumaMonitor monitor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(color: AppColors.n600, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              monitor.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardTitle.copyWith(color: AppColors.n500),
            ),
          ),
          Text(pausedDurationLabel(monitor), style: AppTypography.meta),
        ],
      ),
    );
  }
}

class _NoKumaInstance extends StatelessWidget {
  const _NoKumaInstance();

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.monitor_heart_outlined,
      title: 'No Uptime Kuma',
      message: 'Configure an Uptime Kuma service in Settings to see your monitors.',
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/uptime/uptime_page_test.dart`
Expected: PASS

- [ ] **Step 5: Run the full Uptime test suite to check for regressions, then commit**

```bash
flutter test test/features/uptime/
dart format lib/features/uptime/ test/features/uptime/
dart analyze lib/features/uptime/
git add lib/features/uptime/uptime_page.dart test/features/uptime/uptime_page_test.dart
git rm lib/features/uptime/widgets/monitor_tile.dart
git commit -m "feat(uptime): rewrite Uptime page onto Nocturne (README §2k)"
```

---

### Task 7: Prowlarr client date-scoped indexer stats

**Files:**
- Modify: `lib/services/prowlarr/client.dart:39-45`
- Modify: `lib/services/prowlarr/repository.dart:13-14`
- Modify: `lib/services/prowlarr/providers.dart` (add two new providers; existing `prowlarrIndexerStats` stays untouched — `home_providers.dart`'s `_prowlarrSummary` still depends on the unscoped call)
- Test: `test/services/prowlarr/client_test.dart` (create if it doesn't exist; check first) or add to the existing Prowlarr client test file if one exists.

**Interfaces:**
- Produces: `ProwlarrClient.getIndexerStats({DateTime? startDate, DateTime? endDate})` (existing no-arg call sites keep working — both params default to `null`), `ProwlarrRepository.getIndexerStats({DateTime? startDate, DateTime? endDate})`, `prowlarrIndexerStats30dProvider(String instanceId)`, `prowlarrIndexerStatsLast24hProvider(String instanceId)` — both `Future<Result<IndexerStatsResponse>>`. Task 9 (`indexers_page.dart`) consumes the two new providers.

- [ ] **Step 1: Check for an existing Prowlarr client test file**

Run: `find test -path '*prowlarr*client*'`

If a file exists, add the new test group to it, matching its existing mocking
pattern (check for a `Dio`/`DioAdapter` mock setup already in use). If none
exists, create `test/services/prowlarr/client_test.dart` using the pattern
below — check `test/services/radarr/` or `test/services/sonarr/` first for
this codebase's established Dio-mocking approach (likely `http_mock_adapter`
or a hand-written fake `Dio`) and mirror it exactly rather than introducing a
second mocking style.

- [ ] **Step 2: Write the failing test**

```dart
// test/services/prowlarr/client_test.dart
// Mirror this codebase's existing Dio test-double pattern from
// test/services/radarr/ or test/services/sonarr/ for the Dio construction —
// the shape below shows the assertion, not a prescribed mocking library.
import 'package:arrstack/services/prowlarr/client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('getIndexerStats sends startDate and endDate as query params when given', () async {
    late Map<String, dynamic>? capturedQuery;
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = _CapturingAdapter((query) => capturedQuery = query);
    final client = ProwlarrClient(dio);

    await client.getIndexerStats(
      startDate: DateTime(2026, 8, 14),
      endDate: DateTime(2026, 9, 13),
    );

    expect(capturedQuery, {'startDate': '2026-08-14', 'endDate': '2026-09-13'});
  });

  test('getIndexerStats omits query params when neither date is given', () async {
    late Map<String, dynamic>? capturedQuery;
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..httpClientAdapter = _CapturingAdapter((query) => capturedQuery = query);
    final client = ProwlarrClient(dio);

    await client.getIndexerStats();

    expect(capturedQuery, <String, dynamic>{});
  });
}

// A minimal adapter that captures the request's query parameters and
// returns an empty indexer-stats JSON body. Replace with this codebase's
// existing Dio test double if one already exists (see Step 1).
class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this.onRequest);
  final void Function(Map<String, dynamic>?) onRequest;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    onRequest(options.queryParameters);
    return ResponseBody.fromString('{"indexers": []}', 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/services/prowlarr/client_test.dart`
Expected: FAIL — `getIndexerStats` doesn't accept named parameters yet.

- [ ] **Step 4: Write minimal implementation**

`lib/services/prowlarr/client.dart` — replace the `getIndexerStats` method:

```dart
  Future<Result<IndexerStatsResponse>> getIndexerStats({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = <String, dynamic>{};
    if (startDate != null) query['startDate'] = _isoDate(startDate);
    if (endDate != null) query['endDate'] = _isoDate(endDate);

    return dioCall(
      () => _dio.get('api/v1/indexerstats', queryParameters: query),
      map: (data) => IndexerStatsResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  static String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
```

`lib/services/prowlarr/repository.dart` — replace the `getIndexerStats` method:

```dart
  Future<Result<IndexerStatsResponse>> getIndexerStats({
    DateTime? startDate,
    DateTime? endDate,
  }) => _client.getIndexerStats(startDate: startDate, endDate: endDate);
```

`lib/services/prowlarr/providers.dart` — add after the existing
`prowlarrIndexerStats` provider:

```dart
@riverpod
Future<Result<IndexerStatsResponse>> prowlarrIndexerStats30d(
  Ref ref,
  String instanceId,
) async {
  final repo = await ref.watch(prowlarrRepositoryProvider(instanceId).future);
  final now = DateTime.now();
  return repo.getIndexerStats(startDate: now.subtract(const Duration(days: 30)), endDate: now);
}

@riverpod
Future<Result<IndexerStatsResponse>> prowlarrIndexerStatsLast24h(
  Ref ref,
  String instanceId,
) async {
  final repo = await ref.watch(prowlarrRepositoryProvider(instanceId).future);
  final now = DateTime.now();
  return repo.getIndexerStats(startDate: now.subtract(const Duration(hours: 24)), endDate: now);
}
```

- [ ] **Step 5: Regenerate Riverpod code-gen, then run tests**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/services/prowlarr/
```

Expected: PASS. Also confirm nothing else broke:

```bash
grep -rn "getIndexerStats(" lib/ test/ | grep -v "client.dart\|repository.dart\|providers.dart"
```

Confirm every other call site (e.g. `home_providers.dart`'s use of
`prowlarrIndexerStatsProvider`, which calls the repository's no-arg form
internally) still compiles — it does, since both new params are optional and
`prowlarrIndexerStatsProvider` itself is untouched.

- [ ] **Step 6: Commit**

```bash
dart format lib/services/prowlarr/ test/services/prowlarr/
dart analyze lib/services/prowlarr/
git add lib/services/prowlarr/client.dart lib/services/prowlarr/repository.dart lib/services/prowlarr/providers.dart lib/services/prowlarr/providers.g.dart test/services/prowlarr/client_test.dart
git commit -m "feat(prowlarr): add date-scoped indexer stats for 30d/24h windows"
```

---

### Task 8: Indexer-stats pure logic

**Files:**
- Create: `lib/features/indexers/indexer_stats.dart`
- Test: `test/features/indexers/indexer_stats_test.dart`

**Interfaces:**
- Consumes: `IndexerStat` from `lib/services/prowlarr/models/indexer_stat.dart` (fields: `indexerId`, `averageResponseTime`, `numberOfQueries`, `numberOfGrabs`, `numberOfFailures`).
- Produces: `const int slowResponseThresholdMs = 1000`, `bool isSlowResponse(int averageResponseTimeMs)`, `class IndexerTotals { totalGrabs, slowestResponseMs, queries, grabs, failures }`, `IndexerTotals aggregateIndexerStats(List<IndexerStat> stats)`. Task 9 (`indexers_page.dart`) calls these.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/indexers/indexer_stats_test.dart
import 'package:arrstack/features/indexers/indexer_stats.dart';
import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSlowResponse', () {
    test('is true above the threshold', () {
      expect(isSlowResponse(1284), isTrue);
    });

    test('is false at or below the threshold', () {
      expect(isSlowResponse(1000), isFalse);
      expect(isSlowResponse(55), isFalse);
    });
  });

  group('aggregateIndexerStats', () {
    test('sums grabs/queries/failures and finds the max response time', () {
      final stats = [
        const IndexerStat(
          indexerId: 1,
          averageResponseTime: 55,
          numberOfQueries: 100,
          numberOfGrabs: 10,
          numberOfFailures: 1,
        ),
        const IndexerStat(
          indexerId: 2,
          averageResponseTime: 1284,
          numberOfQueries: 200,
          numberOfGrabs: 6,
          numberOfFailures: 36,
        ),
      ];

      final totals = aggregateIndexerStats(stats);

      expect(totals.totalGrabs, 16);
      expect(totals.slowestResponseMs, 1284);
      expect(totals.queries, 300);
      expect(totals.grabs, 16);
      expect(totals.failures, 37);
    });

    test('returns all zeros for an empty list', () {
      final totals = aggregateIndexerStats(const []);
      expect(totals.totalGrabs, 0);
      expect(totals.slowestResponseMs, 0);
      expect(totals.queries, 0);
      expect(totals.grabs, 0);
      expect(totals.failures, 0);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/indexers/indexer_stats_test.dart`
Expected: FAIL — file not found.

- [ ] **Step 3: Write minimal implementation**

```dart
// lib/features/indexers/indexer_stats.dart
/// Pure helpers for Indexers page metrics (README §2l): the slow-response
/// threshold, and aggregation across all indexer stats for the header row
/// and the "LAST 24H" block. Kept free of Flutter imports so they're
/// unit-testable without pumping widgets.
library;

import 'package:arrstack/services/prowlarr/models/indexer_stat.dart';

/// An indexer's average response time above this is flagged "slow". Not a
/// value the README specifies numerically (only the 1284ms example) — a
/// documented judgment call, easy to retune.
const int slowResponseThresholdMs = 1000;

bool isSlowResponse(int averageResponseTimeMs) =>
    averageResponseTimeMs > slowResponseThresholdMs;

class IndexerTotals {
  const IndexerTotals({
    required this.totalGrabs,
    required this.slowestResponseMs,
    required this.queries,
    required this.grabs,
    required this.failures,
  });

  final int totalGrabs;
  final int slowestResponseMs;
  final int queries;
  final int grabs;
  final int failures;
}

IndexerTotals aggregateIndexerStats(List<IndexerStat> stats) {
  if (stats.isEmpty) {
    return const IndexerTotals(
      totalGrabs: 0,
      slowestResponseMs: 0,
      queries: 0,
      grabs: 0,
      failures: 0,
    );
  }
  return IndexerTotals(
    totalGrabs: stats.fold(0, (sum, s) => sum + s.numberOfGrabs),
    slowestResponseMs: stats.map((s) => s.averageResponseTime).reduce((a, b) => a > b ? a : b),
    queries: stats.fold(0, (sum, s) => sum + s.numberOfQueries),
    grabs: stats.fold(0, (sum, s) => sum + s.numberOfGrabs),
    failures: stats.fold(0, (sum, s) => sum + s.numberOfFailures),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/indexers/indexer_stats_test.dart`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
dart format lib/features/indexers/indexer_stats.dart test/features/indexers/indexer_stats_test.dart
dart analyze lib/features/indexers/indexer_stats.dart
git add lib/features/indexers/indexer_stats.dart test/features/indexers/indexer_stats_test.dart
git commit -m "feat(indexers): add pure stat aggregation and slow-threshold helpers"
```

---

### Task 9: Rewrite `indexers_page.dart`

**Files:**
- Modify: `lib/features/indexers/indexers_page.dart` (full rewrite)
- Test: `test/features/indexers/indexers_page_test.dart`

**Interfaces:**
- Consumes: `SubPageHeader` (Task 1), `isSlowResponse`/`aggregateIndexerStats`/`IndexerTotals` (Task 8), `prowlarrIndexersProvider(String instanceId)`, `prowlarrIndexerStats30dProvider(String instanceId)`, `prowlarrIndexerStatsLast24hProvider(String instanceId)` (Task 7), `FadingRule`, `EmptyState`.
- Produces: `IndexersPage({required String instanceId})` — unchanged public constructor, still routed at `/home/indexers/:instanceId`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/indexers/indexers_page_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/indexers/indexers_page.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows header stats, a slow response in warning color, and a dimmed disabled row', (
    tester,
  ) async {
    const instanceId = 'prowlarr-1';
    final indexers = [
      const Indexer(id: 1, name: '1337x', protocol: 'torrent', priority: 25, enable: true),
      const Indexer(id: 2, name: 'Nyaa', protocol: 'torrent', priority: 30, enable: false),
    ];
    final stats = [
      const IndexerStat(
        indexerId: 1,
        averageResponseTime: 1284,
        numberOfQueries: 1204,
        numberOfGrabs: 11,
        numberOfFailures: 37,
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prowlarrIndexersProvider(instanceId).overrideWith((ref) async => Ok(indexers)),
          prowlarrIndexerStats30dProvider(
            instanceId,
          ).overrideWith((ref) async => Ok(IndexerStatsResponse(indexers: stats))),
          prowlarrIndexerStatsLast24hProvider(
            instanceId,
          ).overrideWith((ref) async => Ok(IndexerStatsResponse(indexers: stats))),
        ],
        child: const MaterialApp(home: IndexersPage(instanceId: instanceId)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ENABLED'), findsOneWidget);
    expect(find.text('1'), findsWidgets); // ENABLED count
    expect(find.textContaining('1284'), findsWidgets);
    expect(find.text('LAST 24H'), findsOneWidget);
    expect(find.text('37'), findsOneWidget); // failures

    final nyaaOpacity = tester.widget<Opacity>(
      find.ancestor(of: find.text('Nyaa'), matching: find.byType(Opacity)).first,
    );
    expect(nyaaOpacity.opacity, 0.62);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/indexers/indexers_page_test.dart`
Expected: FAIL — today's page has no "LAST 24H" block, no `Opacity` dimming, no
warning-colored slow response.

- [ ] **Step 3: Write minimal implementation**

Replace `lib/features/indexers/indexers_page.dart` in full:

```dart
// lib/features/indexers/indexers_page.dart
/// Prowlarr indexer status + stats (README §2l): a headline stat row, one
/// row per indexer keyed by enabled/disabled and response time, and a
/// "LAST 24H" totals block.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/indexers/indexer_stats.dart';
import 'package:arrstack/services/prowlarr/prowlarr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class IndexersPage extends ConsumerWidget {
  const IndexersPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexersAsync = ref.watch(prowlarrIndexersProvider(instanceId));
    final stats30dAsync = ref.watch(prowlarrIndexerStats30dProvider(instanceId));
    final stats24hAsync = ref.watch(prowlarrIndexerStatsLast24hProvider(instanceId));

    void refresh() {
      ref.invalidate(prowlarrIndexersProvider(instanceId));
      ref.invalidate(prowlarrIndexerStats30dProvider(instanceId));
      ref.invalidate(prowlarrIndexerStatsLast24hProvider(instanceId));
    }

    return Scaffold(
      appBar: SubPageHeader(
        kicker: 'PROWLARR',
        title: 'Indexers',
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 17),
            tooltip: 'Refresh',
            onPressed: refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: indexersAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _IndexersBody(
                indexers: value,
                stats30d: stats30dAsync.asData?.value,
                stats24h: stats24hAsync.asData?.value,
              ),
            Err(:final error) => EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load indexers',
                message: error.userMessage,
                action: FilledButton(onPressed: refresh, child: const Text('Retry')),
              ),
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Unexpected error: $err')),
        ),
      ),
    );
  }
}

class _IndexersBody extends StatelessWidget {
  const _IndexersBody({required this.indexers, this.stats30d, this.stats24h});

  final List<Indexer> indexers;
  final Result<IndexerStatsResponse>? stats30d;
  final Result<IndexerStatsResponse>? stats24h;

  @override
  Widget build(BuildContext context) {
    if (indexers.isEmpty) {
      return const EmptyState(
        icon: Icons.list_alt_outlined,
        title: 'No indexers configured',
        message: 'Add indexers in the Prowlarr web UI.',
      );
    }

    final stats30dList = switch (stats30d) {
      Ok(:final value) => value.indexers,
      _ => const <IndexerStat>[],
    };
    final stats24hList = switch (stats24h) {
      Ok(:final value) => value.indexers,
      _ => const <IndexerStat>[],
    };
    final totals30d = aggregateIndexerStats(stats30dList);
    final totals24h = aggregateIndexerStats(stats24hList);
    final enabledCount = indexers.where((i) => i.enable).length;

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        Row(
          children: [
            _Stat(value: '$enabledCount', label: 'ENABLED'),
            const SizedBox(width: AppSpacing.space8),
            _Stat(value: '${totals30d.totalGrabs}', label: 'GRABS 30D'),
            const SizedBox(width: AppSpacing.space8),
            _Stat(
              value: '${totals30d.slowestResponseMs}',
              label: 'SLOWEST ms',
              color: isSlowResponse(totals30d.slowestResponseMs) ? AppColors.warning : null,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space6),
        Text('INDEXERS · ${indexers.length}', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space4),
        for (final indexer in indexers)
          _IndexerRow(
            indexer: indexer,
            stat: stats30dList.where((s) => s.indexerId == indexer.id).firstOrNull,
          ),
        const SizedBox(height: AppSpacing.space4),
        const FadingRule(),
        const SizedBox(height: AppSpacing.space4),
        Text('LAST 24H', style: AppTypography.kicker),
        const SizedBox(height: AppSpacing.space3),
        _TotalsRow(label: 'Queries', value: totals24h.queries),
        _TotalsRow(label: 'Grabs', value: totals24h.grabs),
        _TotalsRow(
          label: 'Failures',
          value: totals24h.failures,
          color: totals24h.failures > 0 ? AppColors.warning : null,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.color});

  final String value;
  final String label;
  final Color? color;

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

class _IndexerRow extends StatelessWidget {
  const _IndexerRow({required this.indexer, required this.stat});

  final Indexer indexer;
  final IndexerStat? stat;

  @override
  Widget build(BuildContext context) {
    final stat = this.stat;
    final slow = stat != null && isSlowResponse(stat.averageResponseTime);
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Row(
        children: [
          Icon(
            indexer.enable ? PhosphorIconsFill.checkCircle : PhosphorIconsFill.xCircle,
            size: 16,
            color: indexer.enable ? AppColors.up : AppColors.down,
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(indexer.name, style: AppTypography.cardTitle),
                Text(
                  '${indexer.protocol} · priority ${indexer.priority}'
                  '${slow ? ' · slow responses' : ''}',
                  style: AppTypography.meta.copyWith(
                    color: slow ? AppColors.warning : AppColors.n500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              indexer.enable && stat != null ? '${stat.numberOfGrabs}' : '—',
              textAlign: TextAlign.right,
              style: AppTypography.meta.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              indexer.enable && stat != null ? '${stat.averageResponseTime} ms' : '—',
              textAlign: TextAlign.right,
              style: AppTypography.meta.copyWith(
                color: slow ? AppColors.warning : null,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );

    return indexer.enable ? content : Opacity(opacity: 0.62, child: content);
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({required this.label, required this.value, this.color});

  final String label;
  final int value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.meta),
          Text(
            '$value',
            style: AppTypography.meta.copyWith(
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/indexers/indexers_page_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
dart format lib/features/indexers/ test/features/indexers/
dart analyze lib/features/indexers/
git add lib/features/indexers/indexers_page.dart test/features/indexers/indexers_page_test.dart
git commit -m "feat(indexers): rewrite Indexers page onto Nocturne (README §2l)"
```

---

### Task 10: Rewrite `settings_page.dart` and restyle `home_ssid_setting.dart`

**Files:**
- Modify: `lib/features/settings/settings_page.dart` (full rewrite)
- Modify: `lib/features/settings/widgets/home_ssid_setting.dart` (restyle SSID chips and the Detect button; logic unchanged)
- Test: `test/features/settings/settings_page_test.dart`

**Interfaces:**
- Consumes: `SubPageHeader` (Task 1), `DetailChip`, `FadingRule`, `homeServiceSummariesProvider` (existing, returns `Future<List<HomeServiceSummary>>`), `instancesProvider`, `instanceRepositoryProvider`, `defaultEndpointModeSettingsProvider`, `appThemeModeProvider`.
- Produces: `SettingsPage` — unchanged public constructor, still routed at `/home/settings`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/settings/settings_page_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a live status dot and Reachable text for a matched instance', (
    tester,
  ) async {
    final instance = ServiceInstance(
      id: 'radarr-1',
      name: 'Radarr 4K',
      serviceType: ServiceType.radarr,
      authType: AuthType.apiKey,
      localBaseUrl: 'http://10.0.0.1:7878',
      isDefault: true,
      endpointMode: EndpointMode.auto,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([instance])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              const HomeServiceSummary(
                instanceId: 'radarr-1',
                instanceName: 'Radarr 4K',
                serviceType: ServiceType.radarr,
                isReachable: true,
                summaryLine: '412 movies',
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: SettingsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Radarr 4K'), findsOneWidget);
    expect(find.text('Reachable'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
  });

  testWidgets('shows the summary line for an unreachable instance', (tester) async {
    final instance = ServiceInstance(
      id: 'bazarr-1',
      name: 'Bazarr',
      serviceType: ServiceType.bazarr,
      authType: AuthType.apiKey,
      localBaseUrl: 'http://10.0.0.1:6767',
      endpointMode: EndpointMode.auto,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instancesProvider.overrideWith((ref) async => Ok([instance])),
          homeServiceSummariesProvider.overrideWith(
            (ref) async => [
              const HomeServiceSummary(
                instanceId: 'bazarr-1',
                instanceName: 'Bazarr',
                serviceType: ServiceType.bazarr,
                isReachable: false,
                summaryLine: 'Unreachable',
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: SettingsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unreachable'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: FAIL — today's page never reads `homeServiceSummariesProvider`, so
there's no "Reachable"/"Unreachable" text sourced from it.

- [ ] **Step 3: Write minimal implementation**

Replace `lib/features/settings/settings_page.dart` in full:

```dart
// lib/features/settings/settings_page.dart
/// Settings tab: instance management, networking, and appearance
/// (README §2m).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:arrstack/features/settings/widgets/home_ssid_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final summariesAsync = ref.watch(homeServiceSummariesProvider);

    return Scaffold(
      appBar: SubPageHeader(
        title: 'Settings',
        actions: [
          TextButton.icon(
            onPressed: () => context.go(RoutePaths.homeAddInstance),
            icon: const Icon(PhosphorIconsRegular.plus, size: 15),
            label: const Text('Add'),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          instancesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => _InstancesSection(
                  instances: value,
                  summaries: summariesAsync.asData?.value ?? const [],
                ),
              Err(:final error) => Text('Error: ${error.userMessage}'),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
          Text('HOME NETWORKS', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space2),
          Text(
            "On these networks the app uses each instance's Local URL; "
            'anywhere else it uses Remote.',
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space4),
          const HomeSsidSetting(),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
          const _DefaultEndpointModeSetting(),
          const SizedBox(height: AppSpacing.space4),
          const _ThemeSetting(),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }
}

class _InstancesSection extends StatelessWidget {
  const _InstancesSection({required this.instances, required this.summaries});

  final List<ServiceInstance> instances;
  final List<HomeServiceSummary> summaries;

  @override
  Widget build(BuildContext context) {
    if (instances.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INSTANCES · 0', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space4),
          Text('No services configured yet. Tap "Add" to get started.', style: AppTypography.meta),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('INSTANCES · ${instances.length}', style: AppTypography.kicker),
            Text('tap to edit', style: AppTypography.meta),
          ],
        ),
        const SizedBox(height: AppSpacing.space4),
        for (final instance in instances)
          _InstanceRow(
            instance: instance,
            summary: summaries.where((s) => s.instanceId == instance.id).firstOrNull,
          ),
      ],
    );
  }
}

class _InstanceRow extends ConsumerWidget {
  const _InstanceRow({required this.instance, required this.summary});

  final ServiceInstance instance;
  final HomeServiceSummary? summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = this.summary;
    final dotColor = summary == null
        ? AppColors.n600
        : (summary.isReachable ? AppColors.up : AppColors.down);
    final statusLine = summary == null
        ? null
        : (summary.isReachable ? 'Reachable' : summary.summaryLine);

    return InkWell(
      onTap: () => context.go(RoutePaths.homeEditInstance(instance.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          instance.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cardTitle,
                        ),
                      ),
                      if (instance.isDefault) ...[
                        const SizedBox(width: AppSpacing.space2),
                        const DetailChip(label: 'Default', color: AppColors.accent),
                      ],
                    ],
                  ),
                  if (statusLine != null)
                    Text(
                      statusLine,
                      style: AppTypography.meta.copyWith(
                        color: summary!.isReachable ? AppColors.n500 : AppColors.down,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(PhosphorIconsRegular.trash, size: 15),
              onPressed: () => _confirmDelete(context, ref),
            ),
            const Icon(PhosphorIconsRegular.caretRight, size: 12, color: AppColors.n500),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Instance?'),
        content: Text('Are you sure you want to remove ${instance.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(instanceRepositoryProvider).delete(instance.id);
      ref.invalidate(instancesProvider);
    }
  }
}

class _DefaultEndpointModeSetting extends ConsumerWidget {
  const _DefaultEndpointModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(defaultEndpointModeSettingsProvider);

    return modeAsync.when(
      data: (mode) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Default endpoint', style: AppTypography.cardTitle),
              Text('For newly added instances', style: AppTypography.meta),
            ],
          ),
          DropdownButton<EndpointMode>(
            value: mode,
            underline: const SizedBox.shrink(),
            items: EndpointMode.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                .toList(),
            onChanged: (newMode) => newMode != null
                ? ref.read(defaultEndpointModeSettingsProvider.notifier).updateMode(newMode)
                : null,
          ),
        ],
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

class _ThemeSetting extends ConsumerWidget {
  const _ThemeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Theme', style: AppTypography.cardTitle),
        DropdownButton<ThemeMode>(
          value: themeMode,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
          onChanged: (mode) =>
              mode != null ? ref.read(appThemeModeProvider.notifier).update(mode) : null,
        ),
      ],
    );
  }
}
```

In `lib/features/settings/widgets/home_ssid_setting.dart`, restyle only the
`Wrap`/`Chip` block and the Detect button icon — read the file first, then:

- Replace the `Icon(Icons.wifi_outlined, size: 24)` and
  `Icon(Icons.wifi_find, size: 18)` with
  `Icon(PhosphorIconsRegular.wifiHigh, size: 17)` in both places (add the
  `package:phosphor_icons/phosphor_icons.dart` import).
- Replace the `Wrap(... children: ssids.map((ssid) => Chip(...)).toList())`
  block with:

```dart
Wrap(
  spacing: AppSpacing.space3,
  runSpacing: AppSpacing.space2,
  children: ssids.map((ssid) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space3,
        vertical: AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: AppColors.n900,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(ssid, style: AppTypography.cardTitle),
          const SizedBox(width: AppSpacing.space2),
          InkWell(
            onTap: () => notifier.removeHomeSsid(ssid),
            child: const Icon(PhosphorIconsRegular.x, size: 12, color: AppColors.n500),
          ),
        ],
      ),
    );
  }).toList(),
)
```

(The `package:arrstack/app/theme/design_tokens.dart` import is already
present in this file — no need to add it.)

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/settings_page_test.dart`
Expected: PASS

- [ ] **Step 5: Run the existing Settings/SSID tests too, then commit**

```bash
flutter test test/features/settings/
dart format lib/features/settings/ test/features/settings/
dart analyze lib/features/settings/
git add lib/features/settings/settings_page.dart lib/features/settings/widgets/home_ssid_setting.dart test/features/settings/settings_page_test.dart
git commit -m "feat(settings): rewrite Settings page onto Nocturne (README §2m)"
```

---

### Task 11: Edit-instance auto-test-on-load and error-title mapping

**Files:**
- Modify: `lib/features/onboarding/onboarding_providers.dart:118-143` (`load` method), and add two new members to `InstanceForm` / a top-level function.
- Test: `test/features/onboarding/onboarding_providers_test.dart` (check first whether this file exists; extend it if so, matching its existing fake-repository pattern).

**Interfaces:**
- Consumes: existing `InstanceForm` notifier, `testLocal()`, `testRemote()` (unchanged signatures), `AppError` sealed-class hierarchy from `lib/core/network/app_error.dart`, `endpointSessionOverrideProvider` (`EndpointSessionOverride` in `lib/core/network/instance_dio_providers.dart`, method `update(String instanceId, EndpointMode? mode)`), `resolvedEndpointProvider(String instanceId)`.
- Produces: `InstanceForm.load(String id)` now auto-tests after populating state (behavior change, same signature); `String errorCardTitle(AppError error)` (top-level function in `onboarding_providers.dart`); `InstanceForm.useRemoteForNow()` (new method, no return value). Task 12 (`add_instance_page.dart`) calls `errorCardTitle` and `useRemoteForNow`.

- [ ] **Step 1: Check for an existing test file and its fake pattern**

Run: `find test -path '*onboarding*provider*'`

If found, read it fully to match its existing `FakeInstanceRepository`/
`FakeSecureStore`-style doubles before writing new tests. If not found,
create the file using hand-written fakes implementing the real interfaces
(`InstanceRepository`, `SecureStore`) — check
`lib/core/storage/storage.dart` for their exact method signatures first.

- [ ] **Step 2: Write the failing test**

```dart
// test/features/onboarding/onboarding_providers_test.dart
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('errorCardTitle maps NetworkError to a connection-refused title', () {
    expect(
      errorCardTitle(const NetworkError()),
      'Local URL refused the connection',
    );
  });

  test('errorCardTitle maps AuthError to a credentials title', () {
    expect(
      errorCardTitle(const AuthError()),
      'Local URL rejected the credentials',
    );
  });
}
```

`useRemoteForNow()` and the `load()` auto-test change are exercised at the
widget level in Task 12, where a real provider graph with `ProviderScope`
overrides is available — that's the more valuable test for those two
behaviors, since they only matter in the context of the page that reacts to
them.

- [ ] **Step 3: Run test to verify it fails**

Run: `flutter test test/features/onboarding/onboarding_providers_test.dart`
Expected: FAIL — `errorCardTitle` doesn't exist yet.

- [ ] **Step 4: Write minimal implementation**

In `lib/features/onboarding/onboarding_providers.dart`, add this top-level
function (after the imports, before `InstanceFormState`):

```dart
/// A short, user-facing title for the error-first Edit-instance view
/// (README §2n) — e.g. "Local URL refused the connection".
String errorCardTitle(AppError error) => switch (error) {
  NetworkError() => 'Local URL refused the connection',
  AuthError() => 'Local URL rejected the credentials',
  NotFoundError() => 'Local URL has nothing at that address',
  RateLimitedError() => 'Local URL is rate-limiting requests',
  ServerError() => 'Local URL returned a server error',
  ValidationError() => 'Local URL is not valid',
  StorageError() => 'Could not read the saved instance',
  UnknownError() => 'Local URL failed to respond',
};
```

Replace the `load` method body to auto-test after populating state:

```dart
  Future<void> load(String id) async {
    final instanceResult = await ref
        .read(instanceRepositoryProvider)
        .getById(id);
    if (instanceResult is! Ok<ServiceInstance>) return;
    final instance = instanceResult.value;

    final credential = await ref.read(secureStoreProvider).readCredential(id);

    state = InstanceFormState(
      id: instance.id,
      name: instance.name,
      type: instance.serviceType,
      authType: instance.authType,
      localUrl: instance.localBaseUrl ?? '',
      remoteUrl: instance.remoteBaseUrl ?? '',
      isDefault: instance.isDefault,
      apiKey: credential is ApiKeyCredential ? credential.apiKey : '',
      username: credential is UsernamePasswordCredential
          ? credential.username
          : '',
      password: credential is UsernamePasswordCredential
          ? credential.password
          : '',
    );

    if (state.localUrl.isNotEmpty) await testLocal();
    if (state.remoteUrl.isNotEmpty) await testRemote();
  }
```

Add `useRemoteForNow` after `save()`:

```dart
  /// Session-only escape hatch for the error-first Edit-instance view
  /// (README §2n): forces this instance's effective endpoint to remote for
  /// the current app session without touching its saved [EndpointMode].
  void useRemoteForNow() {
    final id = state.id;
    if (id == null) return;
    ref
        .read(endpointSessionOverrideProvider.notifier)
        .update(id, EndpointMode.forceRemote);
    ref.invalidate(resolvedEndpointProvider(id));
  }
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/onboarding/onboarding_providers_test.dart`
Expected: PASS

- [ ] **Step 6: Run the full onboarding test suite to check for regressions, then commit**

```bash
flutter test test/features/onboarding/
dart format lib/features/onboarding/onboarding_providers.dart test/features/onboarding/onboarding_providers_test.dart
dart analyze lib/features/onboarding/onboarding_providers.dart
git add lib/features/onboarding/onboarding_providers.dart test/features/onboarding/onboarding_providers_test.dart
git commit -m "feat(onboarding): auto-test on load, add error-title mapping and Use Remote for now"
```

---

### Task 12: Error-first layout in `add_instance_page.dart`

**Files:**
- Modify: `lib/features/onboarding/add_instance_page.dart` (full rewrite)
- Test: `test/features/onboarding/add_instance_page_test.dart` (check first whether this file exists; extend or create).

**Interfaces:**
- Consumes: `SubPageHeader` (Task 1), `ErrorCard` (existing, `lib/core/widgets/error_card.dart`), `errorCardTitle`, `useRemoteForNow` (Task 11), `instanceFormProvider`.
- Produces: `AddInstancePage({String? instanceId})` — unchanged public constructor, still routed at both `/home/settings/add` and `/home/settings/:id/edit`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/onboarding/add_instance_page_test.dart
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/instance_dio_providers.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/onboarding/add_instance_page.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('shows the error card first when editing with a failed local test', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instanceFormProvider.overrideWith(() => _FakeFailingInstanceForm()),
        ],
        child: const MaterialApp(home: AddInstancePage(instanceId: 'bazarr-1')),
      ),
    );
    await tester.pump();

    expect(find.text('Local URL refused the connection'), findsOneWidget);
    expect(find.text('Use Remote for now'), findsOneWidget);
    expect(find.text('Test again'), findsOneWidget);
  });

  testWidgets('renders the plain add form with no error card when adding fresh', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: AddInstancePage())),
    );
    await tester.pump();

    expect(find.text('Local URL refused the connection'), findsNothing);
    expect(find.text('Add service'), findsOneWidget);
  });

  testWidgets('Use Remote for now sets a session override to forceRemote and pops', (
    tester,
  ) async {
    final overrideNotifier = _RecordingEndpointSessionOverride();
    final router = GoRouter(
      initialLocation: '/edit',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
        GoRoute(
          path: '/edit',
          builder: (context, state) => const AddInstancePage(instanceId: 'bazarr-1'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          instanceFormProvider.overrideWith(() => _FakeFailingInstanceForm()),
          endpointSessionOverrideProvider.overrideWith(() => overrideNotifier),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Use Remote for now'));
    await tester.pumpAndSettle();

    expect(overrideNotifier.calls, [('bazarr-1', EndpointMode.forceRemote)]);
  });
}

class _FakeFailingInstanceForm extends InstanceForm {
  @override
  InstanceFormState build() => InstanceFormState(
    id: 'bazarr-1',
    name: 'Bazarr',
    type: ServiceType.bazarr,
    localUrl: 'http://192.168.1.10:6767',
    localTestResult: const Err(
      NetworkError(cause: 'SocketException: Connection refused'),
    ),
  );
}

/// Records every session-override call instead of just applying it, so the
/// "Use Remote for now" test can assert on instanceId + mode without
/// depending on resolvedEndpointProvider's full resolution chain.
class _RecordingEndpointSessionOverride extends EndpointSessionOverride {
  final calls = <(String, EndpointMode?)>[];

  @override
  Map<String, EndpointMode?> build() => const {};

  @override
  void update(String instanceId, EndpointMode? mode) {
    calls.add((instanceId, mode));
    super.update(instanceId, mode);
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/onboarding/add_instance_page_test.dart`
Expected: FAIL — today's page never renders an `ErrorCard`.

- [ ] **Step 3: Write minimal implementation**

Replace `lib/features/onboarding/add_instance_page.dart` in full:

```dart
// lib/features/onboarding/add_instance_page.dart
/// The page to add a new service instance, or edit an existing one — README
/// §2b (add) and §2n (edit, error-first when the local URL is unreachable).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/onboarding/onboarding_providers.dart';
import 'package:arrstack/features/onboarding/widgets/instance_form.dart'
    as widgets;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AddInstancePage extends ConsumerStatefulWidget {
  const AddInstancePage({super.key, this.instanceId});

  final String? instanceId;

  @override
  ConsumerState<AddInstancePage> createState() => _AddInstancePageState();
}

class _AddInstancePageState extends ConsumerState<AddInstancePage> {
  @override
  void initState() {
    super.initState();
    if (widget.instanceId != null) {
      Future.microtask(() {
        ref.read(instanceFormProvider.notifier).load(widget.instanceId!);
      });
    } else {
      Future.microtask(() {
        ref.read(instanceFormProvider.notifier).reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(instanceFormProvider);
    final notifier = ref.read(instanceFormProvider.notifier);
    final isEditing = state.isEditing;
    final localError = state.localTestResult;
    final showErrorFirst = isEditing && localError is Err<ServiceIdentity>;

    return Scaffold(
      appBar: SubPageHeader(
        kicker: isEditing ? state.type.displayName.toUpperCase() : null,
        title: isEditing ? 'Edit instance' : 'Add service',
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(PhosphorIconsRegular.trash, size: 17),
                  onPressed: () => _confirmDelete(context, state.id!),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: AppInsets.pageMd,
        child: Column(
          children: [
            if (showErrorFirst) ...[
              ErrorCard(
                title: errorCardTitle((localError as Err<ServiceIdentity>).error),
                message: (localError.error.cause ?? localError.error.userMessage)
                    .toString(),
                primaryActionLabel: 'Test again',
                onPrimaryAction: notifier.testLocal,
                secondaryActionLabel: 'Use Remote for now',
                onSecondaryAction: () {
                  notifier.useRemoteForNow();
                  context.pop();
                },
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
            const widgets.InstanceForm(),
            const SizedBox(height: AppSpacing.space8),
            if (state.saveError != null) ...[
              Text(
                state.saveError!.userMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: AppSpacing.space4),
            ],
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: state.isValid && !state.isSaving
                    ? () async {
                        final success = await notifier.save();
                        if (success && context.mounted) {
                          context.pop();
                        }
                      }
                    : null,
                icon: state.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(isEditing ? Icons.save_outlined : Icons.add),
                label: Text(isEditing ? 'Save changes' : 'Add Instance'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String instanceId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Instance?'),
        content: const Text('Are you sure you want to remove this instance?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(instanceRepositoryProvider).delete(instanceId);
      ref.invalidate(instancesProvider);
      if (context.mounted) context.pop();
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/onboarding/add_instance_page_test.dart`
Expected: PASS

- [ ] **Step 5: Run the full onboarding test suite, then commit**

```bash
flutter test test/features/onboarding/
dart format lib/features/onboarding/add_instance_page.dart test/features/onboarding/add_instance_page_test.dart
dart analyze lib/features/onboarding/add_instance_page.dart
git add lib/features/onboarding/add_instance_page.dart test/features/onboarding/add_instance_page_test.dart
git commit -m "feat(onboarding): add error-first Edit-instance layout (README §2n)"
```

---

### Task 13: Full-branch verification pass

**Files:** none created — verification and any small fixes surfaced by it.

- [ ] **Step 1: Run the full test suite**

```bash
flutter test
```

Expected: all tests pass, including every test added in Tasks 1–12 and every
pre-existing test (Home, Library, Activity from Phases 3–5 must still pass —
`homeServiceSummariesProvider` and `resolvedEndpointProvider` are shared with
Home and must not have regressed).

- [ ] **Step 2: Run static analysis and formatting across the whole repo**

```bash
dart analyze
dart format --set-exit-if-changed .
```

Expected: zero issues. Fix any that appear (missing `const`, unused imports
from the `monitor_tile.dart` deletion, etc.) and re-run until clean.

- [ ] **Step 3: Confirm no dangling references to deleted/renamed symbols**

```bash
grep -rn "MonitorTile\|_InstanceSelector\|_AdminOverview\|_StatCard" lib/ test/
```

Expected: no matches (all were private to `uptime_page.dart`/`monitor_tile.dart`
and fully removed in Task 6).

- [ ] **Step 4: Manually cross-check each screen against the spec's screen
      sections** (`docs/superpowers/specs/2026-09-13-nocturne-redesign-phase6-subpages-design.md`)

Walk §2k–2n one more time against the four rewritten pages, confirming: no
`isDark` branching was introduced (`grep -rn "isDark" lib/features/uptime
lib/features/indexers lib/features/settings lib/features/onboarding` should
return nothing new from this phase), tabular figures on every numeric field,
and that `AppColors`/`AppSpacing`/`AppTypography` tokens are used throughout
with no hardcoded hex colors or raw pixel literals introduced by this phase
(the 1px heartbeat-bar radius and 0.75px bar margin are pre-existing-pattern
exceptions, matching the literal-value precedent already set by
`_StatusDot` in the original `monitor_tile.dart`).

- [ ] **Step 5: Commit any fixes from Steps 1–3**

```bash
git add -A
git commit -m "fix(nocturne): address analyze/format/regression findings from Phase 6 verification"
```

(Skip this commit entirely if Steps 1–3 found nothing to fix.)

## Self-Review Notes

- **Spec coverage:** §2k (Uptime) → Tasks 1–6; §2l (Indexers) → Tasks 1, 7–9;
  §2m (Settings) → Tasks 1, 10; §2n (Edit-instance) → Tasks 1, 11–12. All five
  "Decisions locked" items are implemented: dropped selector (Task 6), Retest
  reconnects (Task 6's `onRetest`), session-only override (Task 11's
  `useRemoteForNow`), shared summaries provider with the non-default-instance
  caveat (Task 10), verbatim `cause` text (Task 12). Testing section items
  map 1:1 to each task's test file.
- **Type consistency checked:** `HeartbeatStrip` constructed identically in
  Tasks 4/5/6; `downDurationLabel`/`pausedDurationLabel`/`isMonitorUp`/
  `isMonitorDown`/`isMonitorPaused` signatures from Task 3 match every call
  site in Tasks 4–6; `aggregateIndexerStats`/`isSlowResponse`/
  `IndexerTotals` from Task 8 match Task 9's usage; `errorCardTitle`/
  `useRemoteForNow` from Task 11 match Task 12's usage exactly.
- **No placeholders:** every step above contains complete, real code — no
  "implement per spec" steps remain.

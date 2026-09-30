/// Settings → Advanced → Diagnostic logs: the redacted on-device log of
/// failed requests, failed connection tests, and uncaught errors. Long-press
/// entries to pick which to share, or share everything.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:share_plus/share_plus.dart';

/// Hands log text to the system share sheet; overridden in tests.
typedef LogTextSharer = Future<void> Function(String text);

final logTextSharerProvider = Provider<LogTextSharer>(
  (ref) =>
      (text) => SharePlus.instance.share(
        ShareParams(text: text, subject: 'ArrStack Companion diagnostic logs'),
      ),
);

class DiagnosticLogsPage extends ConsumerStatefulWidget {
  const DiagnosticLogsPage({super.key});

  @override
  ConsumerState<DiagnosticLogsPage> createState() => _DiagnosticLogsPageState();
}

class _DiagnosticLogsPageState extends ConsumerState<DiagnosticLogsPage> {
  /// Selected entries, by identity: two failures of the same request in
  /// the same second are equal values but separate entries. The store
  /// hands back the same objects on every read, so identity is stable.
  final Set<LogEntry> _selected = Set.identity();

  bool get _selecting => _selected.isNotEmpty;

  void _toggle(LogEntry entry) => setState(
    () => _selected.contains(entry)
        ? _selected.remove(entry)
        : _selected.add(entry),
  );

  Future<void> _share(List<LogEntry> entries) async {
    if (entries.isEmpty) return;
    await ref.read(logTextSharerProvider)(formatLogEntriesForSharing(entries));
    if (mounted) setState(_selected.clear);
  }

  Future<void> _clear() async {
    final confirmed = await showDestructiveConfirmDialog(
      context,
      title: 'Clear diagnostic logs?',
      message: 'This deletes every stored log entry from this device.',
      confirmLabel: 'Clear',
    );
    if (confirmed == null) return;
    await ref.read(diagnosticLogStoreProvider).clear();
    if (mounted) setState(_selected.clear);
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(diagnosticLogEntriesProvider);
    final entries = entriesAsync.value ?? const <LogEntry>[];
    // Entries can disappear underneath a selection (cleared, or pushed past
    // the cap); keep only what's still listed.
    _selected.retainAll(entries);

    return Scaffold(
      appBar: SubPageHeader(
        kicker: _selecting ? null : 'Advanced',
        title: _selecting ? '${_selected.length} selected' : 'Diagnostic logs',
        actions: _selecting
            ? [
                IconButton(
                  tooltip: 'Share selected',
                  icon: const Icon(PhosphorIconsRegular.shareNetwork, size: 19),
                  onPressed: () =>
                      _share(entries.where(_selected.contains).toList()),
                ),
                IconButton(
                  tooltip: 'Cancel selection',
                  icon: const Icon(PhosphorIconsRegular.x, size: 19),
                  onPressed: () => setState(_selected.clear),
                ),
              ]
            : [
                IconButton(
                  tooltip: 'Share all',
                  icon: const Icon(PhosphorIconsRegular.shareNetwork, size: 19),
                  onPressed: entries.isEmpty ? null : () => _share(entries),
                ),
                IconButton(
                  tooltip: 'Clear logs',
                  icon: const Icon(PhosphorIconsRegular.trash, size: 19),
                  onPressed: entries.isEmpty ? null : _clear,
                ),
              ],
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not read logs: $error')),
        data: (entries) => entries.isEmpty
            ? const EmptyState(
                icon: PhosphorIconsRegular.chatCircleText,
                title: 'No log entries',
                message:
                    'Failed requests and connection tests are recorded here '
                    'so you can share them when something goes wrong.',
              )
            : ListView.builder(
                padding: AppInsets.pageMd,
                itemCount: entries.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.space4),
                      child: Text(
                        'Long-press entries to choose which to share. '
                        'Server addresses and API keys are removed before '
                        'anything is saved.',
                        style: AppTypography.meta,
                      ),
                    );
                  }
                  final entry = entries[index - 1];
                  return _LogRow(
                    entry: entry,
                    selected: _selected.contains(entry),
                    showRule: index < entries.length,
                    onTap: _selecting ? () => _toggle(entry) : null,
                    onLongPress: () => _toggle(entry),
                  );
                },
              ),
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({
    required this.entry,
    required this.selected,
    required this.showRule,
    required this.onTap,
    required this.onLongPress,
  });

  final LogEntry entry;
  final bool selected;
  final bool showRule;
  final VoidCallback? onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final levelColor = switch (entry.level) {
      LogLevel.error => AppColors.down,
      LogLevel.warn => AppColors.warning,
      LogLevel.info => AppColors.n500,
    };
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.space3,
              horizontal: AppSpacing.space2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.12)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (selected) ...[
                      Icon(
                        PhosphorIconsFill.checkCircle,
                        size: 15,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.space2),
                    ],
                    Expanded(
                      child: Text(entry.tag, style: AppTypography.cardTitle),
                    ),
                    Text(
                      entry.level.label,
                      style: AppTypography.chipLabel.copyWith(
                        color: levelColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(entry.message, style: AppTypography.body),
                const SizedBox(height: AppSpacing.space2),
                Text(formatLogTime(entry.time), style: AppTypography.meta),
              ],
            ),
          ),
        ),
        if (showRule) const FadingRule(),
      ],
    );
  }
}

/// `2026-08-17 23:30:20`, in local time.
String formatLogTime(DateTime time) {
  final t = time.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${t.year}-${two(t.month)}-${two(t.day)} '
      '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// One line per entry, oldest first so it reads as a timeline.
String formatLogEntriesForSharing(List<LogEntry> entries) {
  final sorted = [...entries]..sort((a, b) => a.time.compareTo(b.time));
  return [
    'ArrStack Companion diagnostic logs (${sorted.length} entries)',
    for (final e in sorted)
      '${formatLogTime(e.time)} ${e.level.label} ${e.tag}: ${e.message}',
  ].join('\n');
}

/// The Logs lens: a shortcut to the diagnostic log from Activity. Shows
/// how many entries are stored and the latest few, with a button to the
/// full page (share, clear), so a failure can be checked right after it
/// happens without going through Settings → Advanced.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/logging/log_entry.dart';
import 'package:arrstack/core/logging/logging_providers.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/diagnostics/diagnostic_logs_page.dart'
    show formatLogTime;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

/// How many of the newest entries the lens previews.
const int logsLensPreviewCount = 6;

class LogsLens extends ConsumerWidget {
  const LogsLens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(diagnosticLogEntriesProvider);

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => EmptyState(
        icon: PhosphorIconsRegular.warning,
        title: 'Could not read logs',
        message: '$error',
        action: FilledButton(
          onPressed: () => ref.invalidate(diagnosticLogEntriesProvider),
          child: const Text('Retry'),
        ),
      ),
      data: (entries) => entries.isEmpty
          ? const EmptyState(
              icon: PhosphorIconsRegular.chatCircleText,
              title: 'No log entries',
              message:
                  'Failed requests and connection tests are recorded here '
                  'so you can share them when something goes wrong.',
            )
          : _Preview(entries: entries),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.entries});

  final List<LogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final problems = entries.where((e) => e.level != LogLevel.info).length;
    final shown = entries.take(logsLensPreviewCount).toList();

    return ListView(
      padding: AppInsets.pageMd,
      children: [
        Text(
          'LATEST · ${shown.length} OF ${entries.length}',
          style: AppTypography.kicker,
        ),
        const SizedBox(height: AppSpacing.space2),
        Text(
          problems == 0
              ? 'No warnings or errors recorded.'
              : '$problems warning${problems == 1 ? '' : 's'} or errors '
                    'recorded.',
          style: AppTypography.meta,
        ),
        const SizedBox(height: AppSpacing.space3),
        for (final entry in shown) _Row(entry: entry),
        const SizedBox(height: AppSpacing.space4),
        OutlinedButton.icon(
          onPressed: () => context.push(RoutePaths.logs),
          icon: const Icon(PhosphorIconsRegular.arrowSquareOut, size: 16),
          label: const Text('Open diagnostic logs'),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final levelColor = switch (entry.level) {
      LogLevel.error => AppColors.down,
      LogLevel.warn => AppColors.warning,
      LogLevel.info => AppColors.n600,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: levelColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle,
                ),
                Text(
                  '${entry.tag} · ${entry.level.label} · '
                  '${formatLogTime(entry.time)}',
                  style: AppTypography.meta,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

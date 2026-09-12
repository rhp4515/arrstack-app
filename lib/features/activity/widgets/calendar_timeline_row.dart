/// One scheduled item on the Calendar lens's day-grouped list (spec screen
/// 2i): a tabular time column, a left divider, a title/meta line, and a
/// status chip. Replaces
/// `lib/features/calendar/widgets/calendar_entry_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:flutter/material.dart';

/// "airs in 11h" / "airs in 3d" / "aired 6h ago" relative to [now]. Pure —
/// unit-testable without a widget tree.
String relativeAirLabel(DateTime date, DateTime now) {
  final diff = date.difference(now);
  if (diff.isNegative) {
    final ago = -diff;
    return ago.inHours < 24
        ? 'aired ${ago.inHours}h ago'
        : 'aired ${ago.inDays}d ago';
  }
  return diff.inHours < 24
      ? 'airs in ${diff.inHours}h'
      : 'airs in ${diff.inDays}d';
}

class CalendarTimelineRow extends StatelessWidget {
  const CalendarTimelineRow({required this.entry, this.now, super.key});

  final CalendarEntry entry;

  /// Injected for deterministic tests; defaults to `DateTime.now()`.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final entryDay = DateTime(
      entry.date.year,
      entry.date.month,
      entry.date.day,
    );
    final hasAired = !entry.date.isAfter(reference);
    final timeColor = (entryDay == today && hasAired)
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final metaLine = [
      entry.subtitle,
      entry.network,
    ].where((s) => s != null && s.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space3),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Text(
                formatClockTime(entry.date),
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 11,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: timeColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 13),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (metaLine.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        metaLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 11.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.space2),
                    _StatusRow(entry: entry, now: reference),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.entry, required this.now});

  final CalendarEntry entry;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (entry.hasFile) {
      return const _Chip(label: 'Downloaded', color: AppColors.up);
    }
    if (!entry.monitored) {
      return const _Chip(label: 'Unmonitored', color: AppColors.n500);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Chip(label: 'Monitored', color: colorScheme.primary),
        const SizedBox(width: AppSpacing.space2),
        Text(
          relativeAirLabel(entry.date, now),
          style: AppTypography.meta.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

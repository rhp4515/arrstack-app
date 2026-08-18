/// A single calendar row: poster thumbnail, title, subtitle, air/release time,
/// network/studio, and a service icon indicating episode vs movie.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:arrstack/features/calendar/models/calendar_entry.dart';
import 'package:arrstack/features/calendar/widgets/calendar_date_format.dart';
import 'package:flutter/material.dart';

/// Fixed thumbnail size for a calendar row poster (2:3 aspect).
const double _posterWidth = 56;
const double _posterHeight = 84;

class CalendarEntryTile extends StatelessWidget {
  const CalendarEntryTile({required this.entry, super.key});

  final CalendarEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceMuted = theme.colorScheme.onSurfaceVariant;

    final metaParts = <String>[
      formatClockTime(entry.date),
      if (entry.network != null && entry.network!.isNotEmpty)
        'on ${entry.network}',
    ];

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResolvedPoster(
              service: entry.service,
              instanceId: entry.instanceId,
              relativeUrl: entry.posterUrl,
              width: _posterWidth,
              height: _posterHeight,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (entry.subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      entry.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: onSurfaceMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    metaParts.join('  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _KindBadge(kind: entry.kind, hasFile: entry.hasFile),
          ],
        ),
      ),
    );
  }
}

/// Green when the file already exists, muted outline otherwise — mirrors the
/// mockup's green TV glyph for aired/available episodes.
class _KindBadge extends StatelessWidget {
  const _KindBadge({required this.kind, required this.hasFile});

  final CalendarEntryKind kind;
  final bool hasFile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = hasFile ? const Color(0xFF5CDD8B) : theme.colorScheme.outline;
    final icon = kind == CalendarEntryKind.episode
        ? Icons.live_tv_outlined
        : Icons.local_movies_outlined;
    return Icon(icon, color: color, size: 24);
  }
}

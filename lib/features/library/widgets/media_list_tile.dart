/// A poster-left list row for the Library, shared by movies and series.
///
/// Layout mirrors the app mockups: a rounded poster thumbnail, a title with a
/// year and studio/network beneath it, a status pill (quality for movies,
/// "Monitored" for series) with an optional trailing count, and a chevron.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:flutter/material.dart';

/// Poster thumbnail size for a library row (2:3 aspect).
const double _posterWidth = 64;
const double _posterHeight = 96;

class MediaListTile extends StatelessWidget {
  const MediaListTile({
    required this.service,
    required this.instanceId,
    required this.title,
    this.posterUrl,
    this.year,
    this.studioOrNetwork,
    this.pill,
    this.pillTrailing,
    this.onTap,
    super.key,
  });

  final ServiceType service;
  final String instanceId;
  final String title;
  final String? posterUrl;
  final int? year;
  final String? studioOrNetwork;

  /// The status pill widget (e.g. a quality or "Monitored" chip).
  final Widget? pill;

  /// Text shown to the right of the pill, e.g. downloaded/total ("30/296").
  final String? pillTrailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Card(
      color: theme.colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResolvedPoster(
                service: service,
                instanceId: instanceId,
                relativeUrl: posterUrl,
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
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (year != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$year',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                    ],
                    if (studioOrNetwork != null &&
                        studioOrNetwork!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        studioOrNetwork!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: muted,
                        ),
                      ),
                    ],
                    if (pill != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Flexible(child: pill!),
                          if (pillTrailing != null) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              pillTrailing!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: muted,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}

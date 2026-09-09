import 'dart:developer' as developer;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    required this.imageUrl,
    super.key,
    this.title,
    this.subtitle,
    this.onTap,
    this.aspectRatio = 2 / 3,
    this.monitored = true,
    this.badge,
    this.titleBelow = false,
  });

  final String imageUrl;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double aspectRatio;
  final bool monitored;

  /// Small overlay pinned to the poster's top-left corner (e.g. an
  /// "Available" [StatusChip]) — mirrors the badge treatment on the Seerr
  /// Discover carousels.
  final Widget? badge;

  /// When true, [title]/[subtitle] render as plain text below the poster
  /// (bold title + muted year) instead of as a gradient overlay on top of
  /// the image — the treatment used by the Seerr Discover carousels.
  final bool titleBelow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = _buildCard(context, theme);

    if (!titleBelow) return card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        card,
        if (title != null) ...[
          const SizedBox(height: LegacySpacing.xs),
          Text(
            title!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  developer.log(
                    'PosterCard Image Load Error: $error | URL: $url',
                    name: 'arrstack.ui',
                  );
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    padding: AppInsets.pageMd,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        if (title != null) ...[
                          const SizedBox(height: LegacySpacing.sm),
                          Text(
                            title!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              if (!monitored)
                Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: const Center(
                      child: Icon(
                        Icons.bookmark_remove_outlined,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              if (badge != null)
                Positioned(
                  top: LegacySpacing.xs,
                  left: LegacySpacing.xs,
                  child: badge!,
                ),
              if (!titleBelow && (title != null || subtitle != null))
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(LegacySpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

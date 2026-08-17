/// A shared poster-forward card for movies/series (spec §5, §8).
///
/// Displays a high-quality poster image with a consistent corner radius,
/// aspect ratio, and loading/error fallbacks.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PosterCard extends StatelessWidget {
  const PosterCard({
    required this.imageUrl,
    this.title,
    super.key,
    this.onTap,
    this.aspectRatio = 2 / 3,
    this.monitored = true,
  });

  final String imageUrl;
  final String? title;
  final VoidCallback? onTap;
  final double aspectRatio;
  final bool monitored;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = this.title;

    return Card(
      clipBehavior: Clip.antiAlias,
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
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) {
                  // ignore: avoid_print
                  print('PosterCard Image Load Error: $error | URL: $url');
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
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              if (!monitored)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
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
            ],
          ),
        ),
      ),
    );
  }
}

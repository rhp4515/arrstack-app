/// A labeled section with a horizontal poster carousel — the shared shape
/// behind "Trending"/"Popular Movies"/"Upcoming Movies"/etc. on the Seerr
/// Discover page. Mirrors the label+row pattern used by DashboardPage.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/widgets/poster_card.dart';
import 'package:arrstack/core/widgets/status_chip.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PosterCarouselSection extends StatelessWidget {
  const PosterCarouselSection({
    required this.label,
    required this.items,
    required this.instanceId,
    super.key,
  });

  final String label;
  final List<SeerrResult> items;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppInsets.horizontalMd,
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: AppInsets.horizontalMd,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: SizedBox(
                  width: 130,
                  child: PosterCard(
                    imageUrl: item.posterUrl ?? '',
                    title: item.displayTitle ?? '',
                    subtitle: item.displayYear,
                    titleBelow: true,
                    badge: item.mediaInfo?.status == SeerrMediaStatus.available
                        ? const StatusChip(
                            label: 'Available',
                            color: Colors.green,
                          )
                        : null,
                    onTap: () => context.go(
                      RoutePaths.discoverDetail(
                        instanceId,
                        item.id,
                        item.mediaType,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

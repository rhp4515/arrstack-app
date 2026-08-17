/// A list of active downloads/tasks across the stack (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/service_accents.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:flutter/material.dart';

class ActivityStrip extends StatelessWidget {
  const ActivityStrip({required this.items, super.key});

  final List<ActivityItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'ACTIVE ACTIVITY',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final sourceColor = _getServiceColor(item.serviceType);

            return ListTile(
              leading: Icon(
                _getServiceIcon(item.serviceType),
                color: sourceColor,
                size: 20,
              ),
              title: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              subtitle: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: sourceColor,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              trailing: Text(
                FormatUtils.formatSpeed(item.speed),
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getServiceColor(ServiceType type) {
    return switch (type) {
      ServiceType.radarr => ServiceAccents.radarr,
      ServiceType.sonarr => ServiceAccents.sonarr,
      ServiceType.qbittorrent => ServiceAccents.qbittorrent,
      _ => Colors.grey,
    };
  }

  IconData _getServiceIcon(ServiceType type) {
    return switch (type) {
      ServiceType.radarr => Icons.movie_outlined,
      ServiceType.sonarr => Icons.tv_outlined,
      ServiceType.qbittorrent => Icons.download_outlined,
      _ => Icons.help_outline,
    };
  }
}

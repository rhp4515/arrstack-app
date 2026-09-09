/// A small card showing the health and headline stat of a service (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:flutter/material.dart';

class ServiceHealthTile extends StatelessWidget {
  const ServiceHealthTile({required this.health, this.onTap, super.key});

  final ServiceHealth health;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(LegacySpacing.md),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: health.statusColor, width: 4),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                health.instanceName,
                style: theme.textTheme.labelLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: LegacySpacing.xs),
              Text(
                health.headlineStat,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: health.isReachable ? null : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

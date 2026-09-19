/// A 2-column grid tile showing one configured service's icon, status dot,
/// name, and tabular summary (Phase 3 design §Widget plan). Replaces
/// `service_health_tile.dart`.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/service_accents.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

const Map<ServiceType, IconData> _serviceIcons = {
  ServiceType.radarr: PhosphorIconsRegular.filmSlate,
  ServiceType.sonarr: PhosphorIconsRegular.televisionSimple,
  ServiceType.bazarr: PhosphorIconsRegular.closedCaptioning,
  ServiceType.prowlarr: PhosphorIconsRegular.broadcast,
  ServiceType.uptimeKuma: PhosphorIconsRegular.heartbeat,
  ServiceType.seerr: PhosphorIconsRegular.compass,
  ServiceType.einthusan: PhosphorIconsRegular.popcorn,
};

const Map<ServiceType, Color> _serviceAccentColors = {
  ServiceType.radarr: ServiceAccents.radarr,
  ServiceType.sonarr: ServiceAccents.sonarr,
  ServiceType.bazarr: ServiceAccents.bazarr,
  ServiceType.prowlarr: ServiceAccents.prowlarr,
  ServiceType.uptimeKuma: ServiceAccents.uptimeKuma,
  ServiceType.seerr: ServiceAccents.seerr,
};

class ServiceTile extends StatelessWidget {
  const ServiceTile({required this.summary, required this.onTap, super.key});

  final HomeServiceSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final accent =
        _serviceAccentColors[summary.serviceType] ?? AppColors.accent;
    final icon =
        _serviceIcons[summary.serviceType] ?? PhosphorIconsRegular.squaresFour;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: summary.isReachable
              ? AppShadows.ringSm
              : const Border.fromBorderSide(BorderSide(color: AppColors.down)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: accent),
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: summary.isReachable ? AppColors.up : AppColors.down,
                    shape: BoxShape.circle,
                    boxShadow: summary.isReachable
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.down.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              summary.instanceName,
              style: AppTypography.cardTitle.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              summary.summaryLine,
              style: AppTypography.meta.copyWith(
                color: isDark ? AppColors.n500 : colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

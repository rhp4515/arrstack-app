/// The `section`-fill band: endpoint chip, gear button, hero healthy/total
/// numeral, and up to two status lines (Phase 3 design §Widget plan).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/endpoint_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomeBand extends ConsumerWidget {
  const HomeBand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(homeSummaryProvider);
    final representativeAsync = ref.watch(primaryDashboardInstanceProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space6),
      decoration: const BoxDecoration(color: AppColors.section),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(top: -50, right: -40, child: _RadialGlow()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  representativeAsync.when(
                    data: (instance) => instance == null
                        ? const SizedBox.shrink()
                        : _EndpointChip(instanceId: instance.id),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  IconButton(
                    icon: const Icon(
                      PhosphorIconsRegular.gear,
                      color: AppColors.text,
                    ),
                    onPressed: () => context.go(RoutePaths.homeSettings),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space4),
              summaryAsync.when(
                data: (summary) => _BandBody(summary: summary),
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.space8),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 170,
        height: 170,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.sectionGlow,
              blurRadius: 34,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _BandBody extends StatelessWidget {
  const _BandBody({required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('${summary.healthy}', style: AppTypography.heroNumeral),
            const SizedBox(width: AppSpacing.space2),
            Text('/ ${summary.total} healthy', style: AppTypography.body),
          ],
        ),
        const SizedBox(height: AppSpacing.space3),
        for (final line in summary.statusLines) _StatusLineRow(line: line),
      ],
    );
  }
}

class _StatusLineRow extends StatelessWidget {
  const _StatusLineRow({required this.line});

  final HomeStatusLine line;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.space2),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: line.isWarning ? AppColors.warning : AppColors.up,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.space2),
          Text(line.label, style: AppTypography.meta),
        ],
      ),
    );
  }
}

class _EndpointChip extends ConsumerWidget {
  const _EndpointChip({required this.instanceId});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolutionAsync = ref.watch(resolvedEndpointProvider(instanceId));
    final ssidAsync = ref.watch(currentSsidProvider);

    return resolutionAsync.when(
      data: (result) => switch (result) {
        Ok(:final value) => _ChipLabel(
          instanceId: instanceId,
          resolution: value,
          ssid: ssidAsync.value,
        ),
        Err() => const SizedBox.shrink(),
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({
    required this.instanceId,
    required this.resolution,
    required this.ssid,
  });

  final String instanceId;
  final EndpointResolution resolution;
  final String? ssid;

  @override
  Widget build(BuildContext context) {
    final isLocal = resolution.endpoint == ResolvedEndpoint.local;
    final base = isLocal ? 'Local' : 'Remote';
    final label = ssid == null ? base : '$base · $ssid';

    return InkWell(
      onTap: () => showEndpointSheet(context, instanceId),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space3,
          vertical: AppSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: AppColors.sectionGhost.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isLocal
                  ? PhosphorIconsRegular.hardDrives
                  : PhosphorIconsRegular.cloud,
              size: 14,
              color: AppColors.a300,
            ),
            const SizedBox(width: AppSpacing.space2),
            Text(
              label,
              style: AppTypography.meta.copyWith(color: AppColors.a300),
            ),
          ],
        ),
      ),
    );
  }
}

/// The offline layout for Home (README §3f): the flattened band, the
/// "Tailscale looks disconnected" error card, then a read-only "last
/// known" block built from the summary cache.
library;

import 'dart:async';

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/offline_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeOfflineState extends ConsumerWidget {
  const HomeOfflineState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedAsync = ref.watch(cachedServiceSummariesProvider);
    final instancesAsync = ref.watch(instancesProvider);
    final rawCached = cachedAsync.value ?? const [];
    // Only ids for instances that still exist prune orphaned cache rows
    // left behind by deleted instances (finding #1). When the current
    // instance list hasn't resolved yet or failed to load, there is no
    // filter to apply, so fall back to showing the unfiltered cache rather
    // than crashing or hiding everything.
    final currentInstanceIds = switch (instancesAsync.value) {
      Ok(:final value) => value.map((i) => i.id).toSet(),
      _ => null,
    };
    final cached = currentInstanceIds == null
        ? rawCached
        : rawCached
              .where((s) => currentInstanceIds.contains(s.instanceId))
              .toList();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const OfflineBand(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              ErrorCard(
                title: 'Tailscale looks disconnected',
                message:
                    'All remote URLs timed out. On cellular the app needs '
                    'Tailscale up to reach your stack.',
                primaryActionLabel: 'Retry all',
                onPrimaryAction: () => refreshHome(ref),
                secondaryActionLabel: 'Open Tailscale',
                onSecondaryAction: _openTailscale,
              ),
              if (cached.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.space6),
                Text(
                  'LAST KNOWN · ${_staleness(cached)} MIN AGO',
                  style: AppTypography.kicker,
                ),
                const SizedBox(height: AppSpacing.space2),
                for (final summary in cached)
                  CachedSummaryRow(summary: summary),
              ],
              const SizedBox(height: AppSpacing.space6),
              const Text(
                'Cached figures are read-only — actions stay disabled '
                'until a service answers.',
                style: AppTypography.meta,
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }

  int _staleness(List<CachedServiceSummary> cached) {
    final oldest = cached
        .map((s) => s.lastFetchedAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final minutes = DateTime.now().difference(oldest).inMinutes;
    // A clock correction or timezone shift between write and read could
    // otherwise produce a negative value (finding #6).
    return minutes.clamp(0, 1 << 31);
  }

  void _openTailscale() {
    unawaited(launchUrl(Uri.parse('tailscale://')).catchError((_) => false));
  }
}

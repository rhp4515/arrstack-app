/// The offline layout for Home (README §3f): the flattened band, an error
/// card, then a read-only "last known" block built from the summary cache.
/// The error card's copy depends on whether the reachable services' errors
/// all look like a network outage — a Tailscale-specific diagnosis is only
/// shown when every failure is a [NetworkError]; anything else (bad
/// credentials, a 5xx, a malformed request) gets neutral copy instead, so a
/// user with a wrong API key isn't sent chasing a VPN problem.
library;

import 'dart:async';

import 'package:arrstack/app/route_paths.dart';
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
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeOfflineState extends ConsumerWidget {
  const HomeOfflineState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedAsync = ref.watch(cachedServiceSummariesProvider);
    final instancesAsync = ref.watch(instancesProvider);
    final liveSummariesAsync = ref.watch(homeServiceSummariesProvider);
    final isNetworkOutage = _isNetworkOutage(
      liveSummariesAsync.value ?? const [],
    );
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
                title: isNetworkOutage
                    ? 'Tailscale looks disconnected'
                    : "Couldn't reach your services",
                message: isNetworkOutage
                    ? 'All remote URLs timed out. On cellular the app '
                          'needs Tailscale up to reach your stack.'
                    : "This doesn't look like a connectivity issue — check "
                          'each instance\'s URL and API key in Settings.',
                primaryActionLabel: 'Retry all',
                onPrimaryAction: () => refreshHome(ref),
                secondaryActionLabel: isNetworkOutage
                    ? 'Open Tailscale'
                    : 'Check settings',
                onSecondaryAction: isNetworkOutage
                    ? _openTailscale
                    : () => context.go(RoutePaths.homeSettings),
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

  /// False only when we have positive evidence of a non-network failure —
  /// at least one unreachable summary whose classified error is NOT a
  /// [NetworkError] (bad credentials, a 5xx, a malformed request). This
  /// widget only ever renders once [HomeConnectionState] has already
  /// settled to `offline`, which itself requires `homeServiceSummariesProvider`
  /// to have already resolved — so "no unreachable summaries to classify
  /// yet" isn't a real steady state, just a brief timing gap, and defaults
  /// to the historical network-outage copy rather than guessing "neutral"
  /// for a case that shouldn't persist. An unclassified failure (no error
  /// captured, e.g. a generic catch-all) doesn't count as contrary evidence
  /// either, so it doesn't downgrade the diagnosis on its own.
  bool _isNetworkOutage(List<HomeServiceSummary> liveSummaries) {
    final nonNetworkFailures = liveSummaries.where(
      (s) =>
          !s.isReachable && s.lastError != null && s.lastError is! NetworkError,
    );
    return nonNetworkFailures.isEmpty;
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

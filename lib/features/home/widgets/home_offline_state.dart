/// The offline layout for Home (README §3f): the flattened band, an error
/// card, then a read-only "last known" block built from the summary cache.
/// The error card's copy depends on what the failures actually were — a
/// Tailscale-specific diagnosis is only shown when every failure is a
/// [NetworkError]; anything else (bad credentials, a 5xx, a malformed
/// request) gets neutral copy instead, so a user with a wrong API key isn't
/// sent chasing a VPN problem. Within a network outage the card separates
/// names that never resolved from hosts that never answered.
library;

import 'dart:async';

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/utils/tailscale_launcher.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/cached_summary_row.dart';
import 'package:arrstack/features/home/widgets/offline_band.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The offline card's copy, chosen from the classified failures.
class _OfflineDiagnosis {
  const _OfflineDiagnosis({
    required this.title,
    required this.message,
    required this.blamesTailscale,
  });

  final String title;
  final String message;

  /// Whether the secondary action should offer Tailscale rather than
  /// Settings.
  final bool blamesTailscale;
}

class HomeOfflineState extends ConsumerWidget {
  const HomeOfflineState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedAsync = ref.watch(cachedServiceSummariesProvider);
    final instancesAsync = ref.watch(instancesProvider);
    final liveSummariesAsync = ref.watch(homeServiceSummariesProvider);
    final diagnosis = _diagnose(liveSummariesAsync.value ?? const []);
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
                title: diagnosis.title,
                message: diagnosis.message,
                primaryActionLabel: 'Retry all',
                onPrimaryAction: () => refreshHome(ref),
                secondaryActionLabel: diagnosis.blamesTailscale
                    ? 'Open Tailscale'
                    : 'Check settings',
                onSecondaryAction: diagnosis.blamesTailscale
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

  /// Reads the classified failures and picks copy that matches them.
  ///
  /// Only positive evidence of a non-network failure — an unreachable
  /// summary whose error is NOT a [NetworkError] (bad credentials, a 5xx, a
  /// malformed request) — moves off the connectivity diagnosis. This widget
  /// only ever renders once [HomeConnectionState] has already settled to
  /// `offline`, which itself requires `homeServiceSummariesProvider` to have
  /// resolved, so "no unreachable summaries to classify yet" isn't a real
  /// steady state, just a brief timing gap, and defaults to the
  /// network-outage copy rather than guessing "neutral" for a case that
  /// shouldn't persist. An unclassified failure (no error captured, e.g. a
  /// generic catch-all) isn't contrary evidence either, so it doesn't
  /// downgrade the diagnosis on its own.
  ///
  /// Within a network outage, a failure to resolve the host is called out
  /// separately from a timeout. They need different fixes: an unresolvable
  /// MagicDNS name means the tunnel's DNS isn't answering this device at
  /// all (Tailscale down, or the name only exists inside the tailnet),
  /// while a timeout means the name resolved and nothing replied.
  _OfflineDiagnosis _diagnose(List<HomeServiceSummary> liveSummaries) {
    final failures = liveSummaries
        .where((s) => !s.isReachable && s.lastError != null)
        .toList();

    final hasNonNetworkFailure = failures.any(
      (s) => s.lastError is! NetworkError,
    );
    if (hasNonNetworkFailure) {
      return const _OfflineDiagnosis(
        title: "Couldn't reach your services",
        message:
            "This doesn't look like a connectivity issue — check each "
            "instance's URL and API key in Settings.",
        blamesTailscale: false,
      );
    }

    final networkFailures = failures
        .map((s) => s.lastError)
        .whereType<NetworkError>()
        .toList();

    // `every` is vacuously true for an empty list, which is the brief
    // timing gap described above — that case wants the historical copy at
    // the bottom, so both branches below check for emptiness.
    if (networkFailures.isNotEmpty &&
        networkFailures.every((e) => e.isDnsFailure)) {
      return const _OfflineDiagnosis(
        title: "Can't resolve your services",
        message:
            "Your services' host names didn't resolve, so nothing was "
            'even dialled. Connect Tailscale — or, if it is already '
            "connected, use your services' 100.x addresses, which need "
            'no DNS.',
        blamesTailscale: true,
      );
    }

    // A connection that failed without timing out and without a name
    // lookup failing is a different animal: something answered at the
    // network level and refused, or the route died mid-flight. Claiming
    // "all remote URLs timed out" there is simply false, and it points at
    // the tunnel when the likelier culprit is a service that isn't
    // running. Only say "timed out" when something actually did.
    final blamesTunnel = networkFailures.any(
      (e) => e.isTimeout || e.isDnsFailure,
    );
    if (networkFailures.isNotEmpty && !blamesTunnel) {
      return const _OfflineDiagnosis(
        title: "Couldn't connect to your services",
        message:
            'The connections failed without timing out — the services may '
            'not be running. If you are away from home, check Tailscale '
            'too.',
        blamesTailscale: false,
      );
    }

    // Timeouts against addresses that only exist inside the tailnet say
    // something more specific than "Tailscale looks disconnected": the
    // packets had nowhere else to go, so the tunnel is not carrying this
    // app's traffic. It may well be carrying every other app's — Android
    // excludes apps from a VPN one at a time — and that is the case where
    // the old copy sent people to re-check a connection that was already
    // up.
    if (networkFailures.isNotEmpty &&
        networkFailures.every((e) => e.isTailnetTarget)) {
      return const _OfflineDiagnosis(
        title: "Tailscale isn't carrying this app",
        message:
            'Your tailnet addresses timed out. If Tailscale is connected '
            'and other apps reach your stack, check this app is not '
            "excluded in Tailscale's App-based split tunneling.",
        blamesTailscale: true,
      );
    }

    return const _OfflineDiagnosis(
      title: 'Tailscale looks disconnected',
      message:
          'All remote URLs timed out. On cellular the app needs Tailscale '
          'up to reach your stack.',
      blamesTailscale: true,
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

  /// Opens the Tailscale app — by package on Android, since it has no URL
  /// scheme that opens it. See [TailscaleLauncher].
  void _openTailscale() {
    unawaited(const TailscaleLauncher().open());
  }
}

/// The offline layout for Home (README §3f): the flattened band, the
/// "Tailscale looks disconnected" error card, then a read-only "last
/// known" block built from the summary cache.
library;

import 'dart:async';

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
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
    final cached = cachedAsync.value ?? const [];

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
    return DateTime.now().difference(oldest).inMinutes;
  }

  void _openTailscale() {
    unawaited(launchUrl(Uri.parse('tailscale://')).catchError((_) => false));
  }
}

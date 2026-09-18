// lib/features/home/home_page.dart
/// Home tab: Nocturne band, "Right now" card, and the service-tile grid
/// (Phase 3 design §Widget plan). Branches on
/// [effectiveHomeConnectionStateProvider] to show the empty, loading,
/// offline, or ready layout (README §3f). Each state embeds its own gear
/// button (matching HomeBand/OfflineBand/HomeBandSkeleton) rather than a
/// Scaffold AppBar, so the debug connection-state switcher can sit above
/// all four states uniformly.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/error_card.dart';
import 'package:arrstack/features/activity/activity_providers.dart';
import 'package:arrstack/features/home/home_connection_providers.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/home/widgets/connection_state_dev_chip_row.dart';
import 'package:arrstack/features/home/widgets/home_band.dart';
import 'package:arrstack/features/home/widgets/home_loading_state.dart';
import 'package:arrstack/features/home/widgets/home_offline_state.dart';
import 'package:arrstack/features/home/widgets/right_now_card.dart';
import 'package:arrstack/features/home/widgets/service_tile_grid.dart';
import 'package:arrstack/features/home/widgets/supported_services_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(effectiveHomeConnectionStateProvider);
    final showDevSwitcher = ref.watch(showDevConnectionSwitcherProvider);

    // No outer SafeArea here (finding #3): the ready/loading/offline states
    // all start with a band that must run full-bleed to the very top of the
    // screen, with no status-bar padding above it. SafeArea is instead
    // applied narrowly, only around the dev chip row and inside _EmptyHome
    // (see below), which are the only two things that ever sit directly
    // under the status bar with nothing full-bleed above them.
    return Scaffold(
      body: Column(
        children: [
          if (showDevSwitcher)
            const SafeArea(child: ConnectionStateDevChipRow()),
          Expanded(
            child: switch (connectionState) {
              HomeConnectionState.unconfigured => const _EmptyHome(),
              HomeConnectionState.loading => const HomeLoadingState(),
              HomeConnectionState.offline => const HomeOfflineState(),
              HomeConnectionState.ready => RefreshIndicator(
                onRefresh: () => refreshHome(ref),
                child: const _HomeContent(),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rightNowAsync = ref.watch(rightNowProvider);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const HomeBand(),
        Padding(
          padding: AppInsets.screenHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.space6),
              rightNowAsync.when(
                data: (summary) => summary == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.space6,
                        ),
                        child: RightNowCard(
                          summary: summary,
                          onTap: () {
                            ref
                                .read(activeActivityLensProvider.notifier)
                                .select(ActivityLens.transfers);
                            context.go(RoutePaths.activity);
                          },
                        ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const Text('SERVICES', style: AppTypography.kicker),
              const SizedBox(height: AppSpacing.space4),
              const ServiceTileGrid(),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ],
    );
  }
}

/// The `unconfigured` layout: either the real "no services yet" empty state,
/// or — when [instancesProvider] itself failed to load (a corrupted stored
/// value, for example) — an [ErrorCard] so the failure isn't silently
/// mistaken for "nothing configured yet" (finding #2). Wrapped in its own
/// [SafeArea] (finding #3): unlike the banded states, this screen's gear
/// button sits at the very top with nothing full-bleed above it.
class _EmptyHome extends ConsumerWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final error = _instancesError(instancesAsync);

    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.space2,
                right: AppSpacing.space4,
              ),
              child: IconButton(
                icon: const Icon(PhosphorIconsRegular.gear),
                onPressed: () => context.go(RoutePaths.homeSettings),
              ),
            ),
          ),
          Expanded(
            child: error != null
                ? _EmptyHomeError(error: error, ref: ref)
                : const _EmptyHomeContent(),
          ),
        ],
      ),
    );
  }

  /// Null when instances resolved successfully (even to an empty list) —
  /// that is the genuine "nothing configured yet" case. Non-null when
  /// storage itself failed, whether that surfaced as an [Err] result or as
  /// the [AsyncValue] itself being an [AsyncError].
  AppError? _instancesError(
    AsyncValue<Result<List<ServiceInstance>>> instancesAsync,
  ) {
    if (instancesAsync case AsyncError(:final error)) {
      return error is AppError ? error : UnknownError(cause: error);
    }
    return switch (instancesAsync.value) {
      Err(:final error) => error,
      _ => null,
    };
  }
}

/// Storage-failure branch of [_EmptyHome] (finding #2): tells the user
/// something went wrong instead of inviting them to re-add config that may
/// already exist, with a retry and a "start fresh" escape hatch.
class _EmptyHomeError extends StatelessWidget {
  const _EmptyHomeError({required this.error, required this.ref});

  final AppError error;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppInsets.pageLg,
        child: ErrorCard(
          title: "Couldn't load your services",
          message: error.userMessage,
          primaryActionLabel: 'Retry',
          onPrimaryAction: () => ref.invalidate(instancesProvider),
          secondaryActionLabel: 'Add a service',
          onSecondaryAction: () => context.go(RoutePaths.homeAddInstance),
        ),
      ),
    );
  }
}

/// The genuine "nothing configured yet" content (finding #5). Mirrors
/// [EmptyState]'s layout/spacing exactly, but the shared widget's
/// 56px icon and `titleMedium` title don't match this screen's §3f spec
/// (30px icon, 21px `AppTypography.sectionTitle`), so this screen builds
/// its own content rather than changing [EmptyState] for every caller.
class _EmptyHomeContent extends StatelessWidget {
  const _EmptyHomeContent();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: AppInsets.pageLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              PhosphorIconsRegular.hardDrives,
              size: 30,
              color: AppColors.n600,
            ),
            // ignore: deprecated_member_use_from_same_package
            const SizedBox(height: LegacySpacing.md),
            const Text(
              'No services yet',
              style: AppTypography.sectionTitle,
              textAlign: TextAlign.center,
            ),
            // ignore: deprecated_member_use_from_same_package
            const SizedBox(height: LegacySpacing.sm),
            Text(
              'Add Radarr or Sonarr and this screen fills with your '
              'library, your transfers and your uptime. Everything '
              'stays on your device.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            // ignore: deprecated_member_use_from_same_package
            const SizedBox(height: LegacySpacing.lg),
            const _EmptyHomeActions(),
          ],
        ),
      ),
    );
  }
}

class _EmptyHomeActions extends StatelessWidget {
  const _EmptyHomeActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
          onPressed: () => context.go(RoutePaths.homeAddInstance),
          icon: const Icon(PhosphorIconsRegular.plus),
          label: const Text('Add a service'),
        ),
        const SizedBox(height: AppSpacing.space3),
        TextButton(
          onPressed: () => showSupportedServicesSheet(context),
          child: const Text("What's supported?"),
        ),
      ],
    );
  }
}

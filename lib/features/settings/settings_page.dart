/// Settings tab: instance management, networking, and appearance
/// (README §2m).
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/app/theme/theme_mode_provider.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/storage/storage_providers.dart';
import 'package:arrstack/core/widgets/confirm_dialog.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/sub_page_header.dart';
import 'package:arrstack/features/home/home_providers.dart';
import 'package:arrstack/features/settings/settings_providers.dart';
import 'package:arrstack/features/settings/widgets/home_ssid_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instancesAsync = ref.watch(instancesProvider);
    final summariesAsync = ref.watch(homeServiceSummariesProvider);
    final summariesFailed = summariesAsync.hasError;

    return Scaffold(
      appBar: SubPageHeader(
        title: 'Settings',
        actions: [
          TextButton.icon(
            onPressed: () => context.go(RoutePaths.homeAddInstance),
            icon: const Icon(PhosphorIconsRegular.plus, size: 15),
            label: const Text('Add'),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          instancesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => _InstancesSection(
                instances: value,
                summaries: summariesAsync.asData?.value ?? const [],
                summariesFailed: summariesFailed,
              ),
              Err(:final error) => Text('Error: ${error.userMessage}'),
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
          const Text('HOME NETWORKS', style: AppTypography.kicker),
          const SizedBox(height: AppSpacing.space2),
          const Text(
            "On these networks the app uses each instance's Local URL; "
            'anywhere else it uses Remote.',
            style: AppTypography.meta,
          ),
          const SizedBox(height: AppSpacing.space4),
          const HomeSsidSetting(),
          const SizedBox(height: AppSpacing.space6),
          const FadingRule(),
          const SizedBox(height: AppSpacing.space6),
          const _DefaultEndpointModeSetting(),
          const SizedBox(height: AppSpacing.space4),
          const _ThemeSetting(),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }
}

class _InstancesSection extends StatelessWidget {
  const _InstancesSection({
    required this.instances,
    required this.summaries,
    required this.summariesFailed,
  });

  final List<ServiceInstance> instances;
  final List<HomeServiceSummary> summaries;
  final bool summariesFailed;

  @override
  Widget build(BuildContext context) {
    if (instances.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('INSTANCES · 0', style: AppTypography.kicker),
          SizedBox(height: AppSpacing.space4),
          Text(
            'No services configured yet. Tap "Add" to get started.',
            style: AppTypography.meta,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'INSTANCES · ${instances.length}',
              style: AppTypography.kicker,
            ),
            const Text('tap to edit', style: AppTypography.meta),
          ],
        ),
        const SizedBox(height: AppSpacing.space4),
        for (final instance in instances)
          _InstanceRow(
            instance: instance,
            summary: summaries
                .where((s) => s.instanceId == instance.id)
                .firstOrNull,
            summariesFailed: summariesFailed,
          ),
      ],
    );
  }
}

class _InstanceRow extends ConsumerWidget {
  const _InstanceRow({
    required this.instance,
    required this.summary,
    required this.summariesFailed,
  });

  final ServiceInstance instance;
  final HomeServiceSummary? summary;
  final bool summariesFailed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = this.summary;
    final isQbit = instance.serviceType == ServiceType.qbittorrent;

    // qBittorrent has no entry in `summaries` — homeServiceSummariesProvider
    // deliberately excludes it (it's summarized by the Home hub's
    // `rightNowProvider` instead), so its reachability comes from a direct
    // connection check rather than the shared Home summary every other row
    // uses. Without this, a qBittorrent row's dot stayed permanently
    // neutral and its version never rendered regardless of real state.
    bool? isReachable;
    String? liveVersion;
    String? errorMessage;
    AppError? failureError;
    if (isQbit) {
      final qbitStatusAsync = ref.watch(
        qbitConnectionStatusProvider(instance.id),
      );
      if (qbitStatusAsync.hasValue) {
        switch (qbitStatusAsync.requireValue) {
          case Ok(:final value):
            isReachable = true;
            liveVersion = value.version;
          case Err(:final error):
            isReachable = false;
            failureError = error;
            errorMessage = error.userMessage;
        }
      } else if (qbitStatusAsync.hasError) {
        isReachable = false;
        errorMessage = 'Status unavailable';
      }
    } else {
      isReachable = summary?.isReachable;
      failureError = summary?.lastError;
      // The summary line is the Home tile's compact "Unreachable"; the row
      // has room for the real diagnosis, which is the difference between
      // "Tailscale is down" and "that API key is wrong".
      errorMessage = failureError?.userMessage ?? summary?.summaryLine;
    }

    final dotColor = switch (isReachable) {
      true => AppColors.up,
      false => AppColors.down,
      null => AppColors.n600,
    };

    // Show the endpoint plus a version/transport descriptor (README §2m:
    // `192.168.1.10:7878 · v5.14.0`) rather than the word "Reachable" — the
    // status dot already conveys reachability. The endpoint comes from the
    // same resolver that decides which URL requests actually use: a
    // forced-remote instance, or one off its home network, can be resolved
    // to its remote URL even with a local one configured, so showing the
    // stored local URL unconditionally would show an address other than the
    // one just used for this status check.
    //
    // It is watched for failing rows too, not just healthy ones. A row that
    // says only "Unreachable" hides the one fact that explains an outage
    // off the home network: which of the two URLs was actually tried.
    final resolution = switch (ref
        .watch(resolvedEndpointProvider(instance.id))
        .asData
        ?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final endpoint =
        resolution?.baseUrl ?? instance.localBaseUrl ?? instance.remoteBaseUrl;

    // The resolver silently falls back to the other URL when the one the
    // rules picked is blank. Off the home network that means an instance
    // with no remote URL quietly gets its LAN address, which cannot answer
    // over cellular — and the resulting timeout is indistinguishable from
    // "Tailscale is down" unless the row says so.
    //
    // Only when the failure was a network one, though: a 401 from that same
    // LAN address proves the request arrived, so the missing remote URL
    // isn't what went wrong and saying so would bury the real answer.
    final missingRemoteUrl =
        resolution != null &&
        resolution.isFallback &&
        resolution.endpoint == ResolvedEndpoint.local &&
        (failureError == null || failureError is NetworkError);

    // The live version fetch is best-effort (see [instanceVersionProvider])
    // and only requested once the instance is already known reachable, so
    // it never runs a doomed extra call against an offline instance.
    // qBittorrent's version came back with `qbitConnectionStatusProvider`
    // above already — no separate fetch needed.
    if (isReachable == true && !isQbit) {
      liveVersion = ref
          .watch(instanceVersionProvider(instance.id, instance.serviceType))
          .asData
          ?.value;
    }

    final statusLine = switch (isReachable) {
      true =>
        _formatEndpoint(
              endpoint,
              _secondaryInfo(instance.serviceType, liveVersion),
            ) ??
            'Reachable',
      false => _failureLine(
        endpoint: endpoint,
        errorMessage: errorMessage,
        missingRemoteUrl: missingRemoteUrl,
      ),
      // A `null` summary (non-qBit) means either "the summaries fetch
      // itself failed" or "this instance has no matching summary in an
      // otherwise successful fetch" (a real design fallback, e.g. a
      // non-default duplicate instance). Those are different situations
      // for the user, so give the failed-fetch case its own distinct meta
      // text instead of silently falling back to blank. qBittorrent's own
      // `null` here is a brief per-row loading state, not a fetch failure.
      null => (!isQbit && summariesFailed) ? 'Status unavailable' : null,
    };

    return InkWell(
      onTap: () => context.go(RoutePaths.homeEditInstance(instance.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          instance.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.cardTitle,
                        ),
                      ),
                      if (instance.isDefault) ...[
                        const SizedBox(width: AppSpacing.space2),
                        const DetailChip(
                          label: 'Default',
                          color: AppColors.accent,
                        ),
                      ],
                    ],
                  ),
                  if (statusLine != null)
                    Text(
                      statusLine,
                      style: AppTypography.meta.copyWith(
                        color: isReachable == false
                            ? AppColors.down
                            : AppColors.n500,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(PhosphorIconsRegular.trash, size: 15),
              onPressed: () => _confirmDelete(context, ref),
            ),
            const Icon(
              PhosphorIconsRegular.caretRight,
              size: 12,
              color: AppColors.n500,
            ),
          ],
        ),
      ),
    );
  }

  /// What an unreachable row says under its name: the address that was
  /// actually tried, then why it failed. Naming the address is the point —
  /// it is what tells the user whether the app reached for the Tailscale
  /// URL or the LAN one.
  String? _failureLine({
    required String? endpoint,
    required String? errorMessage,
    required bool missingRemoteUrl,
  }) {
    final host = _formatEndpoint(endpoint, null);
    final reason = missingRemoteUrl
        ? 'No Remote URL set, so the local address was tried. Add this '
              "instance's Tailscale URL to reach it from outside home."
        : errorMessage;
    if (host == null) return reason;
    if (reason == null) return host;
    return '$host · $reason';
  }

  /// Strips scheme and path from a stored base URL for display, e.g.
  /// `http://192.168.1.10:7878/` → `192.168.1.10:7878`, optionally
  /// appended with [secondary] (a live version or transport descriptor).
  /// Returns null when [url] is absent or unparsable so the caller can
  /// fall back to a generic label rather than showing a raw malformed
  /// string.
  String? _formatEndpoint(String? url, String? secondary) {
    if (url == null || url.trim().isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) return null;
    final host = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
    return secondary == null ? host : '$host · $secondary';
  }

  /// A live version (`v5.14.0`) when [instanceVersionProvider] resolved
  /// one, else a static transport descriptor for the one service type
  /// whose client can't cheaply report a version (Uptime Kuma runs over a
  /// persistent socket session, not a plain per-request call — see
  /// [instanceVersionProvider]'s doc comment). Other types without a
  /// live version (Prowlarr, Einthusan) get no secondary text rather than
  /// a fabricated one.
  String? _secondaryInfo(ServiceType type, String? liveVersion) {
    if (liveVersion != null) {
      // qBittorrent's own version string already carries a `v` prefix
      // (e.g. `v4.6.0`) — prepending another would show `vv4.6.0`.
      return liveVersion.startsWith('v') ? liveVersion : 'v$liveVersion';
    }
    if (type == ServiceType.uptimeKuma) return 'socket';
    return null;
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final result = await showDestructiveConfirmDialog(
      context,
      title: 'Remove ${instance.name}?',
      message:
          'This removes ${instance.name} and its stored credentials '
          'from this device. The service itself keeps running elsewhere.',
    );
    if (result == null) return;
    await ref.read(instanceRepositoryProvider).delete(instance.id);
    ref.invalidate(instancesProvider);
  }
}

class _DefaultEndpointModeSetting extends ConsumerWidget {
  const _DefaultEndpointModeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(defaultEndpointModeSettingsProvider);

    return modeAsync.when(
      data: (mode) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Default endpoint', style: AppTypography.cardTitle),
              Text('For newly added instances', style: AppTypography.meta),
            ],
          ),
          DropdownButton<EndpointMode>(
            value: mode,
            underline: const SizedBox.shrink(),
            items: EndpointMode.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                .toList(),
            onChanged: (newMode) => newMode != null
                ? ref
                      .read(defaultEndpointModeSettingsProvider.notifier)
                      .updateMode(newMode)
                : null,
          ),
        ],
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}

class _ThemeSetting extends ConsumerWidget {
  const _ThemeSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Theme', style: AppTypography.cardTitle),
        DropdownButton<ThemeMode>(
          value: themeMode,
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
          onChanged: (mode) => mode != null
              ? ref.read(appThemeModeProvider.notifier).update(mode)
              : null,
        ),
      ],
    );
  }
}

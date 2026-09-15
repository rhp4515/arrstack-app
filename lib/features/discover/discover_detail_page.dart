/// Discover detail / request (README §3b): the 2g header anatomy, a
/// request panel (quality profile, root folder with free space), and a
/// best-effort AVAILABILITY block.
///
/// No "search immediately" toggle here: Overseerr/Jellyseerr's
/// `POST /api/v1/request` has no field for it — whether Radarr/Sonarr
/// searches on approval is controlled by their own settings, not something
/// a per-request API call can influence. An earlier draft rendered such a
/// toggle anyway; it updated local state but never reached the request body
/// or `SeerrClient.request()`, which has no matching parameter. Removed
/// rather than shown disabled, to avoid implying a control that doesn't
/// exist. Contrast `add_movie_options.dart`/`add_series_options.dart`'s
/// "search now" toggle, which drives a real Radarr/Sonarr add-options field
/// and is unrelated to this one.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/utils/format_utils.dart';
import 'package:arrstack/core/widgets/detail_chip.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/core/widgets/fading_rule.dart';
import 'package:arrstack/core/widgets/labeled_dropdown_field.dart';
import 'package:arrstack/features/discover/availability_lines.dart';
import 'package:arrstack/features/discover/discover_providers.dart';
import 'package:arrstack/features/library/widgets/media_detail_header.dart';
import 'package:arrstack/services/seerr/models/seerr_models.dart';
import 'package:arrstack/services/seerr/seerr_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hardcoded to Seerr's server id 0 (its typical first-configured server).
/// Does not look up the actual first server — Overseerr/Jellyseerr assigns
/// server ids incrementally and does not renumber on delete, so a user who
/// removed and re-added their Radarr/Sonarr server in Seerr could have an
/// actual first server at id 1 or higher, which this literal would not
/// match. A proper server picker for multi-server Seerr setups is out of
/// scope for this phase (Phase 7 design spec, Out of scope).
const _defaultServiceId = 0;

class DiscoverDetailPage extends ConsumerWidget {
  const DiscoverDetailPage({
    required this.instanceId,
    required this.id,
    required this.mediaType,
    super.key,
  });

  final String instanceId;
  final int id;
  final String mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveIdAsync = instanceId.isNotEmpty
        ? AsyncData(instanceId)
        : ref.watch(selectedSeerrInstanceIdProvider);

    return effectiveIdAsync.when(
      data: (finalId) {
        if (finalId == null) {
          return const Scaffold(
            body: Center(child: Text('No instance selected')),
          );
        }

        final detailAsync = ref.watch(
          seerrDetailProvider(
            instanceId: finalId,
            id: id,
            mediaType: mediaType,
          ),
        );

        return detailAsync.when(
          data: (result) => switch (result) {
            Ok(:final value) => _DetailContent(
              instanceId: finalId,
              item: value,
            ),
            Err(:final error) => Scaffold(
              appBar: AppBar(),
              body: EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load details',
                message: error.userMessage,
              ),
            ),
          },
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Error: $err')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _DetailContent extends ConsumerStatefulWidget {
  const _DetailContent({required this.instanceId, required this.item});

  final String instanceId;
  final SeerrResult item;

  @override
  ConsumerState<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends ConsumerState<_DetailContent> {
  int? _selectedProfileId;
  String? _selectedRootFolder;
  bool _requesting = false;
  String? _requestError;

  bool get _isTv => widget.item.mediaType == 'tv';

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final serviceAsync = _isTv
        ? ref.watch(
            seerrSonarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          )
        : ref.watch(
            seerrRadarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          );
    final serviceDetails = switch (serviceAsync.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final lines = availabilityLines(item.mediaInfo);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowSquareOut, size: 17),
            tooltip: 'Open in TMDB',
            onPressed: () => _openTmdb(item),
          ),
        ],
      ),
      body: ListView(
        padding: AppInsets.pageMd,
        children: [
          MediaDetailHeader(
            poster: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: 104,
                height: 156,
                child: item.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.posterUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const _PosterFallback(),
                        errorWidget: (_, _, _) => const _PosterFallback(),
                      )
                    : const _PosterFallback(),
              ),
            ),
            title: item.displayTitle ?? '',
            metaParts: [if (item.displayYear != null) item.displayYear!],
            chips: [
              if ((item.voteAverage ?? 0) > 0)
                DetailChip(
                  label: '★ ${item.voteAverage!.toStringAsFixed(1)}',
                  color: AppColors.accent,
                ),
              DetailChip(
                label: _libraryChipLabel(item.mediaInfo),
                color: _isInLibrary(item.mediaInfo)
                    ? AppColors.accent
                    : AppColors.n500,
              ),
            ],
            stats: const [],
          ),
          const SizedBox(height: AppSpacing.space6),
          Text(
            item.overview ?? 'No overview available.',
            style: AppTypography.body,
          ),
          if (_canRequest(item.mediaInfo)) ...[
            const SizedBox(height: AppSpacing.space6),
            const FadingRule(),
            const SizedBox(height: AppSpacing.space4),
            Text(
              'REQUEST TO ${_isTv ? 'SONARR' : 'RADARR'}',
              style: AppTypography.kicker,
            ),
            const SizedBox(height: AppSpacing.space4),
            serviceAsync.when(
              data: (result) => switch (result) {
                Ok(:final value) => _RequestFields(
                  details: value,
                  selectedProfileId: _selectedProfileId,
                  selectedRootFolder: _selectedRootFolder,
                  onProfileChanged: (v) =>
                      setState(() => _selectedProfileId = v),
                  onRootFolderChanged: (v) =>
                      setState(() => _selectedRootFolder = v),
                ),
                Err(:final error) => Text(
                  'Error loading profiles: ${error.userMessage}',
                  style: AppTypography.meta.copyWith(color: AppColors.down),
                ),
              },
              loading: () => const LinearProgressIndicator(),
              error: (err, _) => Text(
                'Error loading profiles: $err',
                style: AppTypography.meta.copyWith(color: AppColors.down),
              ),
            ),
            if (lines.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.space4),
              const FadingRule(),
              const SizedBox(height: AppSpacing.space4),
              const Text('AVAILABILITY', style: AppTypography.kicker),
              const SizedBox(height: AppSpacing.space3),
              for (final (label, value) in lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(label, style: AppTypography.meta),
                      Text(value, style: AppTypography.meta),
                    ],
                  ),
                ),
            ],
            const SizedBox(height: AppSpacing.space6),
            if (_requestError != null) ...[
              Text(
                _requestError!,
                style: AppTypography.meta.copyWith(color: AppColors.down),
              ),
              const SizedBox(height: AppSpacing.space2),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: (_requesting || serviceDetails == null)
                    ? null
                    : _handleRequest,
                icon: _requesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(PhosphorIconsRegular.plus, size: 15),
                label: const Text('Request'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isInLibrary(SeerrMediaInfo? info) =>
      info?.status == SeerrMediaStatus.available ||
      info?.status == SeerrMediaStatus.partiallyAvailable;

  bool _isRequested(SeerrMediaInfo? info) =>
      info?.status == SeerrMediaStatus.pending ||
      info?.status == SeerrMediaStatus.processing;

  String _libraryChipLabel(SeerrMediaInfo? info) {
    if (_isInLibrary(info)) return 'In library';
    if (_isRequested(info)) return 'Requested';
    return 'Not in library';
  }

  /// Matches today's exact gate — only a fully `available` item has
  /// nothing left to request; `partiallyAvailable` TV can still request
  /// more seasons.
  bool _canRequest(SeerrMediaInfo? info) =>
      info == null || info.status != SeerrMediaStatus.available;

  Future<void> _openTmdb(SeerrResult item) async {
    final path = item.mediaType == 'tv' ? 'tv' : 'movie';
    final uri = Uri.parse('https://www.themoviedb.org/$path/${item.id}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _handleRequest() async {
    final serviceAsync = _isTv
        ? ref.read(
            seerrSonarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          )
        : ref.read(
            seerrRadarrServiceProvider(
              instanceId: widget.instanceId,
              serviceId: _defaultServiceId,
            ),
          );
    final details = switch (serviceAsync.asData?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    if (details == null) return;

    final profileId =
        _selectedProfileId ??
        (details.profiles.isNotEmpty ? details.profiles.first.id : null);
    final rootFolder =
        _selectedRootFolder ??
        (details.rootFolders.isNotEmpty
            ? details.rootFolders.first.path
            : null);

    setState(() {
      _requesting = true;
      _requestError = null;
    });

    final repository = await ref.read(
      seerrRepositoryProvider(widget.instanceId).future,
    );
    final result = await repository.request(
      widget.item.id,
      widget.item.mediaType,
      serverId: _defaultServiceId,
      profileId: profileId,
      rootFolder: rootFolder,
    );

    if (!mounted) return;
    switch (result) {
      case Ok():
        setState(() => _requesting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request submitted successfully!')),
        );
        ref.invalidate(
          seerrDetailProvider(
            instanceId: widget.instanceId,
            id: widget.item.id,
            mediaType: widget.item.mediaType,
          ),
        );
      case Err(:final error):
        setState(() {
          _requesting = false;
          _requestError = 'Request failed: ${error.userMessage}';
        });
    }
  }
}

/// Static (non-animating) poster placeholder/error fallback — mirrors
/// `ResolvedPoster`'s `_PosterFallback`. Deliberately avoids an
/// indeterminate `CircularProgressIndicator`: that keeps scheduling frames
/// forever while a `CachedNetworkImage` never resolves in the test
/// environment (no real network), which would make `pumpAndSettle` hang.
class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.n800,
      child: const Icon(Icons.movie_outlined, color: AppColors.n500, size: 28),
    );
  }
}

class _RequestFields extends StatelessWidget {
  const _RequestFields({
    required this.details,
    required this.selectedProfileId,
    required this.selectedRootFolder,
    required this.onProfileChanged,
    required this.onRootFolderChanged,
  });

  final SeerrServiceDetails details;
  final int? selectedProfileId;
  final String? selectedRootFolder;
  final ValueChanged<int?> onProfileChanged;
  final ValueChanged<String?> onRootFolderChanged;

  @override
  Widget build(BuildContext context) {
    final profileValue =
        selectedProfileId ??
        (details.profiles.isNotEmpty ? details.profiles.first.id : null);
    final folder = details.rootFolders.isEmpty
        ? null
        : details.rootFolders.firstWhere(
            (f) => f.path == selectedRootFolder,
            orElse: () => details.rootFolders.first,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledDropdownField<int>(
          label: 'Quality profile',
          value: profileValue,
          items: [
            for (final profile in details.profiles)
              DropdownMenuItem(value: profile.id, child: Text(profile.name)),
          ],
          onChanged: onProfileChanged,
        ),
        const SizedBox(height: AppSpacing.space4),
        LabeledDropdownField<String>(
          label: 'Root folder',
          value: folder?.path,
          items: [
            for (final rootFolder in details.rootFolders)
              DropdownMenuItem(
                value: rootFolder.path,
                child: Text(rootFolder.path),
              ),
          ],
          onChanged: onRootFolderChanged,
          caption: folder == null ? null : _freeSpaceCaption(folder),
        ),
      ],
    );
  }

  String? _freeSpaceCaption(SeerrServiceRootFolder folder) {
    final free = folder.freeSpace;
    final total = folder.totalSpace;
    if (free == null || total == null) return null;
    return '${FormatUtils.formatBytes(free)} free of ${FormatUtils.formatBytes(total)}';
  }
}

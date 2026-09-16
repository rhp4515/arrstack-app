/// Bottom sheet to select options when adding a movie (spec §7): a grab
/// handle, a poster-beside-title header with a "{year} · adding to Radarr"
/// subtitle, the quality-profile/root-folder dropdowns, the search-now
/// toggle (a real Radarr `addOptions.searchForMovie` field — unrelated to
/// the Seerr *request* panel's removed toggle on `discover_detail_page.dart`,
/// which had no working API field behind it), and a full-width
/// accent-outlined primary button.
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/service_type.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/core/widgets/labeled_dropdown_field.dart';
import 'package:arrstack/core/widgets/labeled_toggle_row.dart';
import 'package:arrstack/core/widgets/resolved_poster.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AddMovieOptionsSheet extends ConsumerStatefulWidget {
  const AddMovieOptionsSheet({
    required this.instanceId,
    required this.movie,
    super.key,
  });

  final String instanceId;
  final RadarrMovie movie;

  @override
  ConsumerState<AddMovieOptionsSheet> createState() =>
      _AddMovieOptionsSheetState();
}

class _AddMovieOptionsSheetState extends ConsumerState<AddMovieOptionsSheet> {
  int? _selectedProfileId;
  String? _selectedPath;
  bool _searchNow = true;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(
      radarrQualityProfilesProvider(widget.instanceId),
    );
    final foldersAsync = ref.watch(
      radarrRootFoldersProvider(widget.instanceId),
    );

    return Container(
      padding: AppInsets.pageMd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: _GrabHandle()),
          const SizedBox(height: AppSpacing.space4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResolvedPoster(
                service: ServiceType.radarr,
                instanceId: widget.instanceId,
                relativeUrl: widget.movie.posterUrl,
                width: 44,
                height: 66,
              ),
              const SizedBox(width: AppSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add "${widget.movie.title}"',
                      style: AppTypography.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      '${widget.movie.year ?? '—'} · adding to Radarr',
                      style: AppTypography.meta.copyWith(color: AppColors.n500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space6),
          profilesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => LabeledDropdownField<int>(
                label: 'Quality Profile',
                value:
                    _selectedProfileId ??
                    (value.isNotEmpty ? value.first.id : null),
                items: value
                    .map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name ?? 'Unknown'),
                      ),
                    )
                    .toList(),
                onChanged: (id) => setState(() => _selectedProfileId = id),
              ),
              Err(:final error) => Text(
                'Error loading profiles: ${error.userMessage}',
              ),
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.space4),
          foldersAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => LabeledDropdownField<String>(
                label: 'Root Folder',
                value:
                    _selectedPath ??
                    (value.isNotEmpty ? value.first.path : null),
                items: value
                    .map(
                      (f) => DropdownMenuItem(
                        value: f.path,
                        child: Text(f.path ?? 'Unknown'),
                      ),
                    )
                    .toList(),
                onChanged: (p) => setState(() => _selectedPath = p),
              ),
              Err(:final error) => Text(
                'Error loading folders: ${error.userMessage}',
              ),
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.space4),
          LabeledToggleRow(
            title: 'Search for it now',
            subtitle: 'Uses your enabled indexers',
            value: _searchNow,
            onChanged: (val) => setState(() => _searchNow = val),
          ),
          const SizedBox(height: AppSpacing.space8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isSaving ? null : _save,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    )
                  : const Icon(PhosphorIconsRegular.plus, size: 15),
              label: const Text('Add to library'),
            ),
          ),
          const SizedBox(height: AppSpacing.space6),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final repository = await ref.read(
      radarrRepositoryProvider(widget.instanceId).future,
    );

    // Get defaults if not selected yet
    final profilesResult = ref
        .read(radarrQualityProfilesProvider(widget.instanceId))
        .value;
    final foldersResult = ref
        .read(radarrRootFoldersProvider(widget.instanceId))
        .value;

    final profileId =
        _selectedProfileId ??
        (profilesResult is Ok<List<RadarrQualityProfile>> &&
                profilesResult.value.isNotEmpty
            ? profilesResult.value.first.id
            : null);
    final rootPath =
        _selectedPath ??
        (foldersResult is Ok<List<RadarrRootFolder>> &&
                foldersResult.value.isNotEmpty
            ? foldersResult.value.first.path
            : null);

    if (profileId == null || rootPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a profile and root folder.'),
          ),
        );
      }
      return;
    }

    setState(() => _isSaving = true);

    final movieToAdd = widget.movie.copyWith(
      monitored: true,
      qualityProfileId: profileId,
      rootFolderPath: rootPath,
      addOptions: RadarrAddOptions(
        searchForMovie: _searchNow,
        monitor: 'movieOnly',
      ),
    );

    final result = await repository.addMovie(movieToAdd);

    if (mounted) {
      setState(() => _isSaving = false);
      switch (result) {
        case Ok():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added "${widget.movie.title}"')),
          );
          ref.invalidate(radarrMoviesProvider(widget.instanceId));
          Navigator.pop(context, true);
        case Err(:final error):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${error.userMessage}')),
          );
      }
    }
  }
}

/// The sheet's drag affordance — a short rounded bar centered above the
/// header, matching the divider-on-surface convention used for outlines
/// elsewhere in this design system.
class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}

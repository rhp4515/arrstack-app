/// Bottom sheet to select options when adding a movie (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:arrstack/services/radarr/radarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMovieOptionsSheet extends ConsumerStatefulWidget {
  const AddMovieOptionsSheet({
    required this.instanceId,
    required this.movie,
    super.key,
  });

  final String instanceId;
  final RadarrMovie movie;

  @override
  ConsumerState<AddMovieOptionsSheet> createState() => _AddMovieOptionsSheetState();
}

class _AddMovieOptionsSheetState extends ConsumerState<AddMovieOptionsSheet> {
  int? _selectedProfileId;
  String? _selectedPath;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(radarrQualityProfilesProvider(widget.instanceId));
    final foldersAsync = ref.watch(radarrRootFoldersProvider(widget.instanceId));

    return Container(
      padding: AppInsets.pageMd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add "${widget.movie.title}"',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          profilesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Quality Profile'),
                  initialValue: _selectedProfileId ?? (value.isNotEmpty ? value.first.id : null),
                  items: value.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name ?? 'Unknown'))).toList(),
                  onChanged: (id) => setState(() => _selectedProfileId = id),
                ),
              Err(:final error) => Text('Error loading profiles: ${error.userMessage}'),
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.md),
          foldersAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Root Folder'),
                  initialValue: _selectedPath ?? (value.isNotEmpty ? value.first.path : null),
                  items: value.map((f) => DropdownMenuItem(value: f.path, child: Text(f.path ?? 'Unknown'))).toList(),
                  onChanged: (p) => setState(() => _selectedPath = p),
                ),
              Err(:final error) => Text('Error loading folders: ${error.userMessage}'),
            },
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.add),
            label: const Text('Add to Library'),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final repository = await ref.read(radarrRepositoryProvider(widget.instanceId).future);
    
    // Get defaults if not selected yet
    final profilesResult = ref.read(radarrQualityProfilesProvider(widget.instanceId)).value;
    final foldersResult = ref.read(radarrRootFoldersProvider(widget.instanceId)).value;
    
    final profileId = _selectedProfileId ?? (profilesResult is Ok<List<RadarrQualityProfile>> && profilesResult.value.isNotEmpty ? profilesResult.value.first.id : null);
    final rootPath = _selectedPath ?? (foldersResult is Ok<List<RadarrRootFolder>> && foldersResult.value.isNotEmpty ? foldersResult.value.first.path : null);

    if (profileId == null || rootPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a profile and root folder.')));
      }
      return;
    }

    setState(() => _isSaving = true);
    
    final movieToAdd = widget.movie.copyWith(
      monitored: true,
      qualityProfileId: profileId,
      rootFolderPath: rootPath,
    );

    final result = await repository.addMovie(movieToAdd);
    
    if (mounted) {
      setState(() => _isSaving = false);
      switch (result) {
        case Ok():
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added "${widget.movie.title}"')));
          ref.invalidate(radarrMoviesProvider(widget.instanceId));
          Navigator.pop(context, true);
        case Err(:final error):
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${error.userMessage}')));
      }
    }
  }
}

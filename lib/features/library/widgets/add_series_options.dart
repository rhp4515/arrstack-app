/// Bottom sheet to select options when adding a series (spec §7).
library;

import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/sonarr/models/sonarr_models.dart';
import 'package:arrstack/services/sonarr/sonarr_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSeriesOptionsSheet extends ConsumerStatefulWidget {
  const AddSeriesOptionsSheet({
    required this.instanceId,
    required this.series,
    super.key,
  });

  final String instanceId;
  final SonarrSeries series;

  @override
  ConsumerState<AddSeriesOptionsSheet> createState() => _AddSeriesOptionsSheetState();
}

class _AddSeriesOptionsSheetState extends ConsumerState<AddSeriesOptionsSheet> {
  int? _selectedProfileId;
  String? _selectedPath;
  String _selectedMonitorMode = 'all';
  bool _isSaving = false;

  final _monitorModes = const [
    DropdownMenuItem(value: 'all', child: Text('All Episodes')),
    DropdownMenuItem(value: 'future', child: Text('Future Episodes')),
    DropdownMenuItem(value: 'missing', child: Text('Missing Episodes')),
    DropdownMenuItem(value: 'existing', child: Text('Existing Episodes')),
    DropdownMenuItem(value: 'firstSeason', child: Text('First Season')),
    DropdownMenuItem(value: 'latestSeason', child: Text('Latest Season')),
    DropdownMenuItem(value: 'none', child: Text('None')),
  ];

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(sonarrQualityProfilesProvider(widget.instanceId));
    final foldersAsync = ref.watch(sonarrRootFoldersProvider(widget.instanceId));

    return Container(
      padding: AppInsets.pageMd,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add "${widget.series.title}"',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Monitor Mode'),
            initialValue: _selectedMonitorMode,
            items: _monitorModes,
            onChanged: (val) => setState(() => _selectedMonitorMode = val!),
          ),
          const SizedBox(height: AppSpacing.md),
          profilesAsync.when(
            data: (result) => switch (result) {
              Ok(:final value) => DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Quality Profile'),
                  initialValue: _selectedProfileId ?? (value.isNotEmpty ? value.first.id : null),
                  items: value.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
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
                  items: value.map((f) => DropdownMenuItem(value: f.path, child: Text(f.path))).toList(),
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
    final repository = await ref.read(sonarrRepositoryProvider(widget.instanceId).future);
    
    final profilesResult = ref.read(sonarrQualityProfilesProvider(widget.instanceId)).value;
    final foldersResult = ref.read(sonarrRootFoldersProvider(widget.instanceId)).value;
    
    final profileId = _selectedProfileId ?? (profilesResult is Ok<List<SonarrQualityProfile>> && profilesResult.value.isNotEmpty ? profilesResult.value.first.id : null);
    final rootPath = _selectedPath ?? (foldersResult is Ok<List<SonarrRootFolder>> && foldersResult.value.isNotEmpty ? foldersResult.value.first.path : null);

    if (profileId == null || rootPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a profile and root folder.')));
      }
      return;
    }

    setState(() => _isSaving = true);
    
    final seriesToAdd = widget.series.copyWith(
      monitored: true,
      qualityProfileId: profileId,
      rootFolderPath: rootPath,
      addOptions: SonarrAddOptions(
        monitor: _selectedMonitorMode,
        searchForMissingEpisodes: true,
      ),
    );

    final result = await repository.addSeries(seriesToAdd);
    
    if (mounted) {
      setState(() => _isSaving = false);
      switch (result) {
        case Ok():
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added "${widget.series.title}"')));
          ref.invalidate(sonarrSeriesProvider(widget.instanceId));
          Navigator.pop(context, true);
        case Err(:final error):
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: ${error.userMessage}')));
      }
    }
  }
}

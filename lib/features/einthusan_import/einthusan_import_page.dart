/// Einthusan Import: paste a movie URL, confirm its TMDB match, watch
/// download+import progress, then jump into the Radarr library entry.
/// See docs/superpowers/specs/2026-09-08-einthusan-import-design.md.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_providers.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class EinthusanImportPage extends ConsumerWidget {
  const EinthusanImportPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(einthusanImportControllerProvider(instanceId));
    final controller = ref.read(
      einthusanImportControllerProvider(instanceId).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Einthusan Import')),
      body: SafeArea(child: _buildStep(instanceId, state, controller)),
    );
  }

  Widget _buildStep(
    String instanceId,
    EinthusanImportState state,
    EinthusanImportController controller,
  ) {
    final job = state.job;

    if (job == null) {
      if (state.lastError != null) {
        return _ErrorStep(
          message: state.lastError!.userMessage,
          onRetry: controller.reset,
        );
      }
      return _InputStep(
        isSubmitting: state.isSubmitting,
        onSubmit: controller.submitUrl,
      );
    }

    return switch (job.state) {
      JobState.resolving => const _ResolvingStep(),
      JobState.awaitingVerification => _PreviewStep(
        job: job,
        selectedTmdbId: state.selectedTmdbId ?? job.selectedTmdbId,
        isSubmitting: state.isSubmitting,
        onSelect: controller.selectCandidate,
        onConfirm: controller.confirmDownload,
        onCancel: controller.cancel,
      ),
      JobState.downloading || JobState.importing => _RunningStep(job: job),
      JobState.done => _DoneStep(job: job, onReset: controller.reset),
      JobState.error || JobState.resolveFailed => _ErrorStep(
        message: job.error?.message ?? 'Something went wrong.',
        onRetry: controller.reset,
      ),
    };
  }
}

class _InputStep extends StatefulWidget {
  const _InputStep({required this.isSubmitting, required this.onSubmit});

  final bool isSubmitting;
  final ValueChanged<String> onSubmit;

  @override
  State<_InputStep> createState() => _InputStepState();
}

class _InputStepState extends State<_InputStep> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.pageLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.movie_creation_outlined,
            size: AppSizes.emptyStateIcon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Import from Einthusan',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Paste an Einthusan movie page URL to look up a TMDB match and '
            'download it into Radarr.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _controller,
            enabled: !widget.isSubmitting,
            keyboardType: TextInputType.url,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Einthusan movie URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: widget.isSubmitting || _controller.text.trim().isEmpty
                ? null
                : () => widget.onSubmit(_controller.text.trim()),
            child: widget.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Fetch details'),
          ),
        ],
      ),
    );
  }
}

class _ResolvingStep extends StatelessWidget {
  const _ResolvingStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppInsets.pageLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Fetching page and searching TMDB…',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.job,
    required this.selectedTmdbId,
    required this.isSubmitting,
    required this.onSelect,
    required this.onConfirm,
    required this.onCancel,
  });

  final EinthusanJob job;
  final int? selectedTmdbId;
  final bool isSubmitting;
  final ValueChanged<int> onSelect;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    if (job.candidates.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No TMDB matches found',
        message: 'Einthusan could not resolve a TMDB match for this title.',
        action: OutlinedButton(
          onPressed: onCancel,
          child: const Text('Start over'),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: RadioGroup<int>(
            groupValue: selectedTmdbId,
            onChanged: (value) {
              if (value != null) onSelect(value);
            },
            child: ListView.builder(
              padding: AppInsets.pageMd,
              itemCount: job.candidates.length,
              itemBuilder: (context, index) {
                final candidate = job.candidates[index];
                return _CandidateTile(
                  candidate: candidate,
                  selectedTmdbId: selectedTmdbId,
                  onTap: () => onSelect(candidate.tmdbId),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: AppInsets.pageMd,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: isSubmitting || selectedTmdbId == null
                      ? null
                      : onConfirm,
                  child: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm and download'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CandidateTile extends StatelessWidget {
  const _CandidateTile({
    required this.candidate,
    required this.selectedTmdbId,
    required this.onTap,
  });

  final TmdbCandidate candidate;
  final int? selectedTmdbId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = candidate.tmdbId == selectedTmdbId;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: candidate.posterUrl != null
              ? Image.network(
                  candidate.posterUrl!,
                  width: 48,
                  height: 72,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 48,
                  height: 72,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.movie_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
        title: Text(candidate.title),
        subtitle: Text('${candidate.year}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'View on TMDB',
              onPressed: () => _openTmdb(candidate.tmdbUrl),
            ),
            Radio<int>(value: candidate.tmdbId),
          ],
        ),
      ),
    );
  }

  Future<void> _openTmdb(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _RunningStep extends StatelessWidget {
  const _RunningStep({required this.job});

  final EinthusanJob job;

  @override
  Widget build(BuildContext context) {
    final progress = job.progress;
    final label = job.state == JobState.importing
        ? 'Importing into Radarr…'
        : 'Downloading…';

    return Padding(
      padding: AppInsets.pageLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          if (progress != null && progress.totalBytes > 0) ...[
            LinearProgressIndicator(value: progress.percent / 100),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${_formatBytes(progress.downloadedBytes)} / '
              '${_formatBytes(progress.totalBytes)} • '
              '${_formatBytes(progress.speedBps.round())}/s',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ] else
            const CircularProgressIndicator(),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    var value = bytes.toDouble();
    var unitIndex = 0;
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    return '${value.toStringAsFixed(value < 10 ? 1 : 0)} ${units[unitIndex]}';
  }
}

class _DoneStep extends ConsumerWidget {
  const _DoneStep({required this.job, required this.onReset});

  final EinthusanJob job;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = job.result;
    final radarrInstanceIdAsync = ref.watch(
      selectedLibraryInstanceIdProvider(ServiceType.radarr),
    );

    return Padding(
      padding: AppInsets.pageLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: AppSizes.emptyStateIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Imported successfully',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (result != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              result.file,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (result != null)
            radarrInstanceIdAsync.when(
              data: (radarrInstanceId) => radarrInstanceId == null
                  ? const SizedBox.shrink()
                  : FilledButton.icon(
                      onPressed: () => context.go(
                        RoutePaths.movieDetail(
                          radarrInstanceId,
                          result.radarrMovieId,
                        ),
                      ),
                      icon: const Icon(Icons.movie_outlined),
                      label: const Text('View in Radarr library'),
                    ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: onReset,
            child: const Text('Import another movie'),
          ),
        ],
      ),
    );
  }
}

class _ErrorStep extends StatelessWidget {
  const _ErrorStep({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Import failed',
      message: message,
      action: FilledButton(onPressed: onRetry, child: const Text('Start over')),
    );
  }
}

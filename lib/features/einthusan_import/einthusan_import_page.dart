/// Einthusan Import: paste a movie URL, confirm its TMDB match, watch
/// download+import progress, then jump into the Radarr library entry. Jobs
/// are listed under the input ("Recent imports") so their outcome can be
/// found again after leaving the page or restarting the app.
/// See docs/superpowers/specs/2026-09-08-einthusan-import-design.md.
library;

import 'package:arrstack/app/route_paths.dart';
import 'package:arrstack/app/theme/design_tokens.dart';
import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/widgets/empty_state.dart';
import 'package:arrstack/features/activity/widgets/section_header.dart';
import 'package:arrstack/features/einthusan_import/einthusan_import_providers.dart';
import 'package:arrstack/features/library/library_providers.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shown for a job the downloader no longer lists although it was still in
/// progress: it keeps jobs in memory only, so a restart loses them.
const _lostMessage =
    "The downloader restarted, so this job's status is unknown. Check Radarr.";

class EinthusanImportPage extends ConsumerWidget {
  const EinthusanImportPage({required this.instanceId, super.key});

  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(einthusanImportControllerProvider(instanceId));
    final controller = ref.read(
      einthusanImportControllerProvider(instanceId).notifier,
    );
    final hasOpenJob = state.activeJob != null;

    // An opened job is a step above the list: back returns to the list
    // rather than leaving the page.
    return PopScope(
      canPop: !hasOpenJob,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.reset();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Einthusan Import'),
          leading: hasOpenJob
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'All imports',
                  onPressed: controller.reset,
                )
              : null,
        ),
        body: SafeArea(child: _buildStep(state, controller)),
      ),
    );
  }

  Widget _buildStep(
    EinthusanImportState state,
    EinthusanImportController controller,
  ) {
    final tracked = state.activeJob;

    if (tracked == null) {
      if (state.lastError != null) {
        return _ErrorStep(
          message: state.lastError!.userMessage,
          onRetry: controller.reset,
        );
      }
      return _ImportList(state: state, controller: controller);
    }

    final job = tracked.job;

    if (tracked.isLost) {
      return _ErrorStep(
        icon: Icons.help_outline,
        title: 'Status unknown',
        message: _lostMessage,
        actionLabel: 'All imports',
        onRetry: controller.reset,
      );
    }

    return switch (tracked.state) {
      // Restored from history and not yet confirmed by the downloader.
      _ when job == null && !tracked.state.isTerminal => _WaitingStep(
        unreachable: state.serverUnreachable,
        onBack: controller.reset,
      ),
      JobState.resolving => const _ResolvingStep(),
      JobState.awaitingVerification => _PreviewStep(
        job: job!,
        selectedTmdbId: state.selectedTmdbId ?? job.selectedTmdbId,
        isSubmitting: state.isSubmitting,
        onSelect: controller.selectCandidate,
        onConfirm: controller.confirmDownload,
        onCancel: controller.cancel,
      ),
      JobState.downloading || JobState.importing => _RunningStep(job: job!),
      JobState.done => _DoneStep(
        file: tracked.file,
        radarrMovieId: tracked.radarrMovieId,
        onReset: controller.reset,
      ),
      JobState.error || JobState.resolveFailed => _ErrorStep(
        message: tracked.errorMessage ?? 'Something went wrong.',
        onRetry: controller.reset,
      ),
    };
  }
}

/// The input step above the "Recent imports" list; scrolls as one page.
class _ImportList extends StatelessWidget {
  const _ImportList({required this.state, required this.controller});

  final EinthusanImportState state;
  final EinthusanImportController controller;

  @override
  Widget build(BuildContext context) {
    // At most a couple of dozen rows, so a plain scroll view: the input
    // keeps its text however far the list is scrolled.
    return SingleChildScrollView(
      padding: AppInsets.pageLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state.serverUnreachable) const _UnreachableNotice(),
          _InputStep(
            isSubmitting: state.isSubmitting,
            onSubmit: controller.submitUrl,
          ),
          if (state.jobs.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space8),
            const SectionHeader(kicker: 'RECENT IMPORTS'),
            const SizedBox(height: AppSpacing.space4),
            for (final tracked in state.jobs)
              _JobRow(
                tracked: tracked,
                onOpen: () => controller.openJob(tracked.id),
                onDismiss: () => controller.dismiss(tracked.id),
              ),
          ],
        ],
      ),
    );
  }
}

class _UnreachableNotice extends StatelessWidget {
  const _UnreachableNotice();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space6),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 16, color: colorScheme.error),
          const SizedBox(width: AppSpacing.space3),
          Expanded(
            child: Text(
              "Can't reach the downloader — showing last known status",
              style: AppTypography.meta.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One tracked job in the list: what it is, how it stands, and (once it is
/// finished or lost) a way to clear it.
class _JobRow extends StatelessWidget {
  const _JobRow({
    required this.tracked,
    required this.onOpen,
    required this.onDismiss,
  });

  final TrackedImportJob tracked;
  final VoidCallback onOpen;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final record = tracked.record;
    final title = record.title == null
        ? record.einthusanUrl
        : record.year == null
        ? record.title!
        : '${record.title} (${record.year})';
    final progress = tracked.job?.progress;
    final detail = tracked.isLost
        ? _lostMessage
        : switch (tracked.state) {
            JobState.error || JobState.resolveFailed =>
              tracked.errorMessage ?? 'Something went wrong.',
            _ => null,
          };

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.cardTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    _statusLabel(tracked),
                    style: AppTypography.meta.copyWith(
                      color: _statusColor(tracked, colorScheme),
                    ),
                  ),
                  if (tracked.isActive &&
                      tracked.state == JobState.downloading) ...[
                    const SizedBox(height: AppSpacing.space3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: LinearProgressIndicator(
                        value: progress != null && progress.totalBytes > 0
                            ? progress.percent / 100
                            : null,
                        minHeight: 4,
                      ),
                    ),
                  ],
                  if (detail != null) ...[
                    const SizedBox(height: AppSpacing.space2),
                    Text(
                      detail,
                      style: AppTypography.meta.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (tracked.state == JobState.done &&
                      tracked.radarrMovieId != null)
                    _RadarrLibraryButton(
                      radarrMovieId: tracked.radarrMovieId!,
                      compact: true,
                    ),
                ],
              ),
            ),
            if (tracked.canDismiss)
              IconButton(
                icon: const Icon(Icons.close),
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                tooltip: 'Dismiss',
                onPressed: onDismiss,
              ),
          ],
        ),
      ),
    );
  }

  static String _statusLabel(TrackedImportJob tracked) {
    if (tracked.isLost) return 'Status unknown';
    return switch (tracked.state) {
      JobState.resolving => 'Resolving',
      JobState.awaitingVerification => 'Needs confirmation',
      JobState.downloading =>
        tracked.job?.progress == null
            ? 'Downloading'
            : 'Downloading ${tracked.job!.progress!.percent.round()}%',
      JobState.importing => 'Importing',
      JobState.done => 'Imported',
      JobState.error || JobState.resolveFailed => 'Failed',
    };
  }

  static Color _statusColor(TrackedImportJob tracked, ColorScheme scheme) {
    if (tracked.isLost) return AppColors.warning;
    return switch (tracked.state) {
      JobState.done => AppColors.up,
      JobState.error || JobState.resolveFailed => scheme.error,
      _ => scheme.onSurfaceVariant,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.movie_creation_outlined,
          size: AppSizes.emptyStateIcon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: LegacySpacing.md),
        Text(
          'Import from Einthusan',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: LegacySpacing.sm),
        Text(
          'Paste an Einthusan movie page URL to look up a TMDB match and '
          'download it into Radarr.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: LegacySpacing.lg),
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
        const SizedBox(height: LegacySpacing.md),
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
          const SizedBox(height: LegacySpacing.lg),
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
              const SizedBox(width: LegacySpacing.md),
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
      margin: const EdgeInsets.only(bottom: LegacySpacing.sm),
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
          const SizedBox(height: LegacySpacing.lg),
          if (progress != null && progress.totalBytes > 0) ...[
            LinearProgressIndicator(value: progress.percent / 100),
            const SizedBox(height: LegacySpacing.sm),
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

class _DoneStep extends StatelessWidget {
  const _DoneStep({
    required this.file,
    required this.radarrMovieId,
    required this.onReset,
  });

  final String? file;
  final int? radarrMovieId;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final file = this.file;
    final radarrMovieId = this.radarrMovieId;

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
          const SizedBox(height: LegacySpacing.md),
          Text(
            'Imported successfully',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (file != null) ...[
            const SizedBox(height: LegacySpacing.sm),
            Text(
              file,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: LegacySpacing.lg),
          if (radarrMovieId != null)
            _RadarrLibraryButton(radarrMovieId: radarrMovieId),
          const SizedBox(height: LegacySpacing.md),
          OutlinedButton(
            onPressed: onReset,
            child: const Text('Import another movie'),
          ),
        ],
      ),
    );
  }
}

/// "View in Radarr library": opens the imported movie in the app's selected
/// Radarr instance, and is omitted when there is none to open it in.
class _RadarrLibraryButton extends ConsumerWidget {
  const _RadarrLibraryButton({
    required this.radarrMovieId,
    this.compact = false,
  });

  final int radarrMovieId;

  /// A text button for a list row instead of the step's filled one.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radarrInstanceIdAsync = ref.watch(
      selectedLibraryInstanceIdProvider(ServiceType.radarr),
    );

    return radarrInstanceIdAsync.when(
      data: (radarrInstanceId) {
        if (radarrInstanceId == null) return const SizedBox.shrink();
        void open() =>
            context.go(RoutePaths.movieDetail(radarrInstanceId, radarrMovieId));
        const icon = Icon(Icons.movie_outlined);
        const label = Text('View in Radarr library');
        return compact
            ? TextButton.icon(onPressed: open, icon: icon, label: label)
            : FilledButton.icon(onPressed: open, icon: icon, label: label);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

/// A job restored from history that the downloader has not yet confirmed,
/// so there is nothing live to show for it.
class _WaitingStep extends StatelessWidget {
  const _WaitingStep({required this.unreachable, required this.onBack});

  final bool unreachable;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: unreachable ? Icons.cloud_off : Icons.hourglass_empty,
      title: unreachable
          ? "Can't reach the downloader"
          : 'Checking with the downloader',
      message:
          'The status of this import will appear once the downloader answers.',
      action: OutlinedButton(
        onPressed: onBack,
        child: const Text('All imports'),
      ),
    );
  }
}

class _ErrorStep extends StatelessWidget {
  const _ErrorStep({
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
    this.title = 'Import failed',
    this.actionLabel = 'Start over',
  });

  final String message;
  final VoidCallback onRetry;
  final IconData icon;
  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: icon,
      title: title,
      message: message,
      action: FilledButton(onPressed: onRetry, child: Text(actionLabel)),
    );
  }
}

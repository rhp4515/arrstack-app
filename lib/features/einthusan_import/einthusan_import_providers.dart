/// Providers for the Einthusan Import feature: state machine driving URL
/// submission, TMDB candidate confirmation, and download/import polling,
/// plus the list of jobs it tracks across navigation and app restarts.
/// See docs/superpowers/specs/2026-09-08-einthusan-import-design.md.
library;

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/features/einthusan_import/einthusan_job_history_store.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'einthusan_import_providers.freezed.dart';
part 'einthusan_import_providers.g.dart';

/// One import job the page tracks: what was remembered about it, the
/// downloader's latest word on it (if it has given one this session), and
/// whether the downloader has since forgotten it.
@freezed
abstract class TrackedImportJob with _$TrackedImportJob {
  const factory TrackedImportJob({
    required EinthusanJobRecord record,

    /// The latest live job; null until the downloader has been asked about
    /// a job restored from history.
    EinthusanJob? job,

    /// A job that was still in progress when the downloader stopped
    /// listing it (it restarted), so its outcome is unknown.
    @Default(false) bool isLost,
  }) = _TrackedImportJob;

  const TrackedImportJob._();

  String get id => record.jobId;

  JobState get state => job?.state ?? record.state;

  /// Still expected to change, so worth polling for.
  bool get isActive => !isLost && !state.isTerminal;

  /// Finished or unknowable: nothing more will happen, so it can be
  /// cleared from the list.
  bool get canDismiss => isLost || state.isTerminal;

  String? get file => job?.result?.file ?? record.file;

  int? get radarrMovieId => job?.result?.radarrMovieId ?? record.radarrMovieId;

  String? get errorMessage => job?.error?.message ?? record.errorMessage;
}

@freezed
abstract class EinthusanImportState with _$EinthusanImportState {
  const factory EinthusanImportState({
    /// Tracked jobs, newest first.
    @Default([]) List<TrackedImportJob> jobs,

    /// The job whose wizard step is on screen; null shows the input step
    /// and the job list.
    String? activeJobId,
    int? selectedTmdbId,
    @Default(false) bool isSubmitting,
    AppError? lastError,

    /// The last attempt to list the downloader's jobs failed, so the jobs
    /// shown are as last known.
    @Default(false) bool serverUnreachable,
  }) = _EinthusanImportState;

  const EinthusanImportState._();

  TrackedImportJob? get activeJob {
    for (final tracked in jobs) {
      if (tracked.id == activeJobId) return tracked;
    }
    return null;
  }
}

/// Drives the Einthusan import flow for one instance: submit URL, confirm
/// TMDB match, poll download/import progress. Kept alive so leaving the
/// page neither stops the polling nor forgets the jobs; they are also saved
/// to [EinthusanJobHistoryStore] to outlive the app.
@Riverpod(keepAlive: true)
class EinthusanImportController extends _$EinthusanImportController {
  static const _pollInterval = Duration(seconds: 2);

  Timer? _pollTimer;
  bool _pollInFlight = false;
  bool _disposed = false;

  /// Bumped by every local change to a job; a job changed after a listing
  /// was requested keeps its local state instead of the listing's older one.
  int _epoch = 0;
  final _changedAt = <String, int>{};

  /// Jobs removed on this device this session, so a stale listing (or one
  /// from a downloader that could not delete them) does not bring them back.
  final _removedIds = <String>{};

  @override
  EinthusanImportState build(String instanceId) {
    ref.onDispose(() {
      _disposed = true;
      _pollTimer?.cancel();
    });
    unawaited(_restore());
    return const EinthusanImportState();
  }

  Future<EinthusanRepository> get _repository =>
      ref.read(einthusanRepositoryProvider(instanceId).future);

  EinthusanJobHistoryStore get _store =>
      ref.read(einthusanJobHistoryStoreProvider);

  /// Loads the saved history, then reconciles it with what the downloader
  /// lists. If it cannot be reached the saved records stand.
  Future<void> _restore() async {
    final history = await _store.read(instanceId);
    if (_disposed) return;

    final known = {for (final tracked in state.jobs) tracked.id};
    state = state.copyWith(
      jobs: [
        ...state.jobs,
        for (final record in history)
          if (!known.contains(record.jobId)) TrackedImportJob(record: record),
      ],
    );
    await _refresh();
  }

  /// Submits an Einthusan movie URL, creating a new job in state
  /// `resolving`.
  Future<void> submitUrl(String url) async {
    state = state.copyWith(
      isSubmitting: true,
      activeJobId: null,
      selectedTmdbId: null,
      lastError: null,
    );

    final repository = await _repository;
    final result = await repository.createJob(url);
    if (_disposed) return;

    switch (result) {
      case Ok(:final value):
        _upsertJob(value);
        state = state.copyWith(
          isSubmitting: false,
          activeJobId: value.id,
          serverUnreachable: false,
        );
        _syncPolling();
      case Err(:final error):
        state = state.copyWith(isSubmitting: false, lastError: error);
    }
  }

  /// Selects a TMDB candidate locally; not sent to the server until
  /// [confirmDownload].
  void selectCandidate(int tmdbId) =>
      state = state.copyWith(selectedTmdbId: tmdbId);

  /// Confirms the selected candidate (PATCHing only if it changed) and
  /// starts the download+import.
  Future<void> confirmDownload() async {
    final job = state.activeJob?.job;
    if (job == null) return;

    state = state.copyWith(isSubmitting: true, lastError: null);
    final repository = await _repository;
    var current = job;

    final selected = state.selectedTmdbId;
    if (selected != null && selected != job.selectedTmdbId) {
      final patchResult = await repository.patchJob(
        jobId: job.id,
        tmdbId: selected,
      );
      if (_disposed) return;
      switch (patchResult) {
        case Ok(:final value):
          current = value;
        case Err(:final error):
          state = state.copyWith(isSubmitting: false, lastError: error);
          return;
      }
    }

    // The patched job may not repeat the candidates, so remember the
    // chosen one's title from the list the user picked it from.
    final chosenId = selected ?? job.selectedTmdbId;
    final chosen = job.candidates
        .where((candidate) => candidate.tmdbId == chosenId)
        .firstOrNull;

    final downloadResult = await repository.startDownload(current.id);
    if (_disposed) return;
    switch (downloadResult) {
      case Ok(:final value):
        _upsertJob(value, chosen: chosen);
        state = state.copyWith(isSubmitting: false);
        _syncPolling();
      case Err(:final error):
        _upsertJob(current, chosen: chosen);
        state = state.copyWith(isSubmitting: false, lastError: error);
    }
  }

  /// Cancels the active job (if any) on the downloader, drops it from the
  /// list, and returns to the input step.
  Future<void> cancel() async {
    final tracked = state.activeJob;
    if (tracked == null) {
      reset();
      return;
    }
    await dismiss(tracked.id);
  }

  /// Leaves the active job's step for the input step and job list; the job
  /// itself stays in the list.
  void reset() {
    state = state.copyWith(
      activeJobId: null,
      selectedTmdbId: null,
      lastError: null,
    );
  }

  /// Shows [jobId]'s step, as when its row in the list is tapped.
  void openJob(String jobId) {
    if (!state.jobs.any((tracked) => tracked.id == jobId)) return;
    state = state.copyWith(
      activeJobId: jobId,
      selectedTmdbId: null,
      lastError: null,
    );
  }

  /// Removes [jobId] from the list and asks the downloader to delete it
  /// (which also cancels it if it is still running). Failures, including
  /// the downloader no longer knowing the job, are ignored: the job is gone
  /// from this device either way.
  Future<void> dismiss(String jobId) async {
    _removeJob(jobId);
    _syncPolling();
    _persist();

    try {
      await (await _repository).deleteJob(jobId);
    } on Object {
      // Best effort, as documented above.
    }
  }

  void _removeJob(String jobId) {
    _removedIds.add(jobId);
    _changedAt[jobId] = ++_epoch;
    state = state.copyWith(
      jobs: [
        for (final tracked in state.jobs)
          if (tracked.id != jobId) tracked,
      ],
      activeJobId: state.activeJobId == jobId ? null : state.activeJobId,
      selectedTmdbId: state.activeJobId == jobId ? null : state.selectedTmdbId,
    );
  }

  /// Puts [job], as just returned by the downloader, in the list (newest
  /// first for a new job), persisting if anything worth remembering changed.
  void _upsertJob(EinthusanJob job, {TmdbCandidate? chosen}) {
    final now = DateTime.now();
    _changedAt[job.id] = ++_epoch;
    _removedIds.remove(job.id);

    EinthusanJobRecord update(EinthusanJobRecord record) {
      final synced = record.syncedWith(job, now);
      if (chosen == null) return synced;
      final titled = synced.copyWith(title: chosen.title, year: chosen.year);
      return titled == synced ? synced : titled.copyWith(updatedAt: now);
    }

    final jobs = [...state.jobs];
    final index = jobs.indexWhere((tracked) => tracked.id == job.id);
    if (index == -1) {
      jobs.insert(
        0,
        TrackedImportJob(
          record: update(EinthusanJobRecord.fromJob(job, now)),
          job: job,
        ),
      );
    } else {
      jobs[index] = jobs[index].copyWith(
        record: update(jobs[index].record),
        job: job,
        isLost: false,
      );
    }
    _setJobs(jobs);
  }

  /// Replaces the job list, dropping the oldest beyond the history limit and
  /// persisting if any record changed.
  void _setJobs(List<TrackedImportJob> jobs) {
    final kept = jobs.take(einthusanJobHistoryLimit).toList();
    for (final evicted in jobs.skip(einthusanJobHistoryLimit)) {
      _removedIds.add(evicted.id);
    }
    final changed = !_sameRecords(state.jobs, kept);
    state = state.copyWith(jobs: kept);
    if (changed) _persist();
  }

  bool _sameRecords(List<TrackedImportJob> a, List<TrackedImportJob> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].record != b[i].record) return false;
    }
    return true;
  }

  void _persist() {
    unawaited(
      _store.write(instanceId, [
        for (final tracked in state.jobs) tracked.record,
      ]),
    );
  }

  /// Runs the poll timer exactly while some job is still expected to change.
  void _syncPolling() {
    if (state.jobs.any((tracked) => tracked.isActive)) {
      _pollTimer ??= Timer.periodic(_pollInterval, (_) => unawaited(_poll()));
    } else {
      _pollTimer?.cancel();
      _pollTimer = null;
    }
  }

  Future<void> _poll() async {
    if (_pollInFlight) return;
    _pollInFlight = true;
    try {
      await _refresh();
    } finally {
      _pollInFlight = false;
    }
  }

  /// Lists the downloader's jobs (one request covers all of them) and folds
  /// them into the list. A failure keeps the last known jobs and flags the
  /// downloader as unreachable until a listing succeeds again.
  Future<void> _refresh() async {
    final requestedAt = _epoch;
    Result<List<EinthusanJob>> result;
    try {
      result = await (await _repository).listJobs();
    } on Object catch (error) {
      // No usable repository (e.g. the instance was removed) is as good as
      // an unreachable downloader here.
      result = Err(UnknownError(cause: error));
    }
    if (_disposed) return;

    switch (result) {
      case Ok(:final value):
        _applyListing(value, requestedAt: requestedAt);
      case Err():
        state = state.copyWith(serverUnreachable: true);
    }
    _syncPolling();
  }

  /// Folds the downloader's [listing] into the list: it is authoritative for
  /// every job it lists, jobs it lists that are new here are added, and a job
  /// still in progress that it no longer lists is marked lost. A finished
  /// job it no longer lists keeps the outcome already known. Jobs changed
  /// here since [requestedAt] are left alone, as the listing predates them.
  void _applyListing(List<EinthusanJob> listing, {required int requestedAt}) {
    final now = DateTime.now();
    final live = {for (final job in listing) job.id: job};
    bool stale(String id) => (_changedAt[id] ?? 0) > requestedAt;

    final merged = <TrackedImportJob>[];
    for (final tracked in state.jobs) {
      final job = live[tracked.id];
      if (stale(tracked.id)) {
        merged.add(tracked);
      } else if (job != null) {
        merged.add(
          tracked.copyWith(
            record: tracked.record.syncedWith(job, now),
            job: job,
            isLost: false,
          ),
        );
      } else if (tracked.state.isTerminal) {
        merged.add(tracked);
      } else {
        merged.add(tracked.copyWith(isLost: true));
      }
    }

    final known = {for (final tracked in state.jobs) tracked.id};
    // The downloader lists oldest first; the list here is newest first.
    final added = [
      for (final job in listing.reversed)
        if (!known.contains(job.id) && !_removedIds.contains(job.id))
          TrackedImportJob(
            record: EinthusanJobRecord.fromJob(job, now),
            job: job,
          ),
    ];

    state = state.copyWith(serverUnreachable: false);
    _setJobs([...added, ...merged]);
  }
}

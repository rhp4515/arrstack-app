/// Providers for the Einthusan Import feature: state machine driving URL
/// submission, TMDB candidate confirmation, and download/import polling.
/// See docs/superpowers/specs/2026-09-08-einthusan-import-design.md.
library;

import 'dart:async';

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/einthusan/einthusan_providers.dart';
import 'package:arrstack/services/einthusan/einthusan_repository.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'einthusan_import_providers.freezed.dart';
part 'einthusan_import_providers.g.dart';

@freezed
abstract class EinthusanImportState with _$EinthusanImportState {
  const factory EinthusanImportState({
    EinthusanJob? job,
    int? selectedTmdbId,
    @Default(false) bool isSubmitting,
    AppError? lastError,
  }) = _EinthusanImportState;
}

/// Drives the Einthusan import flow for one instance: submit URL, confirm
/// TMDB match, poll download/import progress.
@riverpod
class EinthusanImportController extends _$EinthusanImportController {
  Timer? _pollTimer;

  @override
  EinthusanImportState build(String instanceId) {
    ref.onDispose(() => _pollTimer?.cancel());
    return const EinthusanImportState();
  }

  Future<EinthusanRepository> get _repository =>
      ref.read(einthusanRepositoryProvider(instanceId).future);

  /// Submits an Einthusan movie URL, creating a new job in state
  /// `resolving`.
  Future<void> submitUrl(String url) async {
    _pollTimer?.cancel();
    state = const EinthusanImportState(isSubmitting: true);

    final repository = await _repository;
    final result = await repository.createJob(url);

    switch (result) {
      case Ok(:final value):
        state = state.copyWith(isSubmitting: false, job: value);
        _startPolling();
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
    final job = state.job;
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
      switch (patchResult) {
        case Ok(:final value):
          current = value;
        case Err(:final error):
          state = state.copyWith(isSubmitting: false, lastError: error);
          return;
      }
    }

    final downloadResult = await repository.startDownload(current.id);
    switch (downloadResult) {
      case Ok(:final value):
        state = state.copyWith(isSubmitting: false, job: value);
        _startPolling();
      case Err(:final error):
        state = state.copyWith(
          isSubmitting: false,
          job: current,
          lastError: error,
        );
    }
  }

  /// Cancels the active job (if any) and returns to the input step.
  Future<void> cancel() async {
    _pollTimer?.cancel();
    final job = state.job;
    if (job != null) {
      final repository = await _repository;
      await repository.deleteJob(job.id);
    }
    state = const EinthusanImportState();
  }

  /// Clears state to import another movie.
  void reset() {
    _pollTimer?.cancel();
    state = const EinthusanImportState();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => unawaited(_poll()),
    );
  }

  Future<void> _poll() async {
    final job = state.job;
    if (job == null || job.state.isTerminal) {
      _pollTimer?.cancel();
      return;
    }

    final repository = await _repository;
    final result = await repository.getJob(job.id);

    switch (result) {
      case Ok(:final value):
        state = state.copyWith(job: value);
        if (value.state.isTerminal) _pollTimer?.cancel();
      case Err(:final error):
        _pollTimer?.cancel();
        state = state.copyWith(lastError: error);
    }
  }
}

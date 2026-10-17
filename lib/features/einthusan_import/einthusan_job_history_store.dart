/// Remembers the Einthusan import jobs this device started, per downloader
/// instance, so the Einthusan Import page can show their outcome after the
/// app restarts or the downloader forgets them (it keeps jobs in memory
/// only). See docs/superpowers/specs/2026-09-08-einthusan-import-design.md.
///
/// A convenience only: every read and write swallows failures (no platform
/// channel in tests, cleared storage) and the page falls back to whatever
/// the downloader itself reports.
library;

import 'dart:convert';

import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'einthusan_job_history_store.g.dart';

/// How many jobs are remembered per instance; the oldest are dropped first.
const einthusanJobHistoryLimit = 25;

/// The wire names of [JobState], as `JobOut.state` spells them.
const _stateWireNames = {
  JobState.resolving: 'resolving',
  JobState.resolveFailed: 'resolve_failed',
  JobState.awaitingVerification: 'awaiting_verification',
  JobState.downloading: 'downloading',
  JobState.importing: 'importing',
  JobState.done: 'done',
  JobState.error: 'error',
};

/// What the app remembers about one import job: enough to say what it was
/// and how it ended without asking the downloader. Progress and TMDB
/// candidates are live-only and deliberately not stored.
@immutable
class EinthusanJobRecord {
  const EinthusanJobRecord({
    required this.jobId,
    required this.einthusanUrl,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.year,
    this.radarrMovieId,
    this.file,
    this.errorMessage,
  });

  /// A record for [job], titled after its selected TMDB candidate if any.
  factory EinthusanJobRecord.fromJob(EinthusanJob job, DateTime now) =>
      EinthusanJobRecord(
        jobId: job.id,
        einthusanUrl: job.einthusanUrl,
        state: job.state,
        createdAt: now,
        updatedAt: now,
      ).syncedWith(job, now);

  /// Throws if [json] is not a record this class wrote.
  factory EinthusanJobRecord.fromJson(Map<String, dynamic> json) {
    final stateName = json['state'] as String;
    return EinthusanJobRecord(
      jobId: json['jobId'] as String,
      einthusanUrl: json['einthusanUrl'] as String,
      title: json['title'] as String?,
      year: json['year'] as int?,
      state: _stateWireNames.entries
          .singleWhere((entry) => entry.value == stateName)
          .key,
      radarrMovieId: json['radarrMovieId'] as int?,
      file: json['file'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String jobId;
  final String einthusanUrl;
  final String? title;
  final int? year;
  final JobState state;
  final int? radarrMovieId;
  final String? file;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  EinthusanJobRecord copyWith({
    String? title,
    int? year,
    JobState? state,
    int? radarrMovieId,
    String? file,
    String? errorMessage,
    DateTime? updatedAt,
  }) => EinthusanJobRecord(
    jobId: jobId,
    einthusanUrl: einthusanUrl,
    title: title ?? this.title,
    year: year ?? this.year,
    state: state ?? this.state,
    radarrMovieId: radarrMovieId ?? this.radarrMovieId,
    file: file ?? this.file,
    errorMessage: errorMessage ?? this.errorMessage,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// This record brought up to date with [job]: the same instance if
  /// nothing worth remembering changed (so a progress tick is not a write),
  /// otherwise a copy stamped [now].
  EinthusanJobRecord syncedWith(EinthusanJob job, DateTime now) {
    final candidate = job.candidates
        .where((candidate) => candidate.tmdbId == job.selectedTmdbId)
        .firstOrNull;
    final next = copyWith(
      title: candidate?.title,
      year: candidate?.year,
      state: job.state,
      radarrMovieId: job.result?.radarrMovieId,
      file: job.result?.file,
      errorMessage: job.error?.message,
    );
    return next == this ? this : next.copyWith(updatedAt: now);
  }

  Map<String, dynamic> toJson() => {
    'jobId': jobId,
    'einthusanUrl': einthusanUrl,
    'title': title,
    'year': year,
    'state': _stateWireNames[state],
    'radarrMovieId': radarrMovieId,
    'file': file,
    'errorMessage': errorMessage,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  // `updatedAt` is stamped by the change, not part of what changed, so it
  // stays out of equality: [syncedWith] compares before stamping.
  @override
  bool operator ==(Object other) =>
      other is EinthusanJobRecord &&
      other.jobId == jobId &&
      other.einthusanUrl == einthusanUrl &&
      other.title == title &&
      other.year == year &&
      other.state == state &&
      other.radarrMovieId == radarrMovieId &&
      other.file == file &&
      other.errorMessage == errorMessage &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    jobId,
    einthusanUrl,
    title,
    year,
    state,
    radarrMovieId,
    file,
    errorMessage,
    createdAt,
  );
}

abstract interface class EinthusanJobHistoryStore {
  /// The saved records for [instanceId], newest first; empty if none or
  /// unreadable.
  Future<List<EinthusanJobRecord>> read(String instanceId);

  /// Saves [records] (newest first) for [instanceId], keeping at most
  /// [einthusanJobHistoryLimit] of them.
  Future<void> write(String instanceId, List<EinthusanJobRecord> records);
}

/// [EinthusanJobHistoryStore] over the app's [AppPreferences]: one JSON
/// list per instance.
class PreferencesEinthusanJobHistoryStore implements EinthusanJobHistoryStore {
  const PreferencesEinthusanJobHistoryStore(this._preferences);

  final AppPreferences _preferences;

  static String _key(String instanceId) => 'einthusan.jobs.$instanceId';

  @override
  Future<List<EinthusanJobRecord>> read(String instanceId) async {
    try {
      final raw = await _preferences.readString(_key(instanceId));
      if (raw == null) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final records = <EinthusanJobRecord>[];
      for (final entry in decoded) {
        try {
          records.add(
            EinthusanJobRecord.fromJson(entry as Map<String, dynamic>),
          );
        } on Object {
          // Skip one unreadable entry rather than lose the whole history.
        }
      }
      return records;
    } on Object {
      return const [];
    }
  }

  @override
  Future<void> write(
    String instanceId,
    List<EinthusanJobRecord> records,
  ) async {
    try {
      final kept = records.take(einthusanJobHistoryLimit);
      await _preferences.writeString(
        _key(instanceId),
        jsonEncode([for (final record in kept) record.toJson()]),
      );
    } on Object {
      // Best effort: the in-memory list still applies this session.
    }
  }
}

@Riverpod(keepAlive: true)
EinthusanJobHistoryStore einthusanJobHistoryStore(Ref ref) =>
    PreferencesEinthusanJobHistoryStore(ref.watch(appPreferencesProvider));

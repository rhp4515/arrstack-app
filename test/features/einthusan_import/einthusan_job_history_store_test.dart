// EinthusanJobHistoryStore: per-instance JSON history in AppPreferences that
// round-trips records, keeps the newest 25, tolerates corrupt data, and never
// throws. EinthusanJobRecord only changes when something worth saving does.

import 'package:arrstack/core/storage/app_preferences.dart';
import 'package:arrstack/features/einthusan_import/einthusan_job_history_store.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:flutter_test/flutter_test.dart';

EinthusanJobRecord _record(String id, {JobState state = JobState.done}) =>
    EinthusanJobRecord(
      jobId: id,
      einthusanUrl: 'https://einthusan.tv/movie/watch/$id',
      state: state,
      createdAt: DateTime.utc(2026, 9, 1, 12),
      updatedAt: DateTime.utc(2026, 9, 1, 13),
    );

/// Preferences whose every call fails, like a platform channel that is
/// missing or storage that was cleared underneath the app.
class _BrokenPreferences extends InMemoryAppPreferences {
  @override
  Future<String?> readString(String key) async =>
      throw StateError('no storage');

  @override
  Future<void> writeString(String key, String value) async =>
      throw StateError('no storage');
}

void main() {
  late InMemoryAppPreferences preferences;
  late PreferencesEinthusanJobHistoryStore store;

  setUp(() {
    preferences = InMemoryAppPreferences();
    store = PreferencesEinthusanJobHistoryStore(preferences);
  });

  test('reads an empty history when nothing was saved', () async {
    expect(await store.read('i1'), isEmpty);
  });

  test('round-trips every field, in order', () async {
    final full = EinthusanJobRecord(
      jobId: 'job-1',
      einthusanUrl: 'https://einthusan.tv/movie/watch/abc',
      title: 'Some Movie',
      year: 2020,
      state: JobState.done,
      radarrMovieId: 12,
      file: 'Some.Movie.2020.mkv',
      errorMessage: 'was flaky',
      createdAt: DateTime.utc(2026, 9, 1, 12),
      updatedAt: DateTime.utc(2026, 9, 1, 13, 30),
    );
    final sparse = _record('job-2', state: JobState.resolving);

    await store.write('i1', [full, sparse]);
    final read = await store.read('i1');

    expect(read, [full, sparse]);
    expect(read.first.updatedAt, DateTime.utc(2026, 9, 1, 13, 30));
    expect(read.first.createdAt, DateTime.utc(2026, 9, 1, 12));
    expect(read.last.title, isNull);
    expect(read.last.radarrMovieId, isNull);
  });

  test('stores each state by its wire name', () async {
    await store.write('i1', [
      for (final state in JobState.values) _record(state.name, state: state),
    ]);

    final raw = await preferences.readString('einthusan.jobs.i1');
    for (final wire in [
      'resolving',
      'resolve_failed',
      'awaiting_verification',
      'downloading',
      'importing',
      'done',
      'error',
    ]) {
      expect(raw, contains('"state":"$wire"'));
    }
    final read = await store.read('i1');
    expect(read.map((record) => record.state), JobState.values);
  });

  test('keeps instances apart', () async {
    await store.write('i1', [_record('a')]);
    await store.write('i2', [_record('b')]);

    expect((await store.read('i1')).single.jobId, 'a');
    expect((await store.read('i2')).single.jobId, 'b');
    expect(await store.read('i3'), isEmpty);
  });

  test('caps the history at 25, keeping the newest (first) ones', () async {
    await store.write('i1', [for (var i = 0; i < 30; i++) _record('job-$i')]);

    final read = await store.read('i1');
    expect(read, hasLength(25));
    expect(read.first.jobId, 'job-0');
    expect(read.last.jobId, 'job-24');
  });

  test('malformed JSON reads as empty', () async {
    await preferences.writeString('einthusan.jobs.i1', '{not json');
    expect(await store.read('i1'), isEmpty);
  });

  test('JSON that is not a list reads as empty', () async {
    await preferences.writeString('einthusan.jobs.i1', '{"jobId":"a"}');
    expect(await store.read('i1'), isEmpty);
  });

  test('skips an unreadable entry but keeps the rest', () async {
    await store.write('i1', [_record('good')]);
    final good = await preferences.readString('einthusan.jobs.i1');
    await preferences.writeString(
      'einthusan.jobs.i1',
      '[{"jobId":"bad","state":"nonsense"},42,${good!.substring(1)}',
    );

    final read = await store.read('i1');
    expect(read.map((record) => record.jobId), ['good']);
  });

  test('swallows storage failures', () async {
    final broken = PreferencesEinthusanJobHistoryStore(_BrokenPreferences());

    expect(await broken.read('i1'), isEmpty);
    await broken.write('i1', [_record('a')]); // Does not throw.
  });

  group('EinthusanJobRecord.syncedWith', () {
    final later = DateTime.utc(2026, 9, 2);

    EinthusanJob job(
      JobState state, {
      JobProgress? progress,
      JobResult? result,
      JobErrorInfo? error,
      int? selected,
      List<TmdbCandidate> candidates = const [],
    }) => EinthusanJob(
      id: 'job-1',
      state: state,
      einthusanUrl: 'https://einthusan.tv/movie/watch/job-1',
      progress: progress,
      result: result,
      error: error,
      selectedTmdbId: selected,
      candidates: candidates,
    );

    test('is the same record for a progress tick', () {
      final record = _record('job-1', state: JobState.downloading);
      const progress = JobProgress(
        downloadedBytes: 5,
        totalBytes: 10,
        percent: 50,
        speedBps: 1,
      );

      expect(
        identical(
          record.syncedWith(
            job(JobState.downloading, progress: progress),
            later,
          ),
          record,
        ),
        isTrue,
      );
    });

    test('stamps a new state, result, error and chosen title', () {
      final record = _record('job-1', state: JobState.downloading);

      final done = record.syncedWith(
        job(
          JobState.done,
          result: const JobResult(file: 'A.mkv', radarrMovieId: 3, tmdbId: 9),
          selected: 9,
          candidates: const [
            TmdbCandidate(
              tmdbId: 9,
              title: 'Nine',
              year: 2009,
              tmdbUrl: 'https://themoviedb.org/movie/9',
            ),
          ],
        ),
        later,
      );
      expect(done.state, JobState.done);
      expect(done.file, 'A.mkv');
      expect(done.radarrMovieId, 3);
      expect(done.title, 'Nine');
      expect(done.year, 2009);
      expect(done.updatedAt, later);
      expect(done.createdAt, record.createdAt);

      final failed = record.syncedWith(
        job(
          JobState.error,
          error: const JobErrorInfo(code: 'x', message: 'It broke'),
        ),
        later,
      );
      expect(failed.errorMessage, 'It broke');
    });

    test('keeps what it knew when the job no longer carries it', () {
      final titled = _record('job-1').copyWith(title: 'Kept', year: 1999);

      final synced = titled.syncedWith(job(JobState.done), later);

      expect(synced.title, 'Kept');
      expect(synced.year, 1999);
      expect(identical(synced, titled), isTrue);
    });
  });
}

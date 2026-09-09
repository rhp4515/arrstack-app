/// Repository for the einthusan-downloader service.
///
/// Thin pass-through over [EinthusanClient], matching [RadarrRepository]'s
/// shape (spec §5).
library;

import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/einthusan/einthusan_client.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';

class EinthusanRepository {
  const EinthusanRepository(this._client);

  final EinthusanClient _client;

  Future<Result<EinthusanJob>> createJob(String einthusanUrl) =>
      _client.createJob(einthusanUrl);

  Future<Result<EinthusanJob>> getJob(String jobId) => _client.getJob(jobId);

  Future<Result<EinthusanJob>> patchJob({
    required String jobId,
    required int tmdbId,
  }) => _client.patchJob(jobId: jobId, tmdbId: tmdbId);

  Future<Result<EinthusanJob>> startDownload(String jobId) =>
      _client.startDownload(jobId);

  Future<Result<void>> deleteJob(String jobId) => _client.deleteJob(jobId);
}

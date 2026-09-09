/// API client for the einthusan-downloader service.
///
/// Implements the endpoints needed to submit an Einthusan movie URL,
/// resolve/confirm its TMDB match, and poll download+import progress.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/einthusan/models/einthusan_models.dart';
import 'package:dio/dio.dart';

class EinthusanClient implements ConnectionTestClient {
  const EinthusanClient(this._dio);

  final Dio _dio;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    return dioCall(
      () => _dio.get('api/v1/health'),
      map: (_) => const ServiceIdentity(instanceName: 'Einthusan Downloader'),
    );
  }

  /// Creates a new import job for [einthusanUrl]. Starts in state
  /// `resolving`.
  Future<Result<EinthusanJob>> createJob(String einthusanUrl) {
    return dioCall(
      () => _dio.post('api/v1/movies', data: {'url': einthusanUrl}),
      map: (data) => EinthusanJob.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<EinthusanJob>> getJob(String jobId) {
    return dioCall(
      () => _dio.get('api/v1/jobs/$jobId'),
      map: (data) => EinthusanJob.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Changes the selected TMDB candidate for a job awaiting verification.
  Future<Result<EinthusanJob>> patchJob({
    required String jobId,
    required int tmdbId,
  }) {
    return dioCall(
      () => _dio.patch('api/v1/jobs/$jobId', data: {'tmdb_id': tmdbId}),
      map: (data) => EinthusanJob.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Confirms the selected match and starts download+import.
  Future<Result<EinthusanJob>> startDownload(String jobId) {
    return dioCall(
      () => _dio.post('api/v1/jobs/$jobId/download'),
      map: (data) => EinthusanJob.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<void>> deleteJob(String jobId) {
    return dioCall(() => _dio.delete('api/v1/jobs/$jobId'), map: (_) {});
  }
}

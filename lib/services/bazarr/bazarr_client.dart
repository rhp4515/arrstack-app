/// API client for Bazarr.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/bazarr/models/bazarr_models.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:dio/dio.dart';

class BazarrClient implements ConnectionTestClient {
  const BazarrClient(this._dio);

  final Dio _dio;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    return dioCall(
      () => _dio.get('api/system/status'),
      map: (data) {
        final map = data as Map<String, dynamic>;
        return ServiceIdentity(
          instanceName: map['app_name'] as String? ?? 'Bazarr',
          version: map['version'] as String?,
        );
      },
    );
  }

  Future<Result<List<BazarrWantedSubtitle>>> getWantedEpisodes() {
    return dioCall(
      () => _dio.get('api/episodes/wanted'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map((json) => BazarrWantedSubtitle.fromJson({
                ...json,
                'type': 'episode',
              }))
          .toList(),
    );
  }

  Future<Result<List<BazarrWantedSubtitle>>> getWantedMovies() {
    return dioCall(
      () => _dio.get('api/movies/wanted'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map((json) => BazarrWantedSubtitle.fromJson({
                ...json,
                'type': 'movie',
              }))
          .toList(),
    );
  }

  /// Triggers a search for missing subtitles for a specific episode.
  Future<Result<void>> searchEpisodeSubtitles(int episodeId) {
    return dioCall(
      () => _dio.patch('api/episodes', queryParameters: {'action': 'search', 'ids': episodeId}),
      map: (_) {},
    );
  }

  /// Triggers a search for missing subtitles for a specific movie.
  Future<Result<void>> searchMovieSubtitles(int radarrId) {
    return dioCall(
      () => _dio.patch('api/movies', queryParameters: {'action': 'search', 'ids': radarrId}),
      map: (_) {},
    );
  }

  Future<Result<BazarrSystemStatus>> getSystemStatus() {
    return dioCall(
      () => _dio.get('api/system/status'),
      map: (data) => BazarrSystemStatus.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Triggers a search for all missing subtitles.
  Future<Result<void>> searchAllSubtitles() {
    return dioCall(
      () => _dio.get('api/subtitles/search/missing'),
      map: (_) {},
    );
  }
}

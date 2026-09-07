/// API client for Bazarr.
library;

import 'dart:developer' as developer;

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
    // `system/health` is Bazarr's health-check endpoint: a 200 confirms the
    // server is reachable and the API key is accepted. It returns a list of
    // health issues (not version info), so identity is a fixed label here;
    // richer status/version comes from [getSystemStatus].
    return dioCall(
      () => _dio.get('api/system/health'),
      map: (_) => const ServiceIdentity(instanceName: 'Bazarr'),
    );
  }

  Future<Result<List<BazarrWantedSubtitle>>> getWantedEpisodes() {
    return dioCall(
      () => _dio.get('api/episodes/wanted'),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return BazarrWantedSubtitle.fromJson({
                  ...json,
                  'type': 'episode',
                });
              } catch (e, st) {
                developer.log(
                  'Bazarr episode parse error: $e',
                  name: 'arrstack.bazarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<BazarrWantedSubtitle>()
            .toList();
      },
    );
  }

  Future<Result<List<BazarrWantedSubtitle>>> getWantedMovies() {
    return dioCall(
      () => _dio.get('api/movies/wanted'),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return BazarrWantedSubtitle.fromJson({
                  ...json,
                  'type': 'movie',
                });
              } catch (e, st) {
                developer.log(
                  'Bazarr movie parse error: $e',
                  name: 'arrstack.bazarr',
                  error: e,
                  stackTrace: st,
                );
                return null;
              }
            })
            .whereType<BazarrWantedSubtitle>()
            .toList();
      },
    );
  }

  /// Triggers a search for missing subtitles for a specific episode.
  Future<Result<void>> searchEpisodeSubtitles(int episodeId) {
    return dioCall(
      () => _dio.patch(
        'api/episodes',
        queryParameters: {'action': 'search', 'ids': episodeId},
      ),
      map: (_) {},
    );
  }

  /// Triggers a search for missing subtitles for a specific movie.
  Future<Result<void>> searchMovieSubtitles(int radarrId) {
    return dioCall(
      () => _dio.patch(
        'api/movies',
        queryParameters: {'action': 'search', 'ids': radarrId},
      ),
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
    return dioCall(() => _dio.get('api/subtitles/search/missing'), map: (_) {});
  }
}

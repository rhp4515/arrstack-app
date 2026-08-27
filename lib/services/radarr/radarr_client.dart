/// API client for Radarr (v3).
///
/// Implements the endpoints needed for library management and lookup.
library;

import 'package:arrstack/core/models/models.dart';
import 'package:arrstack/core/network/network.dart';
import 'package:arrstack/services/contracts/contracts.dart';
import 'package:arrstack/services/radarr/models/radarr_models.dart';
import 'package:dio/dio.dart';

class RadarrClient implements ConnectionTestClient {
  const RadarrClient(this._dio);

  final Dio _dio;

  @override
  Future<Result<ServiceIdentity>> testConnection() async {
    return dioCall(
      () => _dio.get('api/v3/system/status'),
      map: (data) {
        final map = data as Map<String, dynamic>;
        return ServiceIdentity(
          instanceName: map['instanceName'] as String? ?? 'Radarr',
          version: map['version'] as String?,
        );
      },
    );
  }

  Future<Result<List<RadarrMovie>>> getMovies() {
    return dioCall(
      () => _dio.get('api/v3/movie'),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrMovie.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('RadarrMovie parse error: $e');
                return null;
              }
            })
            .whereType<RadarrMovie>()
            .toList();
      },
    );
  }

  Future<Result<RadarrMovie>> getMovie(int id) {
    return dioCall(
      () => _dio.get('api/v3/movie/$id'),
      map: (data) => RadarrMovie.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<List<RadarrMovie>>> lookupMovie(String term) {
    return dioCall(
      () => _dio.get('api/v3/movie/lookup', queryParameters: {'term': term}),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrMovie.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('RadarrMovie lookup parse error: $e');
                return null;
              }
            })
            .whereType<RadarrMovie>()
            .toList();
      },
    );
  }

  Future<Result<RadarrMovie>> addMovie(RadarrMovie movie) {
    final payload = movie.toJson();
    // Radarr v3 often fails if 'id' is present (even as null/0) during POST
    payload.remove('id');
    
    return dioCall(
      () => _dio.post('api/v3/movie', data: payload),
      map: (data) => RadarrMovie.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Result<void>> updateMovie(RadarrMovie movie) {
    return dioCall(
      () => _dio.put('api/v3/movie/${movie.id}', data: movie.toJson()),
      map: (_) {},
    );
  }

  Future<Result<void>> deleteMovie(int id, {bool deleteFiles = false}) {
    return dioCall(
      () => _dio.delete(
        'api/v3/movie/$id',
        queryParameters: {'deleteFiles': deleteFiles},
      ),
      map: (_) {},
    );
  }

  /// Movies with a release date between [start] and [end]. Radarr returns full
  /// movie objects, so the calendar reuses [RadarrMovie] (with its release-date
  /// and studio fields) directly.
  Future<Result<List<RadarrMovie>>> getCalendar(DateTime start, DateTime end) {
    return dioCall(
      () => _dio.get(
        'api/v3/calendar',
        queryParameters: {
          'start': start.toUtc().toIso8601String(),
          'end': end.toUtc().toIso8601String(),
        },
      ),
      map: (data) {
        if (data is! List) return [];
        return data
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrMovie.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('RadarrMovie calendar parse error: $e');
                return null;
              }
            })
            .whereType<RadarrMovie>()
            .toList();
      },
    );
  }

  Future<Result<List<RadarrQualityProfile>>> getQualityProfiles() {
    return dioCall(
      () => _dio.get('api/v3/qualityProfile'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(RadarrQualityProfile.fromJson)
          .toList(),
    );
  }

  Future<Result<List<RadarrRootFolder>>> getRootFolders() {
    return dioCall(
      () => _dio.get('api/v3/rootFolder'),
      map: (data) => (data as List)
          .cast<Map<String, dynamic>>()
          .map(RadarrRootFolder.fromJson)
          .toList(),
    );
  }

  Future<Result<List<RadarrQueueItem>>> getQueue() {
    return dioCall(
      () => _dio.get('api/v3/queue'),
      map: (data) {
        if (data is! Map) return [];
        final records = data['records'];
        if (records is! List) return [];
        return records
            .cast<Map<String, dynamic>>()
            .map((json) {
              try {
                return RadarrQueueItem.fromJson(json);
              } catch (e) {
                // ignore: avoid_print
                print('RadarrQueueItem parse error: $e');
                return null;
              }
            })
            .whereType<RadarrQueueItem>()
            .toList();
      },
    );
  }
}
